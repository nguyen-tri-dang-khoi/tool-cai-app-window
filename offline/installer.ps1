chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
# Kiem tra quyen Administrator
$IsAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)
if (-not $IsAdmin) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList @(
        "-NoProfile"
        "-ExecutionPolicy Bypass"
        "-File `"$PSCommandPath`""
    )
    exit
}
cmd /c "color 57"

if ($PSScriptRoot) {
    $ThuMucGoc = $PSScriptRoot
} else {
    $ExePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
    $ThuMucGoc = [System.IO.Path]::GetDirectoryName($ExePath)
}

$appDirs = Join-Path -Path $ThuMucGoc -ChildPath "Apps"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
# Tao giao dien
$Form = New-Object Windows.Forms.Form
$Form.Text = "Khôi"
$Form.Size = New-Object Drawing.Size(450, 400)
$Form.StartPosition = "CenterScreen"

# Danh sach checkbox
$List = New-Object Windows.Forms.CheckedListBox
$List.Location = New-Object Drawing.Point(20, 20)
$List.Size = New-Object Drawing.Size(390, 250)
$List.CheckOnClick = $true
$List.DisplayMember = "Name"

# Quet file EXE va MSI
$Config = Join-Path $ThuMucGoc "config\software.json"
$Software = Get-Content $Config -Raw | ConvertFrom-Json

foreach ($File in $Software) {
    [void]$List.Items.Add($File)
}
$List.DisplayMember = "Name"

$All = New-Object Windows.Forms.Button
$All.Text = "Chọn tất cả"
$All.Location = New-Object Drawing.Point(20, 285)
$All.Size = New-Object Drawing.Size(100, 30)
$All.Add_Click({
    for ($i = 0; $i -lt $List.Items.Count; $i++) {
        $List.SetItemChecked($i, $true)
    }
})

$Clear = New-Object Windows.Forms.Button
$Clear.Text = "Bỏ chọn"
$Clear.Location = New-Object Drawing.Point(130, 285)
$Clear.Size = New-Object Drawing.Size(100, 30)
$Clear.Add_Click({
    for ($i = 0; $i -lt $List.Items.Count; $i++) {
        $List.SetItemChecked($i, $false)
    }
})
# Thanh tien trinh 3 cham
$Dots = 0
$Timer = New-Object System.Windows.Forms.Timer
$Timer.Interval = 400

$Timer.Add_Tick({
    $Dots = ($Dots + 1) % 4
    $ProgressLabel.Text = "Đang cài đặt $AppName" + ("." * $Dots)
})
# Nut cai dat
$Install = New-Object Windows.Forms.Button
$Install.Text = "Cài Đặt"
$Install.Location = New-Object Drawing.Point(250, 285)
$Install.Size = New-Object Drawing.Size(160, 30)
$Install.Add_Click({
    $Selected = @($List.CheckedItems)
    if ($Selected.Count -eq 0) {
        [Windows.Forms.MessageBox]::Show("Không được để trống!")
        return
    }
    foreach ($App in $Selected) {
        try {
            $File = [System.IO.Path]::Combine($ThuMucGoc, "apps", $App.File)
            if (-not (Test-Path $File)) {
                Write-Host "[ERROR] Không tìm thấy $($App.File)" -ForegroundColor Red
                continue
            }
            switch ($App.Type.ToUpper()) {
                "MSI" {
                    $Process = Start-Process "msiexec.exe" -ArgumentList "/i `"$File`" $($App.Arguments)" -PassThru
                    $Dots = 0
                    while (-not $Process.HasExited) {
                        $Dots = ($Dots + 1) % 4
                        Write-Host "`r[INSTALL] $($App.Name)" ("." * $Dots) -NoNewline -ForegroundColor Cyan
                        Start-Sleep -Milliseconds 400
                        $Process.Refresh()
                    }
                    $Process.WaitForExit()
                    Write-Host ""
                    if($App.File -eq "LibreOffice_26.8.3_Win_x86-64.msi") {
                        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ThuMucGoc\powershell\create_shortcut.ps1`"" -Wait
                        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ThuMucGoc\powershell\save_as_libreoffice.ps1`"" -Wait
                    } 
                }
                "EXE" {
                    $Process = Start-Process -FilePath $File -ArgumentList $App.Arguments -PassThru
                    $Dots = 0
                    while (-not $Process.HasExited) {
                        $Dots = ($Dots + 1) % 4
                        Write-Host "`r[INSTALL] $($App.Name)" ("." * $Dots) -NoNewline -ForegroundColor Cyan
                        Start-Sleep -Milliseconds 400
                        $Process.Refresh()
                    }
                    $Process.WaitForExit()
                    Write-Host ""
                }
                "COPY" {
                    Write-Host "`r[INSTALL] $($App.Name)..."
                    $Destination = [Environment]::GetFolderPath($App.Destination)
                    Copy-Item $File $Destination -Force
                    $Process = $null
                }
                default {
                    throw "Không hợp lệ: $($App.Type)"
                }
            }
            if ($App.Type -eq "COPY") {
                Write-Host "[OK] $($App.Name)" -ForegroundColor Green
            }
            elseif ($Process.ExitCode -eq 0) {
                Write-Host "[OK] $($App.Name)" -ForegroundColor Green
            }
            elseif ($Process.ExitCode -eq 3010 -or $Process.ExitCode -eq 1641) {
                Write-Host "[OK] $($App.Name) - Cần khởi động lại" -ForegroundColor Yellow
            }
            else {
                Write-Host "[ERROR] $($App.Name) - $($Process.ExitCode)" -ForegroundColor Red
            }
        }
        catch {
            [Windows.Forms.MessageBox]::Show($_.Exception.Message)
        }
    }
    
    if ($List.CheckedItems.Count -eq $List.Items.Count -and $List.Items.Count -gt 0) {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ThuMucGoc\powershell\icon.ps1`"" -Wait
    }
    [Windows.Forms.MessageBox]::Show("Đã xử lý xong!")
})
# Them control vao Form
$Form.Controls.AddRange(@($List, $All, $Clear, $Install))

# Hien thi
[void]$Form.ShowDialog()
