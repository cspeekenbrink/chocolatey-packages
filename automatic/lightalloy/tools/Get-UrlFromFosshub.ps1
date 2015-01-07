# Get the resolved URL form a FossHub download link.
#
# Takes a FossHub URL in the “genLink” format and returns the generated expiring download link for the file which can
# be used for downloading with Ketarin/Chocolatey.
#
# Usage: Get-UrlFromFosshub genLink_url
# Examples:
# Get-UrlFromFosshub http://www.fosshub.com/genLink/Light-Alloy/LA_Setup_v4.8.8.exe

Function Get-UrlFromFosshub($genLinkUrl) {

  $fosshubAppName = $genLinkUrl -match 'genLink/(.+?)/'
  $fosshubAppName = $Matches[1]

  $referer = "http://www.fosshub.com/${fosshubAppName}.html"

  $webClient = New-Object System.Net.WebClient
  $webClient.Headers.Add("Referer", $referer)

  $generatedLink = $webClient.DownloadString($genLinkUrl)

  return $generatedLink
}
