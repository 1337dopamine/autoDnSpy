@echo off
setlocal enabledelayedexpansion

set "repo=dnSpy/dnSpy"
set "assetName=dnSpy-net-win64.zip"
set "zipFile=%TEMP%\dnSpy.zip"
set "extractDir=%TEMP%\dnSpyExtracted"
set "installDir=%ProgramFiles%\dnSpy"
set "shortcutName=dnSpy.lnk"
set "desktopShortcut=%USERPROFILE%\Desktop\%shortcutName%"

echo [!] Fetching latest dnSpy release info from GitHub...

for /f "usebackq delims=" %%u in (`powershell -NoProfile -Command ^
  "$release=(Invoke-RestMethod -Uri 'https://api.github.com/repos/%repo%/releases/latest'); ^
   $asset=$release.assets | Where-Object { $_.name -eq '%assetName%' }; ^
   if ($asset) { Write-Output $asset.browser_download_url } else { exit 1 }"`) do (
    set "downloadUrl=%%u"
)

if not defined downloadUrl (
    echo [!] ERROR: Could not find download URL for %assetName%.
    exit /b 1
)

echo [!] Download URL: %downloadUrl%
echo [!] Downloading dnSpy...

powershell -NoProfile -Command "Invoke-WebRequest -Uri '%downloadUrl%' -OutFile '%zipFile%'"

if not exist "%zipFile%" (
    echo [!] ERROR: Failed to download dnSpy.
    exit /b 1
)

echo [!] Extracting dnSpy...
powershell -NoProfile -Command "Expand-Archive -Path '%zipFile%' -DestinationPath '%extractDir%' -Force"

if exist "%installDir%" (
    echo [!] Removing old installation...
    rmdir /s /q "%installDir%"
)

if exist "%extractDir%\dnSpy" (
    move "%extractDir%\dnSpy" "%installDir%"
) else (
    move "%extractDir%" "%installDir%"
)

echo [!] Creating desktop shortcut...

powershell -NoProfile -Command ^
 "$s=(New-Object -COM WScript.Shell).CreateShortcut('%desktopShortcut%'); ^
  $s.TargetPath='%installDir%\dnSpy.exe'; ^
  $s.WorkingDirectory='%installDir%'; ^
  $s.IconLocation='%installDir%\dnSpy.exe'; ^
  $s.Save()"

echo [!] Cleaning up...
del "%zipFile%"
rmdir /s /q "%extractDir%"

echo [!] Done! dnSpy installed to "%installDir%" and shortcut created on Desktop.
pause
