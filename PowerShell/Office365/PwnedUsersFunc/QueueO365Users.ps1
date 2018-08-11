Write-Output "PowerShell Timer trigger function executed at:$(get-date)"
# For use in Azure Function apps
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# vars
$clientid = $env:client_id
$clientsecret = $env:client_secret
$loginurl = $env:login_url
$tenantdomain = $env:tenant_domain
$queuefuncapp = $env:queuefuncapp_name
$queuefuncxhead = $env:createqueuemsg_funckey
$userdetails = -join (
    'UserPrincipalName,',
    'DisplayName,',
    'accountEnabled,',
    'ProxyAddresses,',
    'id,',
    'assignedPlans,',
    'onPremisesSyncEnabled,',
    'PasswordPolices,',
    'userType'
)
$infoact = 'SilentlyContinue'
$queuefunchead = @{
    "x-functions-key" = $queuefuncxhead
}
$queuefuncuri = "https://$queuefuncapp.azurewebsites.net/api/CreateQueueMsg"

class UserItemQueueMsg {
    [string]$UserPrincipalName
    [string]$DisplayName
    [bool]$accountEnabled
    [System.Collections.Generic.List[string]]$ProxyAddresses
    [string]$id
    [System.Collections.Generic.List[string]]$servicePlanIds
    [bool]$onPremisesSyncEnabled
    [string]$PasswordPolices
    [string]$userType
}

# Get MS Graph Access Token
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

# Get Users
try {
    $usersheader = Get-MSGraphToken -parmsplat $tokenparms
    [System.Uri]$Uri = "https://graph.microsoft.com/v1.0/users?`$select=$userdetails"
    [System.String]$usersnextlink = ''
    # $queuemsgs = @()
    $reauthcount = 0
    do {
        try {
            $response = Invoke-RestMethod -Headers $usersheader -Uri $Uri -Method Get
            $usersnextlink = $response.'@odata.nextLink'
            $Uri = $usersnextlink
            foreach ($user in $response.value) {
                $usermsg = New-Object UserItemQueueMsg
                $usermsg.UserPrincipalName = $user.userPrincipalName
                $usermsg.DisplayName = $user.DisplayName
                $usermsg.accountEnabled = $user.accountEnabled
                $usermsg.ProxyAddresses = $user.ProxyAddresses
                $usermsg.id = $user.id
                $usermsg.servicePlanIds = $user.assignedPlans.servicePlanId
                $usermsg.onPremisesSyncEnabled = $user.onPremisesSyncEnabled
                $usermsg.PasswordPolices = $user.PasswordPolices
                $usermsg.userType = $user.userType
                $userjson = $usermsg | ConvertTo-Json
                $queueuser = Invoke-RestMethod -Uri $queuefuncuri -Headers $queuefunchead -Method Post -Body $userjson
                Write-Output $queueuser
            }
        } catch {
            if (($_.Exception.Response.StatusCode -match "Unauthorized") -and ($script:reauthcount -lt 5)) {
                $StatusCode = $_.Exception.Response.StatusCode
                $StatusDescription = $_.Exception.Response.StatusDescription
                $errormessageparms = @{
                    Message  = "Request to $Uri failed with HTTP Status $StatusCode $StatusDescription"
                    Category = 'AuthenticationError'
                }
                Write-Error @errormessageparms
                Write-information -MessageData "Getting new token and retrying..." -InformationAction $infoact
                $usersheader = Get-MSGraphToken -parmsplat $tokenparms
                $reauthcount++
            } else {
                $StatusCode = $_.Exception.Response.StatusCode
                $StatusDescription = $_.Exception.Response.StatusDescription
                $errormessageparms = @{
                    Message  = "Request to $Uri failed with HTTP Status $StatusCode $StatusDescription"
                    Category = 'AuthenticationError'
                }
                Write-Error @errormessageparms
                Write-information -MessageData "Unhandled error, aborting..." -InformationAction $infoact
                break
            }
        }
    } while (![string]::IsNullOrEmpty($usersnextlink))
} catch {
    $StatusCode = $_.Exception.Response.StatusCode
    $StatusDescription = $_.Exception.Response.StatusDescription
    $errormessageparms = @{
        Message  = "Request to $Uri failed with HTTP Status $StatusCode $StatusDescription"
        Category = 'InvalidResult'
    }
    Write-Error @errormessageparms
    break
}
Write-information -MessageData "Found $($queuemsgs.count) users" -InformationAction $infoact