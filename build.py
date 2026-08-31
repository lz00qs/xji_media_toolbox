import argparse
import hashlib
import os
import platform
import re
import shutil
import subprocess
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent
WINDOWS_RELEASE_DIRECTORY = (
    PROJECT_ROOT / "build/windows/x64/runner/Release"
)
WINDOWS_INSTALLER_DIRECTORY = PROJECT_ROOT / "build/windows/installer"
WINDOWS_INSTALLER_SCRIPT = (
    PROJECT_ROOT / "installer/windows/xji_media_toolbox.iss"
)
WINDOWS_EXECUTABLE_NAME = "xji_footage_toolbox.exe"
RUNTIME_FILES = {
    "windows": {
        "assets/windows/ffmpeg/ffmpeg.exe": (
            "72a489eccd008c2ec2c0a5856c5c75bc3d8bbfa90166c4566865c246445e6aa3"
        ),
        "assets/windows/ffmpeg/ffprobe.exe": (
            "19202b23c0043f15ad1b7bce2344f406fd52bd6efd8f995ce02e7392a1cec52f"
        ),
    },
    "macos": {
        "assets/macos/ffmpeg/ffmpeg": (
            "393e4c395020a1cb7cbd77fbe00599ce69d1c6466fee0dbd59d13f86a81a1611"
        ),
        "assets/macos/ffmpeg/ffprobe": (
            "7abc49fb2bdf2204f018e76dc6e0a8ae7643313bae09a9fa43e7eb12442271bc"
        ),
    },
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as file:
        for chunk in iter(lambda: file.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def verify_runtime(target: str) -> None:
    for relative_path, expected_hash in RUNTIME_FILES[target].items():
        path = PROJECT_ROOT / relative_path
        if not path.is_file():
            raise FileNotFoundError(f"Missing bundled FFmpeg runtime: {path}")
        actual_hash = sha256(path)
        if actual_hash != expected_hash:
            raise RuntimeError(
                f"Checksum mismatch for {path}:\n"
                f"expected {expected_hash}\n"
                f"actual   {actual_hash}"
            )
        print(f"Verified {relative_path}: {actual_hash}")


def validate_host(target: str) -> None:
    system = platform.system().lower()
    machine = platform.machine().lower()
    if target == "windows" and system != "windows":
        raise RuntimeError("The Windows release must be built on Windows.")
    if target == "macos" and (system != "darwin" or machine != "arm64"):
        raise RuntimeError("The macOS release must be built on Apple Silicon.")


def run(command: list[str], *, environment: dict[str, str] | None = None) -> None:
    print(f"Running: {' '.join(command)}")
    subprocess.run(
        command,
        cwd=PROJECT_ROOT,
        check=True,
        env=environment,
    )


def read_app_version() -> tuple[str, str]:
    pubspec = (PROJECT_ROOT / "pubspec.yaml").read_text(encoding="utf-8")
    match = re.search(
        r"^version:\s*['\"]?"
        r"(\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+\d+)?)"
        r"['\"]?\s*(?:#.*)?$",
        pubspec,
        re.MULTILINE,
    )
    if match is None:
        raise RuntimeError("pubspec.yaml must contain a valid semantic version.")

    display_version = match.group(1)
    numeric_match = re.fullmatch(
        r"(\d+)\.(\d+)\.(\d+)(?:-[^+]+)?(?:\+(\d+))?",
        display_version,
    )
    if numeric_match is None:
        raise RuntimeError(f"Unsupported application version: {display_version}")

    numeric_parts = [
        int(numeric_match.group(1)),
        int(numeric_match.group(2)),
        int(numeric_match.group(3)),
        int(numeric_match.group(4) or 0),
    ]
    if any(part > 65535 for part in numeric_parts):
        raise RuntimeError(
            "Each Windows version component must be between 0 and 65535."
        )

    return display_version, ".".join(str(part) for part in numeric_parts)


def find_inno_setup_compiler() -> Path:
    configured_path = os.environ.get("INNO_SETUP_COMPILER")
    if configured_path:
        compiler = Path(configured_path)
        if compiler.is_file():
            return compiler
        raise FileNotFoundError(
            f"INNO_SETUP_COMPILER does not point to ISCC.exe: {compiler}"
        )

    for executable_name in ("ISCC.exe", "ISCC"):
        executable = shutil.which(executable_name)
        if executable:
            return Path(executable)

    program_files_directories = [
        os.environ.get("ProgramFiles"),
        os.environ.get("ProgramFiles(x86)"),
    ]
    for program_files_directory in program_files_directories:
        if not program_files_directory:
            continue
        for inno_version in ("Inno Setup 7", "Inno Setup 6"):
            compiler = Path(program_files_directory) / inno_version / "ISCC.exe"
            if compiler.is_file():
                return compiler

    raise FileNotFoundError(
        "Inno Setup compiler was not found. Install Inno Setup 6 or 7, or set "
        "INNO_SETUP_COMPILER to the full path of ISCC.exe."
    )


def build_windows_installer() -> Path:
    required_release_files = [
        WINDOWS_RELEASE_DIRECTORY / WINDOWS_EXECUTABLE_NAME,
        WINDOWS_RELEASE_DIRECTORY / "ffmpeg/ffmpeg.exe",
        WINDOWS_RELEASE_DIRECTORY / "ffmpeg/ffprobe.exe",
    ]
    for required_file in required_release_files:
        if not required_file.is_file():
            raise FileNotFoundError(
                f"Windows release is incomplete; missing: {required_file}"
            )
    if not WINDOWS_INSTALLER_SCRIPT.is_file():
        raise FileNotFoundError(
            f"Inno Setup script was not found: {WINDOWS_INSTALLER_SCRIPT}"
        )

    display_version, numeric_version = read_app_version()
    WINDOWS_INSTALLER_DIRECTORY.mkdir(parents=True, exist_ok=True)
    compiler = find_inno_setup_compiler()
    run(
        [
            str(compiler),
            f"/DMyAppVersion={display_version}",
            f"/DMyNumericVersion={numeric_version}",
            f"/DMyAppSourceDir={WINDOWS_RELEASE_DIRECTORY}",
            f"/DMyOutputDir={WINDOWS_INSTALLER_DIRECTORY}",
            f"/DMyProjectRoot={PROJECT_ROOT}",
            str(WINDOWS_INSTALLER_SCRIPT),
        ]
    )

    installer = (
        WINDOWS_INSTALLER_DIRECTORY
        / f"XJI-Media-Toolbox-Setup-{display_version}-x64.exe"
    )
    if not installer.is_file():
        raise FileNotFoundError(
            f"Inno Setup completed without producing the installer: {installer}"
        )

    installer_checksum = sha256(installer)
    checksum_file = installer.with_suffix(f"{installer.suffix}.sha256")
    checksum_file.write_text(
        f"{installer_checksum}  {installer.name}\n",
        encoding="utf-8",
    )
    print(f"Created Windows installer: {installer}")
    print(f"Installer SHA-256: {installer_checksum}")
    return installer


def verify_packaged_runtime(target: str) -> None:
    if target == "windows":
        runtime_directory = WINDOWS_RELEASE_DIRECTORY / "ffmpeg"
        executables = [
            runtime_directory / "ffmpeg.exe",
            runtime_directory / "ffprobe.exe",
        ]
    else:
        app_directory = (
            PROJECT_ROOT
            / "build/macos/Build/Products/Release/XJI Media Toolbox.app"
        )
        runtime_directory = app_directory / "Contents/Helpers"
        executables = [runtime_directory / "ffmpeg", runtime_directory / "ffprobe"]

    for executable in executables:
        if not executable.is_file():
            raise FileNotFoundError(
                f"Release was built without the FFmpeg runtime: {executable}"
            )
        run([str(executable), "-version"])

    if target == "macos":
        app_executable = app_directory / "Contents/MacOS/XJI Media Toolbox"
        macho_files = []
        for candidate in app_directory.rglob("*"):
            if not candidate.is_file() or candidate.is_symlink():
                continue
            description = subprocess.run(
                ["/usr/bin/file", "-b", str(candidate)],
                cwd=PROJECT_ROOT,
                check=True,
                capture_output=True,
                text=True,
            ).stdout
            if "Mach-O" in description:
                macho_files.append(candidate)

        if app_executable not in macho_files:
            raise RuntimeError(f"Application executable is not Mach-O: {app_executable}")

        arm64_only_files = {
            app_executable,
            app_directory / "Contents/Frameworks/App.framework/Versions/A/App",
            app_directory
            / "Contents/Frameworks/FlutterMacOS.framework/Versions/A/FlutterMacOS",
            *executables,
        }
        for executable in macho_files:
            architectures = subprocess.run(
                ["lipo", "-archs", str(executable)],
                cwd=PROJECT_ROOT,
                check=True,
                capture_output=True,
                text=True,
            ).stdout.strip()
            architecture_set = set(architectures.split())
            if "arm64" not in architecture_set:
                raise RuntimeError(
                    f"Mach-O file does not support arm64 "
                    f"('{architectures}'): {executable}"
                )
            if executable in arm64_only_files and architecture_set != {"arm64"}:
                raise RuntimeError(
                    f"Expected an arm64-only executable, got "
                    f"'{architectures}': {executable}"
                )
        run(
            [
                "codesign",
                "--verify",
                "--deep",
                "--strict",
                "--verbose=2",
                str(app_directory),
            ]
        )


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Build an FFmpeg-enabled XJI Media Toolbox release."
    )
    parser.add_argument(
        "--build",
        required=True,
        choices=["macos", "windows"],
        help="Release platform. macOS builds target Apple Silicon only.",
    )
    args = parser.parse_args()

    validate_host(args.build)
    verify_runtime(args.build)

    flutter = shutil.which("flutter")
    if flutter is None:
        raise FileNotFoundError("Flutter was not found on PATH.")

    # Release artifacts must be rebuilt from scratch. Incremental macOS builds
    # can otherwise leave the outer app signature sealing an older App.framework.
    run([flutter, "clean"])
    run([flutter, "pub", "get"])
    if args.build == "macos":
        macos_environment = os.environ.copy()
        macos_environment.update(
            {
                "ARCHS": "arm64",
                "EXCLUDED_ARCHS": "x86_64",
                "ONLY_ACTIVE_ARCH": "YES",
            }
        )
        run(
            [flutter, "build", "macos", "--release"],
            environment=macos_environment,
        )
    else:
        run([flutter, "build", "windows", "--release"])

    verify_packaged_runtime(args.build)
    if args.build == "windows":
        build_windows_installer()


if __name__ == "__main__":
    main()
