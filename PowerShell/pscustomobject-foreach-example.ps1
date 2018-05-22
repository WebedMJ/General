$a = foreach ($guest in $guests) {
    [pscustomobject]@{
        Name  = $guest.DisplayName
        AccountEnabled = $guest.AccountEnabled
        UserPrincipalName = $guest.UserPrincipalName
        Mail = $guest.Mail
        MailNickName = $guest.MailNickName
        OtherMails = ($guest.OtherMails) -join ";"
    }
}