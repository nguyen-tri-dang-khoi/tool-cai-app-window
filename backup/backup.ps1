chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
# Clear-Host
# Lay thong tin user
$Username = $env:USERNAME
$UserPath = $env:USERPROFILE
Write-Host "`nUser: $Username"
Write-Host "Profile: $UserPath"
# Chon o dia backup
Write-Host "`nDanh sách ổ đĩa:"
Get-Volume |
Where-Object {
    $_.DriveLetter
} | Format-Table DriveLetter, FileSystemLabel,@{Name="TotalSize(GB)"; Expression={[math]::Round($_.Size / 1GB, 2)}}, @{Name="FreeSpace(GB)"; Expression={[math]::Round($_.SizeRemaining / 1GB, 2)}}

$Drive = Read-Host "Nhập ký tự ổ đĩa (VD: E)"
if ($Drive -notmatch '^[A-Za-z]$' -or
    -not (Test-Path "$($Drive):\")) {
    Write-Host "Ổ đĩa không hợp lệ!" -ForegroundColor Red
    exit 1
}

$Destination = "$($Drive):\du_lieu_khach"

# Tao thu muc backup
$Date = Get-Date -Format "dd-MM-yyyy_HH-mm-ss"
$BackupPath = Join-Path $Destination "${Username}_${Date}_backup"
New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null

$Folders = @("Desktop","Documents","Downloads","Pictures","Videos","Music")
foreach ($Folder in $Folders) {
    $Source = Join-Path $UserPath $Folder
    $Target = Join-Path $BackupPath $Folder
    if (Test-Path $Source) {
        Write-Host "`nĐang backup: $Folder" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $Target -Force | Out-Null
        robocopy $Source $Target /E /COPY:DAT /DCOPY:DAT /R:2 /W:2 /XJ /TEE /NFL /NDL /NP
        $Result = $LASTEXITCODE
        if ($Result -lt 8) {
            Write-Host "$Folder : Thành công" -ForegroundColor Green
        }
        else {
            Write-Host "$Folder : Lỗi Backup (Code $Result)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "$Folder : Không tồn tại" -ForegroundColor DarkGray
    }
}
Write-Host "Dữ liệu: $BackupPath"
Read-Host "Backup hoàn tất"

