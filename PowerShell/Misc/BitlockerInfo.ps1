# https://docs.microsoft.com/en-us/windows/desktop/secprov/getencryptionmethod-win32-encryptablevolume
# Get Bitlocker information
Get-WmiObject Win32_EncryptableVolume -Namespace root\CIMv2\Security\MicrosoftVolumeEncryption