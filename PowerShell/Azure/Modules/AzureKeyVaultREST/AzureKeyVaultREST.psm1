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

function Get-AzureKeyVaultRESTSecrets {
    <#
    .SYNOPSIS

    .PARAMETER TimeZoneId
        Specify TimeZone in which to report secret date time fields.  Key Vault API returns ctime.

        Default is GMT Standard Time.

        Valid values are TimeZoneInfo Ids as returned by Get-TimeZone
    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureKeyVaultREST
    #>
    [CMDLetBinding(DefaultParameterSetName = "All")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$VaultName,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$SecretType,
        [Parameter(Mandatory = $false)]
        [string]$TimeZoneId = 'GMT Standard Time',
        [Parameter(Mandatory = $false, ParameterSetName = "MaxResults")]
        [ValidateRange(1, 25)]
        [int]$MaxResults,
        [Parameter(Mandatory = $false, ParameterSetName = "All")]
        [Switch]$All,
        [Parameter(Mandatory = $false)]
        [Switch]$IncludeDisabled
    )
    if (!(Get-TimeZone -Id $TimeZoneId).Id) {
        throw "Error invalid TimeZone Id!"
    }
    $TZ = [TimeZoneInfo]::FindSystemTimeZoneById($TimeZoneId)
    [datetime]$epoc = "1/1/1970"
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
        [PSCustomObject]$thisresponse = @()
        $splat = @{
            Headers     = Get-AzureRESTtoken -AzureResource 'Vault'
            Uri         = $uri
            Method      = 'Get'
            ErrorAction = 'Stop'
        }
        $thisresponse += Invoke-RestMethod @splat
        $response += $thisresponse.value
        if ($All) {
            $secretsnextlink = $thisresponse.nextLink
            [uri]$uri = $secretsnextlink
        }
    } while (![string]::IsNullOrEmpty($secretsnextlink))
    If ($SecretType) {
        $FilteredResponse = $response | Where-Object {$_.contentType -eq $SecretType}
    }
    $KVSecrets = @()
    switch ($IncludeDisabled) {
        $true {
            foreach ($secret in $FilteredResponse) {
                $KVSecrets += [PSCustomObject]@{
                    VaultName     = $VaultName
                    SecretName    = $secret.id -split '/' | select-object -last 1
                    SecretType    = $secret.contentType
                    Enabled       = $secret.attributes.enabled
                    Created       = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId(
                        $epoc.AddSeconds($secret.attributes.created),
                        $TZ.Id
                    )
                    Updated       = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId(
                        $epoc.AddSeconds($secret.attributes.updated),
                        $TZ.Id
                    )
                    RecoveryLevel = $secret.attributes.recoveryLevel
                }
            }
        }
        $false {
            foreach ($secret in ($FilteredResponse | Where-Object {$_.attributes.enabled -eq 'Enabled'})) {
                $KVSecrets += [PSCustomObject]@{
                    VaultName     = $VaultName
                    SecretName    = $secret.id -split '/' | select-object -last 1
                    SecretType    = $secret.contentType
                    Enabled       = $secret.attributes.enabled
                    Created       = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId(
                        $epoc.AddSeconds($secret.attributes.created),
                        $TZ.Id
                    )
                    Updated       = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId(
                        $epoc.AddSeconds($secret.attributes.updated),
                        $TZ.Id
                    )
                    RecoveryLevel = $secret.attributes.recoveryLevel
                }
            }
        }
    }
    return $KVSecrets
}

