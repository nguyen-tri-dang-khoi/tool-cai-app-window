# Set-LibreOfficeSaveFormat.ps1
$ErrorActionPreference = "Stop"

$configDir = Join-Path $env:APPDATA "LibreOffice\4\user"
$configFile = Join-Path $configDir "registrymodifications.xcu"

if (Get-Process soffice -ErrorAction SilentlyContinue) {
    Write-Host "Hay dong tat ca LibreOffice truoc khi chay script."
    exit 1
}

New-Item -ItemType Directory -Path $configDir -Force | Out-Null

# Tao file cau hinh neu chua ton tai
if (!(Test-Path $configFile)) {
    Set-Content -Path $configFile `
        -Value '<?xml version="1.0" encoding="UTF-8"?><oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"></oor:items>' `
        -Encoding UTF8
}

# Sao luu cau hinh hien tai
$backup = "$configFile.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Copy-Item $configFile $backup -Force

# Doc cau hinh XML
[xml]$xml = Get-Content $configFile -Raw
$ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$ns.AddNamespace("oor", "http://openoffice.org/2001/registry")

$settings = @(
    @{
        Path = "/org.openoffice.Setup/Office/Factories/org.openoffice.Setup:Factory['com.sun.star.text.TextDocument']"
        Filter = "MS Word 2007 XML"
    },
    @{
        Path = "/org.openoffice.Setup/Office/Factories/org.openoffice.Setup:Factory['com.sun.star.sheet.SpreadsheetDocument']"
        Filter = "Calc MS Excel 2007 XML"
    },
    @{
        Path = "/org.openoffice.Setup/Office/Factories/org.openoffice.Setup:Factory['com.sun.star.presentation.PresentationDocument']"
        Filter = "Impress MS PowerPoint 2007 XML"
    }
)

foreach ($setting in $settings) {
    $xpath = "/oor:items/oor:item[@oor:path='$($setting.Path)']"
    $item = $xml.SelectSingleNode($xpath, $ns)

    if (!$item) {
        $item = $xml.CreateElement("item", $ns.LookupNamespace("oor"))
        $attr = $xml.CreateAttribute("oor", "path", $ns.LookupNamespace("oor"))
        $attr.Value = $setting.Path
        $item.Attributes.Append($attr) | Out-Null
        $xml.DocumentElement.AppendChild($item) | Out-Null
    }

    $prop = $item.SelectSingleNode("oor:prop[@oor:name='ooSetupFactoryDefaultFilter']", $ns)

    if (!$prop) {
        $prop = $xml.CreateElement("prop", $ns.LookupNamespace("oor"))
        $nameAttr = $xml.CreateAttribute("oor", "name", $ns.LookupNamespace("oor"))
        $nameAttr.Value = "ooSetupFactoryDefaultFilter"
        $prop.Attributes.Append($nameAttr) | Out-Null

        $opAttr = $xml.CreateAttribute("oor", "op", $ns.LookupNamespace("oor"))
        $opAttr.Value = "fuse"
        $prop.Attributes.Append($opAttr) | Out-Null
        $item.AppendChild($prop) | Out-Null
    }

    $value = $prop.SelectSingleNode("oor:value", $ns)
    if (!$value) {
        $value = $xml.CreateElement("value", $ns.LookupNamespace("oor"))
        $prop.AppendChild($value) | Out-Null
    }
    $value.InnerText = $setting.Filter
}

$xml.Save($configFile)

Write-Host "Da dat dinh dang mac dinh:"
Write-Host "Writer  -> DOCX"
Write-Host "Calc    -> XLSX"
Write-Host "Impress -> PPTX"
Write-Host "Backup: $backup"
Write-Host "Hay mo lai LibreOffice de kiem tra."
Read-Host "Nhan Enter de thoat"
