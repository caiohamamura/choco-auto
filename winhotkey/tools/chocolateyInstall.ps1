$packageName = '{{PackageName}}'
$fileType = 'exe'
$silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART'
$url = '{{DownloadUrl}}' 
Install-ChocolateyPackage $packageName $fileType $silentArgs $url