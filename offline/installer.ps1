chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Folder = $PSScriptRoot

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
$Files = Get-ChildItem -Path $Folder -File |
    Where-Object { $_.Extension -in ".exe", ".msi" }

foreach ($File in $Files) {
    [void]$List.Items.Add($File)
}

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

    foreach ($File in $Selected) {
        try {
            if ($File.Extension -eq ".msi") {
                Start-Process "msiexec.exe" `
                    -ArgumentList "/i `"$($File.FullName)`"" -Wait
            }
            else {
                Start-Process -FilePath $File.FullName -Wait
            }
        }
        catch {
            [Windows.Forms.MessageBox]::Show($_.Exception.Message)
        }
    }

    [Windows.Forms.MessageBox]::Show("Đã xử lý xong!")
})

# Them control vao Form
$Form.Controls.AddRange(@($List, $All, $Clear, $Install))

# Hien thi
[void]$Form.ShowDialog()
