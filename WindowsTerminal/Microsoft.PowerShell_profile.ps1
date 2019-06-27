$wc = New-Object System.Net.WebClient
$wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

Import-Module posh-git
$GitPromptSettings.DefaultPromptPrefix = '$(Get-Date -f "dd-MM HH:mm:ss") '
$GitPromptSettings.DefaultPromptSuffix = '`n$(">" * ($nestedPromptLevel + 1)) '
$GitPromptSettings.DefaultForegroundColor = 'DarkYellow'

# Clear-Host