class ADObjectACL {
    [string]$DistinguishedName
    [string]$Name
    [guid]$Guid
    [string]$ObjectClass
    [System.Security.Principal.IdentityReference]$IdentityReference
    [System.DirectoryServices.ActiveDirectoryRights]$ActiveDirectoryRights
    [System.Security.AccessControl.AccessControlType]$AccessControlType
    [bool]$IsInherited
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]$InheritanceType
    [System.Security.AccessControl.InheritanceFlags]$InheritanceFlags
    [System.Security.AccessControl.PropagationFlags]$PropagationFlags
}
$aclreport = @()
$alladobjects = Get-ADObject -Filter *
Set-Location 'AD:'
$alladobjects.foreach( {
        $adobject = $PSItem
        $acls = (Get-Acl ($PSItem.DistinguishedName)).access
        foreach ($acl in $acls) {
            $adacl = New-Object ADObjectACL
            $adacl.DistinguishedName = $adobject.DistinguishedName
            $adacl.Name = $adobject.Name
            $adacl.Guid = $adobject.ObjectGUID
            $adacl.ObjectClass = $adobject.ObjectClass
            $adacl.IdentityReference = $acl.IdentityReference
            $adacl.ActiveDirectoryRights = $acl.ActiveDirectoryRights
            $adacl.AccessControlType = $acl.AccessControlType
            $adacl.IsInherited = $acl.IsInherited
            $adacl.InheritanceType = $acl.InheritanceType
            $adacl.InheritanceFlags = $acl.InheritanceFlags
            $adacl.PropagationFlags = $acl.PropagationFlags
            $aclreport += $adacl
        }
    })
