# Veeam file restore script

An old script, could probably be improved!

USAGE:

```PowerShell
.\VeeamFileRestore-auto.ps1 -TargetVM <VMName> -FilesToRestore <File1,File2> -Reason <VeeamJobReason> -BackupDate <ddmmyyyy>
```

We actually deployed it using LAMP front end that collected the parameters with a form and created a request file that was then processed by `ProcessRestoreRequests`.