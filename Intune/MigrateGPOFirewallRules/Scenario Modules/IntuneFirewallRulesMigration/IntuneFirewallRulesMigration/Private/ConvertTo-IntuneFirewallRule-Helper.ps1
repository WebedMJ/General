. "$PSScriptRoot\Use-HelperFunctions.ps1"
. "$PSScriptRoot\Strings.ps1"

# Helper functions used for extracting various pieces of information from a firewall rule.
# The values found internally in firewall objects when accessing them from a host were found from this link:
# https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/jj676843(v=vs.85)
# but the return values that are to be sent to Intune are determined by the API found in:
# https://docs.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-windowsfirewallrule?view=graph-rest-beta

# If there are any discrepencies between the two APIs (e.g. there is another option available but Intune doesn't support it),
# we will throw an error upon encountering the discrepency.

# A wrapper exception class to allow for more detailed exceptions to be thrown
class ExportFirewallRuleException : System.Exception {
    # Represents the particular property that is thrown
    [string] $firewallRuleProperty

    ExportFirewallRuleException($Message, $firewallRuleProperty) : base($Message) {
        $this.firewallRuleProperty = $firewallRuleProperty
    }
}

function Get-FirewallDisplayName {
    <#
    .SYNOPSIS
    Retrieves the display name for a firewall rule.
    .EXAMPLE
    Get-FirewallDisplayName -firewallObject $firewallObject
    .PARAMETER firewallObject The firewall object.
    .INPUTS
    Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule
    .OUTPUTS
    String
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $firewallObject
    )
    $displayNameLengthLimit = 200
    # replaces '/' and '|' as '_'; Intune does not allow '/' or '|' in display names
    $formattedDisplayName = $firewallObject.displayName -replace "/|\|", "_"
    # Intune sets a hard limit of 200 characters for display name lengths
    If ($firewallObject.displayName.Length -gt $displayNameLengthLimit) {
        $errorTitle = $Strings.FirewallRuleDisplayNameTooLongTitle
        $errorMessage = $Strings.FirewallRuleDisplayNameTooLongMessage `
            -f $firewallObject.DisplayName, $firewallObject.displayName.subString(0, $displayNameLengthLimit)

        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", $($Strings.FirewallRuleDisplayNameYes -f $displayNameLengthLimit)
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", $Strings.FirewallRuleDisplayNameNo
        $rename = New-Object System.Management.Automation.Host.ChoiceDescription "&Rename", $Strings.FirewallRuleDisplayNameRename
        $errorOptions = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $rename)

        $choice = Get-UserPrompt -promptTitle $errorTitle `
            -promptMessage $errorMessage `
            -promptOptions $errorOptions `
            -defaultOption 0

        # Choice is the index of the option
        Switch ($choice) {
            # replaces '/' and '|' as '_'
            0 { return $formattedDisplayName.subString(0, $displayNameLengthLimit) }
            1 { Throw [ExportFirewallRuleException]::New($Strings.FirewallRuleDisplayNameException, $Strings.FirewallRuleDisplayName) }
            2 { return Read-Host -Prompt $Strings.FirewallRuleDisplayNameRenamePrompt }
        }
    }
    return $formattedDisplayName
}

# Due to the way package family names are stored in Windows, there is some preprocessing that has to
# be done to avoid linear time lookups for the package family name.
$packageFullNameToFamilyName = @{ }
ForEach ($appPackage in Get-AppxPackage) {
    $packageFullNameToFamilyName.Set_Item($appPackage.PackageFullName, $appPackage.PackageFamilyName)
}

