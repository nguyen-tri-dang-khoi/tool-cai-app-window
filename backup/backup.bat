@echo off
chcp 65001 > nul
cd /d "%~dp0"
@REM net session >nul 2>&1
@REM  if %errorlevel% neq 0 (
@REM      echo Run As Administrator...
@REM      powershell -Command "Start-Process '%~f0' -Verb RunAs -Wait"
@REM      exit /b
@REM  )
start /wait "Backup dữ liệu" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0backup.ps1"
echo Đã hoàn tất
pause