$allous = Get-ADOrganizationalUnit -Filter *
$OUdeets = @()
$allous.foreach( {
    $OUdeets += [PSCustomObject]@{
        Name              = $PSItem.Name
        DistinguishedName = $PSItem.DistinguishedName
        LinkedGPOs        = $PSItem.LinkedGroupPolicyObjects
        GUID              = $PSItem.ObjectGUID
    }
})
$OUdeets | Export-Csv -Path .\ouexport.csv -NoTypeInformation