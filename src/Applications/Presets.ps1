function ConvertTo-JSoftPresetId {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $id = $Name.ToLowerInvariant()
    $id = $id -replace '[ä]', 'ae'
    $id = $id -replace '[ö]', 'oe'
    $id = $id -replace '[ü]', 'ue'
    $id = $id -replace 'ß', 'ss'
    $id = $id -replace '[^a-z0-9]+', '-'
    $id = $id.Trim('-')

    if ([string]::IsNullOrWhiteSpace($id)) {
        throw "Der Preset-Name erzeugt keine gültige ID."
    }

    return $id.Substring(0, [Math]::Min($id.Length, 63))
}

function Write-JSoftPresetsFile {
    param(
        [Parameter(Mandatory)]
        [string]$ConfigPath,

        [Parameter(Mandatory)]
        [object[]]$Presets
    )

    $path = Join-Path $ConfigPath "presets.json"
    $document = [ordered]@{
        schemaVersion = "0.1"
        presets = @($Presets | ForEach-Object {
            [ordered]@{
                id = [string]$_.id
                name = [string]$_.name
                description = [string]$_.description
                applications = @($_.applications | ForEach-Object { [string]$_ })
            }
        })
    }

    $json = $document | ConvertTo-Json -Depth 8
    $utf8Bom = [System.Text.UTF8Encoding]::new($true)
    [System.IO.File]::WriteAllText($path, $json + [Environment]::NewLine, $utf8Bom)
}
