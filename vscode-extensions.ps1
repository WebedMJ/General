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
    "ms-toolsai.vscode-ai",
    "ms-vscode.azure-account",
    "ms-vscode.azurecli",
    "ms-vscode.PowerShell",
    "ms-vscode.vscode-azureextensionpack",
    "ms-vsts.team",
    "msazurermtools.azurerm-vscode-tools",
    "mshdinsight.azure-hdinsight",
    "PeterJausovec.vscode-docker",
    "redhat.vscode-yaml",
    "Tyriar.shell-launcher",
    "usqlextpublisher.usql-vscode-ext",
    "VisualStudioOnlineApplicationInsights.application-insights",
    "vsciot-vscode.azure-iot-edge",
    "vsciot-vscode.azure-iot-toolkit",
    "vscoss.vscode-ansible",
    "wholroyd.jinja"
    "stansw.vscode-odata"
)
$extensions.ForEach( {code --install-extension $PSItem} )