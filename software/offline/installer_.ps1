# Write-Host "=======Dang cai: Chrome=======" -ForegroundColor Yellow
# Start-Process -FilePath ".\file_cai_dat\ChromeSetup.exe" -ArgumentList "/silent", "/install" -Wait
# Write-Host "===Ok===" -ForegroundColor Green

# Write-Host "=======Dang cai: Winrar 64bit=======" -ForegroundColor Yellow
# Start-Process -FilePath ".\file_cai_dat\winrar_600_64bit.exe" -ArgumentList "/S" -Wait
# Write-Host "===Ok===" -ForegroundColor Green

# Write-Host "=======Dang cai: PDF Viewer=======" -ForegroundColor Yellow
# Start-Process -FilePath ".\file_cai_dat\PDFXVwer.exe" -ArgumentList "/silent", "/install" -Wait
# Write-Host "===Ok===" -ForegroundColor Green

Write-Host "=======Dang cai: LibreOffice 26.8.1=======" -ForegroundColor Yellow
#Start-Process -FilePath ".\file_cai_dat\LibreOffice.msi" -ArgumentList "/S" -Wait
# $Path = Join-Path $PSScriptRoot "file_cai_dat\LibreOffice.msi"
# Start-Process -FilePath $Path -ArgumentList "/i", "/qb", "/norestart" -Wait
# Write-Host "===Ok===" -ForegroundColor Green
msiexec /i "%CD%\file_cai_dat\LibreOffice.msi" /passive /quiet /norestart
Read-Host "Ok"
