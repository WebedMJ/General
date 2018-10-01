# See also Get-AllADPermissions.ps1
$CSVFilesPath = $env:temp
$dt = Get-Date -Format yyyMMddHHmmss
Import-Module ActiveDirectory -ErrorAction Stop
Set-Location ad:

$alladusers = Get-ADUser -Filter *
($alladusers.DistinguishedName).ForEach( {
        $ADObjectDN = $PSItem
        $acllist = (Get-Acl -Path $PSItem).Access
        $acls = @()
        $acllist.ForEach( {
                $acls += [PSCustomObject]@{
                    ADObjectDN            = $ADObjectDN
                    ActiveDirectoryRights = $PSItem.ActiveDirectoryRights
                    AccessControlType     = $PSItem.AccessControlType
                    IdentityReference     = $PSItem.IdentityReference
                    PropagationFlags      = $PSItem.PropagationFlags
                    IsInherited           = $PSItem.IsInherited
                    InheritanceFlags      = $PSItem.InheritanceFlags
                    InheritanceType       = $PSItem.InheritanceType
                }
            })
        $acls | Export-Csv -Path "$CSVFilesPath\aduserpermissions_$dt.csv" -Append -NoTypeInformation
    })

$alladcomputers = Get-ADComputer -Filter *
($alladcomputers.DistinguishedName).ForEach( {
        $ADObjectDN = $PSItem
        $acllist = (Get-Acl -Path $PSItem).Access
        $acls = @()
        $acllist.ForEach( {
                $acls += [PSCustomObject]@{
                    ADObjectDN            = $ADObjectDN
                    ActiveDirectoryRights = $PSItem.ActiveDirectoryRights
                    AccessControlType     = $PSItem.AccessControlType
                    IdentityReference     = $PSItem.IdentityReference
                    PropagationFlags      = $PSItem.PropagationFlags
                    IsInherited           = $PSItem.IsInherited
                    InheritanceFlags      = $PSItem.InheritanceFlags
                    InheritanceType       = $PSItem.InheritanceType
                }
            })
        $acls | Export-Csv -Path "$CSVFilesPath\adcomputerpermissions_$dt.csv" -Append -NoTypeInformation
    })

$alladOUs = Get-ADOrganizationalUnit -Filter *
($alladOUs.DistinguishedName).ForEach( {
        $ADObjectDN = $PSItem
        $acllist = (Get-Acl -Path $PSItem).Access
        $acls = @()
        $acllist.ForEach( {
                $acls += [PSCustomObject]@{
                    ADObjectDN            = $ADObjectDN
                    ActiveDirectoryRights = $PSItem.ActiveDirectoryRights
                    AccessControlType     = $PSItem.AccessControlType
                    IdentityReference     = $PSItem.IdentityReference
                    PropagationFlags      = $PSItem.PropagationFlags
                    IsInherited           = $PSItem.IsInherited
                    InheritanceFlags      = $PSItem.InheritanceFlags
                    InheritanceType       = $PSItem.InheritanceType
                }
            })
        $acls | Export-Csv -Path "$CSVFilesPath\adOUpermissions_$dt.csv" -Append -NoTypeInformation
    })