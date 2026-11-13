
@echo off
setlocal EnableExtensions
chcp 65001 >nul
title GỠ BỎ PHẦN MỀM
color 0C
mode con: cols=75 lines=30
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Run as administrator.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
where winget >nul 2>&1
if errorlevel 1 (
    echo [LOI] Máy chưa có Winget.
    pause
    exit /b 1
)

:MENU
color 0C
cls
echo =================================================================================
echo                              TOOL GỠ BỎ PHẦN MỀM
echo =================================================================================
echo.
echo [1] Gói cơ bản   (Google Chrome, Winrar, LibreOffice, Unikey, PDF-XChange Viewer)
echo [1] Gói cơ bản 2 (VSCode, Virtual Box, Git, Github Desktop, Docker)
echo.
echo [3]  7-Zip             [4]  VLC Media Player        [5]  LibreOffice
echo [6]  UltraViewer       [7]  UniKey                  [8]  PDF-XChange Viewer
echo [9]  Chrome            [10] WinRAR                  [11] TeamViewer
echo [12] VSCode            [13] Virtual Box             [14] Git
echo [15] Github Desktop    [16] Docker
echo [0]  Thoát
echo.
echo ===========================================================
set /p "CHOICE=Nhập lựa chọn: "

if "%CHOICE%"=="1" call :REMOVE "Google Chrome" "Google.Chrome" & goto MENU
if "%CHOICE%"=="2" call :REMOVE "7-Zip" "7zip.7zip" & goto MENU
if "%CHOICE%"=="3" call :REMOVE "VLC Media Player" "VideoLAN.VLC" & goto MENU
if "%CHOICE%"=="4" call :REMOVE "WinRAR" "RARLab.WinRAR" & goto MENU
if "%CHOICE%"=="5" call :REMOVE "Visual Studio Code" "Microsoft.VisualStudioCode" & goto MENU
if "%CHOICE%"=="6" call :REMOVE "Git" "Git.Git" & goto MENU
if "%CHOICE%"=="7" call :REMOVE "Python 3.13" "Python.Python.3.13" & goto MENU
if "%CHOICE%"=="8" call :REMOVE "LibreOffice" "TheDocumentFoundation.LibreOffice" & goto MENU
if "%CHOICE%"=="9" call :REMOVE "Foxit PDF Reader" "Foxit.FoxitReader" & goto MENU
if "%CHOICE%"=="10" (
    tasklist | findstr /I "UniKeyNT.exe" >nul
    if %errorlevel%==0 (
        taskkill /F /IM UniKeyNT.exe
    )
    call :REMOVE "UniKey" "UniKey.UniKey"
    if exist "%USERPROFILE%\Desktop\UniKey.lnk" (
        del "%USERPROFILE%\Desktop\UniKey.lnk"
    )
    goto MENU
) 
if "%CHOICE%"=="11" call :REMOVE "PDF-XChange Viewer" "TrackerSoftware.PDF-XChangeViewer" & goto MENU
if "%CHOICE%"=="13" (
    cls
    echo ===========================================================
    echo GỠ CÀI ĐẶT PHẦN MỀM: Chrome, WinRAR, LibreOffice, PDF-XChangeViewer, UniKeyNT
    echo ===========================================================
    winget uninstall --id "Google.Chrome" --exact 
    winget uninstall --id "RARLab.WinRAR" --exact
    winget uninstall --id "TheDocumentFoundation.LibreOffice" --exact
    winget uninstall --id "TrackerSoftware.PDF-XChangeViewer" --exact
    tasklist | findstr /I "UniKeyNT.exe" >nul
    if %errorlevel%==0 (
        taskkill /F /IM UniKeyNT.exe
    )
    winget uninstall --id "UniKey.UniKey" --exact
    if exist "%USERPROFILE%\Desktop\UniKey.lnk" (
        del "%USERPROFILE%\Desktop\UniKey.lnk"
    )
    goto MENU
) 
if "%CHOICE%"=="0" goto EXIT

echo Lựa chọn không hợp lệ
timeout /t 2 >nul
goto MENU

:REMOVE
cls
echo ===========================================================
echo PHẦN MỀM: %~1
echo PACKAGE ID: %~2
echo ===========================================================
set "CONFIRM="
set /p "CONFIRM=Xác nhận gỡ cài đặt (Y/N): "

if /i not "%CONFIRM%"=="Y" exit /b 0

echo.
winget uninstall --id "%~2" --exact
if errorlevel 1 (
    echo.
    echo [!] Không gỡ được ID này
    echo Hãy tìm kiếm hoặc dùng winget list để kiểm tra
) else (
    echo.
    echo Lệnh gỡ cài đặt hoàn tất
)
pause
exit /b 0
:EXIT
echo Dang thoat...
endlocal
exit /b 0