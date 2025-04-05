<#
    .SYNOPSIS
    This Cmdlet is used to get a list of all the Domain Controllers with the site name and OS type

    .DESCRIPTION
    Function to get a list of all Domain Controllers in a domain

    .EXAMPLE
    Get-ADAllDomainControllers

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>
Function Get-ADAllDomainControllers
{
    Get-ADDomainController -Filter * | `
        Select-Object Name, IsReadOnly, Operatingsystem, Domain, Site | `
        ForEach-Object `
    {
        $IPAddress = Resolve-DnsName $_.Name -ErrorAction SilentlyContinue
                            
        if ($_.IsReadOnly)
        {
            $Type = "ReadOnly"
        }
        else
        {
            $Type = "Writable"
        }
                            
        [PSCustomObject]@{
            Name   = $_.Name
            IP     = $IPAddress.IPAddress
            Type   = $Type
            OS     = $_.OperatingSystem
            Domain = $_.Domain
            Site   = $_.Site
        }
    }
}