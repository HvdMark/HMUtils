Import-Module ActiveDirectory
<#
    .SYNOPSIS
    This Cmdlet is used to get a list of all servers in the domain

    .DESCRIPTION
    This Cmdlet is used to get a list of all servers in the domain

    .EXAMPLE
    Get-ADServers

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>
function Get-ADServers
{

    # Get the current domain
    $Domain = (Get-ADDomain).DNSRoot    
    # Find the closest/best domain controller automatically
    $DC = Get-ADDomainController -DomainName $Domain -Discover -NextClosestSite

    $DCName = $DC.HostName[0]

    # Query servers using that DC
    Get-ADComputer -Filter { OperatingSystem -like "*Windows Server*" } -Properties OperatingSystem, IPv4Address, DNSHostName, DistinguishedName -Server $DCName | ForEach-Object {
        [pscustomobject]@{
            DNSName            = $_.DNSHostName
            IP                 = $_.IPv4Address
            "Operating System" = $_.OperatingSystem
            Domain             = $Domain
        }
    }
}
