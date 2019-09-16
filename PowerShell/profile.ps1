# https://twitter.com/lee_holmes/status/1172640465767682048?s=12
Set-PSReadLineOption -AddToHistoryHandler {
    param([string]$line)
    $sensitive = "password|asplaintext|token|key|secret"
    return ($line -notmatch $sensitive)
}
$wc = New-Object System.Net.WebClient
$wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
Import-Module posh-git