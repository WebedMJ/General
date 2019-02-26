# Untested - 17/02/2019
function Get-AzureRMToken {
    [CmdletBinding()]
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
            scope         = 'https://management.azure.com/'
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

# Example use:
# $graphheader = Get-MSGraphToken -ClientId 'GUID' -ClientSecret 'Secret' -AzureADTenantDomain 'mycompany.onmicrosoft.com'