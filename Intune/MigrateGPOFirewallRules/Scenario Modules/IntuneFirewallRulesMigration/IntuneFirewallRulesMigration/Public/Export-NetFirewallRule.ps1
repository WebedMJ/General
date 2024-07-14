. "$PSScriptRoot\ConvertTo-IntuneFirewallRule.ps1"

function Export-NetFirewallRule {
    <#
    .SYNOPSIS
    Exports network firewall rules found on this host into Intune firewall rules.

    .DESCRIPTION
    Export-NetFirewallRule will export all network firewall rules found on the host and convert them into an
    intermediate IntuneFirewallRule object

    .EXAMPLE
    Export-NetFirewallRule
    Export-NetFirewallRule -PolicyStoreSource GroupPolicy
    Export-NetFirewallRule -PolicyStoreSource All
    Export-NetFirewallRule -splitConflictingAttributes -sendExportTelemetry

    .NOTES
    Export-NetFirewallRule is a wrapper for the cmdlet call to Get-NetFirewallRule piped to ConvertTo-IntuneFirewallRule.

    If -splitConflictingAttributes is toggled, then firewall rules with multiple attributes of filePath, serviceName,
    or packageFamilyName will automatically be processed and split instead of prompting users to split the firewall rule

    If -sendExportTelemetry is toggled, then error messages encountered will automatically be sent to Microsoft and the
    tool will continue processing net firewall rules.

    .LINK
    https://docs.microsoft.com/en-us/powershell/module/netsecurity/get-netfirewallrule?view=win10-ps#description

    .OUTPUTS
    IntuneFirewallRule[]

    A stream of exported firewall rules represented via the intermediate IntuneFirewallRule class
    #>
    [CmdletBinding()]
    Param(
        # If this flag is toggled, then firewall rules with multiple attributes of filePath, serviceName,
        # or packageFamilyName will automatically be processed and split instead of prompting users to split
        [switch] $splitConflictingAttributes,
        # If this flag is toggled, then telemetry is automatically sent to Microsoft.
        [switch] $sendExportTelemetry,
        # Defines the policy store source to pull net firewall rules from.
        [string] $PolicyStoreSource = 'All'
    )

    Switch ($PolicyStoreSource) {
        'All' {
            # The default behavior for Get-NetFirewallRule is to retrieve all WDFWAS firewall rules
            return $(Get-NetFirewallRule | ConvertTo-IntuneFirewallRule `
                    -splitConflictingAttributes:$splitConflictingAttributes `
                    -sendConvertTelemetry:$sendExportTelemetry)
        }
        'GroupPolicy' {
            return $(Get-NetFirewallRule -PolicyStore RSOP | ConvertTo-IntuneFirewallRule `
                    -splitConflictingAttributes:$splitConflictingAttributes `
                    -sendConvertTelemetry:$sendExportTelemetry)
        }
        default { Throw $('Given invalid policy store source: {0}' -f $PolicyStoreSource) }
    }
}