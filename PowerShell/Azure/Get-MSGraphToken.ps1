# vars from environment for use with Azure Functions, Jenkins, etc...
$clientid = $env:client_id
$clientsecret = $env:client_secret
$loginurl = $env:login_url
$tenantdomain = $env:tenant_domain

function Get-MSGraphToken {
    param (
        $paramsplat
    )
    Invoke-RestMethod @paramsplat
}
# get Access Token
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

$authorization = Get-MSGraphToken -paramsplat $tokenparms
$accesstoken = $authorization.access_token
$tokenheader = @{
    Authorization = "Bearer $accesstoken"
}

# Example use:
# $userdetails = 'UserPrincipalName,DisplayName,accountEnabled,ProxyAddresses,id,assignedPlans,onPremisesSyncEnabled,passwordPolicies,userType'
# [System.Uri]$Uri = "https://graph.microsoft.com/v1.0/users?`$select=$userdetails"
# Invoke-RestMethod -Headers $tokenheader -Uri $Uri -Method Get -ErrorAction Stop