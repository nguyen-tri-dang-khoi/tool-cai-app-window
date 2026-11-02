$File = "$env:APPDATA\LibreOffice\4\user\registrymodifications.xcu"
$File
[xml]$Xml = Get-Content $File -Raw
$Xml.Save([Console]::Out)
$Ns = New-Object System.Xml.XmlNamespaceManager($Xml.NameTable)
$Ns.AddNamespace("oor", "http://openoffice.org/2001/registry")
$Ns.AddNamespace("xs", "http://www.w3.org/2001/XMLSchema")
$Ns.AddNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance")

$Items = $Xml.SelectSingleNode("//oor:items", $Ns)
$Items
Read-Host "Nhan Enter de thoat"
# $Fragment = $Xml.CreateDocumentFragment()
# $Fragment.InnerXml = @'
# <item oor:path="/org.openoffice.Setup/Office/Factories/org.openoffice.Setup:Factory['com.sun.star.text.TextDocument']"><prop oor:name="ooSetupFactoryDefaultFilter" oor:op="fuse"><value>Office Open XML Text</value></prop></item>
# <item oor:path="/org.openoffice.Setup/Office/Factories/org.openoffice.Setup:Factory['com.sun.star.sheet.SpreadsheetDocument']"><prop oor:name="ooSetupFactoryDefaultFilter" oor:op="fuse"><value>Calc Office Open XML</value></prop></item>
# <item oor:path="/org.openoffice.Setup/Office/Factories/org.openoffice.Setup:Factory['com.sun.star.presentation.PresentationDocument']"><prop oor:name="ooSetupFactoryDefaultFilter" oor:op="fuse"><value>Impress MS PowerPoint 2007 XML</value></prop></item>
# '@

# $Items.AppendChild($Fragment) | Out-Null
# $Xml.Save($File)