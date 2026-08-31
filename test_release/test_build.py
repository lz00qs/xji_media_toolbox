import hashlib
import os
import subprocess
import unittest
from contextlib import contextmanager
from pathlib import Path
from tempfile import TemporaryDirectory
from types import SimpleNamespace
from unittest.mock import call, patch

import build


@contextmanager
def temporary_project():
    with TemporaryDirectory() as directory:
        root = Path(directory)
        paths = SimpleNamespace(
            root=root,
            windows_release=root / "build/windows/x64/runner/Release",
            windows_installer=root / "build/windows/installer",
            windows_script=root
            / "installer/windows/xji_media_toolbox.iss",
            macos_app=root
            / "build/macos/Build/Products/Release/XJI Media Toolbox.app",
        )
        with patch.multiple(
            build,
            PROJECT_ROOT=paths.root,
            WINDOWS_RELEASE_DIRECTORY=paths.windows_release,
            WINDOWS_INSTALLER_DIRECTORY=paths.windows_installer,
            WINDOWS_INSTALLER_SCRIPT=paths.windows_script,
        ):
            yield paths


def write_file(path: Path, content: bytes = b"fixture") -> Path:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(content)
    return path


def populate_windows_release(paths: SimpleNamespace) -> None:
    write_file(paths.windows_release / build.WINDOWS_EXECUTABLE_NAME)
    write_file(paths.windows_release / "ffmpeg/ffmpeg.exe")
    write_file(paths.windows_release / "ffmpeg/ffprobe.exe")


def populate_macos_bundle(paths: SimpleNamespace) -> set[Path]:
    app = paths.macos_app
    macho_files = {
        write_file(app / "Contents/MacOS/XJI Media Toolbox"),
        write_file(app / "Contents/Helpers/ffmpeg"),
        write_file(app / "Contents/Helpers/ffprobe"),
        write_file(app / "Contents/Frameworks/App.framework/Versions/A/App"),
        write_file(
            app
            / "Contents/Frameworks/FlutterMacOS.framework/Versions/A/FlutterMacOS"
        ),
    }
    write_file(app / "Contents/Info.plist", b"not a Mach-O binary")
    return macho_files


class ChecksumAndRuntimeTests(unittest.TestCase):
    def test_sha256_reads_the_complete_file(self) -> None:
        with TemporaryDirectory() as directory:
            content = b"a" * (1024 * 1024) + b"tail"
            path = write_file(Path(directory) / "runtime", content)

            self.assertEqual(build.sha256(path), hashlib.sha256(content).hexdigest())

    def test_verify_runtime_accepts_matching_files(self) -> None:
        with temporary_project() as paths:
            ffmpeg = write_file(paths.root / "runtime/ffmpeg", b"ffmpeg")
            ffprobe = write_file(paths.root / "runtime/ffprobe", b"ffprobe")
            runtime_files = {
                "macos": {
                    "runtime/ffmpeg": build.sha256(ffmpeg),
                    "runtime/ffprobe": build.sha256(ffprobe),
                }
            }

            with (
                patch.object(build, "RUNTIME_FILES", runtime_files),
                patch("builtins.print") as print_mock,
            ):
                build.verify_runtime("macos")

            self.assertEqual(print_mock.call_count, 2)

    def test_verify_runtime_rejects_a_missing_file(self) -> None:
        with temporary_project():
            runtime_files = {
                "windows": {"runtime/ffmpeg.exe": "0" * 64}
            }
            with patch.object(build, "RUNTIME_FILES", runtime_files):
                with self.assertRaisesRegex(
                    FileNotFoundError, "Missing bundled FFmpeg runtime"
                ):
                    build.verify_runtime("windows")

    def test_verify_runtime_rejects_a_checksum_mismatch(self) -> None:
        with temporary_project() as paths:
            write_file(paths.root / "runtime/ffmpeg", b"tampered")
            runtime_files = {"macos": {"runtime/ffmpeg": "0" * 64}}
            with patch.object(build, "RUNTIME_FILES", runtime_files):
                with self.assertRaisesRegex(RuntimeError, "Checksum mismatch"):
                    build.verify_runtime("macos")


