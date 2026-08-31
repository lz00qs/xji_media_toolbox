import argparse
import hashlib
import os
import platform
import shutil
import subprocess
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent
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


def verify_packaged_runtime(target: str) -> None:
    if target == "windows":
        runtime_directory = (
            PROJECT_ROOT / "build/windows/x64/runner/Release/ffmpeg"
        )
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


if __name__ == "__main__":
    main()
