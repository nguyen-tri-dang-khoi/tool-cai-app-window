
@echo off
chcp 65001 >nul
setlocal EnableExtensions
title WinGet - Kiem tra va cai dat
echo ==========================================
echo       TOOL KIEM TRA VA CAI DAT WINGET
echo ==========================================
echo.

:: 1. Kiem tra he dieu hanh
for /f "tokens=4-5 delims=. " %%a in ('ver') do (
    set "BUILD=%%b"
)

for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2^>nul ^| findstr /i "ProductName"') do set "OSNAME=%%a"

for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuildNumber 2^>nul ^| findstr /i "CurrentBuildNumber"') do set "BUILD=%%a"

echo He dieu hanh: %OSNAME%
echo Build: %BUILD%
echo.

:: Kiem tra Windows 10/11 toi thieu build 17763
if not defined BUILD (
    echo [LOI] Khong xac dinh duoc Windows Build.
    pause
    exit /b 1
)

if %BUILD% LSS 17763 (
    echo [LOI] Windows qua cu. Can Windows 10 build 17763 tro len.
    pause
    exit /b 1
)

:: Kiem tra WinGet
where winget >nul 2>&1
if not errorlevel 1 (
    echo [OK] Tim thay WinGet trong PATH.
    winget --version
    echo.
    echo Kiem tra App Installer...
    start "Checking Winget" powershell -NoProfile -Command ^
      "Get-AppxPackage Microsoft.DesktopAppInstaller | Select-Object Name,Version"
    echo.
    echo WinGet da cai dat tren may.
    pause
    exit /b 0
)

echo [Warning] Chua tim thay lenh WinGet trong PATH.
echo Dang kiem tra App Installer...

:: Dang ky lai WinGet neu App Installer da co
start "Register Again " powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe -ErrorAction SilentlyContinue"

timeout /t 3 /nobreak >nul

:: Kiem tra WinGet lan nua
where winget >nul 2>&1
if not errorlevel 1 (
    echo [OK] Da tim thay WinGet sau khi dang ky.
    winget --version
    pause
    exit /b 0
)

:: Mo trang App Installer chinh thuc de cai dat
start "" "https://apps.microsoft.com/detail/9nblggh4nns1"

echo.
pause
exit /b 1