class HostAndCommandTests(unittest.TestCase):
    def test_validate_host_accepts_supported_build_hosts(self) -> None:
        supported_hosts = [
            ("windows", "Windows", "AMD64"),
            ("macos", "Darwin", "arm64"),
        ]
        for target, system, machine in supported_hosts:
            with self.subTest(target=target):
                with (
                    patch.object(build.platform, "system", return_value=system),
                    patch.object(build.platform, "machine", return_value=machine),
                ):
                    build.validate_host(target)

    def test_validate_host_rejects_windows_on_another_system(self) -> None:
        with (
            patch.object(build.platform, "system", return_value="Darwin"),
            patch.object(build.platform, "machine", return_value="arm64"),
        ):
            with self.assertRaisesRegex(RuntimeError, "must be built on Windows"):
                build.validate_host("windows")

    def test_validate_host_rejects_macos_on_intel(self) -> None:
        with (
            patch.object(build.platform, "system", return_value="Darwin"),
            patch.object(build.platform, "machine", return_value="x86_64"),
        ):
            with self.assertRaisesRegex(RuntimeError, "Apple Silicon"):
                build.validate_host("macos")

    def test_run_uses_the_project_root_and_provided_environment(self) -> None:
        environment = {"ARCHS": "arm64"}
        with temporary_project() as paths:
            with patch.object(build.subprocess, "run") as runner:
                build.run(["tool", "--flag"], environment=environment)

            runner.assert_called_once_with(
                ["tool", "--flag"],
                cwd=paths.root,
                check=True,
                env=environment,
            )

    def test_run_propagates_an_external_command_failure(self) -> None:
        failure = subprocess.CalledProcessError(7, ["tool"])
        with patch.object(build.subprocess, "run", side_effect=failure):
            with self.assertRaises(subprocess.CalledProcessError) as context:
                build.run(["tool"])

        self.assertIs(context.exception, failure)


class VersionTests(unittest.TestCase):
    def test_read_app_version_supports_release_and_prerelease_versions(self) -> None:
        cases = [
            ("version: 1.2.3+42\n", ("1.2.3+42", "1.2.3.42")),
            (
                "version: '2.0.1-beta.3+7' # release candidate\n",
                ("2.0.1-beta.3+7", "2.0.1.7"),
            ),
            ('version: "3.4.5"\n', ("3.4.5", "3.4.5.0")),
        ]
        for pubspec, expected in cases:
            with self.subTest(pubspec=pubspec):
                with temporary_project() as paths:
                    write_file(paths.root / "pubspec.yaml", pubspec.encode())
                    self.assertEqual(build.read_app_version(), expected)

    def test_read_app_version_rejects_a_missing_or_invalid_version(self) -> None:
        for pubspec in ("name: toolbox\n", "version: latest\n"):
            with self.subTest(pubspec=pubspec):
                with temporary_project() as paths:
                    write_file(paths.root / "pubspec.yaml", pubspec.encode())
                    with self.assertRaisesRegex(RuntimeError, "semantic version"):
                        build.read_app_version()

    def test_read_app_version_rejects_oversized_windows_components(self) -> None:
        with temporary_project() as paths:
            write_file(paths.root / "pubspec.yaml", b"version: 65536.0.0+1\n")
            with self.assertRaisesRegex(RuntimeError, "between 0 and 65535"):
                build.read_app_version()


class InnoSetupTests(unittest.TestCase):
    def test_find_inno_setup_uses_the_explicit_compiler(self) -> None:
        with TemporaryDirectory() as directory:
            compiler = write_file(Path(directory) / "ISCC.exe")
            with (
                patch.dict(
                    os.environ,
                    {"INNO_SETUP_COMPILER": str(compiler)},
                    clear=True,
                ),
                patch.object(build.shutil, "which") as which_mock,
            ):
                self.assertEqual(build.find_inno_setup_compiler(), compiler)

            which_mock.assert_not_called()

    def test_find_inno_setup_rejects_an_invalid_explicit_compiler(self) -> None:
        with patch.dict(
            os.environ,
            {"INNO_SETUP_COMPILER": "/missing/ISCC.exe"},
            clear=True,
        ):
            with self.assertRaisesRegex(FileNotFoundError, "does not point"):
                build.find_inno_setup_compiler()

    def test_find_inno_setup_searches_path(self) -> None:
        with patch.dict(os.environ, {}, clear=True):
            with patch.object(
                build.shutil, "which", side_effect=[None, "/tools/ISCC"]
            ) as which_mock:
                compiler = build.find_inno_setup_compiler()

        self.assertEqual(compiler, Path("/tools/ISCC"))
        self.assertEqual(
            which_mock.call_args_list,
            [call("ISCC.exe"), call("ISCC")],
        )

    def test_find_inno_setup_searches_program_files(self) -> None:
        with TemporaryDirectory() as directory:
            program_files = Path(directory) / "Program Files"
            compiler = write_file(program_files / "Inno Setup 7/ISCC.exe")
            with (
                patch.dict(
                    os.environ,
                    {"ProgramFiles": str(program_files)},
                    clear=True,
                ),
                patch.object(build.shutil, "which", return_value=None),
            ):
                self.assertEqual(build.find_inno_setup_compiler(), compiler)

    def test_find_inno_setup_reports_when_no_compiler_exists(self) -> None:
        with (
            patch.dict(os.environ, {}, clear=True),
            patch.object(build.shutil, "which", return_value=None),
        ):
            with self.assertRaisesRegex(FileNotFoundError, "was not found"):
                build.find_inno_setup_compiler()


