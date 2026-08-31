#!/bin/sh

set -eu

source_directory="${PROJECT_DIR}/../assets/macos/ffmpeg"
destination_directory="${TARGET_BUILD_DIR}/${CONTENTS_FOLDER_PATH}/Helpers"

for executable_name in ffmpeg ffprobe; do
  source_path="${source_directory}/${executable_name}"
  if [ ! -f "${source_path}" ]; then
    echo "error: Missing bundled FFmpeg runtime: ${source_path}" >&2
    exit 1
  fi
done

mkdir -p "${destination_directory}"

for executable_name in ffmpeg ffprobe; do
  source_path="${source_directory}/${executable_name}"
  destination_path="${destination_directory}/${executable_name}"
  ditto "${source_path}" "${destination_path}"
  chmod 755 "${destination_path}"
  xattr -cr "${destination_path}"

  signing_identity="${EXPANDED_CODE_SIGN_IDENTITY:--}"
  if [ "${CONFIGURATION}" = "Release" ] && [ "${signing_identity}" != "-" ]; then
    codesign --force --sign "${signing_identity}" --options runtime --timestamp "${destination_path}"
  else
    codesign --force --sign "${signing_identity}" --options runtime "${destination_path}"
  fi
done
