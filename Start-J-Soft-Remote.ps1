param(
    [switch]$ValidateOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repository = "https://github.com/KiritoKazuto22/J-Soft"
$archiveUri = "$repository/archive/refs/heads/main.zip"
$temporaryId = [Guid]::NewGuid().ToString("N")
$archivePath = Join-Path ([System.IO.Path]::GetTempPath()) "J-Soft-$temporaryId.zip"
$extractPath = Join-Path ([System.IO.Path]::GetTempPath()) "J-Soft-$temporaryId"

try {
    Write-Host "J-Soft wird aus GitHub geladen und nur vorübergehend gestartet..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $archiveUri -OutFile $archivePath -UseBasicParsing
    Expand-Archive -LiteralPath $archivePath -DestinationPath $extractPath -Force

    $projectPath = Get-ChildItem -LiteralPath $extractPath -Directory | Select-Object -First 1
    if (-not $projectPath) {
        throw "Das GitHub-Archiv enthält keinen gültigen J-Soft-Projektordner."
    }

    $startScript = Join-Path $projectPath.FullName "Start-J-Soft.ps1"
    if (-not (Test-Path -LiteralPath $startScript)) {
        throw "Start-J-Soft.ps1 wurde im GitHub-Archiv nicht gefunden."
    }

    $isAdministrator = ([Security.Principal.WindowsPrincipal]::new(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($isAdministrator) {
        if ($ValidateOnly) {
            & $startScript -ValidateOnly
        } else {
            & $startScript
        }
    } else {
        $powerShellPath = (Get-Command powershell.exe -ErrorAction Stop).Source
        $quotedStartScript = '"{0}"' -f $startScript
        $arguments = @(
            "-NoProfile",
            "-ExecutionPolicy", "Bypass",
            "-File", $quotedStartScript
        )
        if ($ValidateOnly) {
            $arguments += "-ValidateOnly"
        }

        Start-Process -FilePath $powerShellPath `
            -ArgumentList $arguments `
            -WorkingDirectory $projectPath.FullName `
            -Verb RunAs `
            -Wait | Out-Null
    }
} finally {
    if (Test-Path -LiteralPath $extractPath) {
        Remove-Item -LiteralPath $extractPath -Recurse -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path -LiteralPath $archivePath) {
        Remove-Item -LiteralPath $archivePath -Force -ErrorAction SilentlyContinue
    }
}
