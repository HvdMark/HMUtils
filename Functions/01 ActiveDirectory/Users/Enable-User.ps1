function Enable-User 
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
        
        # Check if user is disabled 

        $stat = (Get-ADUser $username -Properties Enabled | Select-Object Enabled).Enabled
        Write-Host "current: $stat"

        if (!(Get-ADUser $username -Properties Enabled | Select-Object Enabled).Enabled)
        {
            Enable-ADAccount -Identity $Username -ErrorAction Stop
            if ((Get-ADUser $username -Properties Enabled | Select-Object Enabled).Enabled)
            {
                Write-Verbose "$Username enabled"
                return $true
            }
            else 
            {
                Write-Verbose "$Username disabled"
                return $false
            }
        }
        else
        {
            Write-Verbose "$Username already enabled"
            return $true
        }
        
    }
    catch 
    {
        Throw "Failed to enable user account '$Username': $($_.Exception.Message)"
    }
}

Enable-User -Username "User1"