class WindowsInstallerTests(unittest.TestCase):
    def test_build_windows_installer_writes_a_checksum_manifest(self) -> None:
        with temporary_project() as paths:
            populate_windows_release(paths)
            write_file(paths.windows_script, b"[Setup]")
            compiler = paths.root / "tools/ISCC.exe"
            installer = (
                paths.windows_installer
                / "XJI-Media-Toolbox-Setup-1.2.3+4-x64.exe"
            )

            def create_installer(command, *, environment=None):
                self.assertIsNone(environment)
                write_file(installer, b"installer payload")

            with (
                patch.object(
                    build, "read_app_version", return_value=("1.2.3+4", "1.2.3.4")
                ),
                patch.object(
                    build, "find_inno_setup_compiler", return_value=compiler
                ),
                patch.object(build, "run", side_effect=create_installer) as run_mock,
                patch("builtins.print"),
            ):
                result = build.build_windows_installer()

            self.assertEqual(result, installer)
            command = run_mock.call_args.args[0]
            self.assertEqual(command[0], str(compiler))
            self.assertIn("/DMyAppVersion=1.2.3+4", command)
            self.assertIn("/DMyNumericVersion=1.2.3.4", command)
            self.assertIn(f"/DMyAppSourceDir={paths.windows_release}", command)
            self.assertIn(f"/DMyOutputDir={paths.windows_installer}", command)
            self.assertIn(f"/DMyProjectRoot={paths.root}", command)
            self.assertEqual(command[-1], str(paths.windows_script))

            expected_hash = hashlib.sha256(b"installer payload").hexdigest()
            checksum_file = installer.with_suffix(".exe.sha256")
            self.assertEqual(
                checksum_file.read_text(encoding="utf-8"),
                f"{expected_hash}  {installer.name}\n",
            )

    def test_build_windows_installer_rejects_an_incomplete_release(self) -> None:
        with temporary_project() as paths:
            with self.assertRaisesRegex(FileNotFoundError, "release is incomplete"):
                build.build_windows_installer()

    def test_build_windows_installer_requires_the_inno_script(self) -> None:
        with temporary_project() as paths:
            populate_windows_release(paths)
            with self.assertRaisesRegex(FileNotFoundError, "script was not found"):
                build.build_windows_installer()

    def test_build_windows_installer_propagates_compiler_failure(self) -> None:
        failure = subprocess.CalledProcessError(2, ["ISCC.exe"])
        with temporary_project() as paths:
            populate_windows_release(paths)
            write_file(paths.windows_script)
            with (
                patch.object(
                    build, "read_app_version", return_value=("1.0.0", "1.0.0.0")
                ),
                patch.object(
                    build,
                    "find_inno_setup_compiler",
                    return_value=Path("ISCC.exe"),
                ),
                patch.object(build, "run", side_effect=failure),
            ):
                with self.assertRaises(subprocess.CalledProcessError) as context:
                    build.build_windows_installer()

        self.assertIs(context.exception, failure)

    def test_build_windows_installer_requires_compiler_output(self) -> None:
        with temporary_project() as paths:
            populate_windows_release(paths)
            write_file(paths.windows_script)
            with (
                patch.object(
                    build, "read_app_version", return_value=("1.0.0", "1.0.0.0")
                ),
                patch.object(
                    build,
                    "find_inno_setup_compiler",
                    return_value=Path("ISCC.exe"),
                ),
                patch.object(build, "run"),
            ):
                with self.assertRaisesRegex(
                    FileNotFoundError, "without producing the installer"
                ):
                    build.build_windows_installer()


