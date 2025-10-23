<#
    .SYNOPSIS
    This Cmdlet is used to get the SID of a user

    .DESCRIPTION
    The userToSid cmdlet checks the SID of a user

    .EXAMPLE
    Get-UserToSid -User <username>
    
    Returns the SID of the user

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>

function Get-UserToSid
{
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Username
    )

    try 
    {
        $User = Get-ADUser -Identity $Username -ErrorAction Stop
        $SID = $User.SID
        Write-Output $SID
    }
    catch 
    {
        # Try to get SID for local user if domain user not found
        try 
        {
            $User = Get-WmiObject -Class Win32_UserAccount -Filter "Name='$Username'" -ErrorAction Stop
            $SID = $User.SID
            Write-Output $SID
        }
        catch 
        {
            Write-Error "User $Username not found."
        }
    }
}
