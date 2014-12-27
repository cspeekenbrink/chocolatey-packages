﻿$packageId = '{{PackageName}}'
$fileType = 'exe'
$fileArgs = '/passive'
$url = '{{DownloadUrl}}'

# Installer is for both 32- and 64-bit versions
$url64 = $url

Install-ChocolateyPackage $packageId $fileType $fileArgs $url $url64