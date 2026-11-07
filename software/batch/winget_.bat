
@echo off
chcp 65001 >nul
setlocal EnableExtensions
title WinGet - Kiem tra va cai dat
:: Kiem tra he dieu hanh
for /f "tokens=4-5 delims=. " %%a in ('ver') do (
    set "BUILD=%%b"
)

for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2^>nul ^| findstr /i "ProductName"') do set "OSNAME=%%a"

for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuildNumber 2^>nul ^| findstr /i "CurrentBuildNumber"') do set "BUILD=%%a"

echo %OSNAME% %BUILD%
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
winget
:: https://github.com//microsoft/winget-cli/releases/download/v1.29.380/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
start "Winget" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\powershell\download.ps1"

echo.
pause
exit /b 1
