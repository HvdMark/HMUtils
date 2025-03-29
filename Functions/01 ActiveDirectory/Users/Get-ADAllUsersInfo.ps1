<#
    .SYNOPSIS
    Get a list of All Users with their info

    .DESCRIPTION
    Get a list of All Users with their info

    .EXAMPLE
    Export all users to the screen
    Get-AllUsersInfo

    Enter credentials when needed
    Get-AllUsersInfo -Credential "contoso\administrator"

    Export output to a csv file
    Get-AllUsersInfo -FileName "filename.csv" -Filetype csv

    Export output to a html file
    Get-AllUsersInfo -FileName "filename.html" -Filetype html

    Export output to a json file
    Get-AllUsersInfo -FileName "filename.json" -Filetype json

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/hvdm/HMUtils/
#>

Import-Module ActiveDirectory

function Get-ADAllUsersInfo
{
    [CmdletBinding(DefaultParameterSetName = "ScreenOutput")]
    param 
    (
        [parameter(Mandatory = $false)]
        [Management.Automation.PSCredential] $Credential,

        # Optional Filename parameter, only in "FileOutput" parameter set
        [Parameter(ParameterSetName = "FileOutput")]
        [string]$Filename,

        # FileType is mandatory only when Filename is provided, also in "FileOutput" set
        [Parameter(Mandatory = $true, ParameterSetName = "FileOutput")]
        [ValidateSet("csv", "html", "json")]
        [string]$FileType
    )

    process
    {
        if ($null -ne $Credential)
        {
            $users = Get-ADUser -Filter * -Credential $Credential -Properties "SamAccountName", "DisplayName", "LastLogonDate", "PasswordLastSet", "LastBadPasswordAttempt", "PasswordNeverExpires", "LockedOut", "PasswordExpired", "PasswordNotRequired", "BadLogonCount", "badPwdCount", "CannotChangePassword", "logonCount" | `
                Select-Object "SamAccountName", "DisplayName", "LastLogonDate", "PasswordLastSet", "LastBadPasswordAttempt", "PasswordNeverExpires", "LockedOut", "PasswordExpired", "PasswordNotRequired", "BadLogonCount", "badPwdCount", "CannotChangePassword", "logonCount" `
                -ExcludeProperty "DistinguishedName", "GivenName", "ModifiedProperties", "PropertyCount", "RemovedProperties", "AddedProperties", "PropertyNames", "Surname", "SID", "ObjectGUID", "ObjectClass"
        }
        else 
        {
            $users = Get-ADUser -Filter * -Properties "SamAccountName", "DisplayName", "LastLogonDate", "PasswordLastSet", "LastBadPasswordAttempt", "PasswordNeverExpires", "LockedOut", "PasswordExpired", "PasswordNotRequired", "BadLogonCount", "badPwdCount", "CannotChangePassword", "logonCount" | `
                Select-Object "SamAccountName", "DisplayName", "LastLogonDate", "PasswordLastSet", "LastBadPasswordAttempt", "PasswordNeverExpires", "LockedOut", "PasswordExpired", "PasswordNotRequired", "BadLogonCount", "badPwdCount", "CannotChangePassword", "logonCount" `
                -ExcludeProperty "DistinguishedName", "GivenName", "ModifiedProperties", "PropertyCount", "RemovedProperties", "AddedProperties", "PropertyNames", "Surname", "SID", "ObjectGUID", "ObjectClass"
        }

        if ($PSCmdlet.ParameterSetName -eq 'FileOutput') 
        {
            # Logic to output to file based on file type
            switch ($FileType) 
            {
                "csv" { $users | Export-Csv -Delimiter ';' -NoTypeInformation -Path $Filename }
                "html" { $users | ConvertTo-Html | Set-Content -Path $Filename }
                "json" { $users | ConvertTo-Json | Set-Content -Path $Filename }
            }
        } 
        else 
        {
            # Default output to screen
            $users
        }
    }
}