<#
.SYNOPSIS
    UPDATED TO USE Az MODULE INSTEAD OF AzureRM module in Automation Accounts!

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
        Uses web/function app's Azure AD managed identity or Azure Automation RunAs to get Azure REST API tokens.
        Can also use AAD client id / secret for shared key authorization with MSGraph and ARM.

        Returns a hashtable with authorization (with bearer token) and contentType to use as an authorization header.
    .PARAMETER AzureResource
        Choose which azure resource to get an authorization token for when using Managed Identity.
        No effect when using Azure Automation RunAs or Shared Key.

        Valid values: ARM, Vault, MSGraph, AADGraph
    .PARAMETER AzureIdentity
        Select which authentication source to use, currently supports managed identities, Azure Automation RunAs accounts,
        and Shared Key.

        Azure Automation RunAs uses Az module.

        SharedKey currently supports MSGraph only.

        Valid values: ManagedIdentity, AzureAutomationRunAs, SharedKey
    .PARAMETER SharedKeyScope
        For use with SharedKey authorization with.
        Select the scope to authorize with the shared client id and secret key.
    .PARAMETER ClientId
        Client Id aor Application Id from an AAD appliction registration.
    .PARAMETER ClientSecret
        Generated Secret from the AAD application registration referenced by ClientId
    .PARAMETER AADTenantDomain
        Domain name of the AAD tenant for the registered AAD application.
        In the form of domain.onmicrosoft.com.
    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureRESTAuth
    #>
    [CMDLetBinding()]
    [OutputType("System.Collections.Hashtable")]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = "ManagedIdentity",
            HelpMessage = "Valid values: ARM, Vault, MSGraph, AADGraph.  Maximum of one allowed.")]
        [ValidateSet("ARM", "Vault", "MSGraph", "AADGraph")]
        [ValidateCount(1, 1)]
        [string[]]$AzureResource = 'ARM',
        [Parameter(Mandatory = $false,
            HelpMessage = "Valid values: ManagedIdentity, AzureAutomationRunAs, SharedKey.  Maximum of one allowed.")]
        [ValidateSet("ManagedIdentity", "AzureAutomationRunAs", "SharedKey")]
        [ValidateCount(1, 1)]
        [string[]]$AzureIdentity = 'ManagedIdentity',
        [Parameter(Mandatory = $true, ParameterSetName = "SharedKey",
            HelpMessage = "Valid values: MSGraph.  Maximum of one allowed.")]
        [ValidateSet("MSGraph")]
        [ValidateCount(1, 1)]
        [string[]]$SharedKeyScope,
        [Parameter(Mandatory = $true, ParameterSetName = "SharedKey")]
        [string]$ClientId,
        [Parameter(Mandatory = $true, ParameterSetName = "SharedKey")]
        [string]$ClientSecret,
        [Parameter(Mandatory = $true, ParameterSetName = "SharedKey")]
        [string]$AADTenantDomain
    )

    begin {
        $funcerror = $null
        $ARMuri = 'https://management.azure.com'
        $Vaulturi = 'https://vault.azure.net'
        $MSGraphuri = 'https://graph.microsoft.com'
        $AADGraphuri = 'https://graph.windows.net'
        switch ($AzureIdentity) {
            'ManagedIdentity' {
                $apiVersion = '2017-09-01'
                switch ($AzureResource) {
                    'ARM' { $resourceURI = $ARMuri }
                    'Vault' { $resourceURI = $Vaulturi }
                    'MSGraph' { $resourceURI = $MSGraphuri }
                    'AADGraph' { $resourceURI = $AADGraphuri }
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
            }
            'AzureAutomationRunAs' {
                $AzRunAs = Get-AutomationConnection -Name AzureRunAsConnection
                $Azlogin = @{
                    ServicePrincipal      = $true
                    Tenant                = $AzRunAs.TenantId
                    ApplicationId         = $AzRunAs.ApplicationId
                    CertificateThumbprint = $AzRunAs.CertificateThumbprint
                }
            }
            'SharedKey' {
                If (!($PSBoundParameters.ContainsKey('ClientId'))) {
                    throw "Error: ClientId, ClientSecret and AADTenantDomain are required when using SharedKey"
                }
                $loginurl = 'https://login.microsoftonline.com'
                switch ($SharedKeyScope) {
                    'ARM' { $SKScopeURI = $ARMuri }
                    'MSGraph' { $SKScopeURI = "$MSGraphuri/.default" }
                }
                $tokenbody = @{
                    client_id     = $ClientId
                    scope         = $SKScopeURI
                    client_secret = $ClientSecret
                    grant_type    = 'client_credentials'
                }
                $tokensplat = @{
                    Uri         = "$loginurl/$AADTenantDomain/oauth2/v2.0/token"
                    Method      = 'Post'
                    Body        = $tokenbody
                    ErrorAction = 'Stop'
                }
            }
        }
    }

    process {
        switch ($AzureIdentity) {
            'ManagedIdentity' {
                try {
                    $tokenResponse = Invoke-RestMethod @tokensplat
                    $accessToken = $tokenResponse.access_token
                } catch {
                    $funcerror = $Error[0].Exception
                }
            }
            'AzureAutomationRunAs' {
                try {
                    $Azsession = Connect-AzAccount @Azlogin
                    $context = Get-AzContext
                    $cache = $context.TokenCache
                    $cacheItems = $cache.ReadItems()
                    $accesstoken = $cacheItems[$cacheItems.Count - 1].AccessToken
                } catch {
                    $funcerror = $Error[0].Exception
                }
            }
            'SharedKey' {
                try {
                    $tokenResponse = Invoke-RestMethod @tokensplat
                    $accessToken = $tokenResponse.access_token
                } catch {
                    $funcerror = $Error[0].Exception
                }
            }
        }
    }

    end {
        if (!$funcerror) {
            $tokenheader = @{
                Authorization  = "Bearer $accesstoken"
                'Content-Type' = 'application/json'
            }
            return $tokenheader
        } else {
            throw $funcerror
        }
    }

}