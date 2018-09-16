# For use in Azure Function apps
# Sources:
# https://gcits.com/knowledge-base/check-office-365-accounts-against-have-i-been-pwned-breaches/
# https://www.petri.com/checking-office-365-email-addresses-compromise
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#vars
$tenantdomain = $env:tenant_domain
$tablepartitionkey = $env:breachtable_partkey
$funcapp = $env:funcapp_name
$gettablerowfuncxhead = $env:gettablerow_funckey
$gettablerowfunchead = @{
    "x-functions-key" = $gettablerowfuncxhead
}
$gettablerowfuncuri = "https://$funcapp.azurewebsites.net/api/GetTableRow"
$pwnedheaders = @{
    "User-Agent"  = "$tenantdomain Account Check"
    "api-version" = 2
}
$pwnedbaseUri = "https://haveibeenpwned.com/api"
$infoact = 'SilentlyContinue'

$in = Get-Content $triggerInput -Raw
Write-Output "Processing queue message '$in'"

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
class breachreport {
    [string]$Email
    [string]$UserPrincipalName
    [string]$DisplayName
    [bool]$Enabled
    [bool]$IsTenantAdmin
    [bool]$OnPremiseAccount
    [string]$UserType
    [string]$PasswordPolices
    [string]$BreachName
    [string]$BreachTitle
    [datetime]$BreachDate
    [datetime]$BreachAdded
    [datetime]$ModifiedDate
    [string]$BreachDescription
    [string]$BreachDataClasses
    [bool]$IsVerified
    [bool]$IsFabricated
    [bool]$IsActive
    [bool]$IsRetired
    [bool]$IsSpamList
    [string]$aztablepartitionkey
    [int32]$BreachHash
}

function Get-IdHash {
    param (
        $StringToHash
    )
    $hasher = new-object System.Security.Cryptography.SHA256Managed
    $toHash = [System.Text.Encoding]::UTF8.GetBytes($StringToHash)
    $hashByteArray = $hasher.ComputeHash($toHash)
    foreach ($byte in $hashByteArray) {
        $res += $byte.ToString()
    }
    return $res;
}

# Create user object from queue message
$user = New-Object UserItemQueueMsg
$user.UserPrincipalName = $in.userPrincipalName
$user.DisplayName = $in.DisplayName
$user.accountEnabled = $in.accountEnabled
$user.ProxyAddresses = $in.ProxyAddresses
$user.id = $in.id
$user.servicePlanIds = $in.assignedPlans.servicePlanId
$user.onPremisesSyncEnabled = $in.onPremisesSyncEnabled
$user.PasswordPolices = $in.PasswordPolices
$user.userType = $in.userType

