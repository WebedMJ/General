Configuration uksouthVPNServer
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName NetworkingDsc
    Import-DsCResource -ModuleName CISBaselinesDsc
    Import-DscResource -ModuleName ComputerManagementDsc
    Import-DscResource -ModuleName CertificateDsc

    $InternalInterfaceAlias = 'Ethernet 2'
    $ExternalInterfaceAlias = 'Ethernet 3'
    $CustomRootCert1 = @'
xxxxxx
'@
    $CustomRootCert1Thumb = 'xxxx'
    $CustomIntCert1 = @'
xxxxxx
'@
    $CustomIntCert1Thumb = 'xxxx'
    Node AlwaysOnVPNServers
    {

        CISWindowsServer2019 AlwaysOnVPNServerCIS
        {
            SkipLogonAsService = $false
            AdminAccountStatus = 'Enabled'
            ServerCore         = $true
        }

        NetIPInterface EnableDhcpExternal {
            InterfaceAlias = $ExternalInterfaceAlias
            AddressFamily  = "IPv4"
            Dhcp           = "Enabled"
        }

        NetIPInterface EnableDhcpInternal {
            InterfaceAlias = $InternalInterfaceAlias
            AddressFamily  = "IPv4"
            Dhcp           = "Enabled"
            Forwarding     = "Enabled"
        }

        NetConnectionProfile SetExtNICPublic {
            InterfaceAlias  = $ExternalInterfaceAlias
            NetworkCategory = "Private"
        }

        NetConnectionProfile SetIntNICPrivate {
            InterfaceAlias  = $InternalInterfaceAlias
            NetworkCategory = "Private"
        }

        WindowsFeatureSet RemovedFeatures {
            Name   = @("PowerShell-V2", "FS-SMB1")
            Ensure = "Absent"
        }

        WindowsFeatureSet AddedFeatures {
            Name   = @("SNMP-Service", "SNMP-WMI-Provider", "DirectAccess-VPN", "RSAT-RemoteAccess-PowerShell")
            Ensure = "Present"
        }

        Registry 'Vulnerability mitigation: MSRC ADC190013 A' {
            ValueName = 'FeatureSettingsOverride'
            ValueType = 'Dword'
            Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management'
            ValueData = 72
            Ensure    = "Present"
        }

        Registry 'Vulnerability mitigation: MSRC ADC190013 B' {
            ValueName = 'FeatureSettingsOverrideMask'
            ValueType = 'Dword'
            Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management'
            ValueData = 3
            Ensure    = "Present"
        }

        Registry 'Vulnerability mitigation: FEATURE_ENABLE_PRINT_INFO_DISCLOSURE_FIX_1' {
            ValueName = 'iexplore.exe'
            ValueType = 'Dword'
            Key       = 'HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_ENABLE_PRINT_INFO_DISCLOSURE_FIX'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'Vulnerability mitigation: FEATURE_ENABLE_PRINT_INFO_DISCLOSURE_FIX_2' {
            ValueName = 'iexplore.exe'
            ValueType = 'Dword'
            Key       = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_ENABLE_PRINT_INFO_DISCLOSURE_FIX'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry SNMPPublicCommunity {
            Key       = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities'
            ValueName = 'ro_lmk_community'
            ValueType = 'Dword'
            ValueData = 4
            Ensure    = "Present"
        }

        Registry SNMPPermittedManagers1 {
            Key       = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers'
            ValueName = '1'
            ValueType = 'String'
            ValueData = 'localhost'
            Ensure    = "Present"
        }

        Registry SNMPPermittedManagers2 {
            Key       = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers'
            ValueName = '2'
            ValueType = 'String'
            ValueData = '10.128.4.38'
            Ensure    = "Present"
        }

        Registry 'ActiveHoursStart' {
            ValueName = 'ActiveHoursStart'
            ValueType = 'Dword'
            Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
            ValueData = 6
            Ensure    = "Present"
        }

        Registry 'ActiveHoursEnd' {
            ValueName = 'ActiveHoursEnd'
            ValueType = 'Dword'
            Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
            ValueData = 23
            Ensure    = "Present"
        }

        Registry 'SetActiveHours' {
            ValueName = 'SetActiveHours'
            ValueType = 'Dword'
            Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'dotNet2TlsWow64' {
            ValueName = 'SystemDefaultTlsVersions'
            ValueType = 'Dword'
            Key       = 'HKLM:\Software\WOW6432Node\Microsoft\.NETFramework\v2.0.50727'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'dotNet4TlsWow64' {
            ValueName = 'SystemDefaultTlsVersions'
            ValueType = 'Dword'
            Key       = 'HKLM:\Software\WOW6432Node\Microsoft\.NETFramework\v4.0.30319'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'dotNet2Tls' {
            ValueName = 'SystemDefaultTlsVersions'
            ValueType = 'Dword'
            Key       = 'HKLM:\Software\\Microsoft\.NETFramework\v2.0.50727'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'dotNet4Tl' {
            ValueName = 'SystemDefaultTlsVersions'
            ValueType = 'Dword'
            Key       = 'HKLM:\Software\\Microsoft\.NETFramework\v4.0.30319'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'dotNet2StrongCryptoWow64' {
            ValueName = 'SchUseStrongCrypto'
            ValueType = 'Dword'
            Key       = 'HKLM:\Software\WOW6432Node\Microsoft\.NETFramework\v2.0.50727'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'dotNet4StrongCryptoWow64' {
            ValueName = 'SchUseStrongCrypto'
            ValueType = 'Dword'
            Key       = 'HKLM:\Software\WOW6432Node\Microsoft\.NETFramework\v4.0.30319'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'dotNet2StrongCrypto' {
            ValueName = 'SchUseStrongCrypto'
            ValueType = 'Dword'
            Key       = 'HKLM:\Software\\Microsoft\.NETFramework\v2.0.50727'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'dotNet4StrongCrypto' {
            ValueName = 'SchUseStrongCrypto'
            ValueType = 'Dword'
            Key       = 'HKLM:\Software\\Microsoft\.NETFramework\v4.0.30319'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'DisableSSL2Client' {
            ValueName = 'Enabled'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client'
            ValueData = 0
            Ensure    = "Present"
        }

        Registry 'DisableSSL2Server' {
            ValueName = 'Enabled'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server'
            ValueData = 0
            Ensure    = "Present"
        }

        Registry 'DisableSSL3Client' {
            ValueName = 'Enabled'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client'
            ValueData = 0
            Ensure    = "Present"
        }

        Registry 'DisableSSL3Server' {
            ValueName = 'Enabled'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server'
            ValueData = 0
            Ensure    = "Present"
        }

        Registry 'DisableTLS1_0Client' {
            ValueName = 'Enabled'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client'
            ValueData = 0
            Ensure    = "Present"
        }

        Registry 'DisableTLS1_0Server' {
            ValueName = 'Enabled'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server'
            ValueData = 0
            Ensure    = "Present"
        }

        Registry 'DisableTLS1_1Client' {
            ValueName = 'Enabled'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client'
            ValueData = 0
            Ensure    = "Present"
        }

        Registry 'DisableTLS1_1Server' {
            ValueName = 'Enabled'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server'
            ValueData = 0
            Ensure    = "Present"
        }

        Registry 'EnableTLS1_2Client' {
            ValueName = 'Enabled'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'EnableTLS1_2Server' {
            ValueName = 'Enabled'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'IKEv2Fragmentation' {
            ValueName = 'EnableServerFragmentation'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Services\RemoteAccess\Parameters\Ikev2'
            ValueData = 1
            Ensure    = "Present"
        }

        Registry 'IKEEXT_limits' {
            ValueName = 'IkeNumEstablishedForInitialQuery'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Services\IKEEXT\Parameters'
            ValueData = 50000
            Ensure    = "Present"
        }

        Registry 'RRAS_CRLcheck' {
            ValueName = 'CertAuthFlags'
            ValueType = 'Dword'
            Key       = 'HKLM:\System\CurrentControlSet\Services\RemoteAccess\Parameters\Ikev2'
            ValueData = 4
            Ensure    = "Present"
        }

        Firewall SNMPTRAPInUDP {
            Name    = 'SNMPTRAP-In-UDP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall SNMPTRAPInUDPNoScope {
            Name    = 'SNMPTRAP-In-UDP-NoScope'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall DeliveryOptimizationTCPIn {
            Name    = 'DeliveryOptimization-TCP-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall DeliveryOptimizationUDPIn {
            Name    = 'DeliveryOptimization-UDP-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall EventForwarderInTCP {
            Name    = 'EventForwarder-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall EventForwarderRPCSSInTCP {
            Name    = 'EventForwarder-RPCSS-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall NETDISUPnPHostInTCP {
            Name    = 'NETDIS-UPnPHost-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall NETDISNB_NameInUDP {
            Name    = 'NETDIS-NB_Name-In-UDP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall NETDISNB_DatagramInUDP {
            Name    = 'NETDIS-NB_Datagram-In-UDP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall NETDISWSDEVNTSInTCP {
            Name    = 'NETDIS-WSDEVNTS-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall NETDISWSDEVNTInTCP {
            Name    = 'NETDIS-WSDEVNT-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall NETDISSSDPSrvInUDP {
            Name    = 'NETDIS-SSDPSrv-In-UDP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall NETDISFDPHOSTInUDP {
            Name    = 'NETDIS-FDPHOST-In-UDP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall NETDISLLMNRInUDP {
            Name    = 'NETDIS-LLMNR-In-UDP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall NETDISFDRESPUBWSDInUDP {
            Name    = 'NETDIS-FDRESPUB-WSD-In-UDP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall AllJoynRouterInTCP {
            Name    = 'AllJoyn-Router-In-TCP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall AllJoynRouterInUDP {
            Name    = 'AllJoyn-Router-In-UDP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall NetlogonNamedPipeIn {
            Name    = 'Netlogon-NamedPipe-In'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall NetlogonTCPRPCIn {
            Name    = 'Netlogon-TCP-RPC-In'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall WininitShutdownInRuleTCPRPC {
            Name    = 'Wininit-Shutdown-In-Rule-TCP-RPC'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall WininitShutdownInRuleTCPRPCEPMapper {
            Name    = 'Wininit-Shutdown-In-Rule-TCP-RPC-EPMapper'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall FPSSMBDiWARPInTCP {
            Name    = 'FPSSMBD-iWARP-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteTaskInTCP {
            Name    = 'RemoteTask-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteTaskRPCSSInTCP {
            Name    = 'RemoteTask-RPCSS-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall WINRMHTTPInTCP {
            Name    = 'WINRM-HTTP-In-TCP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall WINRMHTTPInTCPPUBLIC {
            Name    = 'WINRM-HTTP-In-TCP-PUBLIC'
            Enabled = 'False'
            Profile = ('Public')
            Ensure  = 'Present'
        }

        Firewall WINRMHTTPCompatInTCP {
            Name    = 'WINRM-HTTP-Compat-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MicrosoftWindowsPeerDistHttpTransIn {
            Name    = 'Microsoft-Windows-PeerDist-HttpTrans-In'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MicrosoftWindowsPeerDistWSDIn {
            Name    = 'Microsoft-Windows-PeerDist-WSD-In'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MicrosoftWindowsPeerDistHostedServerIn {
            Name    = 'Microsoft-Windows-PeerDist-HostedServer-In'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteDesktopUserModeInTCP {
            Name    = 'RemoteDesktop-UserMode-In-TCP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteDesktopUserModeInUDP {
            Name    = 'RemoteDesktop-UserMode-In-UDP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteDesktopShadowInTCP {
            Name    = 'RemoteDesktop-Shadow-In-TCP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteDesktopInTCPWS {
            Name    = 'RemoteDesktop-In-TCP-WS'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteDesktopInTCPWSS {
            Name    = 'RemoteDesktop-In-TCP-WSS'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RRASGREIn {
            Name    = 'RRAS-GRE-In'
            Enabled = 'False'
            Profile = ('Domain', 'Private', 'Public')
            Ensure  = 'Present'
        }

        Firewall RRASL2TPInUDP {
            Name    = 'RRAS-L2TP-In-UDP'
            Enabled = 'False'
            Profile = ('Domain', 'Private', 'Public')
            Ensure  = 'Present'
        }

        Firewall RRASPPTPInTCP {
            Name    = 'RRAS-PPTP-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private', 'Public')
            Ensure  = 'Present'
        }

        Firewall FPSNB_SessionInTCP {
            Name    = 'FPS-NB_Session-In-TCP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall FPSSMBInTCP {
            Name    = 'FPS-SMB-In-TCP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall FPSNB_NameInUDP {
            Name    = 'FPS-NB_Name-In-UDP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall FPSNB_DatagramInUDP {
            Name    = 'FPS-NB_Datagram-In-UDP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall FPSSpoolSvcInTCP {
            Name    = 'FPS-SpoolSvc-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall FPSRPCSSInTCP {
            Name    = 'FPS-RPCSS-In-TCP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall FPSICMP4ERQIn {
            Name    = 'FPS-ICMP4-ERQ-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall FPSICMP6ERQIn {
            Name    = 'FPS-ICMP6-ERQ-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall FPSLLMNRInUDP {
            Name    = 'FPS-LLMNR-In-UDP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RVMVDSInTCP {
            Name    = 'RVM-VDS-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RVMVDSLDRInTCP {
            Name    = 'RVM-VDSLDR-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RVMRPCSSInTCP {
            Name    = 'RVM-RPCSS-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MsiScsiInTCP {
            Name    = 'MsiScsi-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteEventLogSvcInTCP {
            Name    = 'RemoteEventLogSvc-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteEventLogSvcNPInTCP {
            Name    = 'RemoteEventLogSvc-NP-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteEventLogSvcRPCSSInTCP {
            Name    = 'RemoteEventLogSvc-RPCSS-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall SLBMMUXINTCP {
            Name    = 'SLBM-MUX-IN-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall SPPSVCInTCP {
            Name    = 'SPPSVC-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall TPMVSCMGRRPCSSInTCPNoScope {
            Name    = 'TPMVSCMGR-RPCSS-In-TCP-NoScope'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall TPMVSCMGRServerInTCPNoScope {
            Name    = 'TPMVSCMGR-Server-In-TCP-NoScope'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall TPMVSCMGRRPCSSInTCP {
            Name    = 'TPMVSCMGR-RPCSS-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall TPMVSCMGRServerInTCP {
            Name    = 'TPMVSCMGR-Server-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall PerfLogsAlertsPLASrvInTCP {
            Name    = 'PerfLogsAlerts-PLASrv-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall PerfLogsAlertsDCOMInTCP {
            Name    = 'PerfLogsAlerts-DCOM-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall PerfLogsAlertsPLASrvInTCPNoScope {
            Name    = 'PerfLogsAlerts-PLASrv-In-TCP-NoScope'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall PerfLogsAlertsDCOMInTCPNoScope {
            Name    = 'PerfLogsAlerts-DCOM-In-TCP-NoScope'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP6DUIn {
            Name    = 'CoreNet-ICMP6-DU-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP6PTBIn {
            Name    = 'CoreNet-ICMP6-PTB-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP6TEIn {
            Name    = 'CoreNet-ICMP6-TE-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP6PPIn {
            Name    = 'CoreNet-ICMP6-PP-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP6NDSIn {
            Name    = 'CoreNet-ICMP6-NDS-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP6NDAIn {
            Name    = 'CoreNet-ICMP6-NDA-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP6RAIn {
            Name    = 'CoreNet-ICMP6-RA-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP6RSIn {
            Name    = 'CoreNet-ICMP6-RS-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP6LQIn {
            Name    = 'CoreNet-ICMP6-LQ-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP6LRIn {
            Name    = 'CoreNet-ICMP6-LR-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP6LR2In {
            Name    = 'CoreNet-ICMP6-LR2-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP6LDIn {
            Name    = 'CoreNet-ICMP6-LD-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetICMP4DUFRAGIn {
            Name    = 'CoreNet-ICMP4-DUFRAG-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetIGMPIn {
            Name    = 'CoreNet-IGMP-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetDHCPIn {
            Name    = 'CoreNet-DHCP-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private', 'Public')
            Ensure  = 'Present'
        }

        Firewall CoreNetDHCPV6In {
            Name    = 'CoreNet-DHCPV6-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private', 'Public')
            Ensure  = 'Present'
        }

        Firewall CoreNetTeredoIn {
            Name    = 'CoreNet-Teredo-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetIPHTTPSIn {
            Name    = 'CoreNet-IPHTTPS-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall CoreNetIPv6In {
            Name    = 'CoreNet-IPv6-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MSDTCInTCP {
            Name    = 'MSDTC-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MSDTCKTMRMInTCP {
            Name    = 'MSDTC-KTMRM-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MSDTCRPCSSInTCP {
            Name    = 'MSDTC-RPCSS-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteSvcAdminInTCP {
            Name    = 'RemoteSvcAdmin-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteSvcAdminNPInTCP {
            Name    = 'RemoteSvcAdmin-NP-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteSvcAdminRPCSSInTCP {
            Name    = 'RemoteSvcAdmin-RPCSS-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MDNSInUDPPrivateActive {
            Name    = 'MDNS-In-UDP-Private-Active'
            Enabled = 'True'
            Profile = ('Private')
            Ensure  = 'Present'
        }

        Firewall MDNSInUDPDomainActive {
            Name    = 'MDNS-In-UDP-Domain-Active'
            Enabled = 'True'
            Profile = ('Domain')
            Ensure  = 'Present'
        }

        Firewall MDNSInUDPPublicActive {
            Name    = 'MDNS-In-UDP-Public-Active'
            Enabled = 'False'
            Profile = ('Public')
            Ensure  = 'Present'
        }

        Firewall RemoteFwAdminInTCP {
            Name    = 'RemoteFwAdmin-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RemoteFwAdminRPCSSInTCP {
            Name    = 'RemoteFwAdmin-RPCSS-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall WMIRPCSSInTCP {
            Name    = 'WMI-RPCSS-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall WMIWINMGMTInTCP {
            Name    = 'WMI-WINMGMT-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall WMIASYNCInTCP {
            Name    = 'WMI-ASYNC-In-TCP'
            Enabled = 'False'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall SNMPInUDP {
            Name    = 'SNMP-In-UDP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall SNMPInUDPNoScope {
            Name    = 'SNMP-In-UDP-NoScope'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall RQSInTCP {
            Name    = 'RQS-In-TCP'
            Enabled = 'True'
            Profile = ('Domain', 'Private', 'Public')
            Ensure  = 'Present'
        }

        Firewall IISWebServerRoleHTTPInTCP {
            Name    = 'IIS-WebServerRole-HTTP-In-TCP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall IISWebServerRoleHTTPSInTCP {
            Name    = 'IIS-WebServerRole-HTTPS-In-TCP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall SSTPINTCP {
            Name    = 'SSTP-IN-TCP'
            Enabled = 'True'
            Profile = ('Domain', 'Private', 'Public')
            Ensure  = 'Present'
        }

        Firewall DHCPv4RelayClientInUDP {
            Name    = 'DHCPv4-Relay-Client-In-UDP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MicrosoftWindowsRemoteAccessNPIn {
            Name    = 'Microsoft-Windows-RemoteAccess-NP-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MicrosoftWindowsRemoteAccessWMIIn {
            Name    = 'Microsoft-Windows-RemoteAccess-WMI-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MicrosoftWindowsRemoteAccessDCOMIn {
            Name    = 'Microsoft-Windows-RemoteAccess-DCOM-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MicrosoftWindowsRemoteAccessRemRrasRPCIn {
            Name    = 'Microsoft-Windows-RemoteAccess-RemRras-RPC-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MicrosoftWindowsRemoteAccessServicesRPCIn {
            Name    = 'Microsoft-Windows-RemoteAccess-Services-RPC-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall MicrosoftWindowsRemoteAccessIasHostRPCIn {
            Name    = 'Microsoft-Windows-RemoteAccess-IasHost-RPC-In'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall DHCPv6RelayServerInUDP {
            Name    = 'DHCPv6-Relay-Server-In-UDP'
            Enabled = 'True'
            Profile = ('Domain', 'Private')
            Ensure  = 'Present'
        }

        Firewall IKEVPNINTCP {
            Name        = 'IKE-VPN-IN-TCP'
            DisplayName = 'IKEv2 VPN Traffic Inbound'
            Action      = 'Allow'
            Enabled     = 'True'
            Profile     = ('Domain', 'Private', 'Public')
            Direction   = 'InBound'
            LocalPort   = ('500', '4500')
            Protocol    = 'UDP'
            Ensure      = 'Present'
        }

        Service 'SNMP' {
            Name        = 'SNMP'
            StartupType = 'Automatic'
            State       = 'Running'
            DependsOn   = '[WindowsFeatureSet]AddedFeatures'
        }

        Service 'RemoteAccess' {
            Name        = 'RemoteAccess'
            StartupType = 'Automatic'
            State       = 'Running'
            DependsOn   = '[WindowsFeatureSet]AddedFeatures'
        }

        Service 'IKEEXT' {
            Name        = 'IKEEXT'
            StartupType = 'Automatic'
            State       = 'Running'
            DependsOn   = '[WindowsFeatureSet]AddedFeatures'
        }

        Service 'IaasVmProvider' {
            Name        = 'IaasVmProvider'
            StartupType = 'Automatic'
            State       = 'Running'
        }

        SmbServerConfiguration SmbServer {
            IsSingleInstance = 'Yes'
            EncryptData      = $true
        }

        Route AzFirewallRoute {
            AddressFamily     = 'IPv4'
            InterfaceAlias    = $ExternalInterfaceAlias
            DestinationPrefix = '10.128.1.0/26'
            NextHop           = '10.128.4.177'
            RouteMetric       = 1
            DependsOn         = '[NetIPInterface]EnableDhcpExternal'
            Ensure            = 'Present'
        }

        Route InternalRoute01 {
            AddressFamily     = 'IPv4'
            InterfaceAlias    = $InternalInterfaceAlias
            DestinationPrefix = '10.0.0.0/8'
            NextHop           = '10.128.4.161'
            RouteMetric       = 5000
            DependsOn         = '[NetIPInterface]EnableDhcpInternal'
            Ensure            = 'Present'
        }

        Route InternalRoute02 {
            AddressFamily     = 'IPv4'
            InterfaceAlias    = $InternalInterfaceAlias
            DestinationPrefix = '172.16.0.0/12'
            NextHop           = '10.128.4.161'
            RouteMetric       = 5000
            DependsOn         = '[NetIPInterface]EnableDhcpInternal'
            Ensure            = 'Present'
        }

        Route InternalRoute03 {
            AddressFamily     = 'IPv4'
            InterfaceAlias    = $InternalInterfaceAlias
            DestinationPrefix = '192.168.0.0/16'
            NextHop           = '10.128.4.161'
            RouteMetric       = 5000
            DependsOn         = '[NetIPInterface]EnableDhcpInternal'
            Ensure            = 'Present'
        }

        Script InstallVPNServer {
            GetScript  = { @{Result = (Get-RemoteAccess).VpnStatus -ne 'Uninstalled' } }
            SetScript  = { Install-RemoteAccess -VpnType 'Vpn' -IPAddressRange '10.128.8.1', '10.128.15.254' }
            TestScript = { [bool]((Get-RemoteAccess).VpnStatus -ne 'Uninstalled') }
            DependsOn  = '[WindowsFeatureSet]AddedFeatures'
        }

        Script SetVPNCertificate {
            # Certificate needs to be pre-installed by the Key Vault VM extension
            GetScript  = {
                $certs = Get-ChildItem -Path Cert:\LocalMachine\My |
                Where-Object { ($PSItem.Subject -eq 'CN=vpn.webedmj.rocks') -and ($PSItem.NotAfter -gt $(Get-Date)) }
                if ($certs) {
                    @{
                        LatestCertificate       = ($certs | Sort-Object NotAfter -Descending)[0].Thumbprint
                        RemoteAccessCertificate = (Get-RemoteAccess).SslCertificate.Thumbprint
                    }
                } else {
                    @{
                        LatestCertificate       = 'None'
                        RemoteAccessCertificate = (Get-RemoteAccess).SslCertificate.Thumbprint
                    }
                }
            }
            SetScript  = {
                $certs = Get-ChildItem -Path Cert:\LocalMachine\My |
                Where-Object { ($PSItem.Subject -eq 'CN=vpn.webedmj.rocks') -and ($PSItem.NotAfter -gt $(Get-Date)) }
                if ($certs) {
                    ($certs | Sort-Object NotAfter -Descending)[0] | Set-RemoteAccess
                } else {
                    throw 'No valid certs available'
                }
            }
            TestScript = {
                $RemoteAccessCertificate = (Get-RemoteAccess).SslCertificate
                [bool]$RemoteAccessCertificateValid = $(Get-Date) -lt $RemoteAccessCertificate.NotAfter
                $certs = Get-ChildItem -Path Cert:\LocalMachine\My |
                Where-Object { ($PSItem.Subject -eq 'CN=vpn.webedmj.rocks') -and ($PSItem.NotAfter -gt $(Get-Date)) }
                if ($certs) {
                    [bool]$AvailableCerts = $true
                    [bool]$CertsMatch = ($certs | Sort-Object NotAfter -Descending)[0].Thumbprint -eq $RemoteAccessCertificate.Thumbprint
                } else {
                    [bool]$AvailableCerts = $false
                }
                [bool]($AvailableCerts -and $RemoteAccessCertificateValid -and $CertsMatch)
            }
            DependsOn  = '[Script]InstallVPNServer', '[CertificateImport]CustomRoot1', '[CertificateImport]CustomInt1', '[CertificateImport]CustomInt2'
        }

        Script SetVPNRootCert {
            GetScript  = {
                $Auth = Get-VpnAuthProtocol
                $RootCACerts = Get-ChildItem -Path cert:\LocalMachine\root |
                Where-Object { ($PSItem.Subject -Like "CN=Corp First Issuing CA*") -and ($PSItem.NotAfter -gt $(Get-Date)) }
                $vpnCerts = Get-ChildItem -Path Cert:\LocalMachine\My |
                Where-Object { ($PSItem.Subject -eq 'CN=vpn.webedmj.rocks') -and ($PSItem.NotAfter -gt $(Get-Date)) }
                if ($RootCACerts) {
                    [bool]$rootCertsMatch = ($RootCACerts | Sort-Object NotAfter -Descending)[0].Thumbprint -eq $Auth.RootCertificateNameToAccept.Thumbprint
                } else {
                    [bool]$rootCertsMatch = $false
                }
                if ($vpnCerts) {
                    [bool]$vpnCertsMatch = ($vpnCerts | Sort-Object NotAfter -Descending)[0].Thumbprint -eq $Auth.CertificateAdvertised.Thumbprint
                } else {
                    [bool]$vpnCertsMatch = $false
                }
                $AuthProtocolMatch = [bool]($Auth.UserAuthProtocolAccepted -eq 'Certificate')
                $CertSkusValid = [bool]($Auth.CertificateEKUsToAccept -eq '1.3.6.1.5.5.7.3.2')
                @{
                    rootCertsMatch    = $rootCertsMatch
                    vpnCertsMatch     = $vpnCertsMatch
                    AuthProtocolMatch = $AuthProtocolMatch
                    CertSkusValid     = $CertSkusValid
                }
            }
            SetScript  = {
                $RootCACerts = Get-ChildItem -Path cert:\LocalMachine\root |
                Where-Object { ($PSItem.Subject -Like "CN=Corp First Issuing CA*") -and ($PSItem.NotAfter -gt $(Get-Date)) }
                $vpnCerts = Get-ChildItem -Path Cert:\LocalMachine\My |
                Where-Object { ($PSItem.Subject -eq 'CN=vpn.webedmj.rocks') -and ($PSItem.NotAfter -gt $(Get-Date)) }
                if ($RootCACerts) {
                    $AuthCert = ($RootCACerts | Sort-Object NotAfter -Descending)[0]
                    $vpnCert = ($vpnCerts | Sort-Object NotAfter -Descending)[0]
                    $params = @{
                        UserAuthProtocolAccepted    = 'Certificate'
                        RootCertificateNameToAccept = $AuthCert
                        CertificateEKUsToAccept     = '1.3.6.1.5.5.7.3.2'
                        CertificateAdvertised       = $vpnCert
                    }
                    Set-VpnAuthProtocol @params
                } else {
                    throw 'No matching root certificates available'
                }
            }
            TestScript = {
                $Auth = Get-VpnAuthProtocol
                $RootCACerts = Get-ChildItem -Path cert:\LocalMachine\root |
                Where-Object { ($PSItem.Subject -Like "CN=Corp First Issuing CA*") -and ($PSItem.NotAfter -gt $(Get-Date)) }
                $vpnCerts = Get-ChildItem -Path Cert:\LocalMachine\My |
                Where-Object { ($PSItem.Subject -eq 'CN=vpn.webedmj.rocks') -and ($PSItem.NotAfter -gt $(Get-Date)) }
                if ($RootCACerts) {
                    [bool]$rootCertsMatch = ($RootCACerts | Sort-Object NotAfter -Descending)[0].Thumbprint -eq $Auth.RootCertificateNameToAccept.Thumbprint
                } else {
                    [bool]$rootCertsMatch = $false
                }
                if ($vpnCerts) {
                    [bool]$vpnCertsMatch = ($vpnCerts | Sort-Object NotAfter -Descending)[0].Thumbprint -eq $Auth.CertificateAdvertised.Thumbprint
                } else {
                    [bool]$vpnCertsMatch = $false
                }
                $AuthProtocolMatch = [bool]($Auth.UserAuthProtocolAccepted -eq 'Certificate')
                $CertSkusValid = [bool]($Auth.CertificateEKUsToAccept -eq '1.3.6.1.5.5.7.3.2')
                [bool]($rootCertsMatch -and $vpnCertsMatch -and $AuthProtocolMatch -and $CertSkusValid)
            }
            DependsOn  = '[Script]SetVPNCertificate', '[CertificateImport]CustomRoot1', '[CertificateImport]CustomInt1', '[CertificateImport]CustomInt2'
        }

        Script EnableCAPI2Log {
            GetScript  = {
                @{CAPI2LogEnabled = (Get-WinEvent -ListLog Microsoft-Windows-CAPI2/Operational).IsEnabled }
            }
            SetScript  = {
                $capi2log = Get-WinEvent -ListLog Microsoft-Windows-CAPI2/Operational
                $capi2log.IsEnabled = $true
                $capi2log.SaveChanges()
            }
            TestScript = {
                (Get-WinEvent -ListLog Microsoft-Windows-CAPI2/Operational).IsEnabled
            }
            DependsOn  = '[WindowsFeatureSet]AddedFeatures'
        }

        Script SetVPNConfig {
            GetScript  = {
                $vpnServerConfig = Get-VpnServerConfiguration
                @{
                    Ikev2Ports                          = [bool](1500 -eq $vpnServerConfig.Ikev2Ports)
                    SstpPorts                           = [bool](0 -eq $vpnServerConfig.SstpPorts)
                    L2tpPorts                           = [bool](0 -eq $vpnServerConfig.L2tpPorts)
                    GrePorts                            = [bool](0 -eq $vpnServerConfig.GrePorts)
                    IdleDisconnectSeconds               = [bool](300 -eq $vpnServerConfig.IdleDisconnect)
                    CustomPolicy                        = [bool]($true -eq $vpnServerConfig.CustomPolicy)
                    EncryptionMethod                    = [bool]('AES256' -eq $vpnServerConfig.EncryptionMethod)
                    IntegrityCheckMethod                = [bool]('SHA256' -eq $vpnServerConfig.IntegrityCheckMethod)
                    DHGroup                             = [bool]('Group24' -eq $vpnServerConfig.DHGroup)
                    CipherTransformConstants            = [bool]('GCMAES256' -eq $vpnServerConfig.CipherTransformConstants)
                    AuthenticationTransformConstants    = [bool]('GCMAES256' -eq $vpnServerConfig.AuthenticationTransformConstants)
                    PfsGroup                            = [bool]('PFS24' -eq $vpnServerConfig.PfsGroup)
                    TunnelType                          = [bool]('IKEV2' -eq $vpnServerConfig.TunnelType)
                    SALifeTimeSeconds                   = [bool](28800 -eq $vpnServerConfig.SALifeTime)
                    MMSALifeTimeSeconds                 = [bool](86400 -eq $vpnServerConfig.MMSALifeTime)
                    SADataSizeForRenegotiationKilobytes = [bool](1024000 -eq $vpnServerConfig.SADataSizeForRenegotiation)
                }
            }
            SetScript  = {
                $param = @{
                    Ikev2Ports                          = 1500
                    SstpPorts                           = 0
                    L2tpPorts                           = 0
                    GrePorts                            = 0
                    IdleDisconnectSeconds               = 300
                    CustomPolicy                        = $true
                    EncryptionMethod                    = 'AES256'
                    IntegrityCheckMethod                = 'SHA256'
                    DHGroup                             = 'Group24'
                    CipherTransformConstants            = 'GCMAES256'
                    AuthenticationTransformConstants    = 'GCMAES256'
                    PfsGroup                            = 'PFS24'
                    TunnelType                          = 'IKEV2'
                    SALifeTimeSeconds                   = 28800
                    MMSALifeTimeSeconds                 = 86400
                    SADataSizeForRenegotiationKilobytes = 1024000
                }
                Set-VpnServerConfiguration @param
            }
            TestScript = {
                $vpnServerConfig = Get-VpnServerConfiguration
                [bool]([bool](1500 -eq $vpnServerConfig.Ikev2Ports) -and
                    [bool](0 -eq $vpnServerConfig.SstpPorts) -and
                    [bool](0 -eq $vpnServerConfig.L2tpPorts) -and
                    [bool](0 -eq $vpnServerConfig.GrePorts) -and
                    [bool](300 -eq $vpnServerConfig.IdleDisconnect) -and
                    [bool]($true -eq $vpnServerConfig.CustomPolicy) -and
                    [bool]('AES256' -eq $vpnServerConfig.EncryptionMethod) -and
                    [bool]('SHA256' -eq $vpnServerConfig.IntegrityCheckMethod) -and
                    [bool]('Group24' -eq $vpnServerConfig.DHGroup) -and
                    [bool]('GCMAES256' -eq $vpnServerConfig.CipherTransformConstants) -and
                    [bool]('GCMAES256' -eq $vpnServerConfig.AuthenticationTransformConstants) -and
                    [bool]('PFS24' -eq $vpnServerConfig.PfsGroup) -and
                    [bool]('IKEV2' -eq $vpnServerConfig.TunnelType) -and
                    [bool](28800 -eq $vpnServerConfig.SALifeTime) -and
                    [bool](86400 -eq $vpnServerConfig.MMSALifeTime) -and
                    [bool](1024000 -eq $vpnServerConfig.SADataSizeForRenegotiation))
            }
            DependsOn  = '[Script]SetVPNRootCert'
        }

        Script EnableInboxAccounting {
            GetScript  = { @{InboxAccountingStatus = [bool]((Get-RemoteAccessAccounting).InboxAccountingStatus -eq 'Enabled') } }
            SetScript  = { Set-RemoteAccessAccounting -EnableAccountingType:Inbox }
            TestScript = { [bool]((Get-RemoteAccessAccounting).InboxAccountingStatus -eq 'Enabled') }
            DependsOn  = '[Script]InstallVPNServer'
        }

        CertificateImport CustomRoot1 {
            Thumbprint = $CustomRootCert1Thumb
            Location   = 'LocalMachine'
            Store      = 'Root'
            Content    = $CustomRootCert1
        }

        CertificateImport CustomInt1 {
            Thumbprint = $CustomIntCert1Thumb
            Location   = 'LocalMachine'
            Store      = 'Root'
            Content    = $CustomIntCert1
        }

        CertificateImport CustomInt2 {
            Thumbprint = $CustomIntCert1Thumb
            Location   = 'LocalMachine'
            Store      = 'CA'
            Content    = $CustomIntCert1
        }

    }
}