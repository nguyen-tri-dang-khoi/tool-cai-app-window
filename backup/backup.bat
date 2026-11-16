@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Run as administrator.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
chcp 65001 > nul
start "Backup du lieu" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0backup.ps1"