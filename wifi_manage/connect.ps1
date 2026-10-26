
param(
    [Parameter(Mandatory = $true)]
    [string]$SSID,

    [Parameter(Mandatory = $true)]
    [string]$PASS
)

$ErrorActionPreference = "Stop"
$profilePath = Join-Path $env:TEMP "wifi-profile.xml"

try {
    # Kiem tra card Wi-Fi
    $interfaces = netsh wlan show interfaces 2>&1 | Out-String

    if ($interfaces -match "There is no wireless interface") {
        throw "Khong tim thay card Wi-Fi hoat dong. Kiem tra driver."
    }

    # Tao Wi-Fi profile WPA2-Personal
    $safeSSID = [System.Security.SecurityElement]::Escape($SSID)
    $safePASS = [System.Security.SecurityElement]::Escape($PASS)

    $xml = @"
<?xml version="1.0" encoding="UTF-8"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
  <name>$safeSSID</name>
  <SSIDConfig>
    <SSID>
      <name>$safeSSID</name>
    </SSID>
  </SSIDConfig>
  <connectionType>ESS</connectionType>
  <connectionMode>auto</connectionMode>
  <MSM>
    <security>
      <authEncryption>
        <authentication>WPA2PSK</authentication>
        <encryption>AES</encryption>
        <useOneX>false</useOneX>
      </authEncryption>
      <sharedKey>
        <keyType>passPhrase</keyType>
        <protected>false</protected>
        <keyMaterial>$safePASS</keyMaterial>
      </sharedKey>
    </security>
  </MSM>
</WLANProfile>
"@

    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($profilePath, $xml, $utf8)

    # Them profile
    netsh wlan add profile "filename=$profilePath" user=current

    if ($LASTEXITCODE -ne 0) {
        throw "Khong them duoc Wi-Fi profile."
    }

    # Ket noi Wi-Fi
    netsh wlan connect "name=$SSID" "ssid=$SSID"

    if ($LASTEXITCODE -ne 0) {
        throw "Lenh ket noi Wi-Fi that bai."
    }

    Write-Host "`nDa gui yeu cau ket noi Wi-Fi: $SSID" -ForegroundColor Green
    Start-Sleep -Seconds 5
    netsh wlan show interfaces
}
catch {
    Write-Host "`nLOI: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    Remove-Item $profilePath -Force -ErrorAction SilentlyContinue
}
