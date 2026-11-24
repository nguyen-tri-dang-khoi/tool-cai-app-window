Start-BitsTransfer -Source "https://github.com//microsoft/winget-cli/releases/download/v1.29.380/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -Destination "$env:USERPROFILE\Downloads\khoi_dep_trai.msixbundle"
$File = "$env:USERPROFILE\Downloads\khoi_dep_trai.msixbundle"
Add-AppxPackage -Path $File -ErrorAction Stop