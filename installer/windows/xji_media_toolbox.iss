#define MyAppName "XJI Media Toolbox"
#define MyAppExeName "xji_footage_toolbox.exe"
#define MyPublisher "top.hylcreative"
#define MyProjectUrl "https://github.com/lz00qs/xji_media_toolbox"

#ifndef MyAppVersion
  #define MyAppVersion "0.1.0"
#endif
#ifndef MyNumericVersion
  #define MyNumericVersion "0.1.0.0"
#endif
#ifndef MyAppSourceDir
  #define MyAppSourceDir "..\..\build\windows\x64\runner\Release"
#endif
#ifndef MyOutputDir
  #define MyOutputDir "..\..\build\windows\installer"
#endif
#ifndef MyProjectRoot
  #define MyProjectRoot "..\.."
#endif

[Setup]
AppId={{8BA22FDE-F78F-499C-9F55-00FE40EA88BE}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyPublisher}
AppPublisherURL={#MyProjectUrl}
AppSupportURL={#MyProjectUrl}/issues
AppUpdatesURL={#MyProjectUrl}/releases
AppCopyright=Copyright (C) 2024-2026 {#MyPublisher}
AppComments=DJI drone media processing toolbox
DefaultDirName={localappdata}\Programs\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
AllowNoIcons=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
CloseApplications=yes
CloseApplicationsFilter={#MyAppExeName}
RestartApplications=no
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName}
LicenseFile={#MyProjectRoot}\LICENSE
SetupIconFile={#MyProjectRoot}\windows\runner\resources\app_icon.ico
OutputDir={#MyOutputDir}
OutputBaseFilename=XJI-Media-Toolbox-Setup-{#MyAppVersion}-x64
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
SetupLogging=yes
VersionInfoVersion={#MyNumericVersion}
VersionInfoCompany={#MyPublisher}
VersionInfoDescription={#MyAppName} Setup
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyNumericVersion}
VersionInfoProductTextVersion={#MyAppVersion}
VersionInfoCopyright=Copyright (C) 2024-2026 {#MyPublisher}

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#MyAppSourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyProjectRoot}\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyProjectRoot}\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyProjectRoot}\THIRD_PARTY_NOTICES.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyProjectRoot}\assets\common\licenses\ffmpeg\*"; DestDir: "{app}\licenses\ffmpeg"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Launch {#MyAppName}"; WorkingDir: "{app}"; Flags: nowait postinstall skipifsilent
