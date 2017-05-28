$packageName   = 'miktex'
$fileType = 'EXE'
$silentArgs = '--unattended --shared'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

$install32 = Join-Path $scriptPath 'basic-miktex.exe'
$install64 = Join-Path $scriptPath 'basic-miktex-x64.exe'
$filePath = @{32=$install32;64=$install64}[(Get-ProcessorBits)]

Function Get-RedirectedUrl {
   Param ([Parameter(Mandatory=$true)][String]$url)

   $request = [System.Net.WebRequest]::Create($url)
   $request.AllowAutoRedirect=$false

   try {
      $response=$request.GetResponse()
      $response.Headers["Location"]
      $response.Close()
   } catch {
      throw $_.Exception 
   }
}
$Url = Get-RedirectedURL http://mirrors.ctan.org/systems/win32/miktex/setup/basic-miktex-2.9.6326.exe

$Url64 = Get-RedirectedURL http://mirrors.ctan.org/systems/win32/miktex/setup/basic-miktex-2.9.6326-x64.exe



# The package installer is very picky about its own file name and silent 
# installation. See for more information:
# https://github.com/AnthonyMastrean/chocolateypackages/issues/143#issuecomment-143379145
# 
# will be fixed when issue is resolved:
# https://github.com/chocolatey/choco/issues/435

Get-ChocolateyWebFile $packageName $filePath $Url $Url64 -Checksum d77118f54a4d21da8e37ed2205b35e62c5931ef20be98309a5597502328faa07 -ChecksumType 'sha256' -Checksum64 bc65a915621442e5e797d14b1509fba25ef836942fc25eefa7f0a2638d827fac -ChecksumType64 'sha256'


Install-ChocolateyInstallPackage $packageName $fileType $silentArgs $filePath

Remove-Item $filePath -Force

#add AutoInstall=1

$uninstallPath = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, 
HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall  |
    Get-ItemProperty |
        Where-Object {$_.DisplayName -match "miktex" } |
            Select-Object -Property DisplayName, UninstallString
			
$temp=($uninstallPath.uninstallstring -split "`" `"")[0]
$installLocation = ($temp -Split("internal"))[0]
$installLocation = ($installLocation -Split("`""))[1]
$installLocation = $installLocation -replace '/','\'
$autoInstall = Join-Path $installLocation "initexmf.exe"
& $autoInstall --set-config-value=[MPM]AutoInstall=1