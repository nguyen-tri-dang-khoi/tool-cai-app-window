@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Run as administrator.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
chcp 65001 >nul
setlocal EnableExtensions
setlocal EnableDelayedExpansion

title CÀI ĐẶT PHẦN MỀM

cd /d "%~dp0"

:MENU
cls
echo =================================================================================
echo                           TOOL CÀI PHẦN MỀM TỰ ĐỘNG
echo =================================================================================
echo.

set /a i=0

for %%F in ("%~dp0*.exe" "%~dp0*.msi") do (
    if exist "%%~fF" (
        set /a i+=1
        echo [!i!] %%~nxF
    )
)
echo Tổng số file cài đặt: !i!

echo.
echo [0] Gói cơ bản (google chrome, winrar, libreoffice, unikey, pdf-xchange viewer)
set /p choice=Chọn file cài đặt: 
if "%choice%"=="0" (
    call :INSTALL ChromeSetup.msi
    start ms-settings:defaultapps
    call :INSTALL PDFXVwer.exe
    call :INSTALL LibreOffice_26.8.3_Win_x86-64.msi
    start "LibreOffice Shortcut" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0powershell\create_shortcut.ps1"
    start "LibreOffice Config" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0powershell\save_as_libreoffice.ps1"
    call :INSTALL UniKeyNT.exe
    call :INSTALL winrar-x64-723.exe
    start "Desktop ControlPanel RecycleBin Shortcut" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0powershell\icon.ps1"
)
echo Đã xử lý xong danh sách
pause
goto MENU
:INSTALL
echo.
echo Đang cài file: %~1
if /I "%~1" == "ChromeSetup.msi" (
    msiexec.exe /i "%~dp0ChromeSetup.msi" /passive /norestart
) else if /I "%~1" == "winrar-x64-723.exe" (
    start /wait "" "winrar-x64-723.exe" /s 
) else if /I "%~1" == "LibreOffice_26.8.3_Win_x86-64.msi" (
    start /wait msiexec /i "LibreOffice_26.8.3_Win_x86-64.msi" /qb /norestart ALLUSERS=1 CREATEDESKTOPLINK=1
) else if /I "%~1" == "PDFXVwer.exe" (
    start /wait "" "PDFXVwer.exe" /SILENT /NORESTART
) else if /I "%~1" == "UniKeyNT.exe" (
    copy /Y "UniKeyNT.exe" "%USERPROFILE%\Desktop\"
)
echo [Thành công]: %~1
echo.
pause