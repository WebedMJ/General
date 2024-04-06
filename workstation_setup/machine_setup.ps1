$ErrorActionPreference = 'Stop'

$wingetApps = @(
    'Microsoft.PowerShell'
    'Git.Git'
    'Microsoft.DotNet.Runtime.8'
    'Microsoft.VisualStudioCode'
    'AgileBits.1Password'
    'JGraph.Draw'
    'Microsoft.Bicep'
    'Hashicorp.Terraform'
    'Microsoft.Azure.AztfExport'
    'Microsoft.WindowsTerminal'
    'JanDeDobbeleer.OhMyPosh'
    'Notepad++.Notepad++'
    'Mozilla.Firefox'
    'Insomnia.Insomnia'
    'Microsoft.AzureCLI'
    'Valve.Steam'
    'EpicGames.EpicGamesLauncher'
)

$vscodeExtensions = @(
    'ms-vscode.vscode-node-azure-pack'
    'msazurermtools.azurerm-vscode-tools'
    'ms-dotnettools.vscode-dotnet-runtime'
    'ms-vscode.azurecli'
    'ms-vscode.powershell'
    'ms-vscode-remote.remote-containers'
    'ms-vscode-remote.remote-wsl'
    'bierner.markdown-mermaid'
    'charliermarsh.ruff'
    'davidanson.vscode-markdownlint'
    'eamodio.gitlens'
    'foxundermoon.shell-format'
    'github.codespaces'
    'hashicorp.hcl'
    'hashicorp.terraform'
    'ionutvmi.reg'
    'ms-azure-devops.azure-pipelines'
    'ms-vsts.team'
    'ms-azuretools.vscode-bicep'
    'ms-ceintl.vscode-language-pack-en-gb'
    'redhat.vscode-yaml'
    'redhat.vscode-xml'
    'stansw.vscode-odata'
    'timonwong.shellcheck'
    'pkief.material-icon-theme'
    'pkief.material-product-icons'
    'vscode-icons-team.vscode-icons'
    'ms-python.python'
    'donjayamanne.python-environment-manager'
    'wholroyd.jinja'
    'visualstudioexptteam.vscodeintellicode'
    'ms-toolsai.jupyter'
    'oderwat.indent-rainbow'
    'gruntfuggly.todo-tree'
)

$addDefenderParams = @{
    AttackSurfaceReductionOnlyExclusions      = @(
        "$env:LOCALAPPDATA\Programs\Python\Python312\Scripts\jupyter-notebook.exe"
        "$env:LOCALAPPDATA\Programs\Python\Python312\Scripts\jupyter.exe"
        "$env:LOCALAPPDATA\Programs\Python\Python312\Scripts\pip.exe"
        "$env:LOCALAPPDATA\Programs\Python\Python312\Scripts\pip3.exe"
        "$env:LOCALAPPDATA\Programs\Python\PYTHON~1\Scripts\jupyter-notebook.exe"
        "$env:LOCALAPPDATA\Programs\Python\PYTHON~1\Scripts\jupyter.exe"
        "$env:LOCALAPPDATA\Programs\Python\PYTHON~1\Scripts\pip.exe"
        "$env:APPDATA\Python\Python312\Scripts\pipenv.exe"
    )
    ControlledFolderAccessAllowedApplications = @(
        'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
        'C:\Program Files (x86)\Steam\Steam.exe'
        'C:\Program Files\Microsoft OneDrive\OneDrive.exe'
        'C:\Program Files\Microsoft VS Code\Code.exe'
        'C:\Program Files\Notepad++\notepad++.exe'
        'C:\Program Files\PowerShell\7\pwsh.exe'
        "$env:LOCALAPPDATA\Microsoft\Teams\Update.exe"
        "$env:LOCALAPPDATA\Programs\signal-desktop\Signal.exe"
        'C:\Windows\System32\mstsc.exe'
        'C:\Windows\System32\notepad.exe'
        'C:\Windows\System32\WinSAT.exe'
    )
}

