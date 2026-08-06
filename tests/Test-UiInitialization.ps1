Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$rootPath = Split-Path -Parent $PSScriptRoot
. (Join-Path $rootPath "src\Security\Security.ps1")
. (Join-Path $rootPath "src\Logging\Logging.ps1")
. (Join-Path $rootPath "src\Applications\Catalog.ps1")
. (Join-Path $rootPath "src\Applications\Presets.ps1")
. (Join-Path $rootPath "src\PackageManagers\Winget.ps1")
. (Join-Path $rootPath "src\PackageManagers\Chocolatey.ps1")
. (Join-Path $rootPath "src\Core\Installer.ps1")
. (Join-Path $rootPath "src\UI\MainWindow.ps1")

$configPath = Join-Path $rootPath "config"
$catalog = Import-JSoftCatalog -ConfigPath $configPath
$wingetStatus = Get-JSoftWingetStatus
$chocolateyStatus = Get-JSoftChocolateyStatus
$logPath = Initialize-JSoftLogger -RootPath $rootPath -Settings $catalog.Settings -WingetVersion $wingetStatus.Version

$script:JSoft = [ordered]@{
    RootPath = $rootPath
    MainScript = Join-Path $rootPath "J-Soft.ps1"
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

Initialize-JSoftUi
try {
    $renderedCount = @($script:JSoft.Ui.ApplicationPanel.Children | ForEach-Object { $_.Content.Children.Count } | Measure-Object -Sum).Sum
    if ($renderedCount -ne $catalog.Applications.Count) {
        throw "UI-Anzahl ($renderedCount) stimmt nicht mit dem Katalog ($($catalog.Applications.Count)) überein."
    }
    if ($script:JSoft.CardControls.Count -ne $catalog.Applications.Count) {
        throw "Kartenanzahl ($($script:JSoft.CardControls.Count)) stimmt nicht mit dem Katalog ($($catalog.Applications.Count)) überein."
    }
    if (@($script:JSoft.CardControls.Values | Where-Object { $_.Child -is [Windows.Controls.CheckBox] }).Count -gt 0) {
        throw "Mindestens eine Anwendungskarte enthält noch eine Checkbox."
    }
    if (@($script:JSoft.CardControls.Values | Where-Object { $_.ContextMenu.Items.Count -lt 1 }).Count -gt 0) {
        throw "Mindestens eine Anwendungskarte besitzt kein Detailmenü."
    }
    if (@($script:JSoft.CardControls.Values | Where-Object {
        $_.Child -isnot [Windows.Controls.StackPanel] -or
        $_.Child.Children.Count -lt 2 -or
        $_.Child.Children[0] -isnot [Windows.Controls.Grid]
    }).Count -gt 0) {
        throw "Mindestens eine Anwendungskarte besitzt kein Icon-Element."
    }
    if ($script:JSoft.Ui.PresetListBox.Items.Count -ne $catalog.Presets.Count) {
        throw "Preset-Editor zeigt nicht alle Presets an."
    }
    $includedPresetApplicationCount = @($script:JSoft.Ui.PresetIncludedPanel.Children | Where-Object { $_ -is [Windows.Controls.WrapPanel] } | ForEach-Object { $_.Children.Count } | Measure-Object -Sum).Sum
    if ($script:JSoft.PresetEditMode) {
        throw "Preset-Editor startet unerwartet im Bearbeitungsmodus."
    }
    if ($script:JSoft.Ui.PresetAvailablePanel.Visibility -ne "Collapsed") {
        throw "Nicht ausgewählte Programme sind außerhalb des Bearbeitungsmodus sichtbar."
    }
    if ($includedPresetApplicationCount -le 0 -or $includedPresetApplicationCount -ge $catalog.Applications.Count) {
        throw "Die normale Preset-Ansicht zeigt nicht ausschließlich die enthaltenen Programme."
    }

    Set-JSoftPresetEditorMode -Editing $true
    Refresh-JSoftPresetApplicationEditor
    $presetApplicationCount = @($script:JSoft.Ui.PresetIncludedPanel.Children | Where-Object { $_ -is [Windows.Controls.WrapPanel] } | ForEach-Object { $_.Children.Count } | Measure-Object -Sum).Sum
    $presetApplicationCount += @($script:JSoft.Ui.PresetAvailablePanel.Children | Where-Object { $_ -is [Windows.Controls.WrapPanel] } | ForEach-Object { $_.Children.Count } | Measure-Object -Sum).Sum
    if ($presetApplicationCount -ne $catalog.Applications.Count) {
        throw "Preset-Editor zeigt im Bearbeitungsmodus nicht alle Anwendungen an."
    }

    $firstAppId = [string]$catalog.Applications[0].id
    Toggle-JSoftApplicationSelection -AppId $firstAppId
    if (-not $script:JSoft.Selected.Contains($firstAppId)) {
        throw "Kartenklick konnte keine Anwendung auswählen."
    }
    Toggle-JSoftApplicationSelection -AppId $firstAppId

    $initialPresetCount = $script:JSoft.PresetEditorSelected.Count
    $availableRow = $script:JSoft.Ui.PresetAvailablePanel.Children | Where-Object { $_ -is [Windows.Controls.WrapPanel] } | Select-Object -First 1
    $availableCard = if ($availableRow) { $availableRow.Children | Select-Object -First 1 } else { $null }
    if ($availableCard) {
        Toggle-JSoftPresetEditorApplication -AppId ([string]$availableCard.Tag)
        if ($script:JSoft.PresetEditorSelected.Count -ne ($initialPresetCount + 1)) {
            throw "Preset-Kartenklick konnte kein Programm hinzufügen."
        }
        Toggle-JSoftPresetEditorApplication -AppId ([string]$availableCard.Tag)
    }

    Set-JSoftPresetEditorMode -Editing $false
    Refresh-JSoftPresetApplicationEditor

    Write-Output ("WPF-UI-Initialisierung erfolgreich: {0} Anwendungskarten" -f $renderedCount)
} finally {
    $script:JSoft.Ui.Window.Close()
}