$packageSidLookup = @{ }
# Package family names are represented internally as package SIDs (Security Identifiers), which are not accepted by Intune.
# These SIDs can be translated by digging into the registry at the provided location
ForEach ($registryItem in Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\SecurityManager\CapAuthz\ApplicationsEx) {
    $packageFullName = $registryItem.Name -replace "^HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\SecurityManager\\CapAuthz\\ApplicationsEx\\", ""
    $packageSid = $registryItem.GetValue("PackageSid")
    If ($packageFullNameToFamilyName.ContainsKey($packageFullName)) {
        $packageSidLookup.Set_Item($packageSid, $packageFullNameToFamilyName[$packageFullName])
    }
}
function Get-FirewallPackageFamilyName {
    <#
    .SYNOPSIS
    Retrieves the package family name from a firewall rule object.
    .EXAMPLE
    Get-FirewallPackageFamilyName -firewallObject $firewallObject
    .PARAMETER firewallObject The firewall object.
    .LINK
    https://docs.microsoft.com/en-us/powershell/module/netsecurity/get-netfirewallapplicationfilter?view=win10-ps#parameters
    .INPUTS
    Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule
    .OUTPUTS
    String
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $firewallObject
    )
    $appFilterInstance = Get-NetFirewallApplicationFilterWrapper -AssociatedNetFirewallRule $firewallObject
    If (-not $appFilterInstance.Package) {
        return $null
    }

    # In scenarios where a package security identifier was found, but did not exist when we created the hash table,
    # user interaction is required.
    If ($appFilterInstance.Package -and -not $packageSidLookup.ContainsKey($appFilterInstance.Package)) {
        $errorTitle = $Strings.FirewallRulePackageFamilyNameSidTitle

        $uniqueName = $Strings.FirewallRulePackageFamilyNameUniqueName -f $firewallObject.Name
        $packageSid = $Strings.FirewallRulePackageFamilyNameSid -f $appFilterInstance.Package
        $errorMessage = $Strings.FirewallRulePackageFamilyNameSidMessage -f ($firewallObject.displayName, `
                $uniqueName, `
                $packageSid, `
                $Strings.FirewallRulePackageFamilyNameDescription)

        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", $Strings.FirewallRulePackageFamilyNameYes
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", $Strings.FirewallRulePackageFamilyNameNo
        $errorOptions = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

        $choice = Get-UserPrompt -promptTitle $errorTitle `
            -promptMessage $errorMessage `
            -promptOptions $errorOptions `
            -defaultOption 0

        # Choice is the index of the option
        Switch ($choice) {
            0 { return Read-Host -Prompt $Strings.FirewallRulePackageFamilyNamePrompt }
            1 { Throw [ExportFirewallRuleException]::new($Strings.FirewallRulePackageFamilyNameException, $Strings.FirewallRulePackageFamilyName) }
        }
    }
    return $packageSidLookup[$appFilterInstance.Package]
}

function Get-FirewallFilePath {
    <#
    .SYNOPSIS
    Retrieves the file path from a firewall rule object.
    .EXAMPLE
    Get-FirewallFilePath -firewallObject $firewallObject
    .PARAMETER firewallObject The firewall object.
    .INPUTS
    Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule
    .OUTPUTS
    String
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $firewallObject
    )
    $appFilterInstance = Get-NetFirewallApplicationFilterWrapper -AssociatedNetFirewallRule $firewallObject
    If ($appFilterInstance.Program -eq $Strings.Any ) {
        return $null
    }
    return $appFilterInstance.Program
}

function Get-FirewallServiceName {
    <#
    .SYNOPSIS
    Retrieves the service name from a firewall rule object.
    .EXAMPLE
    Get-FirewallServiceName -firewallObject $firewallObject
    .PARAMETER firewallObject The firewall object.
    .INPUTS
    Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule
    .OUTPUTS
    String
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $firewallObject
    )
    $serviceFilter = Get-NetFirewallServiceFilterWrapper -AssociatedNetFirewallRule $firewallObject
    If ($serviceFilter.Service -eq $Strings.Any) {
        return $null
    }
    return $serviceFilter.Service
}

