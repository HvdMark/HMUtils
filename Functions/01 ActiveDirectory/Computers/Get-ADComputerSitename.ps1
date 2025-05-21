<#
    .SYNOPSIS
    This Cmdlet is used to the sitename for a computer

    .$DESCIpAddressTION
    This Cmdlet is used to the sitename for a computer

    .EXAMPLE

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>

function Get-ADComputerSitename
{
    param
    (
        [string]$IpAddress
    )
    $site = nltest /DSADDRESSTOSITE:$IpAddress /dsgetsite 2>$null
    
    if ($LASTEXITCODE -eq 0)
    {
        $split = $site[3] -split "\s+"
        if ($split[1] -match [regex]"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$")
        {
            "" | Select-Object @{l = "ADSite"; e = { $split[2] } }, @{l = "ADSubnet"; e = { $split[3] } }
        }
    }
}