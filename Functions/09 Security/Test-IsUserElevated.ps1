<#
    .SYNOPSIS
    This Cmdlet is used to test if a user is elevated as admin

    .DESCRIPTION
    The Test-IsUserElevated cmdlet checks if the current user is elevated as an administrator.

    .EXAMPLE
    Test-IsUserElevated
    
    Returns True if the user has been elevated as admin.

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>

function Test-IsUserElevated
{
    [CmdletBinding()]

    $isElevatedAsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
    return $isElevatedAsAdmin 
}
