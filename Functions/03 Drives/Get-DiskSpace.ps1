<#
    .SYNOPSIS
    This Cmdlet is used to get a list of all the drives and their info

    .DESCRIPTION
    Function to get a list of all drives on a system

    .EXAMPLE
    Get-DiskSpace

    .PARAMETER ComputerName
    Computername to connect to

    .NOTES
    Author : H. van der Mark
    Email  : Herby@vandermark.org
    Version: 1.0
 
    History:
    1.0     19-10-2025  HM  First version
    1.1     21-10-2025  HM  Changed script to have a function
    
    .LINK
    https://github.com/HvdMark/HMUtils/
#>

function Get-DiskSpace
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )

    # Loop through all computernames added
    foreach ($cn in $ComputerName)
    {

        try
        {
            # Check if the computername is the local machine of localhost
            if ($cn -eq $env:COMPUTERNAME -or $cn -eq 'localhost')
            {
                $disks = Get-CimInstance -ClassName Win32_LogicalDisk -ErrorAction Stop

            }
            else
            {
                # if not matches above then it must be a remote computer
                $disks = Invoke-Command -ComputerName $ComputerName -ScriptBlock { Get-CimInstance -ClassName Win32_LogicalDisk } -ErrorAction Stop
            }

        }
        catch 
        {
            # Give warning when CIM instance can't be queried
            Write-Warning "Unable to query CimInstance: $_"
            continue
        }

        # Loop through all disks
        foreach ($d in $disks)
        {
            # Check the drive type
            switch ([int]$d.DriveType) 
            {
                0 { $driveType = 'Unknown' }
                1 { $driveType = 'No RootDir' }
                2 { $driveType = 'Removable' }
                3 { $driveType = 'Local Disk' }
                4 { $driveType = 'Network' }
                5 { $driveType = 'CD-ROM' }
                6 { $driveType = 'RAM Disk' }
                Default { $driveType = 'Unknown' }
            }

            # Calculate the Total Size of the disk
            $TotalGB = if ($d.Size) { [math]::Round($d.Size / 1GB, 2) } else { $null }

            # Calculate the Free Size of the disk
            $FreeGB = if ($d.FreeSpace) { [math]::Round($d.FreeSpace / 1GB, 2) } else { $null }

            # Calculate the Used Size of the disk
            $UsedGB = if (($d.Size) -and ($d.FreeSpace))
            { [math]::Round($($d.Size - $d.FreeSpace) / 1GB, 2) } else { $null }

            # Calculate the Free percentage of the disk
            $FreePct = if ($d.Size -and $d.FreeSpace) { [math]::Round(($d.FreeSpace / $d.Size) * 100, 2) } else { $null }

            # Fill the object
            [PSCustomObject]@{
                Name         = $d.DeviceID
                VolumeName   = $d.VolumeName
                DriveType    = $driveType
                FileSystem   = $d.FileSystem
                TotalGB      = if ($null -ne $TotalGB  ) { "{0:N2}" -f $TotalGB } else { "" }
                UsedGB       = if ($null -ne $UsedGB   ) { "{0:N2}" -f $UsedGB } else { "" }
                FreeGB       = if ($null -ne $FreeGB   ) { "{0:N2}" -f $FreeGB } else { "" }
                FreePct      = if ($null -ne $FreePct  ) { "{0:N2}" -f $FreePct } else { "" }
                ProviderName = $d.ProviderName
            }
        }
    }
}