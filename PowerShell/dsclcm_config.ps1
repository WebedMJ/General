[DSCLocalConfigurationManager()]
configuration LCMConfig
{
    Node localhost
    {
        Settings {
            ConfigurationMode = 'ApplyAndAutoCorrect'
            RefreshMode       = 'Push'
        }
    }
}

LCMConfig