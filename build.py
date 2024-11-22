import argparse
import os
import shutil
import subprocess


def backup_file(file_path):
    backup_path = f"{file_path}.bak"
    shutil.copy(file_path, backup_path)
    return backup_path


def restore_file(file_path, backup_path):
    shutil.move(backup_path, file_path)


def modify_pubspec(file_path):
    with open(file_path, "r", encoding="utf-8") as file:
        lines = file.readlines()

    with open(file_path, "w", encoding="utf-8") as file:
        for line in lines:
            if "- assets/windows/ffmpeg/" in line:
                file.write(f"# {line}")
            else:
                file.write(line)


def run_command(command):
    process = subprocess.Popen(
        command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT
    )
    for line in process.stdout:
        print(line.decode().strip())
    process.wait()
    if process.returncode != 0:
        raise subprocess.CalledProcessError(process.returncode, command)


def main():
    parser = argparse.ArgumentParser(description="Build script for Flutter project.")
    parser.add_argument(
        "--build",
        required=True,
        choices=["macos", "windows"],
        help="Target platform to build.",
    )
    args = parser.parse_args()

    target_platform = args.build

    if target_platform == "macos":
        pubspec_path = "pubspec.yaml"
        backup_path = backup_file(pubspec_path)
        try:
            modify_pubspec(pubspec_path)
            commands = [
                "flutter clean",
                "flutter pub get",
                "flutter build macos --release",
            ]
            for command in commands:
                run_command(command)
        finally:
            restore_file(pubspec_path, backup_path)
            if os.path.exists(backup_path):
                os.remove(backup_path)
    else:
        try:
            commands = [
                "flutter clean",
                "flutter pub get",
                "flutter build windows --release",
            ]
            for command in commands:
                run_command(command)
        finally:
            next


if __name__ == "__main__":
    main()