class PackagedRuntimeTests(unittest.TestCase):
    def test_verify_packaged_windows_runtime_executes_both_tools(self) -> None:
        with temporary_project() as paths:
            ffmpeg = write_file(paths.windows_release / "ffmpeg/ffmpeg.exe")
            ffprobe = write_file(paths.windows_release / "ffmpeg/ffprobe.exe")
            with patch.object(build, "run") as run_mock:
                build.verify_packaged_runtime("windows")

            self.assertEqual(
                run_mock.call_args_list,
                [call([str(ffmpeg), "-version"]), call([str(ffprobe), "-version"])],
            )

    def test_verify_packaged_runtime_rejects_a_missing_tool(self) -> None:
        with temporary_project():
            with self.assertRaisesRegex(
                FileNotFoundError, "built without the FFmpeg runtime"
            ):
                build.verify_packaged_runtime("windows")

    def test_verify_packaged_runtime_propagates_tool_failure(self) -> None:
        failure = subprocess.CalledProcessError(3, ["ffmpeg.exe"])
        with temporary_project() as paths:
            write_file(paths.windows_release / "ffmpeg/ffmpeg.exe")
            write_file(paths.windows_release / "ffmpeg/ffprobe.exe")
            with patch.object(build, "run", side_effect=failure):
                with self.assertRaises(subprocess.CalledProcessError) as context:
                    build.verify_packaged_runtime("windows")

        self.assertIs(context.exception, failure)

    def test_verify_packaged_macos_runtime_checks_architecture_and_signature(
        self,
    ) -> None:
        with temporary_project() as paths:
            macho_files = populate_macos_bundle(paths)

            def inspect(command, **kwargs):
                candidate = Path(command[-1])
                if command[0] == "/usr/bin/file":
                    description = (
                        "Mach-O 64-bit executable arm64"
                        if candidate in macho_files
                        else "XML 1.0 document"
                    )
                    return SimpleNamespace(stdout=description)
                if command[0] == "lipo":
                    return SimpleNamespace(stdout="arm64\n")
                self.fail(f"Unexpected command: {command}")

            with (
                patch.object(build.subprocess, "run", side_effect=inspect),
                patch.object(build, "run") as run_mock,
            ):
                build.verify_packaged_runtime("macos")

            ffmpeg = paths.macos_app / "Contents/Helpers/ffmpeg"
            ffprobe = paths.macos_app / "Contents/Helpers/ffprobe"
            self.assertEqual(
                run_mock.call_args_list,
                [
                    call([str(ffmpeg), "-version"]),
                    call([str(ffprobe), "-version"]),
                    call(
                        [
                            "codesign",
                            "--verify",
                            "--deep",
                            "--strict",
                            "--verbose=2",
                            str(paths.macos_app),
                        ]
                    ),
                ],
            )

    def test_verify_packaged_macos_runtime_requires_a_macho_app(self) -> None:
        with temporary_project() as paths:
            macho_files = populate_macos_bundle(paths)
            app_executable = paths.macos_app / "Contents/MacOS/XJI Media Toolbox"
            macho_files.remove(app_executable)

            def inspect(command, **kwargs):
                candidate = Path(command[-1])
                description = "Mach-O" if candidate in macho_files else "data"
                return SimpleNamespace(stdout=description)

            with (
                patch.object(build.subprocess, "run", side_effect=inspect),
                patch.object(build, "run"),
            ):
                with self.assertRaisesRegex(RuntimeError, "is not Mach-O"):
                    build.verify_packaged_runtime("macos")

    def test_verify_packaged_macos_runtime_rejects_non_arm64_macho_files(
        self,
    ) -> None:
        with temporary_project() as paths:
            macho_files = populate_macos_bundle(paths)
            ffprobe = paths.macos_app / "Contents/Helpers/ffprobe"

            def inspect(command, **kwargs):
                candidate = Path(command[-1])
                if command[0] == "/usr/bin/file":
                    return SimpleNamespace(
                        stdout="Mach-O" if candidate in macho_files else "data"
                    )
                architecture = "x86_64" if candidate == ffprobe else "arm64"
                return SimpleNamespace(stdout=architecture)

            with (
                patch.object(build.subprocess, "run", side_effect=inspect),
                patch.object(build, "run"),
            ):
                with self.assertRaisesRegex(RuntimeError, "does not support arm64"):
                    build.verify_packaged_runtime("macos")

    def test_verify_packaged_macos_runtime_rejects_a_universal_main_binary(
        self,
    ) -> None:
        with temporary_project() as paths:
            macho_files = populate_macos_bundle(paths)
            app_executable = paths.macos_app / "Contents/MacOS/XJI Media Toolbox"

            def inspect(command, **kwargs):
                candidate = Path(command[-1])
                if command[0] == "/usr/bin/file":
                    return SimpleNamespace(
                        stdout="Mach-O" if candidate in macho_files else "data"
                    )
                architectures = (
                    "x86_64 arm64" if candidate == app_executable else "arm64"
                )
                return SimpleNamespace(stdout=architectures)

            with (
                patch.object(build.subprocess, "run", side_effect=inspect),
                patch.object(build, "run"),
            ):
                with self.assertRaisesRegex(RuntimeError, "arm64-only"):
                    build.verify_packaged_runtime("macos")


