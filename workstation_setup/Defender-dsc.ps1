#Requires -Module WindowsDefender

configuration mypc {

    Import-DscResource -ModuleName WindowsDefender

    node localhost
    {
        WindowsDefender DefenderPrefs {
            IsSingleInstance                              = "Yes"
            AttackSurfaceReductionOnlyExclusions          = @(
                "$env:LOCALAPPDATA\Programs\Python\Python312\Scripts\jupyter-notebook.exe"
                "$env:LOCALAPPDATA\Programs\Python\Python312\Scripts\jupyter.exe"
                "$env:LOCALAPPDATA\Programs\Python\Python312\Scripts\pip.exe"
                "$env:LOCALAPPDATA\Programs\Python\Python312\Scripts\pip3.exe"
                "$env:LOCALAPPDATA\Programs\Python\PYTHON~1\Scripts\jupyter-notebook.exe"
                "$env:LOCALAPPDATA\Programs\Python\PYTHON~1\Scripts\jupyter.exe"
                "$env:LOCALAPPDATA\Programs\Python\PYTHON~1\Scripts\pip.exe"
                "$env:APPDATA\Python\Python312\Scripts\pipenv.exe"
            )
            AttackSurfaceReductionRules_Actions           = @(
                'Enabled',
                'AuditMode',
                'Enabled',
                'Enabled',
                'Enabled',
                'Enabled',
                'Enabled',
                'Enabled',
                'Enabled',
                'Enabled',
                'Enabled',
                'Enabled',
                'Enabled',
                'Enabled',
                'Enabled',
                'Enabled'
            )
            AttackSurfaceReductionRules_Ids               = @(
                '01443614-cd74-433a-b99e-2ecdc07bfc25'
                '26190899-1602-49e8-8b27-eb1d0a1ce869'
                '3B576869-A4EC-4529-8536-B80A7769E899'
                '56a863a9-875e-4185-98a7-b882c64b5ce5'
                '5BEB7EFE-FD9A-4556-801D-275E5FFC04CC'
                '75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84'
                '7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c'
                '92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B'
                '9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2'
                'b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4'
                'BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550'
                'c1db55ab-c21a-4637-bb3f-a12568109d35'
                'd1e49aac-8f56-4280-b9ba-993a6d77406c'
                'D3E037E1-3EB8-44C8-A917-57927947596D'
                'D4F940AB-401B-4EFC-AADC-AD5F3C50688A'
                'e6db77e5-3df2-4cf1-b95a-636979351e5b'
            )
            CheckForSignaturesBeforeRunningScan           = $true
            CloudBlockLevel                               = 'HighPlus'
            CloudExtendedTimeout                          = 50
            ControlledFolderAccessProtectedFolders        = ( $($env:OneDrive) )
            ControlledFolderAccessAllowedApplications     = @(
                "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
                "C:\Program Files (x86)\Steam\Steam.exe"
                "C:\Program Files\Microsoft OneDrive\OneDrive.exe"
                "C:\Program Files\Microsoft VS Code\Code.exe"
                "C:\Program Files\Notepad++\notepad++.exe"
                "C:\Program Files\PowerShell\7\pwsh.exe"
                "$env:LOCALAPPDATA\Microsoft\Teams\Update.exe"
                "$env:LOCALAPPDATA\Programs\signal-desktop\Signal.exe"
                "C:\Windows\System32\mstsc.exe"
                "C:\Windows\System32\notepad.exe"
                "C:\Windows\System32\WinSAT.exe"
            )
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
            DisableScanningNetworkFiles                   = $true
            DisableScriptScanning                         = $false
            EnableControlledFolderAccess                  = 1
            EnableNetworkProtection                       = 1
            MAPSReporting                                 = 'Advanced'
            QuarantinePurgeItemsAfterDelay                = 14
            RandomizeScheduleTaskTimes                    = $true
            RealTimeScanDirection                         = 'Both'
            RemediationScheduleDay                        = 'Never'
            ReportingAdditionalActionTimeOut              = 10080
            ReportingCriticalFailureTimeOut               = 10080
            ReportingNonCriticalTimeOut                   = 1440
            ScanAvgCPULoadFactor                          = 50
            ScanOnlyIfIdleEnabled                         = $true
            ScanPurgeItemsAfterDelay                      = 15
            ScanScheduleDay                               = 'Everyday'
            SignatureAuGracePeriod                        = 0
            SignatureDisableUpdateOnStartupWithoutEngine  = $false
            SignatureFirstAuGracePeriod                   = 120
            SignatureScheduleDay                          = 'Everyday'
            SignatureUpdateCatchupInterval                = 1
            SignatureUpdateInterval                       = 1
            SignatureScheduleTime                         = 60
            RemediationScheduleTime                       = '02:00:00'
            ScanScheduleQuickScanTime                     = '12:00:00'
            ScanScheduleTime                              = '13:00:00'
            SubmitSamplesConsent                          = 'SendSafeSamples'
        }
    }
}

mypc