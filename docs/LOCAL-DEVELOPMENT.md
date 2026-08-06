# Lokale Entwicklung

## Start

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\Start-J-Soft.ps1
```

Beim Start fordert J-Soft Administratorrechte ueber die Windows-UAC an. Wird die Abfrage abgebrochen, wird die Anwendung nicht gestartet.

## Validierung

```powershell
.\Start-J-Soft.ps1 -ValidateOnly
.\tests\Test-Configuration.ps1
```

## WinGet-ID pruefen

```powershell
winget search "7-Zip"
winget show --id "7zip.7zip" --exact
```

Neue IDs duerfen nicht geraten werden. Erst nach erfolgreichem `winget show --id ... --exact` in `config/applications.json` eintragen.

## Entwicklungsregeln

- `winutil.ps1` nicht veraendern.
- Keine globale Umbenennung im Referenzcode.
- Keine Internet-Assets herunterladen.
- Keine Self-Hosting-Funktion in dieser Phase.
- Keine unkontrollierte Ausfuehrung ueber `Invoke-Expression`.
- Konfiguration und Programmlogik getrennt halten.
