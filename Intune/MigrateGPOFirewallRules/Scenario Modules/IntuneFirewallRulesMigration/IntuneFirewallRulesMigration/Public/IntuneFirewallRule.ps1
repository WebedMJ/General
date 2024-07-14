. "$PSScriptRoot\..\Private\Strings.ps1"
# An intermediate representation of an Intune firewall rule. The official definition of the firewall can be found here:
# https://docs.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-windowsfirewallrule?view=graph-rest-beta
class IntuneFirewallRule {
    [String] $displayName
    [String] $description
    [String] $packageFamilyName
    [String] $filePath
    [String] $serviceName
    [Int32] $protocol
    [String[]] $localPortRanges
    [String[]] $remotePortRanges
    [String[]] $localAddressRanges
    [String[]] $remoteAddressRanges
    [String] $profileTypes
    [String] $action
    [String] $trafficDirection
    [String] $interfaceTypes
    [String] $localUserAuthorizations
    [String] $edgeTraversal
}

function New-IntuneFirewallRule {
    <#
    .SYNOPSIS
    Creates a new Intune firewall object.

    .DESCRIPTION
    New-IntuneFirewallRule will create a blank IntuneFirewallRule object that can be used to set data values for importing to Intune.

    .EXAMPLE
    New-IntuneFirewallRule

    .OUTPUTS
    IntuneFirewallRule
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param()
    If ($PSCmdlet.ShouldProcess("", $Strings.NewIntuneFirewallRuleShouldProcessMessage)) {
        return New-Object -TypeName IntuneFirewallRule
    }
}
