$servername = 'server01'
$certfile = 'C:\certs\webcert.pfx'
$dollarcred = Get-Credential -Message "Enter server admin account"
$z2mediaweb01 = New-PSSession $servername -Credential $dollarcred
Invoke-Command -ComputerName $servername -Credential $dollarcred -ScriptBlock {
    New-Item C:\Files -Type Directory -ErrorAction SilentlyContinue
}
Copy-Item $certfile 'C:\Files\landmark.pfx' -Force -ToSession $z2mediaweb01
Invoke-Command -ComputerName $servername -Credential $dollarcred -ScriptBlock {
    $certpassword = Read-Host -Prompt "PFX Password" -AsSecureString
    $newcertsplat = @{
        Password          = $certpassword
        CertStoreLocation = 'Cert:\LocalMachine\My'
        FilePath          = 'C:\certs\webcert.pfx'
    }
    $newcert = Import-PfxCertificate @newcertsplat
    if ($null -ne $newcert.Thumbprint) {
        Remove-Item $($newcertsplat.FilePath) -Force
    }
    Get-Item Cert:\LocalMachine\My\$($newcert.Thumbprint) | Set-Item IIS:\SslBindings\0.0.0.0!443
}