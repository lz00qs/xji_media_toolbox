# xji_media_toolbox

## Introduction
This is a toolbox for DJI drone media processing. It base on flutter and can run on both Windows and MacOS. It can process the media files from DJI drones, including the following functions:
- File renaming
- File deleting
- Videos and photos preview
- Videos compression
- Videos trimming
- Videos merging
- AEB photos marking

> DNG photos are not tested.


## Installation
1. Download the latest version from the release page.
2. Unzip the downloaded file.
3. Run the `xji_media_toolbox.exe` on Windows or `XJI Media Toolbox` on MacOS.

> If you are using MacOS, you may need to allow the app to run in the system settings.(System Preferences -> Security & Privacy -> General -> Allow)

> For MacOS, you may need to install the `ffmpeg` first. You can install it by running `brew install ffmpeg` in the terminal.

## Usage
1. Open the media folder by clicking the `Open` button. (Warning: due to this app is still in development, please backup your media files before using this app, not suggested to use it on the original media files or SD cards.).
2. Select the media files you want to process. You can use arrow keys to navigate the files.
3. Select the function you want to use by clicking the buttons on the right side.
4. In settings, you can set the video compression parameters and debug mode.

## Development
This app is developed by Flutter. You can clone the source code and run it by yourself. The source code is in the `src` folder.

> For Windows, due to the `fvp` plugin does not support IDE debugging, you may need to run the app by `flutter run` in the terminal. See this [issue](https://github.com/wang-bin/fvp/issues/125) for more information.