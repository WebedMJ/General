# https://twitter.com/lee_holmes/status/1172640465767682048?s=12
Set-PSReadLineOption -AddToHistoryHandler {
    param([string]$line)
    $sensitive = 'password|asplaintext|token|(?<!controlmon)key|secret'
    $exceptions = 'keyvault'
    return (($line -notmatch $sensitive) -or ($line -match $exceptions))
}
Set-PSReadLineOption -PredictionSource History

Import-Module -Name Terminal-Icons
[Console]::OutputEncoding = [Text.Encoding]::UTF8
oh-my-posh init pwsh --config "<path>\oh-my-posh\<myconfig>.omp.json" | Invoke-Expression
