function Get-JSoftWingetStatus {
    $status = [ordered]@{
        IsInstalled = $false
        Version = "nicht gefunden"
        SourceAvailable = $false
        Message = ""
    }

    $wingetCommand = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $wingetCommand) {
        $status.Message = "WinGet wurde nicht gefunden. Bitte App Installer aus dem Microsoft Store installieren."
        return [pscustomobject]$status
    }

    $status.IsInstalled = $true
    try {
        $status.Version = (& winget --version 2>&1 | Select-Object -First 1)
    } catch {
        $status.Message = "WinGet-Version konnte nicht gelesen werden: $($_.Exception.Message)"
        return [pscustomobject]$status
    }

    try {
        $sourceOutput = & winget source list 2>&1
        $status.SourceAvailable = ($LASTEXITCODE -eq 0 -and ($sourceOutput -match "winget"))
        $status.Message = if ($status.SourceAvailable) { "WinGet bereit." } else { "WinGet-Quelle konnte nicht bestaetigt werden." }
    } catch {
        $status.Message = "WinGet-Quelle konnte nicht abgefragt werden: $($_.Exception.Message)"
    }

    return [pscustomobject]$status
}

function Test-JSoftWingetPackageInstalled {
    param(
        [Parameter(Mandatory)]
        [string]$PackageId,

        [ValidateSet("winget", "msstore")]
        [string]$Source = "winget"
    )

    $arguments = @(
        "list",
        "--id", $PackageId,
        "--exact",
        "--source", $Source,
        "--accept-source-agreements",
        "--disable-interactivity"
    )
    $output = & winget @arguments 2>&1
    if ($LASTEXITCODE -ne 0) {
        return $false
    }

    $text = ($output | Out-String)
    if ($text -match "Keine installierten Pakete|No installed package|No package found") {
        return $false
    }

    return ($text -match [regex]::Escape($PackageId))
}

function Install-JSoftWingetPackage {
    param(
        [Parameter(Mandatory)]
        [string]$PackageId,

        [ValidateSet("winget", "msstore")]
        [string]$Source = "winget"
    )

    $arguments = @(
        "install",
        "--id", $PackageId,
        "--exact",
        "--source", $Source,
        "--accept-package-agreements",
        "--accept-source-agreements",
        "--silent",
        "--disable-interactivity"
    )

    $output = & winget @arguments 2>&1
    $exitCode = $LASTEXITCODE

    return [pscustomobject]@{
        Arguments = $arguments
        ExitCode = $exitCode
        Output = ($output | Out-String).Trim()
        Success = ($exitCode -eq 0)
    }
}
