<#
    .SYNOPSIS
    This Cmdlet is used to get a list of all Wifi profiles and the passwords used

    .DESCRIPTION
    Function to get a list of all Wifi passwords

    .EXAMPLE
    Get-WifiPasswords

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>

function Get-WIFIPasswords
{
    # Get a list of all WLAN Profiles
    $Profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object { $_ -replace "    All User Profile\s+:\s+", "" }

    # Loop through each WiFi profile and retrieve the password
    foreach ($Profile in $Profiles)
    {
        $ProfileInfo = netsh wlan show profile name="$profile" key=clear
        $Password = $ProfileInfo | Select-String "Key Content"
    
        if ($Password)
        {
            [PSCustomObject]@{
                SSID     = $Profile
                Password = ($Password -split ":\s+")[1]
            }
        }
    }
}



