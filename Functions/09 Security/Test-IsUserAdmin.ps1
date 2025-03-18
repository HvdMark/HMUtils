<#
    .SYNOPSIS
    This Cmdlet is used to test if a user has admin privileges

    .DESCRIPTION
    The Test-IsUserAdmin cmdlet checks if the current user is a member of the Administrators group.

    .EXAMPLE
    Test-IsUserAdmin
    
    Returns True if the user has administrative privileges, and False if they do not.

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>

function Test-IsUserAdmin
{
    [CmdletBinding()]

    $CurrentUser = [System.Security.Principal.CurrentUser]::GetCurrent()
    $Principal = New-Object System.Security.Principal.Principal($CurrentUser)

    $IsAdmin = $Principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    return $IsAdmin
}