# Check all smtp addresses against haveibeenpwned
$report = @()
$breaches = 0
$emails = ($user.ProxyAddresses).Where{$_ -match "smtp:" -and $_ -notmatch ".onmicrosoft.com"}
#$IsAdmin = $False
$emails.foreach( {
        $email = ($_ -split ":")[1]
        Write-Information -MessageData "Checking $Email" -InformationAction $infoact
        $uriEncodeEmail = [uri]::EscapeDataString($Email)
        $uri = "$pwnedbaseUri/breachedaccount/$uriEncodeEmail"
        $BreachResult = $null
        try {
            $restparms = @{
                Uri         = $uri
                Headers     = $pwnedheaders
                ErrorAction = 'SilentlyContinue'
            }
            [array]$BreachResult = Invoke-RestMethod @restparms
        } catch {
            if ($error[0].Exception.response.StatusCode -match "NotFound") {
                Write-Information -MessageData "No Breach detected for $email" -InformationAction $infoact
            } else {
                Write-Information -MessageData "Error querying this address!" -InformationAction $infoact
            }
        }
        if ($BreachResult) {
            #if ($Admins -Match $User.UserPrincipalName) {$IsAdmin = $True}
            foreach ($breach in $BreachResult) {
                $idstring = $breach.Email + $breach.Name + $breach.BreachDate + $breach.BreachAdded + $breach.ModifiedDate
                $breachhashid = Get-HashId -StringToHash $idstring
                $ReportLine = New-Object breachreport
                $ReportLine.Email = $email
                $ReportLine.UserPrincipalName = $user.UserPrincipalName
                $ReportLine.DisplayName = $user.DisplayName
                $ReportLine.Enabled = $user.accountEnabled
                $ReportLine.IsTenantAdmin = $IsAdmin
                $ReportLine.OnPremiseAccount = $user.onPremisesSyncEnabled
                $ReportLine.UserType = $user.userType
                $ReportLine.PasswordPolices = $user.passwordPolicies
                $ReportLine.BreachName = $breach.Name
                $ReportLine.BreachTitle = $breach.Title
                $ReportLine.BreachDate = $breach.BreachDate
                $ReportLine.BreachAdded = $breach.AddedDate
                $ReportLine.ModifiedDate = $breach.ModifiedDate
                $ReportLine.BreachDescription = $breach.Description
                $ReportLine.BreachDataClasses = ($breach.dataclasses -join ", ")
                $ReportLine.IsVerified = $breach.IsVerified
                $ReportLine.IsFabricated = $breach.IsFabricated
                $ReportLine.IsActive = $breach.IsActive
                $ReportLine.IsRetired = $breach.IsRetired
                $ReportLine.IsSpamList = $breach.IsSpamList
                $ReportLine.aztablepartitionkey = $tablepartitionkey
                $ReportLine.BreachHash = $breachhashid
                $report += $ReportLine
                Write-Information -MessageData "Breach detected for $email" -InformationAction $infoact
                #if ($IsAdmin -eq $True) {Write-Information -MessageData "This is a tenant administrator account" -InformationAction $infoact}
                $Breaches++
                Write-Information -MessageData $breach.Description -InformationAction $infoact
            }
        }
        Start-sleep -Milliseconds 1700
    })

if ($Breaches -gt 0) {
    # $Report | Export-CSV c:\temp\Breaches.csv -NoTypeInformation
    $report.ForEach( {
            # $filter = 'rowkey={0}'-f $PSItem.BreachHash
            $breachrowjson = $PSItem | ConvertTo-Json
            $breachrowsplat = @{
                Uri     = $gettablerowfuncuri
                Headers = $gettablerowfunchead
                Method  = 'Post'
                Body    = $breachrowjson
            }
            $breachrowres = Invoke-RestMethod @breachrowsplat
            Write-Output $breachrowres
            # https://stackoverflow.com/questions/46646120/azure-function-trigger-by-queue-with-input-data-storage-binding
            # JSON Payload binding: https://docs.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings#binding-expressions-and-patterns
            # https://docs.microsoft.com/en-us/rest/api/storageservices/Query-Entities?redirectedfrom=MSDN
            # https://docs.microsoft.com/en-us/rest/api/storageservices/querying-tables-and-entities
            # Invoke new function here to find existing table row by passing rowkey variable with http trigger value
            # WON'T WORK! - Make new function return table row as json or a "not found" response
            # Then either skip if found or add if not found - assume new
            # When adding table row make rowkey the breachhash and use the partitionkey from $tablepartitionkey
            # May need seperate function to upload row...
        })
    Write-Information -MessageData "Total breaches found: $Breaches" -InformationAction $infoact
} else
{ Write-Information -MessageData "No breaches found for your Office 365 mailboxes!" -InformationAction $infoact }

## TO DO: - Get admin users
##        - Export to Table Storage / CosmosDB
##        - Create PowerApp / web UI
##        - Change notifications - on new row addition?

## Resources...
# List Users - Documentation
# GET https://graph.microsoft.com/v1.0/users
# List Admins (via directory roles) - Documentation
# This is a multi-step process. First you must find the directory role for the Company Administrator,
# which will always have the roleTemplateId of 62e90394-69f5-4237-9190-012177145e10.
# This should not be confused by the actual directory role id, which will be different per directory.
# GET https://graph.microsoft.com/v1.0/directoryRoles
# Then you want to list the users who are a part of that directory role:
# GET https://graph.microsoft.com/v1.0/directoryRoles/<id>/members