<#
    .SYNOPSIS
    This Cmdlet is used to create a password

    .DESCRIPTION
    This Cmdlet is used to create a password

    .EXAMPLE
    New-Password

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>
Function New-Password
{
    Param(
        [int]$Length = 15
    )

    Add-Type -AssemblyName "System.Web" -ErrorAction Stop

    $Password = [System.Web.Security.Membership]::GeneratePassword($Length, $Length / 4)
    return $Password
}