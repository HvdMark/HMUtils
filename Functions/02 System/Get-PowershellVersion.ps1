<#
    .SYNOPSIS
    This Cmdlet is used to get the PowerShell version

    .DESCRIPTION
    get the PowerShell version

    .EXAMPLE
    Get-WifiPasswords $Computername

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>

function Get-PowerShellVersion
{
    [CmdletBinding()]
    param (
        [string[]]
        $ComputerName
    )
    
    begin
    {
        $Session = New-PSSession -ComputerName $ComputerName
    }
    
    process
    {
        Invoke-Command -Session $Session -ScriptBlock {
            $PSVersionTable.PSVersion
        }
    }
    
    end
    {
        Get-PSSession | Remove-PSSession
    }
}