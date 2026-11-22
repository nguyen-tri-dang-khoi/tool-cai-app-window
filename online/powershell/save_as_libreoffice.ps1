$File = "$env:APPDATA\LibreOffice\4\user\registrymodifications.xcu"
if (-not (Test-Path $File)) {
    $SofficePaths = @(
        "$env:ProgramFiles\LibreOffice\program\soffice.exe",
        "${env:ProgramFiles(x86)}\LibreOffice\program\soffice.exe"
    )
    $SofficeExe = $SofficePaths | Where-Object { Test-Path $_ } | Select-Object -First 1
    if ($SofficeExe) {
        Start-Process -FilePath $SofficeExe -ArgumentList "--headless", "--invisible"
        $Timeout = 0
        while (-not (Test-Path $File) -and $Timeout -lt 15) {
            Start-Sleep -Seconds 1
            $Timeout++
        }
        Get-Process -Name "soffice*" -ErrorAction SilentlyContinue | Stop-Process -Force
        Start-Sleep -Milliseconds 500
    } else {
        Write-Error "Không tìm thấy LibreOffice trên máy tính này."
        exit 1
    }
}
$Ns = New-Object System.Xml.XmlDocument
$Ns.Load($File);

$nsMgr = New-Object System.Xml.XmlNamespaceManager($Ns.NameTable)
$nsuri = $Ns.DocumentElement.NamespaceURI
$nsMgr.AddNamespace("oor", $nsuri)

$Items = $Ns.SelectSingleNode("//oor:items", $nsMgr)
$XmlText = @'
<item oor:path="/org.openoffice.Setup/Office/Factories/org.openoffice.Setup:Factory['com.sun.star.text.TextDocument']"><prop oor:name="ooSetupFactoryDefaultFilter" oor:op="fuse"><value>Office Open XML Text</value></prop></item>
<item oor:path="/org.openoffice.Setup/Office/Factories/org.openoffice.Setup:Factory['com.sun.star.sheet.SpreadsheetDocument']"><prop oor:name="ooSetupFactoryDefaultFilter" oor:op="fuse"><value>Calc Office Open XML</value></prop></item>
<item oor:path="/org.openoffice.Setup/Office/Factories/org.openoffice.Setup:Factory['com.sun.star.presentation.PresentationDocument']"><prop oor:name="ooSetupFactoryDefaultFilter" oor:op="fuse"><value>Impress MS PowerPoint 2007 XML</value></prop></item>
'@

$WrapperXml = "<wrapper xmlns:oor=""$nsuri"">$XmlText</wrapper>"
$TempDoc = New-Object System.Xml.XmlDocument
$TempDoc.LoadXml($WrapperXml)

$Fragment = $Ns.CreateDocumentFragment()
foreach ($child in $TempDoc.DocumentElement.ChildNodes) {
    $importedNode = $Ns.ImportNode($child, $true)
    [void]$Fragment.AppendChild($importedNode)
}

[void]$Items.AppendChild($Fragment)
$Ns.Save($File)
# test
# notepad.exe "$env:APPDATA\LibreOffice\4\user\registrymodifications.xcu"