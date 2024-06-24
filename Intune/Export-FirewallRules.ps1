# Adapted from https://github.com/andrew-s-taylor/Intune-PowerShell-Management/blob/master/Export-FirewallRules.ps1
param(
    [switch]$includeDisabledRules,
    [switch]$includeLocalRules,
    [string]$tenantId,
    [string]$appid
)

## check for elevation
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity

if (!$principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host -ForegroundColor Red 'Error:  Must run elevated: run as administrator'
    Write-Host 'No commands completed'
    return
}

#----------------------------------------------------------------------------------------------C:\Users\t-oktess\Documents\powershellproject
if (-not(Test-Path '.\Intune-PowerShell-Management.zip')) {
    #Download a zip file which has other required files from the public repo on github
    Invoke-WebRequest -Uri 'https://github.com/andrew-s-taylor/Intune-PowerShell-Management/archive/master.zip' -OutFile '.\Intune-PowerShell-Management.zip'

    #Unblock the files especially since they are download from the internet
    Get-ChildItem '.\Intune-PowerShell-Management.zip' -Recurse -Force | Unblock-File

    #Unzip the files into the current direectory
    Expand-Archive -LiteralPath '.\Intune-PowerShell-Management.zip' -DestinationPath '.\'
}
#----------------------------------------------------------------------------------------------
Function Connect-ToGraph {
    <#
.SYNOPSIS
Authenticates to the Graph API via the Microsoft.Graph.Authentication module.

.DESCRIPTION
The Connect-ToGraph cmdlet is a wrapper cmdlet that helps authenticate to the Intune Graph API using the Microsoft.Graph.Authentication module. It leverages an Azure AD app ID and app secret for authentication or user-based auth.

.PARAMETER TenantId
Specifies the tenant ID (GUID) to which to authenticate.

.PARAMETER AppId
Specifies the Azure AD app ID (GUID) for the application that will be used to authenticate.

.PARAMETER Scopes
Specifies the user scopes for interactive authentication.

.EXAMPLE
Connect-ToGraph -TenantId $tenantID -AppId $app -Scopes "DeviceManagementConfiguration.ReadWrite.All"

-#>
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $false)] [string]$TenantId,
        [Parameter(Mandatory = $false)] [string]$AppId,
        [Parameter(Mandatory = $false)] [string]$Scopes
    )

    Process {
        Import-Module Microsoft.Graph.Authentication
        $version = (Get-Module microsoft.graph.authentication | Select-Object -ExpandProperty Version).major

        if ($AppId -ne '') {
            $accessToken
            if ($version -eq 2) {
                Write-Host 'Version 2 module detected'
            } else {
                Write-Host 'Version 1 Module Detected'
                Select-MgProfile -Name Beta
            }
            $graph = Connect-MgGraph -ClientId $AppId -TenantId $TenantId -Scopes $Scopes
            Write-Host "Connected to Intune tenant $TenantId"
        } else {
            if ($version -eq 2) {
                Write-Host 'Version 2 module detected'
            } else {
                Write-Host 'Version 1 Module Detected'
                Select-MgProfile -Name Beta
            }
            $graph = Connect-MgGraph -Scopes $scopes
            Write-Host "Connected to Intune tenant $($graph.TenantId)"
        }
    }
}
function getallpagination () {
    <#
.SYNOPSIS
This function is used to grab all items from Graph API that are paginated
.DESCRIPTION
The function connects to the Graph API Interface and gets all items from the API that are paginated
.EXAMPLE
getallpagination -url "https://graph.microsoft.com/v1.0/groups"
 Returns all items
.NOTES
 NAME: getallpagination
#>
    [cmdletbinding()]

    param
    (
        $url
    )
    $response = (Invoke-MgGraphRequest -Uri $url -Method Get -OutputType PSObject)
    $alloutput = $response.value

    $alloutputNextLink = $response.'@odata.nextLink'

    while ($null -ne $alloutputNextLink) {
        $alloutputResponse = (Invoke-MgGraphRequest -Uri $alloutputNextLink -Method Get -OutputType PSObject)
        $alloutputNextLink = $alloutputResponse.'@odata.nextLink'
        $alloutput += $alloutputResponse.value
    }

    return $alloutput
}


Write-Host 'Connecting to Intune Graph'

if ($AppId -ne '') {
    Connect-ToGraph -Tenant $TenantId -AppId $AppId
    Write-Host "Connected to Intune tenant $TenantId using app-based authentication"
} else {
    $graph = Connect-ToGraph -scopes 'Device.ReadWrite.All, DeviceManagementManagedDevices.ReadWrite.All, DeviceManagementServiceConfig.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All'
    Write-Host "Connected to Intune tenant $($graph.TenantId)"
}

#Import all the right modules
Import-Module '.\Intune-PowerShell-Management-master\Scenario Modules\IntuneFirewallRulesMigration\FirewallRulesMigration.psm1'
. '.\Intune-PowerShell-Management-master\Scenario Modules\IntuneFirewallRulesMigration\IntuneFirewallRulesMigration\Private\Strings.ps1'

##Validate the user's profile name
$profileName = ''
try {
    $uri = "https://graph.microsoft.com/beta/deviceManagement/intents?$filter=templateId%20eq%20%274b219836-f2b1-46c6-954d-4cd2f4128676%27%20or%20templateId%20eq%20%274356d05c-a4ab-4a07-9ece-739f7c792910%27%20or%20templateId%20eq%20%275340aa10-47a8-4e67-893f-690984e4d5da%27"
    $json = getallpagination -url $uri
    $profiles = $json.value
    $profileNameExist = $true
    $profileName = Read-Host -Prompt $Strings.EnterProfile
    while (-not($profileName)) {
        $profileName = Read-Host -Prompt $Strings.ProfileCannotBeBlank
    }
    while ($profileNameExist) {
        foreach ($display in $profiles) {
            $name = $display.displayName.Split('-')
            $profileNameExist = $false
            if ($name[0] -eq $profileName) {
                $profileNameExist = $true
                $profileName = Read-Host -Prompt $Strings.ProfileExists
                while (-not($profileName)) {
                    $profileName = Read-Host -Prompt $Strings.ProfileCannotBeBlank
                }
                break
            }
        }
    }
    $EnabledOnly = $true
    if ($includeDisabledRules) {
        $EnabledOnly = $false
    }

    if ($includeLocalRules) {
        Export-NetFirewallRule -ProfileName $profileName -CheckProfileName $false -EnabledOnly:$EnabledOnly -PolicyStoreSource 'All'
    } else {
        Export-NetFirewallRule -ProfileName $profileName -CheckProfileName $false -EnabledOnly:$EnabledOnly
    }

} catch {
    $errorMessage = $_.ToString()
    Write-Host -ForegroundColor Red $errorMessage
    Write-Host 'No commands completed'
}


