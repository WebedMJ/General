# Sources:
# https://gcits.com/knowledge-base/check-office-365-accounts-against-have-i-been-pwned-breaches/
# https://www.petri.com/checking-office-365-email-addresses-compromise

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    $msolsubscriptions = Get-MsolSubscription -ErrorAction Stop
} catch {
    Write-Host "Not connected, trying authentication..."
    try {
        Connect-MsolService -ErrorAction Stop
    } catch {
        if ($error[0].Exception -match "Authentication Error") {
            Write-Host "Authentication Error"
            break
        }
    }
}

$headers = @{
    "User-Agent"  = "$((Get-MsolCompanyInformation).DisplayName) Account Check"
    "api-version" = 2
}

$baseUri = "https://haveibeenpwned.com/api"

# To check for admin status
$RoleId = (Get-MsolRole -RoleName "Company Administrator").ObjectId
$Admins = (Get-MsolRoleMember -RoleObjectId $RoleId | Select-Object EmailAddress)
$Report = @()
$Breaches = 0

# Get users to check
Write-Host "Fetching Users to check..."
$Users = Get-MsolUser -All
Write-Host "Processing "$Users.count

# Check all smtp addresses of users
foreach ($user in $users) {
    $Emails = $User.ProxyAddresses | Where-Object {$_ -match "smtp:" -and $_ -notmatch ".onmicrosoft.com"}
    $IsAdmin = $False
    $MFAUsed = $False
    $emails | ForEach-Object {
        $Email = ($_ -split ":")[1]
        Write-Host "Checking $Email"
        $uriEncodeEmail = [uri]::EscapeDataString($Email)
        $uri = "$baseUri/breachedaccount/$uriEncodeEmail"
        $BreachResult = $null
        try {
            [array]$breachResult = Invoke-RestMethod -Uri $uri -Headers $headers -ErrorAction SilentlyContinue
        } catch {
            if ($error[0].Exception.response.StatusCode -match "NotFound") {
                Write-Host "No Breach detected for $email"
            } else {
                Write-Host "Cannot retrieve results due to rate limiting or suspect IP. You may need to try a different computer"
            }
        }
        if ($BreachResult) {
            $MSOUser = Get-MsolUser -UserPrincipalName $User.UserPrincipalName
            if ($Admins -Match $User.UserPrincipalName) {$IsAdmin = $True}
            if ($MSOUser.StrongAuthenticationMethods -ne $Null) {$MFAUsed = $True}
            foreach ($Breach in $BreachResult) {
                $ReportLine = [PSCustomObject][ordered]@{
                    Email              = $email
                    UserPrincipalName  = $User.UserPrincipalName
                    Name               = $User.DisplayName
                    LastPasswordChange = $MSOUser.LastPasswordChangeTimestamp
                    BreachName         = $breach.Name
                    BreachTitle        = $breach.Title
                    BreachDate         = $breach.BreachDate
                    BreachAdded        = $breach.AddedDate
                    BreachDescription  = $breach.Description
                    BreachDataClasses  = ($breach.dataclasses -join ", ")
                    IsVerified         = $breach.IsVerified
                    IsFabricated       = $breach.IsFabricated
                    IsActive           = $breach.IsActive
                    IsRetired          = $breach.IsRetired
                    IsSpamList         = $breach.IsSpamList
                    IsTenantAdmin      = $IsAdmin
                    MFAUsed            = $MFAUsed
                }

                $Report += $ReportLine
                Write-Host "Breach detected for $email - $($breach.name)" -ForegroundColor Red
                if ($IsAdmin -eq $True) {Write-Host "This is a tenant administrator account" -ForeGroundColor DarkRed}
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
{ Write-Host "Hurray - no breaches found for your Office 365 mailboxes" }