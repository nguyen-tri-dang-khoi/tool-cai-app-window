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

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Ham quet Registry
function Get-InstalledSoftware {
    $Paths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    $Apps = @()
    foreach ($Path in $Paths) {
        if (Test-Path $Path) {
            Get-ItemProperty $Path -ErrorAction SilentlyContinue | ForEach-Object {
                if ($_.DisplayName -and $_.UninstallString -and $_.Publisher -notmatch "Microsoft|Nvidia|Intel|AMD|Realtek" -and (-not $_.SystemComponent)) {
                    $Apps += [PSCustomObject]@{
                        Name            = $_.DisplayName.Trim()
                        UninstallString = $_.UninstallString
                        QuietUninstall  = $_.QuietUninstallString
                    }
                }
            }
        }
    }
    return $Apps | Sort-Object Name -Unique
}
function Wait-ProcessTree {
    param(
        [int]$ParentId, 
        [string]$AppName,
        [int]$TimeoutSeconds = 300 # Gioi han toi da 5 phut
    )
    $Dots = 0
    $Elapsed = 0
    do {
        $Dots = ($Dots + 1) % 4
        Write-Host "`r[UNINSTALL] $AppName" ("." * $Dots) -NoNewline -ForegroundColor Cyan
        Start-Sleep -Milliseconds 500
        $Elapsed += 0.5
        $ParentAlive = Get-Process -Id $ParentId -ErrorAction SilentlyContinue
        $Children = Get-CimInstance Win32_Process -Filter "ParentProcessId = $ParentId" -ErrorAction SilentlyContinue

    } while (($ParentAlive -or $Children) -and ($Elapsed -lt $TimeoutSeconds))
    Write-Host ""
}


# Tao giao dien
$Form = New-Object Windows.Forms.Form
$Form.Text = "Khôi - Gỡ Cài Đặt"
$Form.Size = New-Object Drawing.Size(450, 400)
$Form.StartPosition = "CenterScreen"
$Form.FormBorderStyle = "FixedDialog"
$Form.MaximizeBox = $false

# Danh sach checkbox
$List = New-Object Windows.Forms.CheckedListBox
$List.Location = New-Object Drawing.Point(20, 20)
$List.Size = New-Object Drawing.Size(390, 250)
$List.CheckOnClick = $true
$List.DisplayMember = "Name"

function Load-AppList {
    $List.Items.Clear()
    $InstalledApps = Get-InstalledSoftware
    foreach ($App in $InstalledApps) {
        [void]$List.Items.Add($App)
    }
    $List.DisplayMember = "Name"
}
Load-AppList

# Nut chon tat ca
$All = New-Object Windows.Forms.Button
$All.Text = "Chọn tất cả"
$All.Location = New-Object Drawing.Point(20, 285)
$All.Size = New-Object Drawing.Size(100, 30)
$All.Add_Click({
    for ($i = 0; $i -lt $List.Items.Count; $i++) {
        $List.SetItemChecked($i, $true)
    }
})

# Nut bo chon
$Clear = New-Object Windows.Forms.Button
$Clear.Text = "Bỏ chọn"
$Clear.Location = New-Object Drawing.Point(130, 285)
$Clear.Size = New-Object Drawing.Size(100, 30)
$Clear.Add_Click({
    for ($i = 0; $i -lt $List.Items.Count; $i++) {
        $List.SetItemChecked($i, $false)
    }
})

# Nut go cai dat
$UninstallBtn = New-Object Windows.Forms.Button
$UninstallBtn.Text = "Gỡ Cài Đặt"
$UninstallBtn.Location = New-Object Drawing.Point(250, 285)
$UninstallBtn.Size = New-Object Drawing.Size(160, 30)
$UninstallBtn.Add_Click({
    $Selected = @($List.CheckedItems)
    if ($Selected.Count -eq 0) {
        [Windows.Forms.MessageBox]::Show("Vui lòng chọn ít nhất 1 phần mềm!", "Thông báo", "OK", "Warning")
        return
    }

    $Confirm = [Windows.Forms.MessageBox]::Show(
        "Bạn có chắc chắn muốn gỡ $($Selected.Count) phần mềm đã chọn?",
        "Xác nhận gỡ cài đặt",
        [Windows.Forms.MessageBoxButtons]::YesNo,
        [Windows.Forms.MessageBoxIcon]::Question
    )
    if ($Confirm -ne "Yes") { return }

    foreach ($App in $Selected) {
        try {
            $Cmd = $App.UninstallString.Trim()
            # Xu ly rieng cho goi MSI (MsiExec.exe)
            if ($Cmd -match "msiexec\.exe") {
                if ($Cmd -match "\{[0-9A-Fa-f\-]+\}") {
                    $ProductCode = $Matches[0]
                    $Process = Start-Process "msiexec.exe" -ArgumentList "/x $ProductCode /qn /norestart" -PassThru
                } else {
                    $uniArgs = $Cmd -replace "(?i)msiexec\.exe", "" -replace "/I", "/X"
                    $Process = Start-Process "msiexec.exe" -ArgumentList "$uniArgs /qn /norestart" -PassThru
                }
            }
            else {
                if ($Cmd.StartsWith('"')) {
                    $SplitIndex = $Cmd.IndexOf('"', 1)
                    $ExePath = $Cmd.Substring(1, $SplitIndex - 1)
                    $uniArgs = $Cmd.Substring($SplitIndex + 1).Trim()
                } else {
                    $Parts = $Cmd -split '\.exe', 2
                    $ExePath = $Parts[0] + ".exe"
                    $uniArgs = if ($Parts.Count -gt 1) { $Parts[1].Trim() } else { "" }
                }

                if (-not (Test-Path $ExePath)) {
                    Write-Host "[ERROR] Không tìm thấy trình gỡ cài đặt của $($App.Name)" -ForegroundColor Red
                    continue
                }
                Write-Host $uniArgs
                if ([string]::IsNullOrWhiteSpace($uniArgs)) {
                    $Process = Start-Process -FilePath $ExePath -PassThru
                } else {
                    $Process = Start-Process -FilePath $ExePath -ArgumentList $uniArgs -PassThru
                }
            }

            Wait-ProcessTree -ParentId $Process.Id -AppName $App.Name
            
            # Cho them 1 giay de Windows kip cap nhat Registry
            Start-Sleep -Seconds 1
            Write-Host "[OK] Đã xử lý xong: $($App.Name)" -ForegroundColor Green
        }
        catch {
            Write-Host "[ERROR] Lỗi khi gỡ $($App.Name): $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    # Cap nhat lai danh sach sau khi go xong
    Load-AppList
    [Windows.Forms.MessageBox]::Show("Đã xử lý xong!", "Hoàn tất", "OK", "Information")
})

# Them control vao Form
$Form.Controls.AddRange(@($List, $All, $Clear, $UninstallBtn))

# Hien thi
[void]$Form.ShowDialog()
