# Adapted from https://github.com/andrew-s-taylor/Intune-PowerShell-Management
$AppId = 'YOUR_APP_ID'
$TenantId = 'YOUR_TENANT_ID'
$scopes = 'Device.ReadWrite.All, DeviceManagementManagedDevices.ReadWrite.All, DeviceManagementServiceConfig.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All'

## With custom app
Connect-MgGraph -ClientId $AppId -TenantId $TenantId -Scopes $scopes
## with default MS app
# Connect-MgGraph -Scopes $scopes

Remove-Module FirewallRulesMigration -ErrorAction SilentlyContinue
Import-Module '.\Scenario Modules\IntuneFirewallRulesMigration\FirewallRulesMigration.psm1'
. '.\Scenario Modules\IntuneFirewallRulesMigration\IntuneFirewallRulesMigration\Private\Strings.ps1'

## Use built-in Get-NetFirewallRule command to get the rules you want and pipe to the convert function, some examples....
# All group policy rules
$rules = Get-NetFirewallRule -PolicyStore RSOP | ConvertTo-IntuneFirewallRule -splitConflictingAttributes

# Rules with a display name of 'Steam'
# $rules = Get-NetFirewallRule -DisplayName 'Steam' | ConvertTo-IntuneFirewallRule -splitConflictingAttributes

## See Intune-PowerShell-Management\Scenario Modules\IntuneFirewallRulesMigration\README.md for more

# Running more than once with the same -migratedProfileName will create duplicate profiles with the same name
$rules | Send-IntuneFirewallRulesPolicy -migratedProfileName 'MyCustomProfileName'
