<#
.SYNOPSIS
    Module for interacting with Azure Automation using the ARM REST API, with specialised functions for
    WorkDay user provisioning.
    Designed to be invoked from an Azure web app or function app with managed identity enabled.
.DESCRIPTION

.LINK
    https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureRESTAuth
.NOTES
    Requires managed identity enabled on the app service and IAM permissions configured on the automation account.
#>

function Get-AzureRESTtoken {
    <#
    .SYNOPSIS
        Uses web/function app's Azure AD managed identity or Azure Automation RunAs to get Key Vault REST API token.
    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureRESTAuth
    #>
    [CMDLetBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet("ARM", "Vault")]
        [string]$AzureResource = 'ARM',
        [Parameter(Mandatory = $false)]
        [ValidateSet("ManagedIdentity", "AzureAutomationRunAs")]
        [string]$AzureIdentity = 'ManagedIdentity'
    )
    switch ($AzureIdentity) {
        'ManagedIdentity' {
            $apiVersion = '2017-09-01'
            switch ($AzureResource) {
                'ARM' { $resourceURI = 'https://management.azure.com' }
                'Vault' { $resourceURI = 'https://vault.azure.net' }
            }
            $uriquery = '?resource={0}&api-version={1}' -f $resourceURI, $apiVersion
            [uri]$uriendpoint = $env:MSI_ENDPOINT
            $uri = [System.UriBuilder]::new(
                $uriendpoint.Scheme,
                $uriendpoint.Host,
                $uriendpoint.Port,
                $uriendpoint.AbsolutePath,
                $uriquery
            )
            $tokenheaders = @{
                Secret = $env:MSI_SECRET
            }
            $tokensplat = @{
                Method  = 'Get'
                Headers = $tokenheaders
                Uri     = $uri.Uri
            }
            $tokenResponse = Invoke-RestMethod @tokensplat
            $accessToken = $tokenResponse.access_token
        }
        'AzureAutomationRunAs' {
            $AzRunAs = Get-AutomationConnection -Name AzureRunAsConnection
            $Azlogin = @{
                ServicePrincipal      = $true
                Tenant                = $AzRunAs.TenantId
                ApplicationId         = $AzRunAs.ApplicationId
                CertificateThumbprint = $AzRunAs.CertificateThumbprint
            }
            $Azsession = Login-AzureRmAccount @Azlogin
            $context = Get-AzureRmContext
            $SubscriptionId = $context.SubscriptionId
            $cache = $context.TokenCache
            $cacheItems = $cache.ReadItems()
            $accesstoken = $cacheItems[$cacheItems.Count - 1].AccessToken
        }
    }
    $tokenheader = @{
        Authorization  = "Bearer $accesstoken"
        'Content-Type' = 'application/json'
    }
    return $tokenheader
}