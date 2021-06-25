$folderPath="F:\3D Files"

$Archives = Get-ChildItem $folderPath -recurse
Foreach($Archive in $Archives){
    if($Archive.VersionInfo.FileName.split(".")[1] -eq "zip")
    {
        $Target = $Archive.VersionInfo.FileName.split(".")[0] -ErrorAction SilentlyContinue
        mkdir $Target -ErrorAction SilentlyContinue
        Expand-Archive -path $Archive.VersionInfo.FileName -destinationpath $Target -Force -ErrorAction SilentlyContinue
    }
}
