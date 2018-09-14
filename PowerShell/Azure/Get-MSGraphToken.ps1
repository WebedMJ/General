# vars from environment for use with Azure Functions, Jenkins, etc...
$clientid = $env:client_id
$clientsecret = $env:client_secret
$loginurl = $env:login_url
$tenantdomain = $env:tenant_domain

function Get-MSGraphToken {
    param (
        $parmsplat
    )
    $authorization = Invoke-RestMethod @parmsplat
    $accesstoken = $authorization.access_token
    $tokenheader = @{
        Authorization = "Bearer $accesstoken"
    }
    return $tokenheader
}

$tokenbody = @{
    client_id     = $clientid
    scope         = 'https://graph.microsoft.com/.default'
    client_secret = $clientsecret
    grant_type    = 'client_credentials'
}

$tokenparms = @{
    Uri         = "$loginurl/$tenantdomain/oauth2/v2.0/token"
    Method      = 'Post'
    Body        = $tokenbody
    ErrorAction = 'Stop'
}

# Example use:
$graphheader = Get-MSGraphToken -parmsplat $tokenparms
$userdetails = 'UserPrincipalName,DisplayName,accountEnabled,ProxyAddresses,id,assignedPlans,onPremisesSyncEnabled,passwordPolicies,userType'
[System.Uri]$Uri = "https://graph.microsoft.com/v1.0/users?`$select=$userdetails"
Invoke-RestMethod -Headers $graphheader -Uri $Uri -Method Get -ErrorAction Stop