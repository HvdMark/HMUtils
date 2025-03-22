<#
    .SYNOPSIS
    This Cmdlet is used to check the connection to a specified Domain Controller

    .DESCRIPTION
    Function to test a connection to a Domain Controller

    .PARAMETER DomainController
    DomainController to connect to

    .EXAMPLE
    Test-ADDomainController -DomainController <Servername>

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>

function Test-DomainController
{
    [CmdletBinding()]
    param 
    (
        [Parameter(
            Position=0,
            Mandatory=$true,
            HelpMessage="Specify the Domain Controller to test"
        )]
        [string]$DomainController
    )

    $result = $false

    try
    {
        # Try to get the domain controller by name
        Get-ADDomainController -Server $DomainController -ErrorAction Stop
        $result = $true
    }
    catch
    {
        # If there's an error, $result remains $false
        $result = $false
    }

    return $result
}
