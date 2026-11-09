@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Run as administrator.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
msiexec.exe /i "%~dp0file_cai_dat\LibreOffice.msi" /passive /norestart /L*V "%~dp0install.log"

set "ERR=%ERRORLEVEL%"

echo.
echo ========================================
echo KET QUA: %ERR%
echo ========================================
pause