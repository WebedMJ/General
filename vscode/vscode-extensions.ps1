#code --list-extensions
$extensions = @(
    'azuredevspaces.azds',
    'CoenraadS.bracket-pair-colorizer-2',
    'darkriszty.markdown-table-prettify',
    'DavidAnson.vscode-markdownlint',
    'docsmsft.docs-preview',
    'DotJoshJohnson.xml',
    'GitHub.vscode-pull-request-github',
    'GrapeCity.gc-excelviewer',
    'humao.rest-client',
    'ionutvmi.reg',
    'ms-azure-devops.azure-pipelines',
    'ms-azuretools.vscode-apimanagement',
    'ms-azuretools.vscode-azureappservice',
    'ms-azuretools.vscode-azureeventgrid',
    'ms-azuretools.vscode-azurefunctions',
    'ms-azuretools.vscode-azurestorage',
    'ms-azuretools.vscode-cosmosdb',
    'ms-azuretools.vscode-docker',
    'ms-azuretools.vscode-logicapps',
    'MS-CEINTL.vscode-language-pack-en-GB',
    'ms-kubernetes-tools.vscode-aks-tools',
    'ms-kubernetes-tools.vscode-kubernetes-tools',
    'ms-mssql.mssql',
    'ms-python.python',
    'ms-vscode-remote.remote-wsl',
    'ms-vscode.azure-account',
    'ms-vscode.azurecli',
    'ms-vscode.Go',
    'ms-vscode.powershell',
    'ms-vscode.vscode-node-azure-pack',
    'ms-vscode.vscode-typescript-tslint-plugin',
    'ms-vsliveshare.vsliveshare',
    'ms-vsts.team',
    'msazurermtools.azurerm-vscode-tools',
    'RamiroBerrelleza.bitbucket-pull-requests',
    'redhat.vscode-yaml',
    'samcogan.arm-snippets',
    'stansw.vscode-odata',
    'usqlextpublisher.usql-vscode-ext',
    'VisualStudioOnlineApplicationInsights.application-insights',
    'vsciot-vscode.azure-iot-toolkit',
    'vscode-icons-team.vscode-icons',
    'vscoss.vscode-ansible',
    'wholroyd.jinja',
    'donjayamanne.githistory'
)
$extensions.ForEach( { code --install-extension $PSItem } )