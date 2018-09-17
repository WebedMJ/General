# Powershell Azure Function app to check O365 users against haveibeenpwned.com

Work in progress!!

## Functions:
1. `QueueO365Users.ps1` gets list of all Office 365 users email addresses from the Microsoft Graph and passes each one as a json object to `CreateQueueMsg.ps1`.

2. `CreateQueueMsg.ps1` takes the user json objects and creates an Azure Queue message for each one.

3. `CheckUsers.ps1` should be triggered by queue messages and checks the email addresses in the messages against the haveibeenpwned API.  Found breaches are added to.....

4. ...