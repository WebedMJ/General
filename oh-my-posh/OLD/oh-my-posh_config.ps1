# See https://github.com/TylerLeonhardt/oh-my-posh
# Install https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo/L/Regular/complete

# Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser

# In C:\tools\Cmder\config\user_profile.ps1
[ScriptBlock]$CmderPrompt = {
    Import-Module posh-git
    Import-Module oh-my-posh
    $ohmyposhthemedir = "$env:USERPROFILE\Documents\PowerShell\PoshThemes"
    if (!(Test-Path $ohmyposhthemedir)) {
        New-Item -Path $ohmyposhthemedir -ItemType Directory
    }
    $global:ThemeSettings.MyThemesLocation = $ohmyposhthemedir
    Set-Theme Paradox-Ed
}


# Copy custome theme psm1 file to mythemeslocation...
# Install DarConEmu.xml theme
# Make sure colour 8 = 0x99917b
# .\Install-ConEmuTheme.ps1 -ConfigPath C:\<path>\Cmder\vendor\conemu-maximus5\ConEmu.xml -Operation Add -ThemePathOrName .\DarkConEmu.xml
# Use MesloLGL NF main console font in ConEmu