$setDefenderParams = @{
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
        1,
        1
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
    CloudBlockLevel                               = 4
    CloudExtendedTimeout                          = 50
    ControlledFolderAccessProtectedFolders        = ( $($env:OneDrive) )
    DisableArchiveScanning                        = $false
    DisableAutoExclusions                         = $false
    DisableBehaviorMonitoring                     = $false
    DisableBlockAtFirstSeen                       = $false
    DisableCatchupFullScan                        = $false
    DisableCatchupQuickScan                       = $false
    DisableCpuThrottleOnIdleScans                 = $true
    DisableDatagramProcessing                     = $false
    DisableDnsOverTcpParsing                      = $false
    DisableDnsParsing                             = $false
    DisableEmailScanning                          = $false
    DisableHttpParsing                            = $false
    DisableIntrusionPreventionSystem              = $false
    DisableIOAVProtection                         = $false
    DisableNetworkProtectionPerfTelemetry         = $false
    DisablePrivacyMode                            = $false
    DisableRdpParsing                             = $false
    DisableRealtimeMonitoring                     = $false
    DisableRemovableDriveScanning                 = $false
    DisableRestorePoint                           = $false
    DisableScanningMappedNetworkDrivesForFullScan = $true
    DisableScanningNetworkFiles                   = $true
    DisableScriptScanning                         = $false
    DisableSshParsing                             = $false
    DisableTlsParsing                             = $false
    EnableControlledFolderAccess                  = 1
    EnableDnsSinkhole                             = $true
    EnableFileHashComputation                     = $false
    EnableFullScanOnBatteryPower                  = $false
    EnableLowCpuPriority                          = $false
    EnableNetworkProtection                       = 1
    ForceUseProxyOnly                             = $false
    MAPSReporting                                 = 2
    PUAProtection                                 = 1
    QuarantinePurgeItemsAfterDelay                = 30
    RealTimeScanDirection                         = 'Both'
    RemediationScheduleDay                        = 8
    RemediationScheduleTime                       = '02:00:00'
    ReportingAdditionalActionTimeOut              = 10080
    ReportingCriticalFailureTimeOut               = 10080
    ReportingNonCriticalTimeOut                   = 1440
    ScanAvgCPULoadFactor                          = 50
    ScanOnlyIfIdleEnabled                         = $true
    ScanPurgeItemsAfterDelay                      = 15
    ScanScheduleDay                               = 0
    ScanScheduleQuickScanTime                     = '12:00:00'
    ScanScheduleTime                              = '13:00:00'
    SignatureDisableUpdateOnStartupWithoutEngine  = $false
    SignatureScheduleDay                          = 0
    SignatureScheduleTime                         = '00:00:00'
    SignatureUpdateCatchupInterval                = 1
    SignatureUpdateInterval                       = 1
    SubmitSamplesConsent                          = 'SendSafeSamples'
    ThrottleForScheduledScanOnly                  = $true
}

try {
    Write-Host 'Configuring Defender...' -ForegroundColor Blue
    Add-MpPreference @addDefenderParams
    Set-MpPreference @setDefenderParams
} catch {
    Write-Host $_
    throw 'Error configuring defender'
}

$wingetApps | ForEach-Object {
    try {
        Write-Host "Installing [$PSItem] ..." -ForegroundColor Blue
        winget install --id $PSItem -e -h --disable-interactivity --accept-package-agreements --accept-source-agreements
    } catch {
        Write-Host "Error installing [$PSItem]" -ForegroundColor Red
    }
}

$vscodeExtensions | ForEach-Object {
    try {
        Write-Host "Installing [$PSItem] ..." -ForegroundColor Blue
        code --install-extension $PSItem --force
    } catch {
        Write-Host "Error installing [$PSItem]" -ForegroundColor Red
    }
}

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

try {
    $pwshPath = (Get-ChildItem -Path 'C:\Program Files\WindowsApps\Microsoft.PowerShell_7*\pwsh.exe' |
            Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1).FullName
    if ($pwshPath) {
        Write-Host "Adding [$pwshPath] to controlled folder access allowed applications..." -ForegroundColor Blue
        Add-MpPreference -ControlledFolderAccessAllowedApplications $pwshPath
    } else {
        Write-Host 'No msstore version of pwsh 7 to add to controlled folder access' -ForegroundColor DarkYellow
    }


    $snipToolPath = (Get-ChildItem -Path 'C:\Program Files\WindowsApps\Microsoft.ScreenSketch*\SnippingTool\SnippingTool.exe' |
            Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1).FullName
    if ($snipToolPath) {
        Write-Host "Adding [$snipToolPath] to controlled folder access allowed applications..." -ForegroundColor Blue
        Add-MpPreference -ControlledFolderAccessAllowedApplications $snipToolPath
    } else {
        Write-Host 'No msstore version of snipping tool to add to controlled folder access' -ForegroundColor DarkYellow
    }

    $pwshScript = {
        $pwshModules = @(
            'Az.Accounts'
            'Az.Compute'
            'Az.Websites'
            'Az.ApplicationInsights'
            'Az.Cdn'
            'Az.Resources'
            'Az.Storage'
            'Az.Network'
            'Az.KeyVault'
            'Az.Monitor'
            'Az.PolicyInsights'
            'Az.FrontDoor'
            'Az.TrafficManager'
            'Az.Sql'
            'Az.Do'
            'Pester'
            'PSDesiredStateConfiguration'
            'SecretManagement.1Password'
            'Terminal-Icons'
        )
        $pwshModules | ForEach-Object {
            Write-Host "Installing [$PSItem] ..." -ForegroundColor Blue
            Install-Module $PSItem -Confirm:$false -Scope CurrentUser
            Write-Host "[$PSItem] installed" -ForegroundColor Green
        }
    }
    pwsh -c $pwshScript
} catch {
    Write-Error $_
    throw 'Error installing pwsh modules'
}
