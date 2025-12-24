
function Test-ApplicationInstalled
{
    param 
    (
        [Parameter(Mandatory = $true)]
        [string] $ApplicationName
    )  

    try 
    {
        # Get the info from Uninstall
        $IsInstalled = ($null -ne (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -imatch $ApplicationName }))
        if (-not $IsInstalled)
        {
            $IsInstalled = ($null -ne (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -imatch $ApplicationName }))
        }

        if ($IsInstalled) { return $true } else { return $false }
    }

    catch 
    {
        Write-Host "Error Exception:[$_.Exception.Message]"
    }
}
