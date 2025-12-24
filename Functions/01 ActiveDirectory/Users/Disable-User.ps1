function Disable-User 
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory)]
        [string] $Username
    )

    try 
    {
        # Import AD module
        Import-Module ActiveDirectory -ErrorAction Stop
        
        # Check if user is enabled 

        $stat = (Get-ADUser $username -Properties Enabled | Select-Object Enabled).Enabled
        Write-Host "current: $stat"

        if ((Get-ADUser $username -Properties Enabled | Select-Object Enabled).Enabled)
        {
            Disable-ADAccount -Identity $Username -ErrorAction Stop
            if (!(Get-ADUser $username -Properties Enabled | Select-Object Enabled).Enabled)
            {
                Write-Verbose "$Username disabled"
                return $true
            }
            else 
            {
                Write-Verbose "$Username enabled"
                return $false
            }
        }
        else
        {
            Write-Verbose "$Username already disabled"
            return $true
        }
        
    }
    catch 
    {
        Throw "Failed to disable user account '$Username': $($_.Exception.Message)"
    }
}

Disable-User -Username "User1"