function Get-FirewallProtocol {
    <#
    .SYNOPSIS
    Retrieves the service name from a firewall rule object.
    .EXAMPLE
    Get-FirewallProtocol -firewallObject $firewallObject
    .PARAMETER firewallObject The firewall object.
    .INPUTS
    Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule
    .OUTPUTS
    Int32
    .NOTES
    # Values for the string mapped port values can be found here:
    # https://docs.microsoft.com/en-us/powershell/module/netsecurity/set-netfirewallrule?view=win10-ps
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $firewallObject
    )
    $portFilterInstance = Get-NetFirewallPortFilterWrapper -AssociatedNetFirewallRule $firewallObject

    # The behavior of the Get-NetFirewallPortFilter cmdlet is to return the string name of the protocol for these
    # specific protocols, everything else is a number
    Switch ($portFilterInstance.Protocol) {
        "TCP" { return 6 }
        "UDP" { return 17 }
        "ICMPv4" { return 1 }
        "ICMPv6" { return 58 }
        # the default 'All' value in graph is interpreted as a null argument for the protocol
        $Strings.Any { return $null }
        default {
            Try {
                return [int]$portFilterInstance.Protocol
            }
            Catch {
                Throw [ExportFirewallRuleException]::new($Strings.FirewallRuleProtocolException -f $_, $Strings.FirewallRuleProtocol)
            }
        }
    }
}

function Get-FirewallLocalPortRange {
    <#
    .SYNOPSIS
    Returns the local port ranges for the firewall object
    .EXAMPLE
    Get-FirewallLocalPortRange -firewallObject $firewallObject
    .PARAMETER firewallObject The firewall object.
    .INPUTS
    Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule
    .OUTPUTS
    String
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $firewallObject
    )

    $portFilter = Get-NetFirewallPortFilterWrapper -AssociatedNetFirewallRule $firewallObject
    return Get-FirewallPortRangeHelper -portInstance $portFilter.LocalPort -exportType $Strings.FirewallRuleLocalPort
}

function Get-FirewallRemotePortRange {
    <#
    .SYNOPSIS
    Returns the remote port ranges for the firewall object
    .EXAMPLE
    Get-FirewallRemotePortRange -firewallObject $firewallObject
    .PARAMETER firewallObject The firewall object.
    .INPUTS
    Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule
    .OUTPUTS
    String
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $firewallObject
    )

    $portFilter = Get-NetFirewallPortFilterWrapper -AssociatedNetFirewallRule $firewallObject
    return Get-FirewallPortRangeHelper -portInstance $portFilter.RemotePort -exportType $Strings.FirewallRuleRemotePort
}

