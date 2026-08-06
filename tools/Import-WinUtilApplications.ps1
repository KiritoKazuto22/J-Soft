param(
    [string]$ReferencePath = (Join-Path (Split-Path -Parent $PSScriptRoot) "winutil.ps1"),
    [string]$OutputPath = (Join-Path (Split-Path -Parent $PSScriptRoot) "config\applications.json")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ReferencePath)) {
    throw "Referenzdatei nicht gefunden: $ReferencePath"
}

$rawReference = Get-Content -LiteralPath $ReferencePath -Raw -Encoding UTF8
$match = [regex]::Match(
    $rawReference,
    '\$sync\.configs\.applications\s*=\s*@''(?<json>.*?)\r?\n''@',
    [System.Text.RegularExpressions.RegexOptions]::Singleline
)

if (-not $match.Success) {
    throw "Der strukturierte Anwendungskatalog wurde in der Referenzdatei nicht gefunden."
}

$referenceCatalog = $match.Groups["json"].Value | ConvertFrom-Json
$existingCatalog = $null
if (Test-Path -LiteralPath $OutputPath) {
    $existingCatalog = Get-Content -LiteralPath $OutputPath -Raw -Encoding UTF8 | ConvertFrom-Json
}

$existingById = @{}
foreach ($existing in @($existingCatalog.applications)) {
    $existingById[[string]$existing.id] = $existing
}

$categoryMap = @{
    "Browsers" = "Browser"
    "Communications" = "Kommunikation"
    "Development" = "Entwicklung"
    "Games" = "Gaming"
    "Microsoft Tools" = "Microsoft"
    "Multimedia Tools" = "Medien"
    "Pro Tools" = "Techniker"
    "Selfhosted Tools" = "Self-Hosting"
    "Utilities" = "Werkzeuge"
}
$idAliases = @{
    "notepadplus" = "notepadplusplus"
}
$legacyDescriptions = @{
    "7zip" = "Werkzeug zum Packen und Entpacken von Dateien."
    "firefox" = "Freier Webbrowser von Mozilla."
    "chrome" = "Webbrowser von Google."
    "notepadplusplus" = "Leichter Text- und Code-Editor."
    "vlc" = "Freier Mediaplayer für viele Audio- und Videoformate."
    "git" = "Versionsverwaltung für Softwareentwicklung."
    "vscode" = "Quellcode-Editor von Microsoft."
    "powershell" = "Aktuelle plattformübergreifende PowerShell-Version."
    "terminal" = "Moderner Terminal-Host für Windows."
    "putty" = "SSH- und Telnet-Client für technische Administration."
    "winscp" = "SFTP-, SCP- und FTP-Client für Dateiübertragungen."
    "everything" = "Schnelle lokale Dateisuche für Windows."
    "steam" = "Gaming-Plattform und Spielebibliothek von Valve."
    "discord" = "Kommunikations-App für Communities, Gaming und Teams."
    "obs" = "Software für Bildschirmaufnahme und Livestreaming."
}
$descriptionTemplates = @{
    "Browser" = "{0} ist ein Webbrowser für Windows."
    "Entwicklung" = "{0} ist ein Entwicklungswerkzeug für Windows."
    "Gaming" = "{0} ist eine Anwendung für Gaming und Unterhaltung unter Windows."
    "Kommunikation" = "{0} ist eine Kommunikationsanwendung für Windows."
    "Medien" = "{0} ist eine Anwendung für Audio, Video oder andere Medien unter Windows."
    "Microsoft" = "{0} ist eine Microsoft-Anwendung für Windows."
    "Self-Hosting" = "{0} ist ein Werkzeug für selbst gehostete Dienste und Server."
    "Techniker" = "{0} ist ein technisches Werkzeug für Administration und Systemarbeit."
    "Werkzeuge" = "{0} ist ein praktisches Werkzeug für Windows."
}

$applications = foreach ($property in $referenceCatalog.PSObject.Properties) {
    $source = $property.Value
    $id = ([string]$property.Name -replace '^WPFInstall', '').ToLowerInvariant()
    $id = $id -replace '[^a-z0-9._-]', '-'
    if ($idAliases.ContainsKey($id)) {
        $id = $idAliases[$id]
    }

    if ($id -notmatch '^[a-z0-9][a-z0-9._-]{1,63}$') {
        throw "Ungueltige erzeugte Anwendungs-ID: $id"
    }

    $packageId = [string]$source.winget
    $packageSource = "winget"
    if ($packageId -match '^msstore:(.+)$') {
        $packageSource = "msstore"
        $packageId = $Matches[1]
    }

    $chocolateyId = if ($source.PSObject.Properties.Name -contains "choco") { [string]$source.choco } else { "" }
    if ($chocolateyId -eq "na") {
        $chocolateyId = ""
    }

    $existing = $existingById[$id]
    $category = if ($existing) { [string]$existing.category } elseif ($categoryMap.ContainsKey([string]$source.category)) { $categoryMap[[string]$source.category] } else { [string]$source.category }
    $description = if ($legacyDescriptions.ContainsKey($id)) { $legacyDescriptions[$id] } elseif ($descriptionTemplates.ContainsKey($category)) { $descriptionTemplates[$category] -f [string]$source.content } else { "{0} ist eine installierbare Anwendung für Windows." -f [string]$source.content }
    [ordered]@{
        id = $id
        name = if ($existing) { [string]$existing.name } else { [string]$source.content }
        description = $description
        category = $category
        packageManager = "winget"
        packageId = $packageId
        packageSource = $packageSource
        chocolateyPackageId = $chocolateyId
        website = [string]$source.link
        isFoss = [bool]$source.foss
        enabled = $true
        requiresAdmin = if ($existing) { [bool]$existing.requiresAdmin } else { $false }
    }
}

$catalog = [ordered]@{
    schemaVersion = "0.2"
    applications = @($applications | Sort-Object category, name)
}

$outputDirectory = Split-Path -Parent $OutputPath
if (-not (Test-Path -LiteralPath $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

$json = $catalog | ConvertTo-Json -Depth 8
[System.IO.File]::WriteAllText($OutputPath, $json + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))

Write-Output ("J-Soft-Katalog aktualisiert: {0} Anwendungen" -f $catalog.applications.Count)
Write-Output ("Quelle: {0}" -f $ReferencePath)
Write-Output ("Ziel: {0}" -f $OutputPath)
