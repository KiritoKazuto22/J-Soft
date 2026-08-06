function Read-JSoftJsonFile {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Datei nicht gefunden: $Path"
    }

    try {
        return Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
        throw "JSON konnte nicht gelesen werden ($Path): $($_.Exception.Message)"
    }
}

function Test-JSoftApplicationCatalog {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Catalog
    )

    $errors = [System.Collections.Generic.List[string]]::new()

    if (-not $Catalog.PSObject.Properties.Name.Contains("schemaVersion")) {
        $errors.Add("applications.json enthält keine schemaVersion.")
    }
    if (-not $Catalog.PSObject.Properties.Name.Contains("applications")) {
        $errors.Add("applications.json enthält keine applications-Liste.")
        return $errors
    }

    $ids = @{}
    foreach ($app in @($Catalog.applications)) {
        foreach ($field in @("id", "name", "description", "category", "packageManager", "packageId", "enabled", "requiresAdmin")) {
            if (-not $app.PSObject.Properties.Name.Contains($field)) {
                $errors.Add("Anwendung ohne Pflichtfeld '$field'.")
            }
        }

        if ($app.id -and $ids.ContainsKey($app.id)) {
            $errors.Add("Doppelte Anwendungs-ID: $($app.id)")
        } elseif ($app.id) {
            $ids[$app.id] = $true
        }

        if ($app.id -and $app.id -notmatch '^[a-z0-9][a-z0-9._-]{1,63}$') {
            $errors.Add("Ungültige Anwendungs-ID: $($app.id)")
        }
        if ($app.packageManager -and $app.packageManager -notin @("winget", "chocolatey")) {
            $errors.Add("Ungültiger Paketmanager für $($app.id): $($app.packageManager)")
        }
        if ($app.packageId -and -not (Test-JSoftPackageId -PackageId ([string]$app.packageId))) {
            $errors.Add("Ungültige Paket-ID für $($app.id): $($app.packageId)")
        }
        if ($app.PSObject.Properties.Name.Contains("packageSource") -and $app.packageSource -notin @("winget", "msstore")) {
            $errors.Add("Ungültige WinGet-Quelle für $($app.id): $($app.packageSource)")
        }
    }

    return $errors
}

function Import-JSoftCatalog {
    param(
        [Parameter(Mandatory)]
        [string]$ConfigPath
    )

    $settings = Read-JSoftJsonFile -Path (Join-Path $ConfigPath "settings.json")
    $applications = Read-JSoftJsonFile -Path (Join-Path $ConfigPath "applications.json")
    $categories = Read-JSoftJsonFile -Path (Join-Path $ConfigPath "categories.json")
    $presets = Read-JSoftJsonFile -Path (Join-Path $ConfigPath "presets.json")

    $validationErrors = @(Test-JSoftApplicationCatalog -Catalog $applications)
    if ($validationErrors.Count -gt 0) {
        throw "applications.json ist ungueltig:`n$($validationErrors -join "`n")"
    }

    return [pscustomobject]@{
        Settings = $settings
        Applications = @($applications.applications | Where-Object { $_.enabled -eq $true } | Sort-Object category, name)
        AllApplications = @($applications.applications)
        Categories = @($categories.categories | Sort-Object order, name)
        Presets = @($presets.presets | Sort-Object name)
    }
}
