# J-Soft Migrationsplan

## Grundsatz

Die Migration erfolgt schrittweise, testbar und rueckrollbar. Die bestehende WinUtil-Funktionalitaet bleibt zunaechst erhalten. Keine globale Umbenennung ohne vorherige Tests.

## Phase 0 - Bestand sichern

| Punkt | Inhalt |
| --- | --- |
| Ziel | Ausgangszustand reproduzierbar sichern |
| Betroffene Dateien | `winutil.ps1`, spaeter gesamtes Upstream-Repository |
| Schritte | Vollstaendiges Upstream-Repo beschaffen; lokale Einzeldatei archivieren; Upstream-Remote dokumentieren; Ausgangsversion `26.07.17` taggen |
| Risiken | Aktuelle lokale Kopie ist nur ein Release-Artefakt |
| Abhaengigkeiten | Git muss lokal verfuegbar sein |
| Test | Start von `winutil.ps1` in Test-VM; Start mit `-Offline`; XAML-Load pruefen |
| Rollback | Archivierte Originaldatei wiederherstellen |
| Ergebnis | Gesicherter unveraenderter Referenzstand |

## Phase 1 - Dokumentation und Basistests

| Punkt | Inhalt |
| --- | --- |
| Ziel | Verhalten des Ist-Systems messbar machen |
| Betroffene Dateien | `docs/`, `tests/`, spaeter Pester-Dateien |
| Schritte | Architektur dokumentieren; Funktionsliste erstellen; App-Katalog testen; Import/Export testen; Basistests fuer JSON und Paketmanager-Argumente |
| Risiken | Ohne Quellrepo koennen Build- und CI-Pfade nicht validiert werden |
| Abhaengigkeiten | Pester, Test-VM, ggf. Windows Sandbox |
| Test | Pester: JSON parsebar, eindeutige IDs, keine leeren Pflichtfelder |
| Rollback | Dokumentations-/Testbranch verwerfen |
| Ergebnis | Belastbare Referenz fuer spaetere Umbauten |

## Phase 2 - Quellstruktur wiederherstellen

| Punkt | Inhalt |
| --- | --- |
| Ziel | Aus Einzeldatei wieder wartbare Module machen |
| Betroffene Dateien | `src/`, `config/`, `xaml/`, `build/` |
| Schritte | Upstream-Struktur uebernehmen; Compile-Prozess lauffaehig machen; eingebettete JSON/XAML auslagern; Build-Artefakt reproduzieren |
| Risiken | Abweichung zwischen gebuendelter Datei und Upstream |
| Abhaengigkeiten | Upstream-Repo, Build-Skripte |
| Test | Kompiliertes Ergebnis startet und enthaelt dieselben Katalogeintraege |
| Rollback | Zur gesicherten Einzeldatei zurueck |
| Ergebnis | Arbeitsfaehige Quellbasis |

## Phase 3 - Zentrale Branding-Konfiguration

| Punkt | Inhalt |
| --- | --- |
| Ziel | Sichtbares Branding ohne interne Funktionsumbenennung |
| Betroffene Dateien | `config/settings.json`, UI-XAML, About/Dialog-Code, Bootstrap |
| Schritte | `Branding`-Objekt einfuehren; Fenstertitel, Appname, Links, Logpfade ueber Konfiguration lesen; Herkunftshinweis ergaenzen |
| Risiken | Harte Strings bleiben unentdeckt; Pfadmigration |
| Abhaengigkeiten | Phase 2 |
| Test | Suche nach sichtbaren alten Namen; UI-Screenshot; Logpfad pruefen |
| Rollback | Branding-Konfig deaktivieren |
| Ergebnis | J-Soft tritt sichtbar eigenstaendig auf, Herkunft bleibt dokumentiert |

## Phase 4 - Datenmodell stabilisieren

