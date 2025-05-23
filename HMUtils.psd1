
@{

    # Script module or binary module file associated with this manifest.
    RootModule           = 'HMUtils.psm1'

    # Version number of this module.
    ModuleVersion        = '0.0.6'

    # Supported PSEditions
    CompatiblePSEditions = "Desktop", "Core"

    # ID used to uniquely identify this module
    GUID                 = '698e7dca-a019-476a-b781-78422cd52fca'

    # Author of this module
    Author               = 'H. van der Mark'

    # Company or vendor of this module
    CompanyName          = ''

    # Copyright statement for this module
    Copyright            = '(c) H. van der Mark, all rights reserved.'

    # Description of the functionality provided by this module
    Description          = 'A set of tools, handy for regular use'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion    = '5.0'


    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = 
    @(  "Copy-ADGroupsFromUserToUser",
        "Get-ADAllDomainControllers",
        "Get-ADAllUsersInfo",
        "Get-ADComputerSitename",
        "Get-ADDomainAdmins",
        "Get-ADGroupTreeViewMembers",
        "Get-ADLastLogin",
        "Get-ADServers",
        "Get-BootTime",
        "Get-Hash",
        "Get-MainboardSerial",
        "Get-NetExternalIP",
        "Get-PowerShellVersion",
        "Get-WifiPasswords",
        "Get-WindowsProductKey",
        "New-Password",
        "Test-ADDomainController",
        "Test-ADDomainControllers",
        "Test-IsUserAdmin",
        "Test-IsUserElevated",
        "Test-URL",
        "Test-WinRM"
    )
 
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    # AliasesToExport      = 

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = 'HMUtils'

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/HvdMark/HMUtils/blob/main/LICENSE.txt'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/HvdMark/HMUtils/'

            # A URL to an icon representing this module.
            IconUri      = 'https://github.com/HvdMark/HMutils/blob/main/Images/HMutils.png'

            # ReleaseNotes of this module
            ReleaseNotes = 'https://github.com/HvdMark/HMUtils/blob/main/CHANGELOG.md'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

