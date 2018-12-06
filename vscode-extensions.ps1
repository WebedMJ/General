#code --list-extensions
$extensions = @(
    "DotJoshJohnson.xml",
    "ionutvmi.reg",
    "ms-azuretools.vscode-azureappservice",
    "ms-azuretools.vscode-azureeventgrid",
    "ms-azuretools.vscode-azurefunctions",
    "ms-azuretools.vscode-azurestorage",
    "ms-azuretools.vscode-azureterraform",
    "ms-azuretools.vscode-cosmosdb",
    "ms-kubernetes-tools.vscode-kubernetes-tools",
    "ms-mssql.mssql",
    "ms-python.python",
    "ms-vscode.azure-account",
    "ms-vscode.azurecli",
    "ms-vscode.PowerShell",
    "ms-vsts.team",
    "msazurermtools.azurerm-vscode-tools",
    "PeterJausovec.vscode-docker",
    "redhat.vscode-yaml",
    "usqlextpublisher.usql-vscode-ext",
    "VisualStudioOnlineApplicationInsights.application-insights",
    "vscoss.vscode-ansible",
    "wholroyd.jinja"
    "stansw.vscode-odata",
    "coenraads.bracket-pair-colorizer-2"
)
$extensions.ForEach( {code --install-extension $PSItem} )