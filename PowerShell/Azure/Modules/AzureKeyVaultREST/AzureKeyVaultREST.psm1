<#
.SYNOPSIS
    Module for interacting with Azure Key Vault using the ARM REST API.
    Designed to be invoked from an Azure web app or function app with managed identity enabled.
.DESCRIPTION

.LINK
    https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureKeyVaultREST
.NOTES
    Requires managed identity enabled on the app service and IAM permissions configured in the
    Key Vault Access Policy.
    Uses AzureRESTAuth module to aquire token.
#>

function Get-AzureKeyVaultSecrets {
    <#
    .SYNOPSIS

    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureKeyVaultREST
    #>
    [CMDLetBinding(DefaultParameterSetName = "All")]
    param (
        [string]$VaultName,
        [Parameter(Mandatory = $false, ParameterSetName = "MaxResults")]
        [ValidateRange(1, 25)]
        [int]$MaxResults,
        [Parameter(Mandatory = $false, ParameterSetName = "All")]
        [Switch]$All
    )
    $apiVersion = '7.0'
    [PSCustomObject]$response = @()
    [System.String]$secretsnextlink = ''
    $uripath = 'secrets'
    if ($MaxResults) {
        $uriquery = '?maxresults={0}&api-version={1}' -f $MaxResults, $apiVersion
    } else {
        $uriquery = '?api-version={0}' -f $apiVersion
    }
    [uri]$VaultBaseUrl = 'https://{0}.vault.azure.net' -f $VaultName
    $builturi = [System.UriBuilder]::new($VaultBaseUrl.Scheme, $VaultBaseUrl.Host, $VaultBaseUrl.Port, $uripath, $uriquery)
    [uri]$uri = $builturi.Uri
    do {
        $splat = @{
            Headers     = Get-AzureRESTtoken -AzureResource 'Vault'
            Uri         = $uri
            Method      = 'Get'
            ErrorAction = 'Stop'
        }
        $response += Invoke-RestMethod @splat
        if ($All) {
            $secretsnextlink = $response.nextLink
            [uri]$uri = $secretsnextlink
        }
    } while (![string]::IsNullOrEmpty($secretsnextlink))
    $KVSecrets = @()
    foreach ($secret in $response.value) {
        $KVSecrets += [PSCustomObject]@{
            VaultName     = $VaultName
            SecretName    = $secret.id -split '/' | select-object -last 1
            Enabled       = $secret.attributes.enabled
            Created       = $secret.attributes.created
            Updated       = $secret.attributes.updated
            RecoveryLevel = $secret.attributes.recoveryLevel
        }
    }
    return $KVSecrets
}

function Get-AzureKeyVaultSecretVersions {
    <#
    .SYNOPSIS

    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureKeyVaultREST
    #>
    [CMDLetBinding(DefaultParameterSetName = "All")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$VaultName,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$SecretName,
        [Parameter(Mandatory = $false, ParameterSetName = "MaxResults")]
        [ValidateRange(1, 25)]
        [int]$MaxResults,
        [Parameter(Mandatory = $false, ParameterSetName = "All")]
        [Switch]$All
    )
    $apiVersion = '7.0'
    [PSCustomObject]$response = @()
    [System.String]$secretsnextlink = ''
    $uripath = 'secrets/{0}/versions' -f $SecretName
    if ($MaxResults) {
        $uriquery = '?maxresults={0}&api-version={1}' -f $MaxResults, $apiVersion
    } else {
        $uriquery = '?api-version={0}' -f $apiVersion
    }
    [uri]$VaultBaseUrl = 'https://{0}.vault.azure.net' -f $VaultName
    $builturi = [System.UriBuilder]::new($VaultBaseUrl.Scheme, $VaultBaseUrl.Host, $VaultBaseUrl.Port, $uripath, $uriquery)
    [uri]$uri = $builturi.Uri
    do {
        $splat = @{
            Headers     = Get-AzureRESTtoken -AzureResource 'Vault'
            Uri         = $uri
            Method      = 'Get'
            ErrorAction = 'Stop'
        }
        $response += Invoke-RestMethod @splat
        if ($All) {
            $secretsnextlink = $response.nextLink
            [uri]$uri = $secretsnextlink
        }
    } while (![string]::IsNullOrEmpty($secretsnextlink))
    $KVSecretVers = @()
    foreach ($secret in $response.value) {
        $KVSecretVers += [PSCustomObject]@{
            VaultName     = $VaultName
            SecretName    = $SecretName
            SecretVersion = $secret.id -split '/' | select-object -last 1
            Enabled       = $secret.attributes.enabled
            Created       = $secret.attributes.created
            Updated       = $secret.attributes.updated
            RecoveryLevel = $secret.attributes.recoveryLevel
        }
    }
    return $KVSecretVers
}

function Get-AzureKeyVaultSecretValue {
    <#
    .SYNOPSIS

    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureKeyVaultREST
    #>
    [CMDLetBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$VaultName,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$SecretName,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$SecretVersion
    )
    $apiVersion = '7.0'
    $uripath = 'secrets/{0}/{1}' -f $SecretName, $SecretVersion
    $uriquery = '?api-version={0}' -f $apiVersion
    [uri]$VaultBaseUrl = 'https://{0}.vault.azure.net' -f $VaultName
    $builturi = [System.UriBuilder]::new($VaultBaseUrl.Scheme, $VaultBaseUrl.Host, $VaultBaseUrl.Port, $uripath, $uriquery)
    [uri]$uri = $builturi.Uri
    $splat = @{
        Headers     = Get-AzureRESTtoken -AzureResource 'Vault'
        Uri         = $uri
        Method      = 'Get'
        ErrorAction = 'Stop'
    }
    $response = Invoke-RestMethod @splat
    $KVSecretValue = [PSCustomObject]@{
        VaultName     = $VaultName
        SecretName    = $SecretName
        SecretVersion = $SecretVersion
        SecretValue   = $response.value
        Enabled       = $response.attributes.enabled
        Created       = $response.attributes.created
        Updated       = $response.attributes.updated
        RecoveryLevel = $response.attributes.recoveryLevel
    }
    return $KVSecretValue
}