<#
    .SYNOPSIS
    This Cmdlet is used to check the connection to the Domain, querying all Domain Controllers

    .DESCRIPTION
    Function to test a connection to all Domain Controllers

        .EXAMPLE
    Test-ADDomainController

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>
function Test-ADDomainControllers 
{

    $result = $false

    try 
    {
        $dcs = (Get-ADDomainController -Filter * -ErrorAction Stop)
        if ($dcs.Count -gt 0) { $result = $true }
    }
    catch 
    {
        $result = $false
    }

    return $result
}