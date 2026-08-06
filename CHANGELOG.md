# Changelog

## 0.1.0 - Lokale Erstversion

- Eigenstaendige PowerShell-WPF-Anwendung `J-Soft.ps1`.
- Modularer Aufbau unter `src/`.
- Anwendungskatalog in `config/applications.json`.
- Kategorien und Presets in eigenen JSON-Dateien.
- WinGet-Healthcheck beim Start.
- Optionale Chocolatey-Unterstuetzung vorbereitet.
- Installation in kontrolliertem Runspace mit Status pro Anwendung.
- Nicht-interaktive Installationsparameter fuer WinGet und Chocolatey.
- Keine zusaetzliche J-Soft-Bestaetigungsfrage vor dem Installationslauf.
- Administratorrechte werden beim Start ueber Windows-UAC angefordert.
- Vollstaendiger Katalogimport mit 204 installierbaren Programmen aus dem Referenzbestand.
- Microsoft-Store-Quellen und deutsche J-Soft-Kategorien im Katalog abgebildet.
- Kategorienansicht nach dem Installationsbereich der Referenz mit Kategoriebuttons, Gruppen und Auf-/Zuklapp-Aktionen.
- Anwendungskarten zeigen nur noch den Namen und lassen sich direkt anklicken.
- Kontextmenü mit deutscher Detailansicht für jede Anwendung.
- Deutsche Kurzbeschreibungen und UTF-8-Unterstützung für echte Umlaute.
- Preset-Editor zum Anlegen, Bearbeiten, Löschen und Speichern eigener Presets.
- Einzelne Programme können nach dem Laden eines Presets vor der Installation abgewählt werden.
- Preset-Programme werden als kleine klickbare Namenskarten in „Im Preset“ und „Weitere Programme“ getrennt.
- Hauptfenster für freie Größenänderung und PowerToys FancyZones vorbereitet.
- Preset-Editor verwendet dieselben Kategorie-Schaltflächen und Gruppierungen wie die Startseite.
- Lokaler Installationsverlauf fuer die aktuelle Sitzung.
- Logging unter `logs/`.
- Dokumentation und Third-Party-Notices ergaenzt.
