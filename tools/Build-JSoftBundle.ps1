param(
    [string]$OutputPath = (Join-Path (Split-Path -Parent $PSScriptRoot) "J-Soft-Bundle.ps1"),

    [string]$BundleUrl = "https://raw.githubusercontent.com/KiritoKazuto22/J-Soft/main/J-Soft-Bundle.ps1"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$rootPath = Split-Path -Parent $PSScriptRoot

function ConvertTo-JSoftBundleBase64 {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    $text = [System.IO.File]::ReadAllText($Path, [System.Text.UTF8Encoding]::new($false))
    $bytes = [System.Text.UTF8Encoding]::new($false).GetBytes($text)
    return [Convert]::ToBase64String($bytes)
}

function ConvertTo-JSoftBundleJsonBase64 {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    $json = [System.IO.File]::ReadAllText($Path, [System.Text.UTF8Encoding]::new($false))
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    return [Convert]::ToBase64String($bytes)
}

$moduleFiles = [ordered]@{
    Security = "src\Security\Security.ps1"
    Logging = "src\Logging\Logging.ps1"
    Catalog = "src\Applications\Catalog.ps1"
    Presets = "src\Applications\Presets.ps1"
    Winget = "src\PackageManagers\Winget.ps1"
    Chocolatey = "src\PackageManagers\Chocolatey.ps1"
    Installer = "src\Core\Installer.ps1"
    MainWindow = "src\UI\MainWindow.ps1"
}

$configFiles = [ordered]@{
    Settings = "config\settings.json"
    Applications = "config\applications.json"
    Categories = "config\categories.json"
    Presets = "config\presets.json"
}

foreach ($relativePath in @($moduleFiles.Values) + @($configFiles.Values)) {
    $fullPath = Join-Path $rootPath $relativePath
    if (-not (Test-Path -LiteralPath $fullPath)) {
        throw "Bundle-Quelle fehlt: $fullPath"
    }
}

$moduleBlock = [System.Text.StringBuilder]::new()
foreach ($entry in $moduleFiles.GetEnumerator()) {
    $encoded = ConvertTo-JSoftBundleBase64 -Path (Join-Path $rootPath $entry.Value)
    [void]$moduleBlock.AppendLine("`$script:JSoftBundleModules['$($entry.Key)'] = ConvertFrom-JSoftBundleBase64 -Value '$encoded'")
}

$configBlock = [System.Text.StringBuilder]::new()
foreach ($entry in $configFiles.GetEnumerator()) {
    $encoded = ConvertTo-JSoftBundleJsonBase64 -Path (Join-Path $rootPath $entry.Value)
    [void]$configBlock.AppendLine("    $($entry.Key) = (ConvertFrom-JSoftBundleBase64 -Value '$encoded' | ConvertFrom-Json)")
}

$bundleTemplate = @'
param(
    [switch]$ValidateOnly
)

# Bei irm | iex wird der param-Block nicht als Dateiparameter gebunden.
$validateOnlyVariable = Get-Variable -Name ValidateOnly -ErrorAction SilentlyContinue
if ($null -eq $validateOnlyVariable -or $null -eq $validateOnlyVariable.Value) {
    $ValidateOnly = $false
}

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$script:JSoftBundleUrl = "__BUNDLE_URL__"
$script:JSoftBundleDataRoot = Join-Path $env:LOCALAPPDATA "J-Soft"

function ConvertFrom-JSoftBundleBase64 {
    param(
        [Parameter(Mandatory)]
        [string]$Value
    )

    $bytes = [Convert]::FromBase64String($Value)
    return [Text.Encoding]::UTF8.GetString($bytes)
}

$script:JSoftBundleModules = [ordered]@{}
__MODULE_BLOCK__

$script:JSoftBundleConfig = [pscustomobject]@{
__CONFIG_BLOCK__
}

foreach ($moduleName in @("Security", "Logging", "Catalog", "Presets", "Winget", "Chocolatey", "Installer", "MainWindow")) {
    . ([scriptblock]::Create([string]$script:JSoftBundleModules[$moduleName]))
}

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
$isAdministrator = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdministrator) {
    $elevatedCommand = "& ([ScriptBlock]::Create((Invoke-RestMethod -Uri '$($script:JSoftBundleUrl)')))"
    if ($ValidateOnly) {
        $elevatedCommand += " -ValidateOnly"
    }
    $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($elevatedCommand))
    $powerShellPath = (Get-Command powershell.exe -ErrorAction Stop).Source
    Start-Process -FilePath $powerShellPath `
        -ArgumentList @("-NoProfile", "-ExecutionPolicy", "Bypass", "-EncodedCommand", $encodedCommand) `
        -Verb RunAs `
        -Wait | Out-Null
    return
}

$dataRoot = $script:JSoftBundleDataRoot
$dataConfigPath = Join-Path $dataRoot "config"
if (-not (Test-Path -LiteralPath $dataConfigPath)) {
    New-Item -Path $dataConfigPath -ItemType Directory -Force | Out-Null
}

$catalog = Import-JSoftCatalog `
    -ConfigPath $dataConfigPath `
    -EmbeddedConfig $script:JSoftBundleConfig `
    -PresetPath (Join-Path $dataConfigPath "presets.json")
$wingetStatus = Get-JSoftWingetStatus
$chocolateyStatus = Get-JSoftChocolateyStatus
$logPath = Initialize-JSoftLogger -RootPath $dataRoot -Settings $catalog.Settings -WingetVersion $wingetStatus.Version

$script:JSoft = [ordered]@{
    RootPath = $dataRoot
    MainScript = $script:JSoftBundleUrl
    Settings = $catalog.Settings
    Applications = @($catalog.Applications)
    AllApplications = @($catalog.AllApplications)
    Categories = @($catalog.Categories)
    Presets = @($catalog.Presets)
    WingetStatus = $wingetStatus
    ChocolateyStatus = $chocolateyStatus
    IsAdministrator = $isAdministrator
    Selected = [System.Collections.Generic.HashSet[string]]::new()
    Status = @{}
    CardControls = @{}
    PresetEditorSelected = [System.Collections.Generic.HashSet[string]]::new()
    PresetActiveCategory = "Alle Kategorien"
    PresetEditMode = $false
    BundleModules = $script:JSoftBundleModules
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
    Write-Output "J-Soft Bundle-Validierung erfolgreich."
    Write-Output ("Anwendungen: {0}" -f $script:JSoft.Applications.Count)
    Write-Output ("WinGet: {0} ({1})" -f $script:JSoft.WingetStatus.Version, $script:JSoft.WingetStatus.Message)
    return
}

$script:JSoft.Ui.Window.ShowDialog() | Out-Null
'@

$bundle = $bundleTemplate.Replace("__BUNDLE_URL__", $BundleUrl)
$bundle = $bundle.Replace("__MODULE_BLOCK__", $moduleBlock.ToString().TrimEnd())
$bundle = $bundle.Replace("__CONFIG_BLOCK__", $configBlock.ToString().TrimEnd())

$outputDirectory = Split-Path -Parent $OutputPath
if (-not (Test-Path -LiteralPath $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory -Force | Out-Null
}

$utf8Bom = [System.Text.UTF8Encoding]::new($true)
[System.IO.File]::WriteAllText($OutputPath, $bundle, $utf8Bom)
Write-Output ("J-Soft Bundle erstellt: {0}" -f $OutputPath)
