# Tests

## Durchgefuehrte Tests in dieser Phase

| Test | Ergebnis |
| --- | --- |
| JSON-Dateien parsebar | erfolgreich |
| PowerShell-Syntax der Hauptdateien | erfolgreich |
| Katalogimport aus `winutil.ps1` | erfolgreich, 204 Anwendungen |
| Anwendungskatalog-Validierung | erfolgreich |
| WPF-UI-Initialisierung mit 204 Anwendungskarten | erfolgreich |
| Kategoriebuttons und gruppierte Anwendungspanels | erfolgreich ueber UI-Initialisierung |
| Preset-Editor mit drei vorhandenen Presets und 204 Programmen | erfolgreich ueber UI-Initialisierung |
| Auswahl per Hauptkarte und Hinzufügen/Entfernen per Preset-Karte | erfolgreich |
| Gleiche Kategorien und Reihenfolge auf Startseite und Preset-Editor | erfolgreich |
| WinGet vorhanden | erfolgreich, `v1.29.280` |
| WinGet-Quellen abfragbar | erfolgreich |
| 15 urspruengliche WinGet-IDs mit `winget show --id ... --exact` | erfolgreich |
| Silent-Argumente fuer WinGet und Chocolatey | erfolgreich, ohne echte Installation |

## Nicht automatisch durchgefuehrt

Keine echte Installation wurde automatisiert gestartet, weil sie das System veraendert. Installationstests sollten gezielt und mit wenigen Paketen in einer VM oder auf einem Testsystem erfolgen.

## Manuelle Testliste

- Start ohne Administratorrechte.
- Start mit Administratorrechten.
- Suche nach Anwendungen.
- Kategorienfilter.
- Preset laden.
- Mehrfachauswahl.
- Paket-ID-Anzeige ein-/ausblenden.
- Installation eines bereits installierten Pakets.
- Fehlerhafte Paket-ID in einer Testkopie des Katalogs.
- Fortsetzung nach Paketfehler.
- Schliessen des Fensters waehrend einer Installation.
