$env:APP = "C:\Program Files\LibreOffice\program\";
$link = Join-Path $env:ProgramFiles "LibreOffice\program\soffice.exe";
$isRun = $true;
if(!(Test-Path $link -PathType Leaf)) {
    $link = Join-Path ${env:ProgramFiles(x86)} "LibreOffice\program\soffice.exe";
}
if(!(Test-Path $link -PathType Leaf)) {
    $isRun = $false;
}
if($isRun) {
    $w = New-Object -ComObject WScript.Shell;
    $items = @(@('swriter.exe','Word'),@('scalc.exe','Excel'),@('simpress.exe','PowerPoint')); 
    foreach($i in $items){
        $s = $w.CreateShortcut($env:USERPROFILE+'\Desktop\'+$i[1]+'.lnk');
        $s.TargetPath=$env:APP + $i[0];
        $s.Save();
    }
}
