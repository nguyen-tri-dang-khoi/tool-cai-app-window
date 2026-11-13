
@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Run as administrator.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
chcp 65001 >nul
setlocal EnableExtensions
title INSTALL PHAN MEM CO BAN
call "%~dp0batch/winget_.bat"
:MENU
cls
echo ==========================================
echo       TOOL CÀI PHẦN MỀM TỰ ĐỘNG
echo ==========================================
echo.
echo  [1] Gói cơ bản (google chrome, winrar, libreoffice, unikey, pdf-xchange viewer)
echo  [2] Goi co ban 2 (VSCode, Virtual Box, Git, Github Desktop, Docker)
echo  [3] 7-Zip
echo  [4] VLC Media Player
echo  [5] LibreOffice
echo  [6] UltraViewer
echo  [7] UniKey
echo  [8] PDF-XChange Viewer
echo  [9] Google Chrome
echo  [10] WinRAR
echo  [11] TeamViewer
echo  [12] Danh muc ngon ngu
echo  [0] Thoat
echo.
set /p choice=Nhập lựa chọn: 

if "%choice%"=="0" exit /b
if "%choice%"=="1" (
    call :INSTALL Google.Chrome
    start ms-settings:defaultapps
    call :INSTALL UniKey.UniKey
    start "UniKey Shortcut" powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'; $exe = Get-ChildItem -Path $p -Filter 'UniKeyNT.exe' -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName; if ($exe) { $s = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'UniKey.lnk')); $s.TargetPath = $exe; $s.WorkingDirectory = Split-Path $exe; $s.Save(); Write-Host 'Da tao shortcut:' $exe } else { Write-Host 'Khong tim thay UniKeyNT.exe. Kiem tra lai viec cai dat.' }"
    call :INSTALL TrackerSoftware.PDF-XChangeViewer
    call :INSTALL TheDocumentFoundation.LibreOffice
    if errorlevel 1 (
        echo Cai dat libreoffice that bai
        pause
        goto MENU
    )
    start "LibreOffice Shortcut" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0powershell\create_shortcut.ps1"
    start "LibreOffice Config" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0powershell\save_as_libreoffice.ps1"
    call :INSTALL RARLab.WinRAR
    start "Desktop ControlPanel RecycleBin Shortcut" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0powershell\icon.ps1"

)
if "%choice%"=="2" (
    call :INSTALL Microsoft.VisualStudioCode
    call :INSTALL Oracle.VirtualBox
    call :INSTALL Git.Git
    call :INSTALL GitHub.GitHubDesktop
    call :INSTALL Docker.DockerDesktop
)
if "%choice%"=="3" call :INSTALL 7zip.7zip
if "%choice%"=="4" call :INSTALL VideoLAN.VLC
if "%choice%"=="5" (
    call :INSTALL TheDocumentFoundation.LibreOffice
    if errorlevel 1 (
        echo [Error] LibreOffice install Failed
        pause
        goto MENU
    )
    start "LibreOffice Shortcut" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0powershell\create_shortcut.ps1"
    start "LibreOffice Config" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0powershell\save_as_libreoffice.ps1"
)
if "%choice%"=="6" call :INSTALL DucFabulous.UltraViewer
if "%choice%"=="7" (
    call :INSTALL UniKey.UniKey
    start "UniKey Shortcut" powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'; $exe = Get-ChildItem -Path $p -Filter 'UniKeyNT.exe' -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName; if ($exe) { $s = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'UniKey.lnk')); $s.TargetPath = $exe; $s.WorkingDirectory = Split-Path $exe; $s.Save(); Write-Host 'Da tao shortcut:' $exe } else { Write-Host 'Khong tim thay UniKeyNT.exe. Kiem tra lai viec cai dat.' }"
) 
if "%choice%"=="8" call :INSTALL TrackerSoftware.PDF-XChangeViewer
if "%choice%"=="9" call :INSTALL Google.Chrome
if "%choice%"=="10" call :INSTALL RARLab.WinRAR
if "%choice%"=="11" call :INSTALL TeamViewer.TeamViewer

echo.
echo Da xu ly xong danh sach.
pause
goto MENU

:INSTALL
echo.
echo ==========================================
echo Dang cai: %~1
echo ==========================================
winget install --id "%~1" --exact --silent --accept-package-agreements --accept-source-agreements --log "%~dp0log\%~1.log"
if errorlevel 1 (
    echo [LOI] Hay kiem tra goi: %~1
    exit /b 1
) else (
    echo [OK] Lenh cai dat thanh cong: %~1
    exit /b 0
)