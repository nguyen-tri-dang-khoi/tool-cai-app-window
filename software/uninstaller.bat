
@echo off
setlocal EnableExtensions
chcp 65001 >nul
title GỠ BỎ PHẦN MỀM
color 0C
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
echo.
echo [17] Ngôn ngữ lập trình
echo.
echo [0]  Thoát
echo.
echo ===========================================================
set /p "choice=Nhập lựa chọn: "
if "%choice%"=="0" goto EXIT
if "%choice%"=="1" (
    cls
    echo ===========================================================
    echo Gở gói cơ bản: Chrome, WinRAR, LibreOffice, PDF-XChangeViewer, UniKeyNT
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
if "%choice%"=="2" (
    cls
    echo ===========================================================
    echo Gở gói cơ bản 2: VSCode, Virtual Box, Git, Github Desktop, Docker
    echo ===========================================================
    winget uninstall --id "Microsoft.VisualStudioCode" --exact 
    winget uninstall --id "Oracle.VirtualBox" --exact
    winget uninstall --id "Git.Git" --exact
    winget uninstall --id "GitHub.GitHubDesktop" --exact
    winget uninstall --id "Docker.DockerDesktop" --exact
)
if "%choice%"=="3" call :REMOVE "7-Zip" "7zip.7zip" & goto MENU
if "%choice%"=="4" call :REMOVE "VLC Media Player" "VideoLAN.VLC" & goto MENU
if "%choice%"=="5" call :REMOVE "LibreOffice" "TheDocumentFoundation.LibreOffice" & goto MENU
if "%choice%"=="6" call :REMOVE "UltraViewer" "DucFabulous.UltraViewer" & goto MENU
if "%choice%"=="7" (
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
if "%choice%"=="8" call :REMOVE "PDF-XChange Viewer" "TrackerSoftware.PDF-XChangeViewer" & goto MENU
if "%choice%"=="9" call :REMOVE "Google Chrome" "Google.Chrome" & goto MENU
if "%choice%"=="10" call :REMOVE "WinRAR" "RARLab.WinRAR" & goto MENU
if "%choice%"=="11" call :REMOVE "TeamViewer" "TeamViewer.TeamViewer" & goto MENU
if "%choice%"=="12" call :REMOVE "Visual Studio Code" "Microsoft.VisualStudioCode" & goto MENU
if "%choice%"=="13" call :REMOVE "Virtual Box" "Oracle.VirtualBox" & goto MENU
if "%choice%"=="14" call :REMOVE "Git" "Git.Git" & goto MENU
if "%choice%"=="15" call :REMOVE "Github Desktop" "GitHub.GitHubDesktop" & goto MENU
if "%choice%"=="16" call :REMOVE "Docker" "Docker.DockerDesktop" & goto MENU
if "%choice%"=="17" goto MENU_LANG_PROGRAMMING
echo Lựa chọn không hợp lệ
timeout /t 2 >nul
goto MENU

:MENU_LANG_PROGRAMMING
cls
echo ================================================
echo                  CHỌN NGÔN NGỮ
echo ================================================
echo [1]  NodeJS   
echo [2]  Python     
echo [3]  Visual Studio Community 2022 (c/c++)
echo [4]  Xampp (php)
echo [5]  Quay lại
echo.
echo [0] Thoát chương trình
echo.
set /p choice=Nhập lựa chọn: 
if "%choice%"=="0" exit /b
if "%choice%"=="1" call :REMOVE "NodeJS" "OpenJS.NodeJS.LTS"
if "%choice%"=="2" call :REMOVE "Python 3.14" "Python.Python.3.14"
if "%choice%"=="3" winget uninstall --id Microsoft.VisualStudio.2022.Community --exact --silent
if "%choice%"=="4" call :REMOVE "Xampp" "ApacheFriends.Xampp.8.2"
if "%choice%"=="5" goto MENU
echo.
echo Đã xử lý xong danh sách
pause
goto MENU_LANG_PROGRAMMING
exit /b


:REMOVE
cls
echo ===========================================================
echo %~1
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