function Get-FirewallPortRangeHelper {
    <#
    .SYNOPSIS
    Helper function that parses a string that represents a specific port
    .EXAMPLE
    Get-FirewallPortRangeHelper -portInstance "123"
    Get-FirewallPortRangeHelper -portInstance @("1-123", "123")
    .PARAMETER portInstance the port filter instance to retrieve ports from
    .PARAMETER exportType a string denoting the type of exporting being done for exception classification
    .OUTPUTS
    String
    #>
    Param(
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        $portInstance,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [String]
        $exportType
    )

    If ($null -eq $portInstance) {
        return $null
    }
    If ($portInstance -is [String]) {
        return Get-FirewallPortRangeMapping -port $portInstance -exportType $exportType
    }
    If ($portInstance -is [Array]) {
        $portArray = @()
        ForEach ($instance in $portInstance) {
            $portArray += Get-FirewallPortRangeMapping $instance -exportType $exportType
        }
        return $portArray
    }
    Throw [ExportFirewallRuleException]::new($($Strings.FirewallRulePortException -f $portInstance.GetType().FullName), `
            $exportType)
}

function Get-FirewallPortRangeMapping {
    <#
    .SYNOPSIS
    Helper function that maps the given string to a port range for Intune
    .EXAMPLE
    Get-FirewallPortRange -port "123-245"
    Get-FirewallPortRange -port @()
    Get-FirewallPortRange -port "123"
    .PARAMETER port the port number used to map for Intune
    .PARAMETER exportType a string denoting the type of exporting being done for exception classification
    .INPUTS
    String
    .OUTPUTS
    String
    #>
    Param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]
        $port,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [String]
        $exportType
    )

    If ($port -eq "") {
        return $null
    }
    # We interpret "Any" to be an empty array, with no restrictions on the ports
    If ($port -eq $Strings.Any) {
        return , @()
    }
    # Ports that match "xxx", where x is a digit, are acceptable
    If ($port -match "^\d+$") {
        return $port
    }
    # Ports that match a string containing "xxx-xxx", where x is a digit, are acceptable
    If ($port -match "^\d+-\d+$") {
        return $port
    }
    # There were a few strings such as 'RPC', 'RPC-EPM', 'Teredo', and 'IHTTPSIn', which are currently corner cases
    # Any other type of strings may also be encountered that may not be supported by Graph
    Throw [ExportFirewallRuleException]::new($($Strings.FirewallRulePortRangeException -f $port), $exportType)
}

function Get-FirewallLocalAddressRange {
    <#
    .SYNOPSIS
    Returns the local addresses for firewall objects
    .EXAMPLE
    Get-FirewallLocalAddressRange -firewallObject $firewallObject
    .PARAMETER firewallObject The firewall object.
    .INPUTS
    Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule
    .OUTPUTS
    String
    .LINK
    https://docs.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-windowsfirewallrule?view=graph-rest-beta
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $firewallObject
    )
    $addressFilter = Get-NetFirewallAddressFilterWrapper -AssociatedNetFirewallRule $firewallObject
    return Get-FirewallAddressRange -addressRange $addressFilter.LocalAddress
}

function Get-FirewallRemoteAddressRange {
    <#
    .SYNOPSIS
    Returns the remote addresses for firewall objects
    .EXAMPLE
    Get-FirewallRemoteAddressRange -firewallObject $firewallObject
    .PARAMETER firewallObject The firewall object.
    .INPUTS
    Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule
    .OUTPUTS
    String
    .LINK
    https://docs.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-windowsfirewallrule?view=graph-rest-beta
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $firewallObject
    )
    $addressFilter = Get-NetFirewallAddressFilterWrapper -AssociatedNetFirewallRule $firewallObject
    return Get-FirewallAddressRange -addressRange $addressFilter.RemoteAddress
}

function Get-FirewallAddressRange {
    <#
    .SYNOPSIS
    Returns a string that maps the provided string to an appropriate address range for Intune
    .EXAMPLE
    Get-AddressRangeHelper -addressRange "192.168.92.232"
    .PARAMETER addressRange the string that represents a range of addresses
    .OUTPUTS
    String
    .LINK
    https://docs.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-windowsfirewallrule?view=graph-rest-beta
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $addressRange
    )

    # We perform minimal checking for addresses because of the extensive validation done in the graph,
    # but this may be subject to later changes if errors are frequently encountered
    Switch ($addressRange) {
        $Strings.Any { return $null }
        "PlayToDevice" { Throw [ExportFirewallRuleException]::new($Strings.FirewallRuleAddressRangePlayToDeviceException, $Strings.FirewallRuleAddressRange) }
        default { return $addressRange }
    }
}

function Get-FirewallProfileType {
    <#
    .SYNOPSIS
    # Convert the profile types into a string for firewall rules
    .EXAMPLE
    Get-FirewallProfileType -profileTypes 0
    Get-FirewallProfileType -profileTypes 1
    Get-FirewallProfileType -profileTypes 4
    Get-FirewallProfileType -profileTypes 7
    .PARAMETER profileTypes the number that represents which profile type a firewall rule has
    .INPUTS
    Int16
    .OUTPUTS
    String
    .LINK
    https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/jj676843(v=vs.85)#properties
    https://docs.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-windowsfirewallrule?view=graph-rest-beta
    https://docs.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-windowsfirewallrulenetworkprofiletypes?view=graph-rest-beta
    #>
    Param(
        [Parameter(Mandatory = $true)]
        [uint16]
        $profileTypes
    )
    # The resulting profile types are a bitmap of values. We can represent
    # these combinations as strings for Intune
    Switch ($profileTypes) {
        # "Any" is interpreted as 0 according to the first link, but we can set the default
        # to be "All" by omitting any value in the attribute
        0 { return $null }
        1 { return "domain" }
        2 { return "private" }
        3 { return "domain, private" }
        4 { return "public" }
        5 { return "domain, public" }
        6 { return "private, public" }
        7 { return "domain, private, public" }
        default { Throw [ExportFirewallRuleException]::new($($Strings.FirewallRuleProfileTypeException -f $profileTypes), $Strings.FirewallRuleProfileType) }
    }
}

function Get-FirewallAction {
    <#
    .SYNOPSIS
    Helper function used to convert the action from a firewall object into a string for firewall rules
    .EXAMPLE
    Get-FirewallAction
    .PARAMETER action the number that represents which action a firewall object has
    .INPUTS
    Int16
    .OUTPUTS
    String
    .LINK
    https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/jj676843(v=vs.85)#properties
    #>
    Param(
        [Parameter(Mandatory = $true)]
        [uint16]
        $action
    )
    Switch ($action) {
        2 { return "allowed" }
        # The reference suggests that AllowByPass is a known and expected value, which is not supported by Intune
        3 { Throw [ExportFirewallRuleException]::new($Strings.FirewallRuleActionAllowBypassException, $Strings.FirewallRuleAction) }
        4 { return "blocked" }
        default { Throw [ExportFirewallRuleException]::new($($Strings.FirewallRuleActionException -f $action), $Strings.FirewallRuleAction) }
    }
}

function Get-FirewallDirection {
    <#
    .SYNOPSIS
    Helper function used to convert the direction from a firewall object into a string for firewall rules
    .EXAMPLE
    Get-FirewallDirection -direction 1
    Get-FirewallDirection -direction 2
    .PARAMETER direction The number that represents which direction a firewall rule has
    .INPUTS
    Int16
    .OUTPUTS
    String
    .LINK
    https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/jj676843(v=vs.85)#properties
    #>
    Param(
        [Parameter(Mandatory = $true)]
        [uint16]
        $direction
    )
    # The values found here are in the link provided
    Switch ($direction) {
        1 { return "in" }
        2 { return "out" }
        default { Throw [ExportFirewallRuleException]::new($($Strings.FirewallRuleDirectionException -f $direction), $Strings.FirewallRuleDirection) }
    }
}

function Get-FirewallLocalUserAuthorization {
    <#
    .SYNOPSIS
    # Retrieves the local user authorizations from the firewall object
    .EXAMPLE
    Get-FirewallLocalUserAuthorization -firewallObject $firewallObject
    .PARAMETER firewallObject The firewall object.
    .INPUTS
    Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule
    .OUTPUTS
    String
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $firewallObject
    )

    $securityFilter = Get-NetFirewallSecurityFilterWrapper -AssociatedNetFirewallRule $firewallObject
    Switch ($securityFilter.LocalUser) {
        $Strings.Any { return $null }
        default { return $securityFilter.LocalUser }
    }
}

function Get-FirewallInterfaceType {
    <#
    .SYNOPSIS
    Returns the interface type from a firewall object
    .EXAMPLE
    Get-FirewallInterfaceType -firewallObject $firewallObject
    .PARAMETER firewallObject The firewall object.
    .INPUTS
    Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule
    .OUTPUTS
    String
    .LINK
    http://wutils.com/wmi/root/standardcimv2/msft_netinterfacetypefilter/#interfacetype_properties
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $firewallObject
    )
    $interfaceType = Get-NetFirewallInterfaceTypeFilterWrapper -AssociatedNetFirewallRule $firewallObject
    Switch ($interfaceType.InterfaceType) {
        $Strings.Any { return $null }
        "LocalAccess" { return "lan" }
        "WirelessAccess" { return "wireless" }
        "RemoteAccess" { return "remoteAccess" }
        default {
            Throw [ExportFirewallRuleException]::new($Strings.FirewallRuleInterfaceTypeException -f $interfaceType.InterfaceType, `
                    $Strings.FirewallRuleInterfaceType)
        }
    }
}

