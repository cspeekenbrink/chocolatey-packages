Import-Module au
. "$PSScriptRoot\..\..\scripts\Set-DescriptionFromReadme.ps1"

$source = "https://screencloud.net/pages/download"
$pattern = "ScreenCloud-(.+)-x86.msi"

function global:au_BeforeUpdate {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_SearchReplace {
    @{
        ".\legal\VERIFICATION.txt" = @{
            "(?i)(\s+x32:).*"      = "`${1} $($Latest.URL32)"
            "(?i)(\checksum32:).*" = "`${1} $($Latest.Checksum32)"
        }
    }
}

function global:au_GetLatest {
    $res = Invoke-WebRequest -Uri $source -UseBasicParsing

    $url = $res.Links | ? href -match $pattern | % href
    $version = $matches[1]

    @{
        Version = $version
        URL32 = "https:$url"
    }
}

update -ChecksumFor 32
