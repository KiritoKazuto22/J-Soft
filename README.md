# J-Soft

J-Soft ist ein eigenständiges lokales Software-Center für Windows. Der aktuelle Katalog enthält 204 installierbare Programme aus dem analysierten Referenzbestand. Die Installation erfolgt über WinGet; Chocolatey ist optional vorbereitet.

Installationsläufe werden nicht-interaktiv ausgeführt. WinGet verwendet `--silent` und `--disable-interactivity`; Chocolatey verwendet `-y`, `--no-progress` und `--limit-output`. Ein Paket muss die Silent-Installation selbst unterstützen. Windows-UAC kann unabhängig davon weiterhin eine Systemabfrage anzeigen.

Die Softwarekarten zeigen nur den Programmnamen. Ein Linksklick wählt die Karte aus; über einen Rechtsklick können die vollständigen Details mit deutscher Beschreibung, Paketdaten, Website und Status geöffnet werden.

Das Hauptfenster ist ein normales, frei skalierbares Windows-Fenster (`CanResize`, `SingleBorderWindow`) und kann dadurch mit Microsoft PowerToys FancyZones auf Ultra-Wide-Monitoren verschoben und angeordnet werden.

## Lokaler Start

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\Start-J-Soft.ps1
```

Validierung ohne interaktives Fenster:

```powershell
.\Start-J-Soft.ps1 -ValidateOnly
```

## Direkter Start aus GitHub

Nach dem Veröffentlichen von `J-Soft-Bundle.ps1` kann J-Soft ohne manuellen Klon direkt gestartet werden:

```powershell
irm https://raw.githubusercontent.com/KiritoKazuto22/J-Soft/main/J-Soft-Bundle.ps1 | iex
```

Das Bundle enthält die Anwendung, Module und den Katalog in einer einzelnen PowerShell-Datei. `irm` lädt den Inhalt in den Arbeitsspeicher und `iex` führt ihn aus. J-Soft legt nur Laufzeitdaten wie Protokolle und bearbeitete Presets unter `%LOCALAPPDATA%\J-Soft` ab. Vor dem Einsatz sollte der veröffentlichte Inhalt geprüft werden.

Bundle lokal erzeugen:

```powershell
.\tools\Build-JSoftBundle.ps1
```

## Voraussetzungen

- Windows 11 oder ein aktuelles Windows mit WPF-Unterstützung.
- PowerShell 5.1 oder neuer.
- WinGet/App Installer.
- Internetzugriff für die Paketinstallation.
- J-Soft fordert beim Start Administratorrechte über die Windows-UAC an.

## Projektstruktur

```text
J-Soft/
├── J-Soft-Bundle.ps1
├── J-Soft.ps1
├── Start-J-Soft.ps1
├── src/
│   ├── Applications/
│   ├── Core/
│   ├── Logging/
│   ├── PackageManagers/
│   ├── Security/
│   └── UI/
├── config/
├── schemas/
├── assets/
├── logs/
├── tests/
├── tools/
└── docs/
```

`winutil.ps1` bleibt als unveränderte technische Referenz im Projektordner und wird von J-Soft nicht geladen.

## Anwendungen konfigurieren

Anwendungen liegen in `config/applications.json`. Der Katalog enthält aktuell 204 Programme. Ein Eintrag enthält mindestens:

```json
{
  "id": "7zip",
  "name": "7-Zip",
  "description": "Werkzeug zum Packen und Entpacken von Dateien.",
  "category": "Werkzeuge",
  "packageManager": "winget",
  "packageId": "7zip.7zip",
  "enabled": true,
  "requiresAdmin": false
}
```

Paket-IDs müssen vor dem Eintragen lokal geprüft werden:

```powershell
winget show --id "7zip.7zip" --exact
```

## Presets konfigurieren

Profile liegen in `config/presets.json` und enthalten nur Anwendungs-IDs:

```json
{
  "name": "Techniker-PC",
  "applications": ["7zip", "notepadplusplus", "putty", "winscp"]
}
```

## Referenzkatalog aktualisieren

Die Übernahme aus der unveränderten Referenzdatei ist reproduzierbar:

```powershell
.\tools\Import-WinUtilApplications.ps1
```

Der Import übernimmt nur strukturierte installierbare Anwendungen. WinGet-Quellen wie `msstore` werden getrennt gespeichert; Tweaks, Systemmodule und Skriptfunktionen werden nicht als Anwendungen importiert.

## Presets bearbeiten

Über den Menüpunkt `Presets` können Presets angelegt, umbenannt, beschrieben und gespeichert werden. Die enthaltenen Programme lassen sich einzeln auswählen. Beim Laden eines Presets im Softwarebereich können einzelne Programme vor dem Installieren durch Anklicken der Karten wieder abgewählt werden.

## Bekannte Einschränkungen

- Noch kein Self-Hosting.
- Keine automatische Aktualisierung.
- Kein separater Editor.
- Keine Windows-Tweaks, Debloating-, ISO- oder Systemreparaturfunktionen.
- Installationen verändern das System tatsächlich; Testinstallationen nur bewusst starten.
