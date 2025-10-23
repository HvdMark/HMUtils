<#
    .SYNOPSIS
    This Cmdlet is used to create a Hyper-V VM

    .DESCRIPTION
    Function to create a Hyper-V VM  (WinRM enabled)

    .PARAMETER HyperVHost
    Hyper-V host to connect to

    .PARAMETER VMName
    Hyper-V Name to create

    .PARAMETER vCPU
    Number of CPU's to add

    .PARAMETER vMEM
    Number of GB's of memory to add

    .PARAMETER vDiskC
    Size of the C drive (mandatory)

    .PARAMETER vDiskD
    Size of the D drive

    .PARAMETER vDiskE
    Size of the E drive

    .PARAMETER vSwitch
    Name of the vSwitch to use

    .PARAMETER ISO
    ISO to attach to the machine

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>
function Add-HypervVM
{
    param 
    (
        [Parameter(Mandatory = $true)]
        [string]$HyperVHost,

        [Parameter(Mandatory = $true)]
        [string]$VMName,

        [Parameter(Mandatory = $true)]
        [int]$VCPU,

        [Parameter(Mandatory = $true)]
        [int]$VMem,

        [Parameter(Mandatory = $true)]
        [int]$VDiskC,

        [Parameter(Mandatory = $false)]
        [Nullable[Int]]$VDiskD,

        [Parameter(Mandatory = $false)]
        [Nullable[Int]]$VDiskE,

        [Parameter(Mandatory = $true)]
        [string]$VSwitch,

        [Parameter(Mandatory = $false)]
        [string]$ISO = "C:\ISO\Server2022.iso"
    )

    $ScriptBlock = 
    {
        param 
        (
            [string]$VMName,
            [int]$VCPU,
            [int]$VMem,
            [int]$VDiskC,
            [int]$VDiskD,
            [int]$VDiskE,
            [string]$VSwitch,
            [string]$ISO
        )

        function WriteStep 
        {
            param 
            (
                [string]$Label,
                [string]$Value
            )

            $Output = '{0,-25}: {1,-47}' -f $Label, $Value
            Write-Host -ForegroundColor Green -NoNewline $Output
        }

        function WriteStatus 
        {
            param 
            (
                [string]$Value
            )
            Write-Host -ForegroundColor Yellow "[$Value]"
        }

        $ErrorActionPreference = 'Stop'

        try 
        {
            $VMPath = "E:\Virtual Machines"
            $VHDPath = "E:\Virtual Hard Disks"
            $VHDPathC = "$VHDPath\$($VMName)-C.vhdx"
            $VHDPathD = "$VHDPath\$($VMName)-D.vhdx"
            $VHDPathE = "$VHDPath\$($VMName)-E.vhdx"

            WriteStep "VM creation status" "START"
            Write-Host

            WriteStep "Checking folder" $VMPath
            if (-not (Test-Path -Path $VMPath)) 
            {
                New-Item -Path $VMPath -ItemType Directory | Out-Null
            }
            WriteStatus "Finished"

            WriteStep "Checking folder" $VHDPath
            if (-not (Test-Path -Path $VHDPath)) 
            {
                New-Item -Path $VHDPath -ItemType Directory | Out-Null
            }
            WriteStatus "Finished"

            WriteStep "Creating VM" $VMName
            if (Get-VM -Name $VMName -ErrorAction SilentlyContinue)
            {
                WriteStatus "Allready exists, can't continue"
                throw
            }
            else
            {
                New-VM -Name $VMName -MemoryStartupBytes ($VMem * 1GB) -Generation 2 -SwitchName $VSwitch -Path $VMPath | Out-Null
                WriteStatus "Finished"
            }

            WriteStep "Assigning CPUs" "$VCPU"
            Set-VMProcessor -VMName $VMName -Count $VCPU | Out-Null
            WriteStatus "Finished"

            WriteStep "Creating Disk C" "$VDiskC GB"
            if (Get-VHD -Path $VHDPathC -ErrorAction SilentlyContinue)
            {
                WriteStatus "Allready exists, can't continue"
                throw
            }
            else 
            {
                New-VHD -Path $VHDPathC -SizeBytes ($VDiskC * 1GB) -Dynamic | Out-Null
                Add-VMHardDiskDrive -VMName $VMName -Path $VHDPathC
                WriteStatus "Finished"
            }

            if ($VDiskD -gt 0)
            {
                WriteStep "Creating Disk D" "$VDiskD GB"
                if (Get-VHD -Path $VHDPathD -ErrorAction SilentlyContinue)
                {
                    WriteStatus "Allready exists, can't continue"
                    throw
                }
                else 
                {
                    New-VHD -Path $VHDPathD -SizeBytes ($VDiskD * 1GB) -Dynamic | Out-Null
                    Add-VMHardDiskDrive -VMName $VMName -Path $VHDPathD
                    WriteStatus "Finished"
                }
            }

            if ($VDiskE -gt 0)
            {
                WriteStep "Creating Disk E" "$VDiskE GB"
                if (Get-VHD -Path $VHDPathE -ErrorAction SilentlyContinue)
                {
                    WriteStatus "Allready exists, can't continue"
                    throw
                }
                else 
                {
                    New-VHD -Path $VHDPathE -SizeBytes ($VDiskE * 1GB) -Dynamic | Out-Null
                    Add-VMHardDiskDrive -VMName $VMName -Path $VHDPathE
                    WriteStatus "Finished"
                }
            }

            WriteStep "Attaching ISO" $ISO
            Add-VMDvdDrive -VMName $VMName -Path $ISO
            WriteStatus "Finished"

            WriteStep "Setting boot order" "DVD first"
            $VMFirmware = Get-VMFirmware -VMName $VMName
            Set-VMFirmware -VMName $VMName -FirstBootDevice ($VMFirmware.BootOrder | Where-Object { $_.Device -eq "CD" })
            WriteStatus "Finished"

            WriteStep "VM creation status" "END"
            Write-Host
        }
        catch 
        {
            Write-Host ""
            Write-Host ("ERROR".PadRight(25) + ": Failed to create VM '$VMName' on $env:COMPUTERNAME.")
            Write-Host ("DETAILS".PadRight(25) + ": $($_.Exception.Message)")
            throw $_
        }
    }

    try 
    {
        Invoke-Command -ComputerName $HyperVHost -ScriptBlock $ScriptBlock -ArgumentList $VMName, $VCPU, $VMem, $VDiskC, $VDiskD, $VDiskE, $VSwitch, $ISO -ErrorAction Stop
    }
    catch 
    {
        Write-Host ""
        Write-Host ("REMOTE EXECUTION FAILED".PadRight(25) + ": $($_.Exception.Message)")
    }
}