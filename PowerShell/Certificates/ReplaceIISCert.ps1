$servername = 'server01'
$certfile = 'C:\certs\webcert.pfx'
$dollarcred = Get-Credential -Message "Enter server admin account"
$certpassword = Read-Host -Prompt "PFX Password" -AsSecureString
$newcertsplat = @{
    Password          = $certpassword
    CertStoreLocation = 'Cert:\LocalMachine\My'
    FilePath          = $certfile
}
$newcert = Import-PfxCertificate @newcertsplat
if ($null -ne $newcert.Thumbprint) {
    Remove-Item $($newcertsplat.FilePath) -Force
}
Remove-Item IIS:\SslBindings\0.0.0.0!443
Get-Item Cert:\LocalMachine\My\$($newcert.Thumbprint) | New-Item IIS:\SslBindings\0.0.0.0!443