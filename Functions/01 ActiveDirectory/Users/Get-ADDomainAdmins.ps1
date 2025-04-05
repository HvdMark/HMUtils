<#
    .SYNOPSIS
    Get a list of users that have domain admin privileges

    .DESCRIPTION
    Get a list of users that have domain admin privileges

    .EXAMPLE
    Get-ADDomainAdmins

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>

Import-Module ActiveDirectory


function Get-ADDomainAdmins
{
    $DomainAdmins = @()

    foreach ($DomainAdminGroups in @("Domain Admins", "Enterprise Admins", "Administrators"))
    {
        # Get all members of each admin group
        $Members = Get-ADGroupMember -Identity $DomainAdminGroups -Recursive

        foreach ($Member in $Members) 
        {
            # Get only user objects
            if ($Member.objectClass -eq "user") 
            {
                # Check if the SamAccountName allready exists, if not add it
                if (-not ($DomainAdmins.SamAccountName -contains ($Member.SamAccountName)))
                {
                    # Get detailed user information and add to the adminUsers array
                    $user = Get-ADUser -Identity $member.SamAccountName -Properties *
                    $DomainAdmins += $user
                }

            }
        }
    }
$DomainAdmins | Select-Object Name, SamAccountName, DistinguishedName
}



#$DomainAdmins = (Get-ADGroupMember -Identity 'Domain Admins').DistinguishedName
#$DomainControllers = (Get-ADDomainController -Filter *).HostName