function Get-FirewallEdgeTraversalPolicy {
    <#
    .SYNOPSIS
    Helper function used to convert the edge traversal policy
    .EXAMPLE
    Get-FirewallEdgeTraversalPolicy -firewallObject $firewallObject
    .PARAMETER firewallObject The firewall object.
    .INPUTS
    Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule
    .OUTPUTS
    String
    .LINK
    https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/jj676843(v=vs.85)#properties
    #>
    Param(
        [Parameter(Mandatory = $true)]
        $firewallObject
    )
    # The values found here are in the link provided
    $direction = Get-FirewallDirection $firewallObject.Direction
    # Edge traversal policies are only recognized by the Graph if they are inbound
    If ($direction -eq "in") {
        If ($firewallObject.EdgeTraversalPolicy -eq 0) {
            return "blocked"
        }
        If ($firewallObject.EdgeTraversalPolicy -eq 1) {
            return "allowed"
        }
    }
    ElseIf ($direction -eq "out" -and $firewallObject.EdgeTraversalPolicy -eq 0) {
        return $null
    }
    Throw [ExportFirewallRuleException]::new($($Strings.FirewallRuleEdgeTraversalException -f ($direction, $firewallObject.EdgeTraversalPolicy)), `
            $Strings.FirewallRuleEdgeTraversal)
}

# These wrapper functions are helpers that are designed to extract various filter objects
# The wrapper functions were created from the result of difficulties in testing the cmdlets with Pester
# These is currently no support for qualified functions or cmdlets, which causes mocking the function arguments difficult:
# https://github.com/pester/Pester/issues/308
# And using New-MockObject was not feasible as the type was consistently recognized as invalid
# You can determine this by running New-MockObject -Type Microsoft.Management.Infrastructure.CimInstance#root\StandardCimv2\MSFT_NetFirewallRule

function Get-NetFirewallAddressFilterWrapper {
    Param(
        [Parameter(Mandatory = $true)]
        $AssociatedNetFirewallRule
    )
    return Get-NetFirewallAddressFilter -AssociatedNetFirewallRule $AssociatedNetFirewallRule
}

function Get-NetFirewallApplicationFilterWrapper {
    Param(
        [Parameter(Mandatory = $true)]
        $AssociatedNetFirewallRule
    )
    return Get-NetFirewallApplicationFilter -AssociatedNetFirewallRule $AssociatedNetFirewallRule
}

function Get-NetFirewallInterfaceTypeFilterWrapper {
    Param(
        [Parameter(Mandatory = $true)]
        $AssociatedNetFirewallRule
    )
    return Get-NetFirewallInterfaceTypeFilter -AssociatedNetFirewallRule $AssociatedNetFirewallRule
}

function Get-NetFirewallPortFilterWrapper {
    Param(
        [Parameter(Mandatory = $true)]
        $AssociatedNetFirewallRule
    )
    return Get-NetFirewallPortFilter -AssociatedNetFirewallRule $AssociatedNetFirewallRule
}

function Get-NetFirewallSecurityFilterWrapper {
    Param(
        [Parameter(Mandatory = $true)]
        $AssociatedNetFirewallRule
    )
    return Get-NetFirewallSecurityFilter -AssociatedNetFirewallRule $AssociatedNetFirewallRule
}

function Get-NetFirewallServiceFilterWrapper {
    Param(
        [Parameter(Mandatory = $true)]
        $AssociatedNetFirewallRule
    )
    return Get-NetFirewallServiceFilter -AssociatedNetFirewallRule $AssociatedNetFirewallRule
}