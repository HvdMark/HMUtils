# Get all Function *.ps1 files.
$Functions = @( Get-ChildItem -Path $PSScriptRoot\*.ps1 -Recurse -ErrorAction SilentlyContinue )
   
# Loop through
Foreach ($Function in $Functions)
{
    Try
    {
        . $Function
        Write-Host ">> $Function"
    }
    Catch
    {
        Write-Verbose -Message "Failed to import Function $($Function.fullname): $_"
    }
}

# Export all the Functions modules
Export-ModuleMember -Function $Functions.Basename
