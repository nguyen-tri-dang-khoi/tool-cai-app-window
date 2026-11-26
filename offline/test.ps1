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
$Apps | Sort-Object Name -Unique | Out-GridView
Pause
Read-Host ""