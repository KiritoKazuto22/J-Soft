Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

. (Join-Path $root "src\Security\Security.ps1")
. (Join-Path $root "src\Applications\Catalog.ps1")

$catalog = Import-JSoftCatalog -ConfigPath (Join-Path $root "config")

if ($catalog.Applications.Count -eq 0) {
    throw "Der Anwendungskatalog ist leer."
}

$ids = @{}
foreach ($app in $catalog.AllApplications) {
    if ($ids.ContainsKey($app.id)) {
        throw "Doppelte Anwendungs-ID: $($app.id)"
    }
    $ids[$app.id] = $true
}

foreach ($preset in $catalog.Presets) {
    foreach ($appId in $preset.applications) {
        if (-not $ids.ContainsKey($appId)) {
            throw "Preset '$($preset.name)' referenziert unbekannte Anwendung '$appId'."
        }
    }
}

Write-Output "J-Soft Konfigurationstest erfolgreich."
Write-Output ("Aktive Anwendungen: {0}" -f $catalog.Applications.Count)
Write-Output ("Presets: {0}" -f $catalog.Presets.Count)
