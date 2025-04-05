<#
    .SYNOPSIS
    This script output all the groups a user is a member of

    .DESCRIPTION
    This script output all the groups a user is a member of

    .PARAMETER SamAccountName
    SamAccountName used to identify the user

    .EXAMPLE
    Copy-ADGroupsFromUserToUser -FromSamAccountName <SamAccountName> -ToSamAccountName <SamAccountName>

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>

# Import the AD module
Import-Module ActiveDirectory

function Copy-ADGroupsFromUserToUser
{
    param (
        [Parameter(Mandatory = $true)]
        [string]$FromSamAccountName,

        [Parameter(Mandatory = $true)]
        [string]$ToSamAccountName
    )


    # Get the domain controller
    try
    {
        $DC = (Get-ADDomainController).Name
    }
    catch 
    {
        throw $_
        exit 1
    }

    $FromUser = Get-ADUser -Filter { SamAccountName -eq $FromSamAccountName } -Server $DC -ErrorAction SilentlyContinue
    if (-not $FromUser)
    {
        Write-Host "Error: $FromSamAccountName not found in the domain." -ForegroundColor Red
        exit 1
    }

    $ToUser = Get-ADUser -Filter { SamAccountName -eq $ToSamAccountName } -Server $DC -ErrorAction SilentlyContinue
    if (-not $ToUser)
    {
        Write-Host "Error: $ToSamAccountName not found in the domain." -ForegroundColor Red
        exit 1
    }

    if ($FromUser -eq $ToUser)
    {
        Write-Host "Error: Can't copy to the same user" -ForegroundColor Red
        exit 1
    }

    # Get the DN for comparison
    $FromGroups = Get-ADPrincipalGroupMembership -Identity $FromSamAccountName  | Select-Object -ExpandProperty DistinguishedName
    $ToGroups = Get-ADPrincipalGroupMembership -Identity $ToSamAccountName | Select-Object -ExpandProperty DistinguishedName

    $MissingGroups = $FromGroups | Where-Object { $_ -notin $ToGroups }

    foreach ($Group in $MissingGroups)
    {
        try 
        {
            Add-ADGroupMember -Identity $Group -Members $ToSamAccountName
            Write-Host "Added $ToSamAccountName to group: $($group | Get-ADGroup | Select-Object -ExpandProperty SamAccountName)" -ForegroundColor Green
        }
        catch 
        {
            Write-Host "Failed to add $ToSamAccountName to group: $group. Error: $_" -ForegroundColor Red
        }
    }
}