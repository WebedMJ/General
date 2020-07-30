$setparams = @{
    AttackSurfaceReductionRules_Actions           = @(
        1,
        2,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1
    )
    AttackSurfaceReductionRules_Ids               = @(
        '01443614-cd74-433a-b99e-2ecdc07bfc25',
        '26190899-1602-49e8-8b27-eb1d0a1ce869',
        '3B576869-A4EC-4529-8536-B80A7769E899',
        '5BEB7EFE-FD9A-4556-801D-275E5FFC04CC',
        '75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84',
        '7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c',
        '92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B',
        '9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2',
        'b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4',
        'BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550',
        'c1db55ab-c21a-4637-bb3f-a12568109d35',
        'd1e49aac-8f56-4280-b9ba-993a6d77406c',
        'D3E037E1-3EB8-44C8-A917-57927947596D',
        'D4F940AB-401B-4EFC-AADC-AD5F3C50688A',
        'e6db77e5-3df2-4cf1-b95a-636979351e5b'
    )
    CheckForSignaturesBeforeRunningScan           = $true
    CloudBlockLevel                               = 4
    CloudExtendedTimeout                          = 50
    DisableArchiveScanning                        = $false
    DisableAutoExclusions                         = $false
    DisableBehaviorMonitoring                     = $false
    DisableBlockAtFirstSeen                       = $false
    DisableCatchupFullScan                        = $false
    DisableCatchupQuickScan                       = $false
    DisableEmailScanning                          = $false
    DisableIntrusionPreventionSystem              = $false
    DisableIOAVProtection                         = $false
    DisablePrivacyMode                            = $false
    DisableRealtimeMonitoring                     = $false
    DisableRemovableDriveScanning                 = $false
    DisableRestorePoint                           = $false
    DisableScanningMappedNetworkDrivesForFullScan = $true
    DisableScanningNetworkFiles                   = $false
    DisableScriptScanning                         = $false
    EnableControlledFolderAccess                  = 1
    EnableLowCpuPriority                          = $false
    EnableNetworkProtection                       = 1
    HighThreatDefaultAction                       = 'Remove'
    LowThreatDefaultAction                        = 'Quarantine'
    MAPSReporting                                 = 2
    ModerateThreatDefaultAction                   = 'Remove'
    PUAProtection                                 = 1
    QuarantinePurgeItemsAfterDelay                = 14
    RandomizeScheduleTaskTimes                    = $true
    RealTimeScanDirection                         = 'Both'
    RemediationScheduleDay                        = 0
    RemediationScheduleTime                       = '02:00:00'
    ReportingAdditionalActionTimeOut              = 10080
    ReportingCriticalFailureTimeOut               = 10080
    ReportingNonCriticalTimeOut                   = 1440
    ScanAvgCPULoadFactor                          = 50
    ScanOnlyIfIdleEnabled                         = $true
    ScanParameters                                = 1
    ScanPurgeItemsAfterDelay                      = 15
    ScanScheduleDay                               = 0
    ScanScheduleQuickScanTime                     = '00:00:00'
    ScanScheduleTime                              = '13:00:00'
    SevereThreatDefaultAction                     = 'Remove'
    SignatureAuGracePeriod                        = 0
    SignatureDisableUpdateOnStartupWithoutEngine  = $false
    SignatureFirstAuGracePeriod                   = 120
    SignatureScheduleDay                          = 0
    SignatureScheduleTime                         = '01:45:00'
    SignatureUpdateCatchupInterval                = 1
    SignatureUpdateInterval                       = 1
    SubmitSamplesConsent                          = 1
    UnknownThreatDefaultAction                    = 'Remove'
}
Set-MpPreference @setparams
$addparams = @{
    AttackSurfaceReductionOnlyExclusions      = @(
        '%GOPATH%\bin\*.exe',
        '%localappdata%\Temp\go-build*\*\exe\*.exe',
        'C:\ProgramData\chocolatey\bin\*',
        'C:\Users\%username%\.vs-kubernetes\tools\minikube\windows-amd64\minikube.exe'
    )
    ControlledFolderAccessAllowedApplications = @(
        'C:\Program Files (x86)\Steam\Steam.exe',
        'C:\Windows\System32\CompatTelRunner.exe',
        'C:\Windows\System32\notepad.exe',
        'C:\Program Files (x86)\Heimdal\Heimdal.AgentLoader.exe',
        'C:\Program Files (x86)\Heimdal\Heimdal.ThorAgent.exe',
        'C:\Users\ed\AppData\Local\BraveSoftware\Brave-Browser\Application\brave.exe',
        'C:\Program Files (x86)\Microsoft OneDrive\OneDrive.exe',
        'C:\Windows\System32\mstsc.exe',
        'C:\Windows\System32\poqexec.exe',
        'C:\Windows\System32\RuntimeBroker.exe',
        'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe',
        'C:\Program Files\PowerShell\7\pwsh.exe',
        'TiWorker.exe'
    )
    # ExclusionExtension
    # ExclusionPath
    # ExclusionProcess                          = @()
}
Add-MpPreference @addparams