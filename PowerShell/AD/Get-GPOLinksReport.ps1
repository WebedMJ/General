[xml]$gporeport = Get-GPOReport -All -ReportType Xml
$gpolinks = ($gporeport.gpos.gpo).foreach( {
        [PSCustomObject]@{
            Name    = $PSItem.Name
            LinksTo = $PSItem.LinksTo.SOMPath
        }
    })
$gpolinks

# Remove unlinked GPOs...
# $gpolinks.Where( {!$PSItem.LinksTo}) # Misses site linked GPOs!
# $gpostoremove = $gpolinks.Where( {(!$PSItem.LinksTo) -and ($PSItem.Name -ne 'SomeGPOLinkedToASite')})
# $gpostoremove.Name.ForEach( {Get-GPO -Name $PSItem | Remove-GPO})
