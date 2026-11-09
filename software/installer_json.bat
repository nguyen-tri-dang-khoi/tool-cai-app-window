@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Run as administrator.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
chcp 65001 >nul
setlocal EnableExtensions
title Cai phan mem tu dong package.json
call "%~dp0batch/winget_.bat"
:: doc du lieu danh sach phan mem package.json va tien hanh cai dat
winget import -i package.json --accept-package-agreements --accept-source-agreements