$folderPath="F:\3D Files"

$Archives = Get-ChildItem $folderPath -recurse -Filter *.zip
Foreach($Archive in $Archives){
    $Target = $Archive.VersionInfo.FileName.split(".")[0]
    7z.exe e $Archive.VersionInfo.FileName -o"$($Target)" -aoa -y
}

Get-ChildItem -path $folderPath *.png -Recurse | Remove-Item -Force
Get-ChildItem -path $folderPath *.txt -Recurse | Remove-Item -Force
Get-ChildItem -path $folderPath *.jpg -Recurse | Remove-Item -Force
Get-ChildItem -path $folderPath *.zip -Recurse | Remove-Item -Force
Get-ChildItem -path $folderPath *.html -Recurse | Remove-Item -Force
Get-ChildItem -path $folderPath *.jpeg -Recurse | Remove-Item -Force

do {
  $dirs = Get-ChildItem $folderPath -directory -recurse | `
          Where-Object { (Get-ChildItem $_.fullName).count -eq 0 } | `
          Remove-Item -Force -Recurse
} while ($dirs.count -gt 0)