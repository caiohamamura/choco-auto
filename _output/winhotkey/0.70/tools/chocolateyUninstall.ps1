$packageName = 'winhotkey'
$fileType = 'exe'
$silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART'
$uninstallerPath = "${env:programfiles(x86)}\WinHotKey\unins000.exe"
try {
Uninstall-ChocolateyPackage $packageName $fileType $silentArgs $uninstallerPath
Write-ChocolateySuccess $packageName
} catch {
Write-ChocolateyFailure $packageName $($_.Exception.Message)
throw
}