function Get-AzureKeyVaultRESTSecretVersions {
    <#
    .SYNOPSIS

    .PARAMETER TimeZoneId
        Specify TimeZone in which to report secret date time fields.  Key Vault API returns ctime.

        Default is GMT Standard Time.

        Valid values are TimeZoneInfo Ids as returned by Get-TimeZone
    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureKeyVaultREST
    #>
    [CMDLetBinding(DefaultParameterSetName = "All")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$VaultName,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$SecretName,
        [Parameter(Mandatory = $false)]
        [string]$TimeZoneId = 'GMT Standard Time',
        [Parameter(Mandatory = $false, ParameterSetName = "MaxResults")]
        [ValidateRange(1, 25)]
        [int]$MaxResults,
        [Parameter(Mandatory = $false, ParameterSetName = "All")]
        [Switch]$All
    )
    if (!(Get-TimeZone -Id $TimeZoneId).Id) {
        throw "Error invalid TimeZone Id!"
    }
    $TZ = [TimeZoneInfo]::FindSystemTimeZoneById($TimeZoneId)
    [datetime]$epoc = "1/1/1970"
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
        [PSCustomObject]$thisresponse = @()
        $splat = @{
            Headers     = Get-AzureRESTtoken -AzureResource 'Vault'
            Uri         = $uri
            Method      = 'Get'
            ErrorAction = 'Stop'
        }
        $thisresponse += Invoke-RestMethod @splat
        $response += $thisresponse.value
        if ($All) {
            $secretsnextlink = $thisresponse.nextLink
            [uri]$uri = $secretsnextlink
        }
    } while (![string]::IsNullOrEmpty($secretsnextlink))
    $KVSecretVers = @()
    foreach ($secret in $response) {
        $KVSecretVers += [PSCustomObject]@{
            VaultName     = $VaultName
            SecretName    = $SecretName
            SecretType    = $secret.contentType
            SecretVersion = $secret.id -split '/' | select-object -last 1
            Enabled       = $secret.attributes.enabled
            Created       = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId(
                $epoc.AddSeconds($secret.attributes.created),
                $TZ.Id
            )
            Updated       = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId(
                $epoc.AddSeconds($secret.attributes.updated),
                $TZ.Id
            )
            RecoveryLevel = $secret.attributes.recoveryLevel
        }
    }
    return $KVSecretVers
}

function Get-AzureKeyVaultRESTSecretValue {
    <#
    .SYNOPSIS

    .PARAMETER TimeZoneId
        Specify TimeZone in which to report secret date time fields.  Key Vault API returns ctime.

        Default is GMT Standard Time.

        Valid values are TimeZoneInfo Ids as returned by Get-TimeZone
    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureKeyVaultREST
    #>
    [CMDLetBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$VaultName,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$SecretName,
        [Parameter(Mandatory = $false)]
        [string]$TimeZoneId = 'GMT Standard Time',
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$SecretVersion
    )
    if (!(Get-TimeZone -Id $TimeZoneId).Id) {
        throw "Error invalid TimeZone Id!"
    }
    $TZ = [TimeZoneInfo]::FindSystemTimeZoneById($TimeZoneId)
    [datetime]$epoc = "1/1/1970"
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
        SecretType    = $response.contentType
        SecretVersion = $SecretVersion
        SecretValue   = $response.value
        Enabled       = $response.attributes.enabled
        Created       = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId(
            $epoc.AddSeconds($response.attributes.created),
            $TZ.Id
        )
        Updated       = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId(
            $epoc.AddSeconds($response.attributes.updated),
            $TZ.Id
        )
        RecoveryLevel = $response.attributes.recoveryLevel
    }
    return $KVSecretValue
}

function Set-AzureKeyVaultRESTSecret {
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
        [string]$SecretValue,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$SecretType
    )
    $apiVersion = '7.0'
    $uripath = 'secrets/{0}' -f $SecretName
    $uriquery = '?api-version={0}' -f $apiVersion
    [uri]$VaultBaseUrl = 'https://{0}.vault.azure.net' -f $VaultName
    $builturi = [System.UriBuilder]::new($VaultBaseUrl.Scheme, $VaultBaseUrl.Host, $VaultBaseUrl.Port, $uripath, $uriquery)
    [uri]$uri = $builturi.Uri
    $SecretDetails = [PSCustomObject]@{
        contentType = $SecretType
        value       = $SecretValue
    }
    try {
        $splat = @{
            Headers     = Get-AzureRESTtoken -AzureResource 'Vault'
            Uri         = $uri
            Body        = $SecretDetails | ConvertTo-Json
            Method      = 'Put'
            ErrorAction = 'Stop'
        }
        $response = Invoke-RestMethod @splat
    } catch {
        throw "Error setting secret!"
    }
    $KVSecret = [PSCustomObject]@{
        Id            = $response.id
        SecretType    = $response.contentType
        SecretValue   = $response.value
        Enabled       = $response.attributes.enabled
        Created       = $response.attributes.created
        Updated       = $response.attributes.updated
        RecoveryLevel = $response.attributes.recoveryLevel
    }
    return $KVSecret
}