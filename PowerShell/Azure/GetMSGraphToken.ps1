# Deprecated, see https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureRESTAuth
#
function Get-MSGraphToken {
    [CmdletBinding()]
    [OutputType("System.Collections.Hashtable")]
    param (
        [Parameter(Mandatory = $true)]
        $ClientId,
        [Parameter(Mandatory = $true)]
        $ClientSecret,
        [Parameter(Mandatory = $true)]
        $AzureADTenantDomain
    )

    begin {
        $RestError = $null
        $loginurl = 'https://login.microsoftonline.com'
        $tokenbody = @{
            client_id     = $ClientId
            scope         = 'https://graph.microsoft.com/.default'
            client_secret = $ClientSecret
            grant_type    = 'client_credentials'
        }
        $tokenparms = @{
            Uri         = "$loginurl/$AzureADTenantDomain/oauth2/v2.0/token"
            Method      = 'Post'
            Body        = $tokenbody
            ErrorAction = 'Stop'
        }
    }

    Process {
        try {
            $authorization = Invoke-RestMethod @tokenparms
        } catch {
            $RestError = $Error[0].Exception

        }
    }

    end {
        if (!$RestError) {
            $accesstoken = $authorization.access_token
            $tokenheader = @{
                Authorization = "Bearer $accesstoken"
            }
            return $tokenheader
        } else {
            return $RestError
        }
    }

}

# Example use to get Azure AD users and specific properties:
# $graphheader = Get-MSGraphToken -ClientId 'GUID' -ClientSecret 'Secret' -AzureADTenantDomain 'mycompany.onmicrosoft.com'
# $userdetails = 'UserPrincipalName,DisplayName,accountEnabled,ProxyAddresses,id,assignedPlans,onPremisesSyncEnabled,passwordPolicies,userType'
# [System.Uri]$Uri = "https://graph.microsoft.com/v1.0/users?`$select=$userdetails"
# Invoke-RestMethod -Headers $graphheader -Uri $Uri -Method Get