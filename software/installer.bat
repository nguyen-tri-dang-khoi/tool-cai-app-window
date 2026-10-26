
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

:MENU
cls
echo ==========================================
echo       AUTO INSTALL SOFTWARE - WINDOWS
echo ==========================================
echo.
echo  [1] Google Chrome
echo  [2] Firefox
echo  [3] 7-Zip
echo  [4] VLC Media Player
echo  [5] Git
echo  [6] Visual Studio Code
echo  [7] UniKey
echo  [8] Foxit PDF Reader
echo  [9] PDF-XChange Viewer
echo  [10] LibreOffice
echo  [11] WinRAR
echo  [12] Everything
echo.
echo  [13] Cai bo phan mem co ban
echo  [14] Cai tat ca phan mem
echo  [0] Thoat
echo.
set /p choice=Nhap lua chon: 

if "%choice%"=="0" exit /b
if "%choice%"=="1" (
    call :INSTALL Google.Chrome
    start ms-settings:defaultapps
)
if "%choice%"=="2" call :INSTALL Mozilla.Firefox
if "%choice%"=="3" call :INSTALL 7zip.7zip
if "%choice%"=="4" call :INSTALL VideoLAN.VLC
if "%choice%"=="5" call :INSTALL Git.Git
if "%choice%"=="6" call :INSTALL Microsoft.VisualStudioCode
if "%choice%"=="7" (
    call :INSTALL UniKey.UniKey
    start "UniKey Shortcut" powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'; $exe = Get-ChildItem -Path $p -Filter 'UniKeyNT.exe' -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName; if ($exe) { $s = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'UniKey.lnk')); $s.TargetPath = $exe; $s.WorkingDirectory = Split-Path $exe; $s.Save(); Write-Host 'Da tao shortcut:' $exe } else { Write-Host 'Khong tim thay UniKeyNT.exe. Kiem tra lai viec cai dat.' }"
) 
if "%choice%"=="8" call :INSTALL Foxit.FoxitReader
if "%choice%"=="9" call :INSTALL TrackerSoftware.PDF-XChangeViewer
if "%choice%"=="10" (
    call :INSTALL TheDocumentFoundation.LibreOffice
    if errorlevel 1 (
        echo Cai dat libreoffice that bai
        pause
        goto MENU
    )
    start "LibreOffice Shortcut" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0create_shortcut.ps1"
)
if "%choice%"=="11" call :INSTALL RARLab.WinRAR
if "%choice%"=="12" call :INSTALL voidtools.Everything

if "%choice%"=="13" (
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
    start "LibreOffice Shortcut" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0create_shortcut.ps1"
    call :INSTALL RARLab.WinRAR
    start "" ms-settings:themes

)

if "%choice%"=="14" (
    call :INSTALL Google.Chrome
    call :INSTALL Mozilla.Firefox
    call :INSTALL 7zip.7zip
    call :INSTALL VideoLAN.VLC
    call :INSTALL Git.Git
    call :INSTALL Microsoft.VisualStudioCode
    call :INSTALL UniKey.UniKey
    call :INSTALL Foxit.FoxitReader
    call :INSTALL TrackerSoftware.PDF-XChangeViewer
    call :INSTALL TheDocumentFoundation.LibreOffice
    call :INSTALL RARLab.WinRAR
)

echo.
echo Da xu ly xong danh sach.
pause
goto MENU

:INSTALL
echo.
echo ==========================================
echo Dang cai: %~1
echo ==========================================
winget install --id "%~1" --exact --silent --accept-package-agreements --accept-source-agreements
if errorlevel 1 (
    echo [LOI] Hay kiem tra goi: %~1
    exit /b 1
) else (
    echo [OK] Lenh cai dat thanh cong: %~1
    exit /b 0
)