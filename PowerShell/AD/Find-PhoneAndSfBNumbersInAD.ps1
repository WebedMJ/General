$alladusers = Get-ADUser -Filter * -Properties OfficePhone, 'msRTCSIP-Line'
$numbertransforms = Import-Csv -Path '.\numbertransforms.csv' # CSV Heading = Phone,SfB
$matchedusers = @()
$numbertransforms.foreach( {
        $Phone = $PSItem.Phone
        $SfB = $PSItem.SfB
        $phoneuser = $alladusers.where( {
                $_.OfficePhone -match $Phone
            })
        $sfbuser = $alladusers.where( {
                $_.'msRTCSIP-Line' -match $SfB
            })
        $matchedusers += [PSCustomObject]@{
            RequestedPhone       = $Phone
            RequestedSfB         = $SfB
            PhoneUserUPN         = $phoneuser.UserPrincipalName
            PhoneUserOfficePhone = $phoneuser.OfficePhone
            SfBUserUPN           = $sfbuser.UserPrincipalName
            SfBUsermsRTCSIPLine  = $sfbuser.'msRTCSIP-Line'
        }
    })
$matchedusers
$matchedusers | Export-Csv '.\numbertransformaccounts.csv' -NoTypeInformation | Invoke-Item