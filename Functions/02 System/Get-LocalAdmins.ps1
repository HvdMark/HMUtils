<#
    .SYNOPSIS
    This Cmdlet is used to get a list of the local admins

    .DESCRIPTION
    Function to generate a list of local administratora

    .PARAMETER ComputerName
    Computername(s) to connect to

    .EXAMPLE
    Get-LocalAdmins -ComputerName <ComputerName>

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>
function Get-LocalAdmins
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string[]]$Computer = $env:COMPUTERNAME
    )

    $results = @()

    $ScriptBlock = { Get-LocalGroupMember -Group 'Administrators' -ErrorAction Stop | Select-Object Name, ObjectClass, PrincipalSource }

    foreach ($Comp in $Computer)
    {

        try
        {
            if ( ($Comp -eq $env:COMPUTERNAME) -or ($Comp -eq '127.0.0.1') )
            {
                # Run Get-LocalGroupMember on the local computer
                $members = & $ScriptBlock
            }
            else
            {
                # Run Get-LocalGroupMember on the target computer
                $members = Invoke-Command -ComputerName $Comp -ScriptBlock $ScriptBlock -ErrorAction Stop
            }

            foreach ($m in $members)
            {
                $results += [PSCustomObject]@{
                    ComputerName    = $Comp
                    Name            = $m.Name
                    ObjectClass     = $m.ObjectClass
                    PrincipalSource = $m.PrincipalSource
                }
            }
        }
        catch
        {
            # Return an object describing the error for that computer
            $results += [PSCustomObject]@{
                ComputerName    = $Computer
                Name            = $null
                ObjectClass     = 'Error'
                PrincipalSource = $_.Exception.Message
            }
        }
    }

    return $results
}
