
@echo off
chcp 65001 >nul
title Windows App Management

:MENU
cls
echo =====================================
echo      WINDOWS APP MANAGEMENT
echo =====================================
echo.
echo [1] Apps ^& Features
echo [2] Computer Management
echo [3] Device Manager
echo [4] Services
echo [5] Task Manager
echo [6] Control Panel
echo [7] Display Settings
echo [8] DirectX Diagnostic Tool (dxdiag)
echo [9] Devices and Printers
echo [0] Exit
echo.
set /p choice=Nhap lua chon: 

if "%choice%"=="1" start "" ms-settings:appsfeatures
if "%choice%"=="2" start "" compmgmt.msc
if "%choice%"=="3" start "" devmgmt.msc
if "%choice%"=="4" start "" services.msc
if "%choice%"=="5" start "" taskmgr
if "%choice%"=="7" start "" ms-settings:display
if "%choice%"=="6" start "" control
if "%choice%"=="8" start "" dxdiag
if "%choice%"=="9" start "" control printers
if "%choice%"=="0" exit

goto MENU
