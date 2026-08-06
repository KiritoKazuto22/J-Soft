function Get-JSoftChocolateyStatus {
    $command = Get-Command choco -ErrorAction SilentlyContinue
    if (-not $command) {
        return [pscustomobject]@{
            IsInstalled = $false
            Version = "nicht gefunden"
            Message = "Chocolatey ist nicht installiert."
        }
    }

    $version = (& choco --version 2>&1 | Select-Object -First 1)
    return [pscustomobject]@{
        IsInstalled = $true
        Version = $version
        Message = "Chocolatey bereit."
    }
}

function Install-JSoftChocolateyPackage {
    param(
        [Parameter(Mandatory)]
        [string]$PackageId
    )

    $arguments = @("install", $PackageId, "-y", "--no-progress", "--limit-output")
    $output = & choco @arguments 2>&1
    $exitCode = $LASTEXITCODE

    return [pscustomobject]@{
        Arguments = $arguments
        ExitCode = $exitCode
        Output = ($output | Out-String).Trim()
        Success = ($exitCode -eq 0)
    }
}
