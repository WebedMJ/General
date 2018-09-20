$admincred = Get-Credential
$hvsourceserver = 'server.domain.com'
$hv1 = New-CimSession -ComputerName $hvsourceserver -Credential $admincred
$vmstofailover = Hyper-V\Get-VM -CimSession $hv1 | Where-Object {($PSItem.ReplicationMode -eq "Primary") -and ($PSItem.State -eq "Running")}
$vmstofailover.ForEach( {
        $vmname = $PSItem.Name
        $replicaserver = (Hyper-V\Get-VMReplication -VMName $vmname -CimSession $hv1).ReplicaServer
        if ($replicaserver) {
            if ($hv2.ComputerName -ne $replicaserver) {
                $hv2 = New-CimSession -ComputerName $replicaserver -Credential $admincred
            }
        } else {
            Write-Host "No replica server found!, aborting!"
            exit 1
        }
        Hyper-V\Stop-VM -Name $vmname -CimSession $hv1 -Force -ErrorAction Stop
        Hyper-V\Start-VMFailover -VMName $vmname -Prepare -CimSession $hv1 -Confirm:$false
        Hyper-V\Start-VMFailover -VMName $vmname -CimSession $hv2 -Confirm:$false
        Hyper-V\Set-VMReplication -Reverse -VMName $vmname -CimSession $hv2 -Confirm:$false
        Hyper-V\Start-VM -VMName $vmname -CimSession $hv2 -Confirm:$false
    })
Get-CimSession | Remove-CimSession
