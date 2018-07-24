# List licenses on each user in Azure AD
$licensedlist = @()
 foreach ($User in (Get-MsolUser -All)) {
     $UserInfo = Get-MsolUser -UserPrincipalName $User.UserPrincipalName
     foreach ($license in $User.Licenses) {
         $licensedlist += New-Object PsObject -Property @{
             "Username"     = "$($UserInfo.DisplayName)";
             "UPN"          = "$($UserInfo.UserPrincipalName)";
             "AccountSKUID" = "$($license.AccountSKUid)"
         }
     }
 }

$licensedlist.Count

# Get msol user objects for licensed users...
$licensedMsolusers = ($e3.UPN).ForEach( {Get-MsolUser -UserPrincipalName $PSItem})