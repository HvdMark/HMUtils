<#
    .SYNOPSIS
    Get the Users last logon

    .DESCRIPTION
    Get the date and time a User has his/her last logon

    .PARAMETER SamAccountName
    Account to check

    .EXAMPLE
    Get-ADLastLogon <SamAccountName>

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/hvdm/HMUtils/
#>

Import-Module ActiveDirectory

# Load HMUtils module if not already loaded
if (-not (Get-Module -Name HMUtils)) { Import-Module HMUtils }

[int]$DaysDefault = 90

function Get-ADLastLogon
{
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $false,
            HelpMessage = "Use the SamAccountName(s) separated by a comma, to identify the user, leave empty for all users"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$SamAccountName,
    
        [Parameter(
            Position = 1,
            Mandatory = $false,
            HelpMessage = "Specify the number of days to check for a user logon (default = 90)"
        )]
        [int]$Days = $DaysDefault,

        [Parameter(
            Position = 2,
            Mandatory = $false,
            HelpMessage = "Specify the to CSV export the report to"
        )]
        [string]$FileName
        
    )
    begin
    {
        $Date = (Get-Date).AddDays( - ($Days))

        # User(s) to check
        if ([string]::IsNullOrEmpty($SamAccountName))
        {
            # If no username is entered, get all of them
            $User = '*'
        }
        else 
        {
            $User = $SamAccountName -split ','
            $User = $User -replace (" ", "")
        }
    }

    process
    {
        #Filtering All enabled users who haven't logged in.
        $Report = Get-ADUser `
            -Properties LastLogonDate `
            -Filter { (Name -like $User -and lastlogondate -le $Date) -AND (enabled -eq $True) } | Select-Object SamAccountName, Name, LastLogonDate | Sort-Object SamAccountName

        $Report

        if (-not ([string]::IsNullOrEmpty($FileName)) )
        {
            # Export to a CSV file
            $Report | Export-Csv C:\temp\LastLogonReport_"$NetBio"_"$FileDate".csv -NoTypeInformation
        }
    }
}
