Set-VMHost -VirtualHardDiskPath C:\Hyper-V\VHDs -VirtualMachinePath C:\Hyper-V\VMs
New-VMSwitch -Name NUC01-vSW01 -AllowManagementOS $true -NetAdapterName (Get-NetAdapter).name
New-VMSwitch -SwitchName "NUC01-LabvSW01" -SwitchType Internal
# Get the MAC Address of the VM Adapter bound to the virtual switch
$MacAddress = (Get-VMNetworkAdapter -ManagementOS -SwitchName NUC01-LabvSW01).MacAddress
# Use the MAC Address of the Virtual Adapter to look up the Adapter in the Net Adapter list
$Adapter = Get-NetAdapter | Where-Object {(($_.MacAddress -replace '-','') -eq $MacAddress)}
New-NetIPAddress -IPAddress "10.1.1.1" -PrefixLength 24 -InterfaceIndex $Adapter.ifIndex
New-NetNAT -Name labNAT01 -InternalIPInterfaceAddressPrefix "10.1.1.0/24"
New-VMResourcePool -Name "VHDs" -ResourcePoolType VHD -Paths C:\Hyper-V\VHDs
New-VMResourcePool -Name "LAN" -ResourcePoolType Ethernet
New-VMResourcePool -Name "LabNAT" -ResourcePoolType Ethernet