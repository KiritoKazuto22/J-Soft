if (-not (Get-Variable -Name JSoftLogPath -Scope Script -ErrorAction SilentlyContinue)) {
    $script:JSoftLogPath = $null
}

function Initialize-JSoftLogger {
    param(
        [Parameter(Mandatory)]
        [string]$RootPath,

        [Parameter(Mandatory)]
        [pscustomobject]$Settings,

        [string]$WingetVersion = "unbekannt"
    )

    $logDirectoryName = if ([string]::IsNullOrWhiteSpace([string]$Settings.logDirectory)) { "logs" } else { [string]$Settings.logDirectory }
    $script:JSoftLogDirectory = Join-Path $RootPath $logDirectoryName
    $script:JSoftLogPath = Join-Path $script:JSoftLogDirectory ("jsoft_{0}.log" -f (Get-Date -Format "yyyy-MM-dd_HH-mm-ss"))

    if (-not (Test-Path -LiteralPath $script:JSoftLogDirectory)) {
        New-Item -Path $script:JSoftLogDirectory -ItemType Directory -Force | Out-Null
    }

    Write-JSoftLog -Message ("J-Soft Version: {0}" -f $Settings.version)
    Write-JSoftLog -Message ("Windows Version: {0}" -f [Environment]::OSVersion.VersionString)
    Write-JSoftLog -Message ("WinGet Version: {0}" -f $WingetVersion)

    return $script:JSoftLogPath
}

function Write-JSoftLog {
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet("INFO", "WARN", "ERROR")]
        [string]$Level = "INFO"
    )

    if ([string]::IsNullOrWhiteSpace([string]$script:JSoftLogPath)) {
        return
    }

    $line = "[{0}] [{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"), $Level, $Message
    Add-Content -LiteralPath $script:JSoftLogPath -Value $line -Encoding UTF8
}