class BuildEntryPointTests(unittest.TestCase):
    def test_main_builds_and_packages_windows(self) -> None:
        with (
            patch.object(build, "validate_host") as validate_host,
            patch.object(build, "verify_runtime") as verify_runtime,
            patch.object(build.shutil, "which", return_value="C:/flutter/bin/flutter"),
            patch.object(build, "run") as run_mock,
            patch.object(build, "verify_packaged_runtime") as verify_packaged,
            patch.object(build, "build_windows_installer") as build_installer,
        ):
            build.main(["--build", "windows"])

        validate_host.assert_called_once_with("windows")
        verify_runtime.assert_called_once_with("windows")
        self.assertEqual(
            run_mock.call_args_list,
            [
                call(["C:/flutter/bin/flutter", "clean"]),
                call(["C:/flutter/bin/flutter", "pub", "get"]),
                call(["C:/flutter/bin/flutter", "build", "windows", "--release"]),
            ],
        )
        verify_packaged.assert_called_once_with("windows")
        build_installer.assert_called_once_with()

    def test_main_builds_arm64_macos_without_an_installer(self) -> None:
        with (
            patch.dict(os.environ, {"BASE": "kept"}, clear=True),
            patch.object(build, "validate_host"),
            patch.object(build, "verify_runtime"),
            patch.object(build.shutil, "which", return_value="/tools/flutter"),
            patch.object(build, "run") as run_mock,
            patch.object(build, "verify_packaged_runtime") as verify_packaged,
            patch.object(build, "build_windows_installer") as build_installer,
        ):
            build.main(["--build", "macos"])

        build_call = run_mock.call_args_list[2]
        self.assertEqual(
            build_call.args[0],
            ["/tools/flutter", "build", "macos", "--release"],
        )
        self.assertEqual(
            build_call.kwargs["environment"],
            {
                "BASE": "kept",
                "ARCHS": "arm64",
                "EXCLUDED_ARCHS": "x86_64",
                "ONLY_ACTIVE_ARCH": "YES",
            },
        )
        verify_packaged.assert_called_once_with("macos")
        build_installer.assert_not_called()

    def test_main_stops_when_flutter_is_missing(self) -> None:
        with (
            patch.object(build, "validate_host"),
            patch.object(build, "verify_runtime"),
            patch.object(build.shutil, "which", return_value=None),
            patch.object(build, "run") as run_mock,
        ):
            with self.assertRaisesRegex(FileNotFoundError, "Flutter was not found"):
                build.main(["--build", "windows"])

        run_mock.assert_not_called()

    def test_main_propagates_flutter_command_failure(self) -> None:
        failure = subprocess.CalledProcessError(1, ["flutter", "clean"])
        with (
            patch.object(build, "validate_host"),
            patch.object(build, "verify_runtime"),
            patch.object(build.shutil, "which", return_value="flutter"),
            patch.object(build, "run", side_effect=failure),
            patch.object(build, "verify_packaged_runtime") as verify_packaged,
        ):
            with self.assertRaises(subprocess.CalledProcessError) as context:
                build.main(["--build", "windows"])

        self.assertIs(context.exception, failure)
        verify_packaged.assert_not_called()


if __name__ == "__main__":
    unittest.main()
