Install HMUtils Module from GitHub
=
### Prerequisites
```powershell
Install-Module -Name InstallModuleFromGitHub
```

### Installing or Updating HMUtils for the current user
```powershell
# Install or Update to the latest version available on GitHub
Install-ModuleFromGitHub -GitHubRepo HvdMark/HMUtils -Branch main -Verbose

# To auto import the module when starting PowerShell
notepad $PROFILE
# Add
Import-Module HMUtils
```

### Installing or Updating HMUtils for the all users
```powershell
# Install or Update to the latest version available on GitHub
Install-ModuleFromGitHub -GitHubRepo HvdMark/HMUtils -Branch main -Scope AllUsers -Verbose

# To auto import the module when starting PowerShell
notepad $PROFILE.AllUsersAllHosts
# Add
Import-Module HMUtils
```


# Exported Functions

Function  | Description
------------- | -------------
Get-ADAllUsersInfo | Get a list of all users and export it to a file
Get-ADAllDomainControllers | Get a list of all domain controllers
Get-ADDomainAdmins | Get a list of all users that have Administrator privileges
Get-ADGroupTreeViewMembers | Get a tree of all (nested) group a user is member of
Get-ADLastLogon | Get the user last logon
Get-BootTime | Get the time and date when a machine is rebooted
Get-MainBoardSerial | Get the serial number of the mainboard
Get-NetExternalIP | Get the external IP of your network
Get-PowerShellVersion | Get the PowerShell version local or remote
Get-WifiPasswords | Get a list of all Wifi profiles and the passwords used
Get-WindowsProductKey | Get the windows product key from a local or remote computer
Test-ADDomainController | Test the connection to a specific Domain Controller
Test-ADDomainControllers | Test the connection to all Domain Controllers
Test-IsUserAdmin  | Test if a user has admin privileges
Test-IsUserElevated  | Test if a user has been elevated as admin
Test-Url  | Test if a website is available
Test-WinRM | Test if WinRM is allowing a remote connection 
