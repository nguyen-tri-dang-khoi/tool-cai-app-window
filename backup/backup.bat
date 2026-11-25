@echo off
chcp 65001 > nul
cd /d "%~dp0"
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Run As Administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs -Wait"
    exit /b
)
start /wait "Backup dữ liệu" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0backup.ps1"
echo Đã hoàn tất
pause