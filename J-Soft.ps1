param(
    [switch]$ValidateOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$rootPath = Split-Path -Parent $MyInvocation.MyCommand.Path

. (Join-Path $rootPath "src\Security\Security.ps1")

if (-not (Test-JSoftAdministrator)) {
    $elevationArguments = @()
    if ($ValidateOnly) {
        $elevationArguments = @("-ValidateOnly")
    }

    try {
        Start-JSoftElevated -ScriptPath $MyInvocation.MyCommand.Path -Arguments $elevationArguments | Out-Null
    } catch {
        throw "J-Soft benötigt Administratorrechte. Der erhöhte Start wurde abgebrochen: $($_.Exception.Message)"
    }

    return
}

$configPath = Join-Path $rootPath "config"

. (Join-Path $rootPath "src\Logging\Logging.ps1")
. (Join-Path $rootPath "src\Applications\Catalog.ps1")
. (Join-Path $rootPath "src\Applications\Presets.ps1")
. (Join-Path $rootPath "src\PackageManagers\Winget.ps1")
. (Join-Path $rootPath "src\PackageManagers\Chocolatey.ps1")
. (Join-Path $rootPath "src\Core\Installer.ps1")
. (Join-Path $rootPath "src\UI\MainWindow.ps1")

$catalog = Import-JSoftCatalog -ConfigPath $configPath
$wingetStatus = Get-JSoftWingetStatus
$chocolateyStatus = Get-JSoftChocolateyStatus
$logPath = Initialize-JSoftLogger -RootPath $rootPath -Settings $catalog.Settings -WingetVersion $wingetStatus.Version

$script:JSoft = [ordered]@{
    RootPath = $rootPath
    MainScript = $MyInvocation.MyCommand.Path
    Settings = $catalog.Settings
    Applications = @($catalog.Applications)
    AllApplications = @($catalog.AllApplications)
    Categories = @($catalog.Categories)
    Presets = @($catalog.Presets)
    WingetStatus = $wingetStatus
    ChocolateyStatus = $chocolateyStatus
    IsAdministrator = Test-JSoftAdministrator
    Selected = [System.Collections.Generic.HashSet[string]]::new()
    Status = @{}
    CardControls = @{}
    PresetEditorSelected = [System.Collections.Generic.HashSet[string]]::new()
    PresetActiveCategory = "Alle Kategorien"
    PresetEditMode = $false
    History = [System.Collections.ArrayList]::new()
    InstallationRunning = $false
    InstallQueue = $null
    InstallRunspace = $null
    InstallTimer = $null
    Ui = $null
    LogPath = $logPath
}

Write-JSoftLog -Message ("Anwendungen geladen: {0}" -f $script:JSoft.Applications.Count)
Write-JSoftLog -Message ("Administratorrechte: {0}" -f $script:JSoft.IsAdministrator)
Write-JSoftLog -Message ("WinGet Status: {0}" -f $script:JSoft.WingetStatus.Message)

Initialize-JSoftUi

if ($ValidateOnly) {
    Write-Output "J-Soft Validierung erfolgreich."
    Write-Output ("Anwendungen: {0}" -f $script:JSoft.Applications.Count)
    Write-Output ("WinGet: {0} ({1})" -f $script:JSoft.WingetStatus.Version, $script:JSoft.WingetStatus.Message)
    return
}

$script:JSoft.Ui.Window.ShowDialog() | Out-Null
