﻿$ErrorActionPreference = 'Stop'

$version = '7.1.0'

$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$progDir  = "$toolsDir\octave"

$osBitness = Get-OSArchitectureWidth

$packageArgs = @{
  PackageName    = 'octave.portable'
  UnzipLocation  = $toolsDir
  Url            = 'https://ftp.gnu.org/gnu/octave/windows/octave-7.1.0-w32.7z'
  Url64          = 'https://ftp.gnu.org/gnu/octave/windows/octave-7.1.0-w64.7z'
  Checksum       = '6186416f058e9d673740da467c6f995e3ebdb2fa43f57c2bb46a571c10b41d7c'
  Checksum64     = 'f39581115c0cdd83c5546e9781e28cec1828c08478358d4326993a82a8908630'
  ChecksumType   = 'sha256'
  ChecksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

# Rename unzipped folder
If (Test-Path "$toolsDir\octave-$version-w$osBitness") {
  Rename-Item -Path "$toolsDir\octave-$version-w$osBitness" -NewName 'octave'
}
If (Test-Path "$toolsDir\octave-$version") {
  Rename-Item -Path "$toolsDir\octave-$version" -NewName 'octave'
}

# Don't create shims for any executables
$files = Get-ChildItem "$toolsDir" -include *.exe -recurse
foreach ($file in $files) {
  New-Item "$file.ignore" -type file -force | Out-Null
}

# Link batch
$path = "$progDir\mingw$osBitness\bin\octave.bat"
Install-BinFile -Name 'octave'     -Path $path -Command '--gui' -UseStart
Install-BinFile -Name 'octave-cli' -Path $path -Command '--no-gui'

$pp = Get-PackageParameters

if ($pp.Count -gt 0) {
  $paths = New-Object System.Collections.ArrayList

  if ($pp.DesktopIcon) {
    if ($pp.LocalUser) {
      $desktop = [Environment]::GetFolderPath('Desktop')
    } else {
      $desktop = [Environment]::GetFolderPath('CommonDesktopDirectory')
    }

    $paths.Add($desktop) | Out-Null
  }

  if ($pp.StartMenu) {
    if ($pp.LocalUser) {
      $startMenu = Join-Path ([Environment]::GetFolderPath('StartMenu')) 'Octave'
    } else {
      $startMenu = Join-Path ([Environment]::GetFolderPath('CommonStartMenu')) 'Octave'
    }

    $paths.Add($startMenu) | Out-Null
  }

  if ($paths.Count -gt 0) {
    $icon   = "$progDir\mingw$osBitness\share\octave\$version\imagelib\octave-logo.ico"
    $target = "$progDir\octave.vbs"

    $paths.GetEnumerator() | foreach-object {
      $gui = Join-Path $_ 'Octave.lnk'
      $cli = Join-Path $_ 'Octave CLI.lnk'

      if (-Not (Test-Path $gui)) {
        Install-ChocolateyShortcut -ShortcutFilePath $gui -TargetPath $target -WorkingDirectory '%userprofile%' -IconLocation $icon
      }

      if (-Not (Test-Path $cli)) {
        Install-ChocolateyShortcut -ShortcutFilePath $cli -TargetPath $target -WorkingDirectory '%userprofile%' -Arguments '--no-gui' -IconLocation $icon
      }

    }
  }
}
