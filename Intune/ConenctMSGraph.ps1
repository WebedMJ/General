# Adapted from https://github.com/andrew-s-taylor/Intune-PowerShell-Management/blob/master/Export-FirewallRules.ps1

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
        [Parameter(Mandatory = $true)] [string]$Scopes
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
            Write-Host "Connected to Intune tenant $TenantId using app-based authentication (Azure AD authentication not supported)"
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