<#
    .SYNOPSIS
    This Cmdlet is used to get the user that belongs to a SID

    .DESCRIPTION
    This Cmdlet is used to get the user that belongs to a SID

    .EXAMPLE
    Get-UserToSid -User <username>
    
    Returns the SID of the user

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>
function SidToUser
{
    param (
        [Parameter(Mandatory = $true)]
        [string]$sid
    )

    try
    {
        # Check if the SID belongs to a domain user
        $user = Get-ADUser -Filter { SID -eq $sid } -Properties Name -ErrorAction Stop
        Write-Output $user.Name
    }
    catch
    {
        # Check if the SID belongs to a local user
        try
        {
            $user = Get-WmiObject -Class Win32_UserAccount -Filter "SID='$sid'" -ErrorAction Stop
            Write-Output $user.Name
        }
        catch
        {
            Write-Error "SID not found."
        }
    }
}
