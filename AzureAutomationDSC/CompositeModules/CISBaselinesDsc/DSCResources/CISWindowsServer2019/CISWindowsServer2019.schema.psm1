Configuration CISWindowsServer2019
{
     param
     (
          # Specifiy whether to skip "Logon as a service" user right setting
          [Parameter(Mandatory)]
          [bool] $SkipLogonAsService = $false,
          [Parameter(Mandatory)]
          [ValidateNotNullOrEmpty()]
          [ValidateSet('Enabled', 'Disabled')]
          [string] $AdminAccountStatus = 'Enabled',
          [Parameter(Mandatory)]
          [bool] $ServerCore = $true
     )

     Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
     Import-DSCResource -ModuleName 'AuditPolicyDSC'
     Import-DSCResource -ModuleName 'SecurityPolicyDSC'

     Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\CredUI\EnumerateAdministrators' {
          ValueName = 'EnumerateAdministrators'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\CredUI'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWebServices' {
          ValueName = 'NoWebServices'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoAutorun' {
          ValueName = 'NoAutorun'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveTypeAutoRun' {
          ValueName = 'NoDriveTypeAutoRun'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
          ValueData = 255

     }

     Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\PreXPSP2ShellProtocolBehavior' {
          ValueName = 'PreXPSP2ShellProtocolBehavior'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\MSAOptional' {
          ValueName = 'MSAOptional'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableAutomaticRestartSignOn' {
          ValueName = 'DisableAutomaticRestartSignOn'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\LocalAccountTokenFilterPolicy' {
          ValueName = 'LocalAccountTokenFilterPolicy'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 0

     }

     Registry 'DEL_\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableBkGndGroupPolicy' {
          ValueName = 'DisableBkGndGroupPolicy'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = ''
          Ensure    = 'Absent'

     }

     Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Audit\ProcessCreationIncludeCmdLine_Enabled' {
          ValueName = 'ProcessCreationIncludeCmdLine_Enabled'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Audit'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters\AllowEncryptionOracle' {
          ValueName = 'AllowEncryptionOracle'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon' {
          ValueName = 'AutoAdminLogon'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
          ValueData = '0'

     }

     Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\ScreenSaverGracePeriod' {
          ValueName = 'ScreenSaverGracePeriod'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
          ValueData = '0'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Biometrics\FacialFeatures\EnhancedAntiSpoofing' {
          ValueName = 'EnhancedAntiSpoofing'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Biometrics\FacialFeatures'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\InputPersonalization\AllowInputPersonalization' {
          ValueName = 'AllowInputPersonalization'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\InputPersonalization'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Internet Explorer\Feeds\DisableEnclosureDownload' {
          ValueName = 'DisableEnclosureDownload'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Feeds'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\MicrosoftAccount\DisableUserAuth' {
          ValueName = 'DisableUserAuth'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\MicrosoftAccount'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51\DCSettingIndex' {
          ValueName = 'DCSettingIndex'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51\ACSettingIndex' {
          ValueName = 'ACSettingIndex'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\CloudContent\DisableWindowsConsumerFeatures' {
          ValueName = 'DisableWindowsConsumerFeatures'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Connect\RequirePinForPairing' {
          ValueName = 'RequirePinForPairing'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Connect'
          ValueData = 2

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\CredentialsDelegation\AllowProtectedCreds' {
          ValueName = 'AllowProtectedCreds'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\CredentialsDelegation'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\CredUI\DisablePasswordReveal' {
          ValueName = 'DisablePasswordReveal'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\CredUI'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\DataCollection\AllowTelemetry' {
          ValueName = 'AllowTelemetry'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\DataCollection\DoNotShowFeedbackNotifications' {
          ValueName = 'DoNotShowFeedbackNotifications'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application\Retention' {
          ValueName = 'Retention'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application'
          ValueData = '0'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application\MaxSize' {
          ValueName = 'MaxSize'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application'
          ValueData = 32768

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security\Retention' {
          ValueName = 'Retention'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security'
          ValueData = '0'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security\MaxSize' {
          ValueName = 'MaxSize'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security'
          ValueData = 196608

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\Setup\Retention' {
          ValueName = 'Retention'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Setup'
          ValueData = '0'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\Setup\MaxSize' {
          ValueName = 'MaxSize'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Setup'
          ValueData = 32768

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\System\Retention' {
          ValueName = 'Retention'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\System'
          ValueData = '0'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\System\MaxSize' {
          ValueName = 'MaxSize'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\System'
          ValueData = 32768

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Explorer\NoAutoplayfornonVolume' {
          ValueName = 'NoAutoplayfornonVolume'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Explorer'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Explorer\NoDataExecutionPrevention' {
          ValueName = 'NoDataExecutionPrevention'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Explorer'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Explorer\NoHeapTerminationOnCorruption' {
          ValueName = 'NoHeapTerminationOnCorruption'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Explorer'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}\NoBackgroundPolicy' {
          ValueName = 'NoBackgroundPolicy'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}\NoGPOListChanges' {
          ValueName = 'NoGPOListChanges'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Installer\EnableUserControl' {
          ValueName = 'EnableUserControl'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Installer'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Installer\AlwaysInstallElevated' {
          ValueName = 'AlwaysInstallElevated'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Installer'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Kernel DMA Protection\DeviceEnumerationPolicy' {
          ValueName = 'DeviceEnumerationPolicy'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Kernel DMA Protection'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\LanmanWorkstation\AllowInsecureGuestAuth' {
          ValueName = 'AllowInsecureGuestAuth'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\LanmanWorkstation'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Network Connections\NC_AllowNetBridge_NLA' {
          ValueName = 'NC_AllowNetBridge_NLA'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Network Connections'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Network Connections\NC_ShowSharedAccessUI' {
          ValueName = 'NC_ShowSharedAccessUI'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Network Connections'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Network Connections\NC_StdDomainUserSetLocation' {
          ValueName = 'NC_StdDomainUserSetLocation'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Network Connections'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths\\*\NETLOGON' {
          ValueName = '\\*\NETLOGON'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths'
          ValueData = 'RequireMutualAuthentication=1, RequireIntegrity=1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths\\*\SYSVOL' {
          ValueName = '\\*\SYSVOL'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths'
          ValueData = 'RequireMutualAuthentication=1, RequireIntegrity=1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\OneDrive\DisableFileSyncNGSC' {
          ValueName = 'DisableFileSyncNGSC'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\OneDrive'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Personalization\NoLockScreenCamera' {
          ValueName = 'NoLockScreenCamera'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Personalization'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Personalization\NoLockScreenSlideshow' {
          ValueName = 'NoLockScreenSlideshow'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Personalization'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging\EnableScriptBlockLogging' {
          ValueName = 'EnableScriptBlockLogging'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
          ValueData = 0

     }

     Registry 'DEL_\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging\EnableScriptBlockInvocationLogging' {
          ValueName = 'EnableScriptBlockInvocationLogging'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
          ValueData = ''
          Ensure    = 'Absent'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription\EnableTranscripting' {
          ValueName = 'EnableTranscripting'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription'
          ValueData = 0

     }

     Registry 'DEL_\Software\Policies\Microsoft\Windows\PowerShell\Transcription\OutputDirectory' {
          ValueName = 'OutputDirectory'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription'
          ValueData = ''
          Ensure    = 'Absent'

     }

     Registry 'DEL_\Software\Policies\Microsoft\Windows\PowerShell\Transcription\EnableInvocationHeader' {
          ValueName = 'EnableInvocationHeader'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription'
          ValueData = ''
          Ensure    = 'Absent'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\PreviewBuilds\EnableConfigFlighting' {
          ValueName = 'EnableConfigFlighting'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\PreviewBuilds'
          ValueData = 0

     }

     Registry 'DEL_\Software\Policies\Microsoft\Windows\PreviewBuilds\EnableExperimentation' {
          ValueName = 'EnableExperimentation'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\PreviewBuilds'
          ValueData = ''
          Ensure    = 'Absent'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\PreviewBuilds\AllowBuildPreview' {
          ValueName = 'AllowBuildPreview'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\PreviewBuilds'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\EnableCdp' {
          ValueName = 'EnableCdp'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\AllowDomainPINLogon' {
          ValueName = 'AllowDomainPINLogon'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\BlockDomainPicturePassword' {
          ValueName = 'BlockDomainPicturePassword'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\BlockUserFromShowingAccountDetailsOnSignin' {
          ValueName = 'BlockUserFromShowingAccountDetailsOnSignin'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\DisableLockScreenAppNotifications' {
          ValueName = 'DisableLockScreenAppNotifications'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\DontDisplayNetworkSelectionUI' {
          ValueName = 'DontDisplayNetworkSelectionUI'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\DontEnumerateConnectedUsers' {
          ValueName = 'DontEnumerateConnectedUsers'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\EnumerateLocalUsers' {
          ValueName = 'EnumerateLocalUsers'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WcmSvc\GroupPolicy\fMinimizeConnections' {
          ValueName = 'fMinimizeConnections'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WcmSvc\GroupPolicy'
          ValueData = 3

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Windows Search\AllowIndexingEncryptedStoresOrItems' {
          ValueName = 'AllowIndexingEncryptedStoresOrItems'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\ManagePreviewBuilds' {
          ValueName = 'ManagePreviewBuilds'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\ManagePreviewBuildsPolicyValue' {
          ValueName = 'ManagePreviewBuildsPolicyValue'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client\AllowBasic' {
          ValueName = 'AllowBasic'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client\AllowUnencryptedTraffic' {
          ValueName = 'AllowUnencryptedTraffic'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client\AllowDigest' {
          ValueName = 'AllowDigest'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service\AllowBasic' {
          ValueName = 'AllowBasic'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service\AllowUnencryptedTraffic' {
          ValueName = 'AllowUnencryptedTraffic'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service\DisableRunAs' {
          ValueName = 'DisableRunAs'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\DisableAntiSpyware' {
          ValueName = 'DisableAntiSpyware'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\PUAProtection' {
          ValueName = 'PUAProtection'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\EnableSmartScreen' {
          ValueName = 'EnableSmartScreen'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Real-Time Protection\DisableBehaviorMonitoring' {
          ValueName = 'DisableBehaviorMonitoring'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Real-Time Protection'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Scan\DisableRemovableDriveScanning' {
          ValueName = 'DisableRemovableDriveScanning'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Scan'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Scan\DisableEmailScanning' {
          ValueName = 'DisableEmailScanning'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Scan'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet\LocalSettingOverrideSpynetReporting' {
          ValueName = 'LocalSettingOverrideSpynetReporting'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\ExploitGuard_ASR_Rules' {
          ValueName = 'ExploitGuard_ASR_Rules'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules\75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84' {
          ValueName = '75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
          ValueData = '1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules\3b576869-a4ec-4529-8536-b80a7769e899' {
          ValueName = '3b576869-a4ec-4529-8536-b80a7769e899'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
          ValueData = '1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules\d4f940ab-401b-4efc-aadc-ad5f3c50688a' {
          ValueName = 'd4f940ab-401b-4efc-aadc-ad5f3c50688a'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
          ValueData = '1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules\92e97fa1-2edf-4476-bdd6-9dd0b4dddc7b' {
          ValueName = '92e97fa1-2edf-4476-bdd6-9dd0b4dddc7b'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
          ValueData = '1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules\5beb7efe-fd9a-4556-801d-275e5ffc04cc' {
          ValueName = '5beb7efe-fd9a-4556-801d-275e5ffc04cc'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
          ValueData = '1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules\d3e037e1-3eb8-44c8-a917-57927947596d' {
          ValueName = 'd3e037e1-3eb8-44c8-a917-57927947596d'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
          ValueData = '1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules\be9ba2d9-53ea-4cdc-84e5-9b1eeee46550' {
          ValueName = 'be9ba2d9-53ea-4cdc-84e5-9b1eeee46550'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
          ValueData = '1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules\26190899-1602-49e8-8b27-eb1d0a1ce869' {
          ValueName = '26190899-1602-49e8-8b27-eb1d0a1ce869'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
          ValueData = '1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules\7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c' {
          ValueName = '7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
          ValueData = '1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules\9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2' {
          ValueName = '9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
          ValueData = '1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules\b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4' {
          ValueName = 'b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
          ValueData = '1'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection\EnableNetworkProtection' {
          ValueName = 'EnableNetworkProtection'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender Security Center\App and Browser protection\DisallowExploitProtectionOverride' {
          ValueName = 'DisallowExploitProtectionOverride'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender Security Center\App and Browser protection'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient\EnableMulticast' {
          ValueName = 'EnableMulticast'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Printers\DisableWebPnPDownload' {
          ValueName = 'DisableWebPnPDownload'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Rpc\EnableAuthEpResolution' {
          ValueName = 'EnableAuthEpResolution'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Rpc'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\fAllowUnsolicited' {
          ValueName = 'fAllowUnsolicited'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = 0

     }

     Registry 'DEL_\Software\Policies\Microsoft\Windows NT\Terminal Services\fAllowUnsolicitedFullControl' {
          ValueName = 'fAllowUnsolicitedFullControl'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = ''
          Ensure    = 'Absent'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\fAllowToGetHelp' {
          ValueName = 'fAllowToGetHelp'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = 0

     }

     Registry 'DEL_\Software\Policies\Microsoft\Windows NT\Terminal Services\fAllowFullControl' {
          ValueName = 'fAllowFullControl'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = ''
          Ensure    = 'Absent'

     }

     Registry 'DEL_\Software\Policies\Microsoft\Windows NT\Terminal Services\MaxTicketExpiry' {
          ValueName = 'MaxTicketExpiry'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = ''
          Ensure    = 'Absent'

     }

     Registry 'DEL_\Software\Policies\Microsoft\Windows NT\Terminal Services\MaxTicketExpiryUnits' {
          ValueName = 'MaxTicketExpiryUnits'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = ''
          Ensure    = 'Absent'

     }

     Registry 'DEL_\Software\Policies\Microsoft\Windows NT\Terminal Services\fUseMailto' {
          ValueName = 'fUseMailto'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = ''
          Ensure    = 'Absent'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\DisablePasswordSaving' {
          ValueName = 'DisablePasswordSaving'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\fDisableCdm' {
          ValueName = 'fDisableCdm'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\fEncryptRPCTraffic' {
          ValueName = 'fEncryptRPCTraffic'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\MinEncryptionLevel' {
          ValueName = 'MinEncryptionLevel'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = 3

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\DeleteTempDirsOnExit' {
          ValueName = 'DeleteTempDirsOnExit'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\PerSessionTempDir' {
          ValueName = 'PerSessionTempDir'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\UserAuthentication' {
          ValueName = 'UserAuthentication'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\SecurityLayer' {
          ValueName = 'SecurityLayer'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
          ValueData = 2

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\EnableFirewall' {
          ValueName = 'EnableFirewall'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\DefaultOutboundAction' {
          ValueName = 'DefaultOutboundAction'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\DefaultInboundAction' {
          ValueName = 'DefaultInboundAction'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\DisableNotifications' {
          ValueName = 'DisableNotifications'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\AllowLocalPolicyMerge' {
          ValueName = 'AllowLocalPolicyMerge'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\AllowLocalIPsecPolicyMerge' {
          ValueName = 'AllowLocalIPsecPolicyMerge'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging\LogFilePath' {
          ValueName = 'LogFilePath'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging'
          ValueData = '%systemroot%\system32\logfiles\firewall\domainfw.log'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging\LogFileSize' {
          ValueName = 'LogFileSize'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging'
          ValueData = 16384

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging\LogDroppedPackets' {
          ValueName = 'LogDroppedPackets'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging\LogSuccessfulConnections' {
          ValueName = 'LogSuccessfulConnections'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\DisableNotifications' {
          ValueName = 'DisableNotifications'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\EnableFirewall' {
          ValueName = 'EnableFirewall'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\DefaultOutboundAction' {
          ValueName = 'DefaultOutboundAction'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\DefaultInboundAction' {
          ValueName = 'DefaultInboundAction'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\AllowLocalPolicyMerge' {
          ValueName = 'AllowLocalPolicyMerge'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\AllowLocalIPsecPolicyMerge' {
          ValueName = 'AllowLocalIPsecPolicyMerge'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging\LogFilePath' {
          ValueName = 'LogFilePath'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
          ValueData = '%systemroot%\system32\logfiles\firewall\privatefw.log'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging\LogFileSize' {
          ValueName = 'LogFileSize'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
          ValueData = 16384

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging\LogDroppedPackets' {
          ValueName = 'LogDroppedPackets'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging\LogSuccessfulConnections' {
          ValueName = 'LogSuccessfulConnections'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\DisableNotifications' {
          ValueName = 'DisableNotifications'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\AllowLocalPolicyMerge' {
          ValueName = 'AllowLocalPolicyMerge'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\AllowLocalIPsecPolicyMerge' {
          ValueName = 'AllowLocalIPsecPolicyMerge'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\EnableFirewall' {
          ValueName = 'EnableFirewall'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\DefaultOutboundAction' {
          ValueName = 'DefaultOutboundAction'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\DefaultInboundAction' {
          ValueName = 'DefaultInboundAction'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging\LogFilePath' {
          ValueName = 'LogFilePath'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging'
          ValueData = '%systemroot%\system32\logfiles\firewall\publicfw.log'

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging\LogFileSize' {
          ValueName = 'LogFileSize'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging'
          ValueData = 16384

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging\LogDroppedPackets' {
          ValueName = 'LogDroppedPackets'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging\LogSuccessfulConnections' {
          ValueName = 'LogSuccessfulConnections'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsInkWorkspace\AllowWindowsInkWorkspace' {
          ValueName = 'AllowWindowsInkWorkspace'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\WindowsInkWorkspace'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\System\CurrentControlSet\Control\SecurityProviders\WDigest\UseLogonCredential' {
          ValueName = 'UseLogonCredential'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\SecurityProviders\WDigest'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\System\CurrentControlSet\Control\Session Manager\SafeDllSearchMode' {
          ValueName = 'SafeDllSearchMode'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Session Manager'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\System\CurrentControlSet\Control\Session Manager\kernel\DisableExceptionChainValidation' {
          ValueName = 'DisableExceptionChainValidation'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Session Manager\kernel'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\System\CurrentControlSet\Policies\EarlyLaunch\DriverLoadPolicy' {
          ValueName = 'DriverLoadPolicy'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Policies\EarlyLaunch'
          ValueData = 3

     }

     Registry 'Registry(POL): HKLM:\System\CurrentControlSet\Services\Eventlog\Security\WarningLevel' {
          ValueName = 'WarningLevel'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\Eventlog\Security'
          ValueData = 90

     }

     Registry 'Registry(POL): HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters\SMB1' {
          ValueName = 'SMB1'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\System\CurrentControlSet\Services\MrxSmb10\Start' {
          ValueName = 'Start'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\MrxSmb10'
          ValueData = 4

     }

     Registry 'Registry(POL): HKLM:\System\CurrentControlSet\Services\Netbt\Parameters\NoNameReleaseOnDemand' {
          ValueName = 'NoNameReleaseOnDemand'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\Netbt\Parameters'
          ValueData = 1

     }

     Registry 'Registry(POL): HKLM:\System\CurrentControlSet\Services\Netbt\Parameters\NodeType' {
          ValueName = 'NodeType'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\Netbt\Parameters'
          ValueData = 2

     }

     Registry 'Registry(POL): HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters\DisableIPSourceRouting' {
          ValueName = 'DisableIPSourceRouting'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters'
          ValueData = 2

     }

     Registry 'Registry(POL): HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters\EnableICMPRedirect' {
          ValueName = 'EnableICMPRedirect'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters'
          ValueData = 0

     }

     Registry 'Registry(POL): HKLM:\System\CurrentControlSet\Services\Tcpip6\Parameters\DisableIPSourceRouting' {
          ValueName = 'DisableIPSourceRouting'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\Tcpip6\Parameters'
          ValueData = 2

     }

     AuditPolicySubcategory 'IPsec Driver (Success) - Inclusion' {
          Name      = 'IPsec Driver'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'IPsec Driver (Failure) - Inclusion' {
          Name      = 'IPsec Driver'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'System Integrity (Success) - Inclusion' {
          Name      = 'System Integrity'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'System Integrity (Failure) - Inclusion' {
          Name      = 'System Integrity'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Security System Extension (Success) - Inclusion' {
          Name      = 'Security System Extension'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Security System Extension (Failure) - Inclusion' {
          Name      = 'Security System Extension'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Security State Change (Success) - Inclusion' {
          Name      = 'Security State Change'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Security State Change (Failure) - Inclusion' {
          Name      = 'Security State Change'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Other System Events (Success) - Inclusion' {
          Name      = 'Other System Events'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Other System Events (Failure) - Inclusion' {
          Name      = 'Other System Events'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Group Membership (Success) - Inclusion' {
          Name      = 'Group Membership'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Group Membership (Failure) - Inclusion' {
          Name      = 'Group Membership'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'User / Device Claims (Success) - Inclusion' {
          Name      = 'User / Device Claims'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'User / Device Claims (Failure) - Inclusion' {
          Name      = 'User / Device Claims'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Network Policy Server (Success) - Inclusion' {
          Name      = 'Network Policy Server'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Network Policy Server (Failure) - Inclusion' {
          Name      = 'Network Policy Server'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Other Logon/Logoff Events (Success) - Inclusion' {
          Name      = 'Other Logon/Logoff Events'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Other Logon/Logoff Events (Failure) - Inclusion' {
          Name      = 'Other Logon/Logoff Events'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Special Logon (Success) - Inclusion' {
          Name      = 'Special Logon'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Special Logon (Failure) - Inclusion' {
          Name      = 'Special Logon'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'IPsec Extended Mode (Success) - Inclusion' {
          Name      = 'IPsec Extended Mode'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'IPsec Extended Mode (Failure) - Inclusion' {
          Name      = 'IPsec Extended Mode'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'IPsec Quick Mode (Success) - Inclusion' {
          Name      = 'IPsec Quick Mode'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'IPsec Quick Mode (Failure) - Inclusion' {
          Name      = 'IPsec Quick Mode'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'IPsec Main Mode (Success) - Inclusion' {
          Name      = 'IPsec Main Mode'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'IPsec Main Mode (Failure) - Inclusion' {
          Name      = 'IPsec Main Mode'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Account Lockout (Success) - Inclusion' {
          Name      = 'Account Lockout'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Account Lockout (Failure) - Inclusion' {
          Name      = 'Account Lockout'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Logoff (Success) - Inclusion' {
          Name      = 'Logoff'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Logoff (Failure) - Inclusion' {
          Name      = 'Logoff'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Logon (Success) - Inclusion' {
          Name      = 'Logon'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Logon (Failure) - Inclusion' {
          Name      = 'Logon'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Handle Manipulation (Success) - Inclusion' {
          Name      = 'Handle Manipulation'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Handle Manipulation (Failure) - Inclusion' {
          Name      = 'Handle Manipulation'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Central Policy Staging (Success) - Inclusion' {
          Name      = 'Central Policy Staging'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Central Policy Staging (Failure) - Inclusion' {
          Name      = 'Central Policy Staging'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Removable Storage (Success) - Inclusion' {
          Name      = 'Removable Storage'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Removable Storage (Failure) - Inclusion' {
          Name      = 'Removable Storage'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Detailed File Share (Failure) - Inclusion' {
          Name      = 'Detailed File Share'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Detailed File Share (Success) - Inclusion' {
          Name      = 'Detailed File Share'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Other Object Access Events (Success) - Inclusion' {
          Name      = 'Other Object Access Events'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Other Object Access Events (Failure) - Inclusion' {
          Name      = 'Other Object Access Events'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Filtering Platform Connection (Success) - Inclusion' {
          Name      = 'Filtering Platform Connection'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Filtering Platform Connection (Failure) - Inclusion' {
          Name      = 'Filtering Platform Connection'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Filtering Platform Packet Drop (Success) - Inclusion' {
          Name      = 'Filtering Platform Packet Drop'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Filtering Platform Packet Drop (Failure) - Inclusion' {
          Name      = 'Filtering Platform Packet Drop'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'File Share (Success) - Inclusion' {
          Name      = 'File Share'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'File Share (Failure) - Inclusion' {
          Name      = 'File Share'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Application Generated (Success) - Inclusion' {
          Name      = 'Application Generated'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Application Generated (Failure) - Inclusion' {
          Name      = 'Application Generated'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Certification Services (Success) - Inclusion' {
          Name      = 'Certification Services'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Certification Services (Failure) - Inclusion' {
          Name      = 'Certification Services'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'SAM (Success) - Inclusion' {
          Name      = 'SAM'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'SAM (Failure) - Inclusion' {
          Name      = 'SAM'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Kernel Object (Success) - Inclusion' {
          Name      = 'Kernel Object'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Kernel Object (Failure) - Inclusion' {
          Name      = 'Kernel Object'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Registry (Success) - Inclusion' {
          Name      = 'Registry'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Registry (Failure) - Inclusion' {
          Name      = 'Registry'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'File System (Success) - Inclusion' {
          Name      = 'File System'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'File System (Failure) - Inclusion' {
          Name      = 'File System'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Other Privilege Use Events (Success) - Inclusion' {
          Name      = 'Other Privilege Use Events'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Other Privilege Use Events (Failure) - Inclusion' {
          Name      = 'Other Privilege Use Events'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Non Sensitive Privilege Use (Success) - Inclusion' {
          Name      = 'Non Sensitive Privilege Use'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Non Sensitive Privilege Use (Failure) - Inclusion' {
          Name      = 'Non Sensitive Privilege Use'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Sensitive Privilege Use (Success) - Inclusion' {
          Name      = 'Sensitive Privilege Use'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Sensitive Privilege Use (Failure) - Inclusion' {
          Name      = 'Sensitive Privilege Use'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'RPC Events (Success) - Inclusion' {
          Name      = 'RPC Events'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'RPC Events (Failure) - Inclusion' {
          Name      = 'RPC Events'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Process Creation (Success) - Inclusion' {
          Name      = 'Process Creation'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Process Creation (Failure) - Inclusion' {
          Name      = 'Process Creation'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Process Termination (Success) - Inclusion' {
          Name      = 'Process Termination'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Process Termination (Failure) - Inclusion' {
          Name      = 'Process Termination'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Plug and Play Events (Success) - Inclusion' {
          Name      = 'Plug and Play Events'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Plug and Play Events (Failure) - Inclusion' {
          Name      = 'Plug and Play Events'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'DPAPI Activity (Success) - Inclusion' {
          Name      = 'DPAPI Activity'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'DPAPI Activity (Failure) - Inclusion' {
          Name      = 'DPAPI Activity'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Other Policy Change Events (Failure) - Inclusion' {
          Name      = 'Other Policy Change Events'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Other Policy Change Events (Success) - Inclusion' {
          Name      = 'Other Policy Change Events'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Authentication Policy Change (Success) - Inclusion' {
          Name      = 'Authentication Policy Change'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Authentication Policy Change (Failure) - Inclusion' {
          Name      = 'Authentication Policy Change'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Audit Policy Change (Success) - Inclusion' {
          Name      = 'Audit Policy Change'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Audit Policy Change (Failure) - Inclusion' {
          Name      = 'Audit Policy Change'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Filtering Platform Policy Change (Success) - Inclusion' {
          Name      = 'Filtering Platform Policy Change'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Filtering Platform Policy Change (Failure) - Inclusion' {
          Name      = 'Filtering Platform Policy Change'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Authorization Policy Change (Success) - Inclusion' {
          Name      = 'Authorization Policy Change'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Authorization Policy Change (Failure) - Inclusion' {
          Name      = 'Authorization Policy Change'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'MPSSVC Rule-Level Policy Change (Success) - Inclusion' {
          Name      = 'MPSSVC Rule-Level Policy Change'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'MPSSVC Rule-Level Policy Change (Failure) - Inclusion' {
          Name      = 'MPSSVC Rule-Level Policy Change'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Other Account Management Events (Success) - Inclusion' {
          Name      = 'Other Account Management Events'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Other Account Management Events (Failure) - Inclusion' {
          Name      = 'Other Account Management Events'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Application Group Management (Success) - Inclusion' {
          Name      = 'Application Group Management'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Application Group Management (Failure) - Inclusion' {
          Name      = 'Application Group Management'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Distribution Group Management (Success) - Inclusion' {
          Name      = 'Distribution Group Management'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Distribution Group Management (Failure) - Inclusion' {
          Name      = 'Distribution Group Management'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Security Group Management (Success) - Inclusion' {
          Name      = 'Security Group Management'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Security Group Management (Failure) - Inclusion' {
          Name      = 'Security Group Management'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Computer Account Management (Success) - Inclusion' {
          Name      = 'Computer Account Management'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Computer Account Management (Failure) - Inclusion' {
          Name      = 'Computer Account Management'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'User Account Management (Success) - Inclusion' {
          Name      = 'User Account Management'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'User Account Management (Failure) - Inclusion' {
          Name      = 'User Account Management'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Directory Service Replication (Success) - Inclusion' {
          Name      = 'Directory Service Replication'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Directory Service Replication (Failure) - Inclusion' {
          Name      = 'Directory Service Replication'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Directory Service Access (Success) - Inclusion' {
          Name      = 'Directory Service Access'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Directory Service Access (Failure) - Inclusion' {
          Name      = 'Directory Service Access'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Detailed Directory Service Replication (Success) - Inclusion' {
          Name      = 'Detailed Directory Service Replication'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Detailed Directory Service Replication (Failure) - Inclusion' {
          Name      = 'Detailed Directory Service Replication'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Directory Service Changes (Success) - Inclusion' {
          Name      = 'Directory Service Changes'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Directory Service Changes (Failure) - Inclusion' {
          Name      = 'Directory Service Changes'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Other Account Logon Events (Success) - Inclusion' {
          Name      = 'Other Account Logon Events'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Other Account Logon Events (Failure) - Inclusion' {
          Name      = 'Other Account Logon Events'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Kerberos Service Ticket Operations (Success) - Inclusion' {
          Name      = 'Kerberos Service Ticket Operations'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Kerberos Service Ticket Operations (Failure) - Inclusion' {
          Name      = 'Kerberos Service Ticket Operations'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Credential Validation (Success) - Inclusion' {
          Name      = 'Credential Validation'
          Ensure    = 'Present'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Credential Validation (Failure) - Inclusion' {
          Name      = 'Credential Validation'
          Ensure    = 'Present'
          AuditFlag = 'Failure'

     }

     AuditPolicySubcategory 'Kerberos Authentication Service (Success) - Inclusion' {
          Name      = 'Kerberos Authentication Service'
          Ensure    = 'Absent'
          AuditFlag = 'Success'

     }

     AuditPolicySubcategory 'Kerberos Authentication Service (Failure) - Inclusion' {
          Name      = 'Kerberos Authentication Service'
          Ensure    = 'Absent'
          AuditFlag = 'Failure'

     }

     AuditPolicyOption 'AuditPolicyOption: CrashOnAuditFail' {
          Value = 'Disabled'
          Name  = 'CrashOnAuditFail'

     }

     AuditPolicyOption 'AuditPolicyOption: FullPrivilegeAuditing' {
          Value = 'Disabled'
          Name  = 'FullPrivilegeAuditing'

     }

     AuditPolicyOption 'AuditPolicyOption: AuditBaseObjects' {
          Value = 'Disabled'
          Name  = 'AuditBaseObjects'

     }

     AuditPolicyOption 'AuditPolicyOption: AuditBaseDirectories' {
          Value = 'Disabled'
          Name  = 'AuditBaseDirectories'

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\ScRemoveOption' {
          ValueName = 'ScRemoveOption'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
          ValueData = '1'

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\SCENoApplyLegacyAuditPolicy' {
          ValueName = 'SCENoApplyLegacyAuditPolicy'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters\EnableSecuritySignature' {
          ValueName = 'EnableSecuritySignature'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\InactivityTimeoutSecs' {
          ValueName = 'InactivityTimeoutSecs'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 600

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\RequireSecuritySignature' {
          ValueName = 'RequireSecuritySignature'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Session Manager\ProtectionMode' {
          ValueName = 'ProtectionMode'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Session Manager'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\NoConnectedUser' {
          ValueName = 'NoConnectedUser'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 3

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableUIADesktopToggle' {
          ValueName = 'EnableUIADesktopToggle'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters\RequireStrongKey' {
          ValueName = 'RequireStrongKey'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
          ValueData = 1

     }

     # Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeCaption' {
     #      ValueName = 'LegalNoticeCaption'
     #      ValueType = 'String'
     #      Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
     #      ValueData = 'My Corp'

     # }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA' {
          ValueName = 'EnableLUA'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\PromptOnSecureDesktop' {
          ValueName = 'PromptOnSecureDesktop'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters\SmbServerNameHardeningLevel' {
          ValueName = 'SmbServerNameHardeningLevel'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Session Manager\Memory Management\ClearPageFileAtShutdown' {
          ValueName = 'ClearPageFileAtShutdown'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Memory Management'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0\NTLMMinClientSec' {
          ValueName = 'NTLMMinClientSec'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
          ValueData = 537395200

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters\NullSessionShares' {
          ValueName = 'NullSessionShares'
          ValueType = 'MultiString'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
          ValueData = @('')

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters\SignSecureChannel' {
          ValueName = 'SignSecureChannel'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\CrashOnAuditFail' {
          ValueName = 'CrashOnAuditFail'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\FilterAdministratorToken' {
          ValueName = 'FilterAdministratorToken'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\EveryoneIncludesAnonymous' {
          ValueName = 'EveryoneIncludesAnonymous'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\ScForceOption' {
          ValueName = 'ScForceOption'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorAdmin' {
          ValueName = 'ConsentPromptBehaviorAdmin'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 2

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\UseMachineId' {
          ValueName = 'UseMachineId'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\ShutdownWithoutLogon' {
          ValueName = 'ShutdownWithoutLogon'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Session Manager\SubSystems\optional' {
          ValueName = 'optional'
          ValueType = 'MultiString'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Session Manager\SubSystems'
          ValueData = @('')

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters\RequireSecuritySignature' {
          ValueName = 'RequireSecuritySignature'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters\RestrictNullSessAccess' {
          ValueName = 'RestrictNullSessAccess'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\EnableSecuritySignature' {
          ValueName = 'EnableSecuritySignature'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters\NullSessionPipes' {
          ValueName = 'NullSessionPipes'
          ValueType = 'MultiString'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
          ValueData = @('')

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableCAD' {
          ValueName = 'DisableCAD'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\RestrictAnonymousSAM' {
          ValueName = 'RestrictAnonymousSAM'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0\NTLMMinServerSec' {
          ValueName = 'NTLMMinServerSec'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
          ValueData = 537395200

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\DontDisplayLastUserName' {
          ValueName = 'DontDisplayLastUserName'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableSecureUIAPaths' {
          ValueName = 'EnableSecureUIAPaths'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters\SupportedEncryptionTypes' {
          ValueName = 'SupportedEncryptionTypes'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters'
          ValueData = 2147483640

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters\EnableForcedLogOff' {
          ValueName = 'EnableForcedLogOff'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers\AddPrinterDrivers' {
          ValueName = 'AddPrinterDrivers'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\RestrictRemoteSAM' {
          ValueName = 'RestrictRemoteSAM'
          ValueType = 'String'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 'O:BAG:BAD:(A;;RC;;;BA)'

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableInstallerDetection' {
          ValueName = 'EnableInstallerDetection'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters\MaximumPasswordAge' {
          ValueName = 'MaximumPasswordAge'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
          ValueData = 30

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\ValidateAdminCodeSignatures' {
          ValueName = 'ValidateAdminCodeSignatures'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AllocateDASD' {
          ValueName = 'AllocateDASD'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
          ValueData = '0'

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableVirtualization' {
          ValueName = 'EnableVirtualization'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters\SealSecureChannel' {
          ValueName = 'SealSecureChannel'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters\DisablePasswordChange' {
          ValueName = 'DisablePasswordChange'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\ForceUnlockLogon' {
          ValueName = 'ForceUnlockLogon'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\AuditBaseObjects' {
          ValueName = 'AuditBaseObjects'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\LimitBlankPasswordUse' {
          ValueName = 'LimitBlankPasswordUse'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\LmCompatibilityLevel' {
          ValueName = 'LmCompatibilityLevel'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 5

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\DisableDomainCreds' {
          ValueName = 'DisableDomainCreds'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\EnablePlainTextPassword' {
          ValueName = 'EnablePlainTextPassword'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LDAP\LDAPClientIntegrity' {
          ValueName = 'LDAPClientIntegrity'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LDAP'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\ForceGuest' {
          ValueName = 'ForceGuest'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\PasswordExpiryWarning' {
          ValueName = 'PasswordExpiryWarning'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
          ValueData = 5

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\CachedLogonsCount' {
          ValueName = 'CachedLogonsCount'
          ValueType = 'String'
          Key       = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
          ValueData = '3'

     }

     Registry 'Registry(INF): HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\AuthenticodeEnabled' {
          ValueName = 'AuthenticodeEnabled'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\UndockWithoutLogon' {
          ValueName = 'UndockWithoutLogon'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\pku2u\AllowOnlineID' {
          ValueName = 'AllowOnlineID'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa\pku2u'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy\Enabled' {
          ValueName = 'Enabled'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters\RequireSignOrSeal' {
          ValueName = 'RequireSignOrSeal'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedExactPaths\Machine' {
          ValueName = 'Machine'
          ValueType = 'MultiString'
          Key       = 'HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedExactPaths'
          ValueData = @('System\CurrentControlSet\Control\ProductOptions', 'System\CurrentControlSet\Control\Server Applications', 'Software\Microsoft\Windows NT\CurrentVersion')

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\FullPrivilegeAuditing' {
          ValueName = 'FullPrivilegeAuditing'
          ValueType = 'Binary'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = '0'

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters\AutoDisconnect' {
          ValueName = 'AutoDisconnect'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
          ValueData = 15

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\NoLMHash' {
          ValueName = 'NoLMHash'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\RestrictAnonymous' {
          ValueName = 'RestrictAnonymous'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa'
          ValueData = 1

     }

     # Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeText' {
     #      ValueName = 'LegalNoticeText'
     #      ValueType = 'String'
     #      Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
     #      ValueData = ''

     # }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0\allownullsessionfallback' {
          ValueName = 'allownullsessionfallback'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Session Manager\Kernel\ObCaseInsensitive' {
          ValueName = 'ObCaseInsensitive'
          ValueType = 'Dword'
          Key       = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Kernel'
          ValueData = 1

     }

     Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorUser' {
          ValueName = 'ConsentPromptBehaviorUser'
          ValueType = 'Dword'
          Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
          ValueData = 0

     }

     Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedPaths\Machine' {
          ValueName = 'Machine'
          ValueType = 'MultiString'
          Key       = 'HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedPaths'
          ValueData = @('System\CurrentControlSet\Control\Print\Printers', 'System\CurrentControlSet\Services\Eventlog', 'Software\Microsoft\OLAP Server', 'Software\Microsoft\Windows NT\CurrentVersion\Print', 'Software\Microsoft\Windows NT\CurrentVersion\Windows', 'System\CurrentControlSet\Control\ContentIndex', 'System\CurrentControlSet\Control\Terminal Server', 'System\CurrentControlSet\Control\Terminal Server\UserConfig', 'System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration', 'Software\Microsoft\Windows NT\CurrentVersion\Perflib', 'System\CurrentControlSet\Services\SysmonLog')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Access_Credential_Manager_as_a_trusted_caller' {
          Policy   = 'Access_Credential_Manager_as_a_trusted_caller'
          Force    = $True
          Identity = @('')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Act_as_part_of_the_operating_system' {
          Policy   = 'Act_as_part_of_the_operating_system'
          Force    = $True
          Identity = @('')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Create_a_token_object' {
          Policy   = 'Create_a_token_object'
          Force    = $True
          Identity = @('')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Create_permanent_shared_objects' {
          Policy   = 'Create_permanent_shared_objects'
          Force    = $True
          Identity = @('')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Enable_computer_and_user_accounts_to_be_trusted_for_delegation' {
          Policy   = 'Enable_computer_and_user_accounts_to_be_trusted_for_delegation'
          Force    = $True
          Identity = @('')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Load_and_unload_device_drivers' {
          Policy   = 'Load_and_unload_device_drivers'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Lock_pages_in_memory' {
          Policy   = 'Lock_pages_in_memory'
          Force    = $True
          Identity = @('')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Modify_an_object_label' {
          Policy   = 'Modify_an_object_label'
          Force    = $True
          Identity = @('')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Impersonate_a_client_after_authentication' {
          Policy   = 'Impersonate_a_client_after_authentication'
          Force    = $True
          Identity = @('*S-1-5-19', '*S-1-5-20', '*S-1-5-32-544', '*S-1-5-6')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Change_the_system_time' {
          Policy   = 'Change_the_system_time'
          Force    = $True
          Identity = @('*S-1-5-19', '*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Take_ownership_of_files_or_other_objects' {
          Policy   = 'Take_ownership_of_files_or_other_objects'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Deny_log_on_locally' {
          Policy   = 'Deny_log_on_locally'
          Force    = $True
          Identity = @('*S-1-5-32-546')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Deny_log_on_as_a_batch_job' {
          Policy   = 'Deny_log_on_as_a_batch_job'
          Force    = $True
          Identity = @('*S-1-5-32-546')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Back_up_files_and_directories' {
          Policy   = 'Back_up_files_and_directories'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Allow_log_on_through_Remote_Desktop_Services' {
          Policy   = 'Allow_log_on_through_Remote_Desktop_Services'
          Force    = $True
          Identity = @('*S-1-5-32-544', '*S-1-5-32-555')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Adjust_memory_quotas_for_a_process' {
          Policy   = 'Adjust_memory_quotas_for_a_process'
          Force    = $True
          Identity = @('*S-1-5-19', '*S-1-5-20', '*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Manage_auditing_and_security_log' {
          Policy   = 'Manage_auditing_and_security_log'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Debug_programs' {
          Policy   = 'Debug_programs'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Deny_log_on_through_Remote_Desktop_Services' {
          Policy   = 'Deny_log_on_through_Remote_Desktop_Services'
          Force    = $True
          Identity = @('*S-1-5-32-546')

     }

     if (!$SkipLogonAsService) {
          UserRightsAssignment 'UserRightsAssignment(INF): Log_on_as_a_service' {
               Policy   = 'Log_on_as_a_service'
               Force    = $True
               Identity = @('*S-1-5-80-0')
          }
     }

     if (!$ServerCore) {
          UserRightsAssignment 'UserRightsAssignment(INF): Increase_scheduling_priority' {
               Policy   = 'Increase_scheduling_priority'
               Force    = $True
               Identity = @('*S-1-5-32-544', '*S-1-5-90-0')

          }
     } else {
          UserRightsAssignment 'UserRightsAssignment(INF): Increase_scheduling_priority' {
               Policy   = 'Increase_scheduling_priority'
               Force    = $True
               Identity = @('*S-1-5-32-544')
          }
     }

     UserRightsAssignment 'UserRightsAssignment(INF): Shut_down_the_system' {
          Policy   = 'Shut_down_the_system'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Remove_computer_from_docking_station' {
          Policy   = 'Remove_computer_from_docking_station'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Log_on_as_a_batch_job' {
          Policy   = 'Log_on_as_a_batch_job'
          Force    = $True
          Identity = @('*S-1-5-32-544', '*S-1-5-32-551', '*S-1-5-32-559')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Change_the_time_zone' {
          Policy   = 'Change_the_time_zone'
          Force    = $True
          Identity = @('*S-1-5-19', '*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Replace_a_process_level_token' {
          Policy   = 'Replace_a_process_level_token'
          Force    = $True
          Identity = @('*S-1-5-19', '*S-1-5-20')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Allow_log_on_locally' {
          Policy   = 'Allow_log_on_locally'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Create_a_pagefile' {
          Policy   = 'Create_a_pagefile'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Restore_files_and_directories' {
          Policy   = 'Restore_files_and_directories'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Profile_system_performance' {
          Policy   = 'Profile_system_performance'
          Force    = $True
          Identity = @('*S-1-5-32-544', '*S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Create_global_objects' {
          Policy   = 'Create_global_objects'
          Force    = $True
          Identity = @('*S-1-5-19', '*S-1-5-20', '*S-1-5-32-544', '*S-1-5-6')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Deny_log_on_as_a_service' {
          Policy   = 'Deny_log_on_as_a_service'
          Force    = $True
          Identity = @('*S-1-5-32-546')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Deny_access_to_this_computer_from_the_network' {
          Policy   = 'Deny_access_to_this_computer_from_the_network'
          Force    = $True
          Identity = @('*S-1-5-32-546')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Force_shutdown_from_a_remote_system' {
          Policy   = 'Force_shutdown_from_a_remote_system'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Access_this_computer_from_the_network' {
          Policy   = 'Access_this_computer_from_the_network'
          Force    = $True
          Identity = @('*S-1-5-11', '*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Perform_volume_maintenance_tasks' {
          Policy   = 'Perform_volume_maintenance_tasks'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Generate_security_audits' {
          Policy   = 'Generate_security_audits'
          Force    = $True
          Identity = @('*S-1-5-19', '*S-1-5-20')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Profile_single_process' {
          Policy   = 'Profile_single_process'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Create_symbolic_links' {
          Policy   = 'Create_symbolic_links'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     UserRightsAssignment 'UserRightsAssignment(INF): Modify_firmware_environment_values' {
          Policy   = 'Modify_firmware_environment_values'
          Force    = $True
          Identity = @('*S-1-5-32-544')

     }

     SecurityOption 'SecuritySetting(INF): NewGuestName' {
          Accounts_Rename_guest_account = 'NewGuest'
          Name                          = 'Accounts_Rename_guest_account'

     }

     AccountPolicy 'SecuritySetting(INF): PasswordHistorySize' {
          Name                     = 'Enforce_password_history'
          Enforce_password_history = 24

     }

     AccountPolicy 'SecuritySetting(INF): MinimumPasswordLength' {
          Name                    = 'Minimum_Password_Length'
          Minimum_Password_Length = 14

     }

     AccountPolicy 'SecuritySetting(INF): MinimumPasswordAge' {
          Minimum_Password_Age = 3
          Name                 = 'Minimum_Password_Age'

     }

     SecurityOption 'SecuritySetting(INF): ForceLogoffWhenHourExpire' {
          Name                                                  = 'Network_security_Force_logoff_when_logon_hours_expire'
          Network_security_Force_logoff_when_logon_hours_expire = 'Enabled'

     }

     SecurityOption 'SecuritySetting(INF): LSAAnonymousNameLookup' {
          Name                                                = 'Network_access_Allow_anonymous_SID_Name_translation'
          Network_access_Allow_anonymous_SID_Name_translation = 'Disabled'

     }

     SecurityOption 'SecuritySetting(INF): EnableAdminAccount' {
          Name                                  = 'Accounts_Administrator_account_status'
          Accounts_Administrator_account_status = $AdminAccountStatus

     }

     AccountPolicy 'SecuritySetting(INF): ResetLockoutCount' {
          Reset_account_lockout_counter_after = 30
          Name                                = 'Reset_account_lockout_counter_after'

     }

     AccountPolicy 'SecuritySetting(INF): MaximumPasswordAge' {
          Name                 = 'Maximum_Password_Age'
          Maximum_Password_Age = 42

     }

     AccountPolicy 'SecuritySetting(INF): ClearTextPassword' {
          Name                                        = 'Store_passwords_using_reversible_encryption'
          Store_passwords_using_reversible_encryption = 'Disabled'

     }

     AccountPolicy 'SecuritySetting(INF): LockoutBadCount' {
          Name                      = 'Account_lockout_threshold'
          Account_lockout_threshold = 5

     }

     AccountPolicy 'SecuritySetting(INF): LockoutDuration' {
          Name                     = 'Account_lockout_duration'
          Account_lockout_duration = 30

     }

     SecurityOption 'SecuritySetting(INF): NewAdministratorName' {
          Accounts_Rename_administrator_account = 'NewAdmin'
          Name                                  = 'Accounts_Rename_administrator_account'

     }

     SecurityOption 'SecuritySetting(INF): EnableGuestAccount' {
          Accounts_Guest_account_status = 'Disabled'
          Name                          = 'Accounts_Guest_account_status'

     }

     AccountPolicy 'SecuritySetting(INF): PasswordComplexity' {
          Name                                       = 'Password_must_meet_complexity_requirements'
          Password_must_meet_complexity_requirements = 'Enabled'

     }


}