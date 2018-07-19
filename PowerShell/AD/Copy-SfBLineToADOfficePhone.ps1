$adcred = Get-Credential
$mbusers = Get-ADUser -Filter {msRTCSIP-PrimaryUserAddress -like '*@domain.com'} -Properties 'msRTCSIP-Line' |
    Where-Object {$PSItem.'msRTCSIP-Line' -ne $null}
foreach ($mbuser in $mbusers) {
    $adnumber = (($mbuser.'msRTCSIP-Line').TrimStart('tel:')).Split(';')[0]
    Set-ADUser $mbuser -OfficePhone $adnumber -Credential $adcred
}