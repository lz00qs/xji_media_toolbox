# Third-party notices

## FFmpeg 9.0.1

XJI Media Toolbox distributes the `ffmpeg` and `ffprobe` command-line tools
for Windows x64 and macOS arm64. Both builds enable GPL components, including
libx264 and libx265, and are distributed under the GNU GPL version 3.

The applicable FFmpeg license notice and GNU GPL version 3 text are packaged
under `assets/common/licenses/ffmpeg/`.

Upstream source and license information:

- FFmpeg source: <https://ffmpeg.org/releases/ffmpeg-9.0.1.tar.xz>
- FFmpeg source repository: <https://git.ffmpeg.org/ffmpeg.git>
- FFmpeg licensing: <https://ffmpeg.org/legal.html>
- x264 source: <https://code.videolan.org/videolan/x264>
- x265 source: <https://bitbucket.org/multicoreware/x265_git>

### Windows x64

- Build: Gyan.dev FFmpeg 9.0.1 essentials, GPLv3, static x64
- Build page: <https://www.gyan.dev/ffmpeg/builds/>
- Source revision: <https://github.com/FFmpeg/FFmpeg/commit/bf1b838f2a>
- Distribution archive SHA-256:
  `49a73bdf0850092a252ac4641d922f3048d63ed113e196cc65ce1e4f7fb33e85`
- `ffmpeg.exe` SHA-256:
  `72a489eccd008c2ec2c0a5856c5c75bc3d8bbfa90166c4566865c246445e6aa3`
- `ffprobe.exe` SHA-256:
  `19202b23c0043f15ad1b7bce2344f406fd52bd6efd8f995ce02e7392a1cec52f`

The complete build configuration supplied by the distributor is packaged as
`assets/common/licenses/ffmpeg/WINDOWS_BUILD_README.txt`.

### macOS arm64

- Build: Martin Riedl FFmpeg 9.0.1 release, GPLv3, static Apple Silicon
- Build page: <https://ffmpeg.martin-riedl.de/>
- Open-source build scripts:
  <https://git.martin-riedl.de/ffmpeg/build-script>
- FFmpeg archive SHA-256:
  `8287a1b2229e05eb41859f073e18e6c52c60a778f2f5e6881070fe51b79407fe`
- FFprobe archive SHA-256:
  `102a26b8940a053298d9929bfaae71e4b6ef65ba5f19a99a88c433108560741a`
- `ffmpeg` SHA-256:
  `393e4c395020a1cb7cbd77fbe00599ce69d1c6466fee0dbd59d13f86a81a1611`
- `ffprobe` SHA-256:
  `7abc49fb2bdf2204f018e76dc6e0a8ae7643313bae09a9fa43e7eb12442271bc`

The macOS binaries are arm64 Mach-O executables and link only to macOS system
frameworks and libraries.
