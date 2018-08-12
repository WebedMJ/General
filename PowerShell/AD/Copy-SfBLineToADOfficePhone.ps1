$adcred = Get-Credential
$users = Get-ADUser -Filter {msRTCSIP-PrimaryUserAddress -like '*@domain.com'} -Properties 'msRTCSIP-Line' |
    Where-Object {$PSItem.'msRTCSIP-Line' -ne $null}
foreach ($user in $users) {
    $adnumber = (($user.'msRTCSIP-Line').TrimStart('tel:')).Split(';')[0]
    Set-ADUser $user -OfficePhone $adnumber -Credential $adcred
}