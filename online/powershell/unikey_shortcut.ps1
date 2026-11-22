$p = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
$exe = Get-ChildItem -Path $p -Filter 'UniKeyNT.exe' -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
if ($exe) { 
    $s = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'UniKey.lnk'))
    $s.TargetPath = $exe; $s.WorkingDirectory = Split-Path $exe
    $s.Save(); 
    Write-Host 'Da tao shortcut:' $exe 
} else { 
    Write-Host 'Khong tim thay UniKeyNT.exe. Kiem tra lai viec cai dat.' 
}