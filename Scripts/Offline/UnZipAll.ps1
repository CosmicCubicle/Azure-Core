$folderPath="F:\3D Files"

$Archives = Get-ChildItem $folderPath -recurse -Filter *.zip
Foreach($Archive in $Archives){
    $Target = $Archive.VersionInfo.FileName.split(".")[0]
    7z.exe e $Archive.VersionInfo.FileName -o"$($Target)" -aoa -y
    remove-item $Archive.VersionInfo.FileName -Force
}
$tdc="C:\a\c\d"
do {
  $dirs = gci $tdc -directory -recurse | Where { (gci $_.fullName).count -eq 0 } | select -expandproperty FullName
  $dirs | Foreach-Object { Remove-Item $_ }
} while ($dirs.count -gt 0)