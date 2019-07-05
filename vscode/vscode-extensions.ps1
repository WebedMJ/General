#code --list-extensions
$extensions = @(
    "AwesomeAutomationTeam.azureautomation",
    "CoenraadS.bracket-pair-colorizer-2",
    "darkriszty.markdown-table-prettify",
    "DavidAnson.vscode-markdownlint",
    "docsmsft.docs-preview",
    "DotJoshJohnson.xml",
    "GrapeCity.gc-excelviewer",
    "ionutvmi.reg",
    "ms-azuretools.vscode-azureappservice",
    "ms-azuretools.vscode-azureeventgrid",
    "ms-azuretools.vscode-azurefunctions",
    "ms-azuretools.vscode-azurestorage",
    "ms-azuretools.vscode-azureterraform",
    "ms-azuretools.vscode-cosmosdb",
    "ms-azuretools.vscode-logicapps",
    "MS-CEINTL.vscode-language-pack-en-GB",
    "ms-kubernetes-tools.vscode-kubernetes-tools",
    "ms-mssql.mssql",
    "ms-python.python",
    "ms-vscode.azure-account",
    "ms-vscode.azurecli",
    "ms-vscode.Go",
    "ms-vscode.PowerShell",
    "ms-vscode.vscode-node-azure-pack",
    "ms-vsliveshare.vsliveshare",
    "ms-vsts.team",
    "msazurermtools.azurerm-vscode-tools",
    "PeterJausovec.vscode-docker",
    "RamiroBerrelleza.bitbucket-pull-requests",
    "redhat.vscode-yaml",
    "samcogan.arm-snippets",
    "stansw.vscode-odata",
    "usqlextpublisher.usql-vscode-ext",
    "VisualStudioOnlineApplicationInsights.application-insights",
    "vsciot-vscode.azure-iot-toolkit",
    "vscode-icons-team.vscode-icons",
    "vscoss.vscode-ansible",
    "wholroyd.jinja"
)
$extensions.ForEach( {code --install-extension $PSItem} )