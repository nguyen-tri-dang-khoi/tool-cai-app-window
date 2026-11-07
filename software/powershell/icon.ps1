$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"

New-Item -Path $path -Force | Out-Null

# This PC
Set-ItemProperty -Path $path -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -Type DWord

# Recycle Bin
Set-ItemProperty -Path $path -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Value 0 -Type DWord

# Control Panel
Set-ItemProperty -Path $path -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Value 0 -Type DWord

# Khoi dong lai Windows Explorer
Stop-Process -Name explorer -Force
Start-Process explorer.exe