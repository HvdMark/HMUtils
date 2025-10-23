Write-Verbose "--- Environment checks -------------------------------------------------------"
$ManifestFile = Join-Path $PSScriptRoot "HMutils.psd1"
$ModuleInfo = Test-ModuleManifest -Path $ManifestFile
Write-Verbose "Importing module                 : HMUtils $($ModuleInfo.Version)"

# Detect if machine is a Domain Controller
$ComputerSystem = Get-CimInstance -Class Win32_ComputerSystem -ErrorAction SilentlyContinue
$IsDC = $false
if ($ComputerSystem -and $null -ne $ComputerSystem.DomainRole)
{
    $IsDC = [bool]($ComputerSystem.DomainRole -ge 4)
}
Write-Verbose "Machine is a Domain Controller   : $IsDC"

# Detect AD module presence
$HasADModule = [bool](Get-Module -ListAvailable -Name ActiveDirectory)
Write-Verbose "Machine has RSAT tools installed : $HasADModule"

Write-Verbose "--- Checking folders ---------------------------------------------------------"

$RootFolder = Join-Path $PSScriptRoot "Functions"
if (-not ($HasADModule -or $IsDC))
{
    $ExcludedFolder = "01 ActiveDirectory"
    $FoldersList = @(Get-ChildItem -Directory $RootFolder | Where-Object Name -NotMatch $ExcludedFolder -ErrorAction SilentlyContinue)
}
else
{
    $FoldersList = @(Get-ChildItem -Directory $RootFolder -ErrorAction SilentlyContinue)
}

# Collect all .ps1 files in the folders (recursively)
$FunctionsList = foreach ($Folder in $FoldersList)
{
    Get-ChildItem -Path $Folder.FullName -Filter "*.ps1" -Recurse -ErrorAction SilentlyContinue
}

#Dot source the files
foreach ($import in @($FunctionsList))
{
    try
    {
        Write-Verbose "Importing function: $($import.fullname)"
        . $import.fullname
    }
    catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# # Export Public functions
Write-Verbose "Exporting function: $($FunctionsList.Basename)"
Export-ModuleMember -Function $FunctionsList.Basename

