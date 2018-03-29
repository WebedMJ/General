# Configure WinRM HTTPS listener for PowerShell remoting over HTTPS
# Create CA cert
New-SelfSignedCertificate -KeyAlgorithm ECDSA_nistP384 -KeyExportPolicy NonExportable -NotAfter (Get-Date).AddYears(10) -Subject "CN=nuc01.ed.home" -Type SSLServerAuthentication -FriendlyName "NUC01 CA" -CertStoreLocation "cert:\LocalMachine\My" -CurveExport CurveName -KeyUsage DigitalSignature

# Create host cert for listener
$carootcert = (Get-ChildItem -Path Cert:\LocalMachine\Root\<THUMBPRINT_OF_CA_SIGNING_CERT>)
New-SelfSignedCertificate -KeyAlgorithm ECDSA_nistP384 -KeyExportPolicy NonExportable -NotAfter (Get-Date).AddYears(10) -Subject "CN=nuc01" -Type SSLServerAuthentication -DnsName "nuc01.ed.home","192.168.110.149" -FriendlyName "WinRM HTTPS Certificate" -CertStoreLocation "cert:\LocalMachine\My" -CurveExport CurveName -Signer $carootcert

# Create HTTPS listener
cmd /c 'winrm create winrm/config/listener?Address=*+Transport=HTTPS @{Hostname="hostname";CertificateThumbprint="8A00370A23F17D023A1472C98A0F7A0C00CD01A2"}'

# Export public cert to import on clients root store for trust
Export-Certificate -FilePath C:\Files\CARoot.cer -Cert $carootcert

# Create firewall rule
$port = 5986
New-NetFirewallRule -Name WINRM-HTTPS-In-TCP-ALL -DisplayName "Windows Remote Management (HTTPS-In)" -Description "Inbound rule for Windows Remote Management via WS-Management. [TCP 5986]" -Enabled True -Profile Any -Direction Inbound -Action Allow -Group "Windows Remote Management" -EdgeTraversalPolicy Block -Protocol TCP -LocalPort $port

# Connect over HTTPS
# import CARoot.cer into client root store
$psoptions = New-PSSessionOption -SkipRevocationCheck
$session1 = New-PSSession hostname -Credential $nucadmin -UseSSL -SessionOption $psoptions
Enter-PSSession -Session $session1 -SessionOption $psoptions