
@echo off
setlocal EnableExtensions
chcp 65001 >nul
title UNINSTALL PHAN MEM CO BAN
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
    echo [LOI] May chua co WinGet.
    echo Hay cai App Installer tu Microsoft Store.
    pause
    exit /b 1
)

:MENU
color 0C
cls
echo ===========================================================
echo                 SOFTWARE UNINSTALL TOOL
echo                    WINDOWS 10 / 11
echo ===========================================================
echo.
echo  [1]  Google Chrome
echo  [2]  7-Zip
echo  [3]  VLC Media Player
echo  [4]  WinRAR
echo  [5]  Visual Studio Code
echo  [6]  Git
echo  [7]  Python 3.13
echo  [8]  LibreOffice
echo  [9]  Foxit PDF Reader
echo  [10] UniKey
echo  [11] PDF-XChange Viewer
echo  [13] Phan mem co ban
echo  [0]  Thoat
echo.
echo ===========================================================
set "CHOICE="
set /p "CHOICE=Chon chuc nang: "

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
    echo GO CAI DAT PHAN MEM: Chrome, WinRAR, LibreOffice, PDF-XChangeViewer, UniKeyNT
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

echo Lua chon khong hop le.
timeout /t 2 >nul
goto MENU

:REMOVE
cls
echo ===========================================================
echo PHAN MEM: %~1
echo PACKAGE ID: %~2
echo ===========================================================
set "CONFIRM="
set /p "CONFIRM=Xac nhan go cai dat (Y/N): "

if /i not "%CONFIRM%"=="Y" exit /b 0

echo.
winget uninstall --id "%~2" --exact
if errorlevel 1 (
    echo.
    echo [!] Khong go duoc bang ID nay.
    echo Hay dung muc tim kiem hoac winget list de kiem tra.
) else (
    echo.
    echo Lenh go cai dat da hoan tat.
)
pause
exit /b 0
:EXIT
echo Dang thoat...
endlocal
exit /b 0