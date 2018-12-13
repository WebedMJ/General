# requires -Version 2.0
Add-Type -AssemblyName 'System.Web'
$Password = [System.Web.Security.Membership]::GeneratePassword(32, 32 / 4)
if (![bool](Get-WmiObject -Query 'Select * From Win32_UserAccount Where LocalAccount = TRUE AND Name = "MyAdmin"'))
{
  & "$env:windir\system32\net.exe" USER 'MyAdmin' "$Password" /ADD /Y
  & "$env:windir\system32\net.exe" LOCALGROUP 'Administrators' 'MyAdmin' /ADD
}