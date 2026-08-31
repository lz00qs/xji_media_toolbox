import re
import unittest
from pathlib import Path

import build


PROJECT_ROOT = Path(__file__).resolve().parents[1]


class RuntimeManifestContractTests(unittest.TestCase):
    def test_runtime_manifest_contains_both_tools_for_each_platform(self) -> None:
        self.assertEqual(set(build.RUNTIME_FILES), {"macos", "windows"})
        expected_names = {
            "macos": {"ffmpeg", "ffprobe"},
            "windows": {"ffmpeg.exe", "ffprobe.exe"},
        }

        for target, expected in expected_names.items():
            with self.subTest(target=target):
                entries = build.RUNTIME_FILES[target]
                self.assertEqual(
                    {Path(relative_path).name for relative_path in entries},
                    expected,
                )
                for checksum in entries.values():
                    self.assertRegex(checksum, r"^[0-9a-f]{64}$")


class MacOSPackagingContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.embed_script = (
            PROJECT_ROOT / "macos/scripts/embed_ffmpeg.sh"
        ).read_text(encoding="utf-8")
        cls.xcode_project = (
            PROJECT_ROOT / "macos/Runner.xcodeproj/project.pbxproj"
        ).read_text(encoding="utf-8")

    def test_embed_script_fails_fast_and_requires_both_tools(self) -> None:
        self.assertIn("set -eu", self.embed_script)
        self.assertIn("for executable_name in ffmpeg ffprobe", self.embed_script)
        self.assertIn("Missing bundled FFmpeg runtime", self.embed_script)
        self.assertIn('exit 1', self.embed_script)

    def test_embed_script_installs_executable_helpers(self) -> None:
        self.assertIn(
            '${TARGET_BUILD_DIR}/${CONTENTS_FOLDER_PATH}/Helpers',
            self.embed_script,
        )
        self.assertIn('ditto "${source_path}" "${destination_path}"', self.embed_script)
        self.assertIn('chmod 755 "${destination_path}"', self.embed_script)
        self.assertIn('xattr -cr "${destination_path}"', self.embed_script)

    def test_embed_script_signs_release_helpers_with_a_timestamp(self) -> None:
        self.assertIn('[ "${CONFIGURATION}" = "Release" ]', self.embed_script)
        self.assertIn(
            'codesign --force --sign "${signing_identity}" '
            '--options runtime --timestamp "${destination_path}"',
            self.embed_script,
        )
        self.assertIn(
            'codesign --force --sign "${signing_identity}" '
            '--options runtime "${destination_path}"',
            self.embed_script,
        )

    def test_xcode_project_runs_the_embed_script_with_declared_io(self) -> None:
        self.assertGreaterEqual(
            self.xcode_project.count("Embed FFmpeg Runtime"),
            2,
        )
        for path in (
            "$(PROJECT_DIR)/../assets/macos/ffmpeg/ffmpeg",
            "$(PROJECT_DIR)/../assets/macos/ffmpeg/ffprobe",
            "$(PROJECT_DIR)/scripts/embed_ffmpeg.sh",
            "$(TARGET_BUILD_DIR)/$(CONTENTS_FOLDER_PATH)/Helpers/ffmpeg",
            "$(TARGET_BUILD_DIR)/$(CONTENTS_FOLDER_PATH)/Helpers/ffprobe",
        ):
            with self.subTest(path=path):
                self.assertIn(f'"{path}"', self.xcode_project)
        self.assertIn(
            'shellScript = "/bin/sh \\"$PROJECT_DIR/scripts/embed_ffmpeg.sh\\"\\n";',
            self.xcode_project,
        )


class WindowsPackagingContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.cmake = (PROJECT_ROOT / "windows/CMakeLists.txt").read_text(
            encoding="utf-8"
        )
        cls.inno_setup = (
            PROJECT_ROOT / "installer/windows/xji_media_toolbox.iss"
        ).read_text(encoding="utf-8")

    def test_cmake_requires_and_installs_both_runtime_tools(self) -> None:
        self.assertIn(
            '${CMAKE_CURRENT_SOURCE_DIR}/../assets/windows/ffmpeg',
            self.cmake,
        )
        self.assertIn('"${FFMPEG_RUNTIME_SOURCE_DIR}/ffmpeg.exe"', self.cmake)
        self.assertIn('"${FFMPEG_RUNTIME_SOURCE_DIR}/ffprobe.exe"', self.cmake)
        self.assertIn('if(NOT EXISTS "${FFMPEG_RUNTIME_FILE}")', self.cmake)
        self.assertIn('message(FATAL_ERROR "Missing bundled FFmpeg runtime:', self.cmake)
        self.assertRegex(
            self.cmake,
            re.compile(
                r"install\(FILES \$\{FFMPEG_RUNTIME_FILES\}\s+"
                r'DESTINATION "\$\{CMAKE_INSTALL_PREFIX\}/ffmpeg"',
                re.MULTILINE,
            ),
        )

    def test_installer_is_per_user_and_x64(self) -> None:
        self.assertIn("PrivilegesRequired=lowest", self.inno_setup)
        self.assertIn("DefaultDirName={localappdata}\\Programs\\{#MyAppName}", self.inno_setup)
        self.assertIn("ArchitecturesAllowed=x64compatible", self.inno_setup)
        self.assertIn("ArchitecturesInstallIn64BitMode=x64compatible", self.inno_setup)

    def test_installer_consumes_build_script_version_defines(self) -> None:
        for define in (
            "MyAppVersion",
            "MyNumericVersion",
            "MyAppSourceDir",
            "MyOutputDir",
            "MyProjectRoot",
        ):
            with self.subTest(define=define):
                self.assertIn(f"#ifndef {define}", self.inno_setup)
        self.assertIn("AppVersion={#MyAppVersion}", self.inno_setup)
        self.assertIn("VersionInfoVersion={#MyNumericVersion}", self.inno_setup)
        self.assertIn(
            "OutputBaseFilename=XJI-Media-Toolbox-Setup-{#MyAppVersion}-x64",
            self.inno_setup,
        )

    def test_installer_packages_the_release_tree_and_notices(self) -> None:
        self.assertIn(
            'Source: "{#MyAppSourceDir}\\*"; DestDir: "{app}"; '
            "Flags: ignoreversion recursesubdirs createallsubdirs",
            self.inno_setup,
        )
        for filename in ("README.md", "LICENSE", "THIRD_PARTY_NOTICES.md"):
            with self.subTest(filename=filename):
                self.assertIn(
                    f'Source: "{{#MyProjectRoot}}\\{filename}"',
                    self.inno_setup,
                )
        self.assertIn(
            'DestDir: "{app}\\licenses\\ffmpeg"',
            self.inno_setup,
        )


class ReleaseWorkflowContractTests(unittest.TestCase):
    def test_workflow_uses_the_verified_release_entry_point(self) -> None:
        workflow = (PROJECT_ROOT / ".github/workflows/build.yml").read_text(
            encoding="utf-8"
        )
        self.assertIn("python build.py --build macos", workflow)
        self.assertIn("python build.py --build windows", workflow)
        self.assertIn("Verify Windows installer", workflow)
        self.assertIn("ffmpeg\\ffmpeg.exe", workflow)
        self.assertIn("build/windows/installer/*.sha256", workflow)
        self.assertIn("if-no-files-found: error", workflow)


if __name__ == "__main__":
    unittest.main()
