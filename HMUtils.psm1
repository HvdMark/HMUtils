Write-Host "Importing HMUtils"

# Get all Function *.ps1 files.
$Functions = @( Get-ChildItem -Path $PSScriptRoot\*.ps1 -Recurse -ErrorAction SilentlyContinue )
   
# Loop through
Foreach ($Function in $Functions)
{
    Try
    {
        . $Function
        Write-Verbose ">> $Function"
    }
    Catch
    {
        Write-Verbose "Failed to import Function $($Function.fullname): $_"
    }
}

# Export all the Functions modules
Export-ModuleMember -Function $Functions.Basename
