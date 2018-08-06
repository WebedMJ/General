# For use in Azure Functions
# Sources:
# https://gcits.com/knowledge-base/check-office-365-accounts-against-have-i-been-pwned-breaches/
# https://www.petri.com/checking-office-365-email-addresses-compromise

# vars
$clientid = $env:client_id
$clientsecret = $env:client_secret
$loginurl = $env:login_url
$tenantdomain = $env:tenant_domain
$userdetails = -join (
    'UserPrincipalName,',
    'DisplayName,',
    'accountEnabled,',
    'ProxyAddresses,',
    'id,',
    'assignedPlans,',
    'onPremisesSyncEnabled,',
    'passwordPolicies,',
    'userType'
)
$pwnedheaders = @{
    "User-Agent"  = "$tenantdomain Account Check"
    "api-version" = 2
}
$pwnedbaseUri = "https://haveibeenpwned.com/api"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

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
    $users = @()
    $reauthcount = 0
    do {
        try {
            $response = Invoke-RestMethod -Headers $usersheader -Uri $Uri -Method Get
            $usersnextlink = $response.'@odata.nextLink'
            $Uri = $usersnextlink
            # Option 1:
            $users += foreach ($user in $response.value) {
                [pscustomobject]@{
                    UserPrincipalName     = $user.UserPrincipalName
                    DisplayName           = $user.DisplayName
                    accountEnabled        = $user.accountEnabled
                    ProxyAddresses        = $user.ProxyAddresses
                    id                    = $user.id
                    assignedPlans         = $user.assignedPlans
                    onPremisesSyncEnabled = $user.onPremisesSyncEnabled
                    passwordPolicies      = $user.passwordPolicies
                    userType              = $user.userType

                }
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
                Write-information -MessageData "Getting new token and retrying..." -InformationAction Continue
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
                Write-information -MessageData "Unhandled error, aborting..." -InformationAction Continue
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
Write-information -MessageData "Found $($users.count) users" -InformationAction Continue

## TO DO: Get admin users!! ##

# List Users - Documentation
# GET https://graph.microsoft.com/v1.0/users
# List Admins (via directory roles) - Documentation
# This is a multi-step process. First you must find the directory role for the Company Administrator,
# which will always have the roleTemplateId of 62e90394-69f5-4237-9190-012177145e10.
# This should not be confused by the actual directory role id, which will be different per directory.
# GET https://graph.microsoft.com/v1.0/directoryRoles
# Then you want to list the users who are a part of that directory role:
# GET https://graph.microsoft.com/v1.0/directoryRoles/<id>/members

# Check all smtp addresses against haveibeenpwned
$Report = @()
$Breaches = 0
foreach ($user in $testusers) {
    $Emails = ($User.ProxyAddresses).Where{$_ -match "smtp:" -and $_ -notmatch ".onmicrosoft.com"}
    #$IsAdmin = $False
    $emails | ForEach-Object {
        $Email = ($_ -split ":")[1]
        Write-Host "Checking $Email"
        $uriEncodeEmail = [uri]::EscapeDataString($Email)
        $uri = "$pwnedbaseUri/breachedaccount/$uriEncodeEmail"
        $BreachResult = $null
        try {
            [array]$breachResult = Invoke-RestMethod -Uri $uri -Headers $pwnedheaders -ErrorAction SilentlyContinue
        } catch {
            if ($error[0].Exception.response.StatusCode -match "NotFound") {
                Write-Host "No Breach detected for $email"
            } else {
                Write-Host "Error querying this address!"
            }
        }
        if ($BreachResult) {
            #if ($Admins -Match $User.UserPrincipalName) {$IsAdmin = $True}
            foreach ($Breach in $BreachResult) {
                $ReportLine = [PSCustomObject][ordered]@{
                    Email             = $email
                    UserPrincipalName = $User.UserPrincipalName
                    Name              = $User.DisplayName
                    Enabled           = $User.accountEnabled
                    OnPremiseAccount  = $User.onPremisesSyncEnabled
                    UserType          = $User.userType
                    PasswordPolices   = $User.passwordPolicies
                    BreachName        = $breach.Name
                    BreachTitle       = $breach.Title
                    BreachDate        = $breach.BreachDate
                    BreachAdded       = $breach.AddedDate
                    BreachDescription = $breach.Description
                    BreachDataClasses = ($breach.dataclasses -join ", ")
                    IsVerified        = $breach.IsVerified
                    IsFabricated      = $breach.IsFabricated
                    IsActive          = $breach.IsActive
                    IsRetired         = $breach.IsRetired
                    IsSpamList        = $breach.IsSpamList
                    #IsTenantAdmin      = $IsAdmin
                }

                $Report += $ReportLine
                Write-Host "Breach detected for $email - $($breach.name)" -ForegroundColor Red
                #if ($IsAdmin -eq $True) {Write-Host "This is a tenant administrator account" -ForeGroundColor DarkRed}
                $Breaches++
                Write-Host $breach.Description -ForegroundColor Yellow
            }
        }
        Start-sleep -Milliseconds 2000
    }
}
if ($Breaches -gt 0) {
    $Report | Export-CSV c:\temp\Breaches.csv -NoTypeInformation
    Write-Host "Total breaches found: " $Breaches " You can find a report in c:\temp\Breaches.csv"
} else
{ Write-Host "No breaches found for your Office 365 mailboxes!" }
