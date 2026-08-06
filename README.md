# J-Soft

J-Soft ist ein eigenstaendiges lokales Software Center fuer Windows. Der aktuelle Katalog enthaelt 204 installierbare Programme aus dem analysierten Referenzbestand. Die Installation erfolgt ueber WinGet; Chocolatey ist optional vorbereitet.

Installationslaeufe werden nicht-interaktiv ausgefuehrt. WinGet verwendet `--silent` und `--disable-interactivity`; Chocolatey verwendet `-y`, `--no-progress` und `--limit-output`. Ein Paket muss die Silent-Installation selbst unterstuetzen. Windows-UAC kann unabhaengig davon weiterhin eine Systemabfrage anzeigen.

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

Nach dem Veröffentlichen von `Start-J-Soft-Remote.ps1` kann J-Soft ohne manuellen Klon direkt gestartet werden:

```powershell
irm https://raw.githubusercontent.com/KiritoKazuto22/J-Soft/main/Start-J-Soft-Remote.ps1 | iex
```

Der Remote-Launcher lädt das Projekt nur vorübergehend nach `%TEMP%`, startet J-Soft lokal mit Administratorrechten und entfernt die temporären Dateien nach dem Beenden. Für produktive Nutzung sollte der Inhalt vor dem Ausführen geprüft werden.

## Voraussetzungen

- Windows 11 oder ein aktuelles Windows mit WPF-Unterstuetzung.
- PowerShell 5.1 oder neuer.
- WinGet/App Installer.
- Internetzugriff fuer Paketinstallation.
- J-Soft fordert beim Start Administratorrechte ueber die Windows-UAC an.

## Projektstruktur

```text
J-Soft/
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
└── docs/
```

`winutil.ps1` bleibt als unveraenderte technische Referenz im Projektordner und wird von J-Soft nicht geladen.

## Anwendungen konfigurieren

Anwendungen liegen in `config/applications.json`. Der Katalog enthaelt aktuell 204 Programme. Ein Eintrag enthaelt mindestens:

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

Paket-IDs muessen vor dem Eintragen lokal geprueft werden:

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

Die Uebernahme aus der unveraenderten Referenzdatei ist reproduzierbar:

```powershell
.\tools\Import-WinUtilApplications.ps1
```

Der Import uebernimmt nur strukturierte installierbare Anwendungen. WinGet-Quellen wie `msstore` werden getrennt gespeichert; Tweaks, Systemmodule und Skriptfunktionen werden nicht als Anwendungen importiert.

## Presets bearbeiten

Über den Menüpunkt `Presets` können Presets angelegt, umbenannt, beschrieben und gespeichert werden. Die enthaltenen Programme lassen sich einzeln auswählen. Beim Laden eines Presets im Softwarebereich können einzelne Programme vor dem Installieren durch Anklicken der Karten wieder abgewählt werden.

## Bekannte Einschraenkungen

- Noch kein Self-Hosting.
- Kein `irm | iex`.
- Keine automatische Aktualisierung.
- Kein separater Editor.
- Keine Windows-Tweaks, Debloating-, ISO- oder Systemreparaturfunktionen.
- Installationen veraendern das System tatsaechlich; Testinstallationen nur bewusst starten.
