# From ISESteroids
# http://www.powertheshell.com/isesteroids/
try {
    # Something
} catch {
    # get error record
    [Management.Automation.ErrorRecord]$e = $_
    # retrieve information about runtime error
    $info = [PSCustomObject]@{
        Exception = $e.Exception.Message
        Reason    = $e.CategoryInfo.Reason
        Target    = $e.CategoryInfo.TargetName
        Script    = $e.InvocationInfo.ScriptName
        Line      = $e.InvocationInfo.ScriptLineNumber
        Column    = $e.InvocationInfo.OffsetInLine
    }
    # output information. Post-process collected info, and log info (optional)
    $info
}