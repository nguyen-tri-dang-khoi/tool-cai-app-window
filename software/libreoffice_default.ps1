$File = "$env:APPDATA\LibreOffice\4\user\registrymodifications.xcu"
$Ns = New-Object System.Xml.XmlDocument
$Ns.Load($File);

$nsMgr = New-Object System.Xml.XmlNamespaceManager($Ns.NameTable)
$nsuri = $Ns.DocumentElement.NamespaceURI
$nsMgr.AddNamespace("oor", $nsuri)

$Items = $Ns.SelectSingleNode("//oor:items", $nsMgr)


# 3. Tạo một XML tạm thời để import chuỗi văn bản an toàn
$XmlText = @'
<item oor:path="/org.openoffice.Setup/Office/Factories/org.openoffice.Setup:Factory['com.sun.star.text.TextDocument']"><prop oor:name="ooSetupFactoryDefaultFilter" oor:op="fuse"><value>Office Open XML Text</value></prop></item>
<item oor:path="/org.openoffice.Setup/Office/Factories/org.openoffice.Setup:Factory['com.sun.star.sheet.SpreadsheetDocument']"><prop oor:name="ooSetupFactoryDefaultFilter" oor:op="fuse"><value>Calc Office Open XML</value></prop></item>
<item oor:path="/org.openoffice.Setup/Office/Factories/org.openoffice.Setup:Factory['com.sun.star.presentation.PresentationDocument']"><prop oor:name="ooSetupFactoryDefaultFilter" oor:op="fuse"><value>Impress MS PowerPoint 2007 XML</value></prop></item>
'@

# Bọc chuỗi bằng một tag tạm thời chứa sẵn namespace 'oor'
$WrapperXml = "<wrapper xmlns:oor=""$nsuri"">$XmlText</wrapper>"
$TempDoc = New-Object System.Xml.XmlDocument
$TempDoc.LoadXml($WrapperXml)

# 4. Tạo fragment và import các node con từ TempDoc sang tài liệu gốc ($Ns)
$Fragment = $Ns.CreateDocumentFragment()
foreach ($child in $TempDoc.DocumentElement.ChildNodes) {
    $importedNode = $Ns.ImportNode($child, $true)
    [void]$Fragment.AppendChild($importedNode)
}

[void]$Items.AppendChild($Fragment);
$Ns.Save($File)