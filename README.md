Install HMUtils Module from GitHub
=
### Prerequisites
```powershell
Install-Module -Name InstallModuleFromGitHub -RequiredVersion 0.3
```

### Installing HMUtils
```powershell
Install-ModuleFromGitHub -GitHubRepo HvdMark/HMUtils -Branch main -Debug -Verbose
```

# Exported Functions

Function  | Description
------------- | -------------
Test-IsUserAdmin  | Test if a user has admin privileges
Test-IsUserElevated  | Test if a user has been elevated as admin
Test-Url  | Test if a website is available
Test-WinRM | Test if WinRM is allowing a remote connection 