| Punkt | Inhalt |
| --- | --- |
| Ziel | App-Katalog editorfaehig machen |
| Betroffene Dateien | `config/applications.json`, `config/categories.json`, `config/profiles.json`, `schemas/*.json`, `src/JSoft.Applications/*` |
| Schritte | Neue IDs einfuehren; Kategorien auslagern; Profile versionieren; Migration alter `WPFInstall*`-Keys; Schema-Validierung |
| Risiken | Bestehende Presets/Imports brechen |
| Abhaengigkeiten | Basistests |
| Test | Alte und neue Imports; Katalogvalidierung; Install-Tab rendert identisch |
| Rollback | Altes eingebettetes JSON weiter nutzen |
| Ergebnis | Erweiterbarer, validierter Katalog |

## Phase 5 - Paketmanager-Adapter

| Punkt | Inhalt |
| --- | --- |
| Ziel | WinGet/Chocolatey sicher und testbar kapseln |
| Betroffene Dateien | `src/JSoft.PackageManagers/*`, Tests |
| Schritte | Argumentaufbau als Arrays; Exitcode-Auswertung; `winget search/show/list`; Quellen-Allowlist; Duplikatpruefung |
| Risiken | Unterschiedliches CLI-Verhalten je Windows-Version |
| Abhaengigkeiten | Testsysteme mit/ohne WinGet/Chocolatey |
| Test | Unit-Tests fuer Argumentlisten; Integrationstests mit harmlosen Queries |
| Rollback | Alte Funktionen als Kompatibilitaetsfallback behalten |
| Ergebnis | Robuste Paketmanager-Schicht |

## Phase 6 - J-Soft Editor

| Punkt | Inhalt |
| --- | --- |
| Ziel | Separate Editor-App fuer Konfigurationen |
| Betroffene Dateien | `src/JSoft.Editor/*`, `schemas/*`, `config/*` |
| Schritte | PowerShell-WPF-Editor erstellen; App-Liste; Detailformular; WinGet-Suche; Validierungsreport; Backup/Restore; Export/Import |
| Risiken | Custom Commands koennen unsicher werden |
| Abhaengigkeiten | Phase 4 und 5 |
| Test | Editor speichert atomar; fehlerhafte JSON wird abgelehnt; Duplikate werden erkannt |
| Rollback | Backups der Config; Editor getrennt deaktivieren |
| Ergebnis | Eigene Apps/Profile ohne manuelles JSON-Bearbeiten |

## Phase 7 - Self-Hosting

| Punkt | Inhalt |
| --- | --- |
| Ziel | Eigener sicherer Bereitstellungspfad |
| Betroffene Dateien | `build/Release.ps1`, `releases/`, Webserver-Konfiguration |
| Schritte | Stable/Dev-Kanal; Manifest; SHA256; optional Signatur; Bootstrap; Release Notes; Rollback-Versionen |
| Risiken | `irm | iex` bleibt riskant; TLS/Server kompromittierbar |
| Abhaengigkeiten | Domain/Webserver oder GitHub Releases |
| Test | Download, Hashpruefung, Start; alter Release weiterhin abrufbar |
| Rollback | Stable-Symlink auf vorherige Version |
| Ergebnis | J-Soft kann kontrolliert selbst gehostet gestartet werden |

## Phase 8 - Qualitaetssicherung

| Punkt | Inhalt |
| --- | --- |
| Ziel | Produktive Nutzung auf eigenen Systemen absichern |
| Betroffene Dateien | `tests/`, `docs/`, Build-Pipeline |
| Schritte | Pester-Suite; Testmatrix Windows 11; Offline-Bundle; Signaturpruefung; Referenz-Screenshots; Log-Audit |
| Risiken | Admin-Aktionen koennen Testsysteme veraendern |
| Abhaengigkeiten | VM/Sandbox |
| Test | Voller Dry-run; kontrollierte Installation/Deinstallation bekannter Pakete |
| Rollback | VM-Snapshots |
| Ergebnis | Reproduzierbare Releases mit dokumentierter Qualitaet |

## Naechste Phase

Als naechstes sollte Phase 0/1 abgeschlossen werden: vollstaendiges Upstream-Repository beschaffen, Lizenzdatei lokal herstellen, unveraenderten Build testen und Basistests fuer den eingebetteten Katalog ergaenzen.
