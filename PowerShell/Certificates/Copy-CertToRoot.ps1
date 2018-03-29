# Change $cert selection filter on line 9

$SourceStoreScope = 'LocalMachine'
$SourceStorename = 'My'

$SourceStore = New-Object  -TypeName System.Security.Cryptography.X509Certificates.X509Store  -ArgumentList $SourceStorename, $SourceStoreScope
$SourceStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly)

$cert = $SourceStore.Certificates | Where-Object  -FilterScript {
    $_.subject -like '*domain.com'
}

$DestStoreScope = 'LocalMachine'
$DestStoreName = 'root'

$DestStore = New-Object  -TypeName System.Security.Cryptography.X509Certificates.X509Store  -ArgumentList $DestStoreName, $DestStoreScope
$DestStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
$DestStore.Add($cert)

$SourceStore.Close()
$DestStore.Close()