@echo off
title WIFI CONNECT TOOL
color 0A
chcp 65001 >nul
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)


:MENU
cls
echo =====================================
echo       WIFI CONNECT TOOL
echo =====================================
echo.
echo 1. Bat Wi-Fi
echo 2. Xem danh sach Wi-Fi
echo 3. Ket noi Wi-Fi bang mat khau
echo 4. Xem trang thai ket noi
echo 5. Thoat
echo.
set /p choice=Chon chuc nang: 

if "%choice%"=="1" goto ENABLE
if "%choice%"=="2" goto SCAN
if "%choice%"=="3" goto CONNECT
if "%choice%"=="4" goto STATUS
if "%choice%"=="5" exit
goto MENU

:ENABLE
echo Dang bat Wi-Fi...
netsh interface set interface name="Wi-Fi" admin=enabled
timeout /t 2 >nul
goto MENU

:SCAN
netsh wlan show networks
echo.
pause
goto MENU

:CONNECT
echo.
set /p SSID=Nhap ten Wi-Fi (SSID): 
set /p PASS=Nhap mat khau Wi-Fi: 

echo.
echo Dang tao cau hinh Wi-Fi...
start "Wifi Connection " powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0connect.ps1" -SSID "%SSID%" -PASS "%PASS%"
echo.
echo Da gui lenh ket noi. Kiem tra trang thai...
timeout /t 5 >nul
netsh wlan show interfaces
pause
goto MENU

:STATUS
netsh wlan show interfaces
echo.
pause
goto MENU
```