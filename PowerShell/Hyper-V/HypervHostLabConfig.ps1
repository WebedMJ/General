Set-VMHost -VirtualHardDiskPath C:\Hyper-V\VHDs -VirtualMachinePath C:\Hyper-V\VMs
New-VMSwitch -Name NUC01-vSW01 -AllowManagementOS $true -NetAdapterName (Get-NetAdapter).name
$natsw = New-VMSwitch -SwitchName "NUC01-LabvSW01" -SwitchType Internal
$natswname = $natsw.name
New-NetIPAddress -IPAddress "10.1.1.1" -PrefixLength 24 -InterfaceAlias "vEthernet ($natswname)"
New-NetNAT -Name labNAT01 -InternalIPInterfaceAddressPrefix "10.1.1.0/24"
New-VMResourcePool -Name "VHDs" -ResourcePoolType VHD -Paths C:\Hyper-V\VHDs
New-VMResourcePool -Name "LAN" -ResourcePoolType Ethernet
New-VMResourcePool -Name "LabNAT" -ResourcePoolType Ethernet
Install-Module DockerMsftProvider -Force
Install-Package Docker -ProviderName DockerMsftProvider -Force
# Worth restarting here...