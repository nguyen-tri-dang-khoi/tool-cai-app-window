chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

$p = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
$exe = Get-ChildItem -Path $p -Filter 'UniKeyNT.exe' -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
if ($exe) { 
    $s = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'UniKey.lnk'))
    $s.TargetPath = $exe; $s.WorkingDirectory = Split-Path $exe
    $s.Save(); 
    Write-Host 'Đã tạo shortcut:' $exe 
} else { 
    Write-Host 'Không tìm thấy Unikey hãy kiểm tra cài đặt.' 
}