# Anwendungskatalog

Der Katalog liegt in `config/applications.json`.

## Pflichtfelder

| Feld | Bedeutung |
| --- | --- |
| `id` | stabile interne ID, klein geschrieben |
| `name` | Anzeigename |
| `description` | Kurzbeschreibung fuer die UI |
| `category` | sichtbare Kategorie |
| `packageManager` | `winget` oder `chocolatey` |
| `packageId` | WinGet-ID ohne Quellenpraefix |
| `packageSource` | optionale WinGet-Quelle: `winget` oder `msstore` |
| `enabled` | deaktivierte Apps werden nicht regulaer angezeigt |
| `requiresAdmin` | UI-Hinweis und Angebot fuer erhoehten Neustart |

Optional:

| Feld | Bedeutung |
| --- | --- |
| `chocolateyPackageId` | Paket-ID fuer optionale Chocolatey-Installation |
| `website` | Hersteller- oder Projektseite |
| `isFoss` | Kennzeichnung fuer freie/Open-Source-Software |

Der aktuelle Katalog enthaelt 204 Anwendungen aus dem strukturierten Programmbestand der Referenzdatei. Die Kategorien werden in J-Soft-eigene deutsche Kategorien ueberfuehrt. Die Konvertierung kann mit `tools/Import-WinUtilApplications.ps1` reproduziert werden.

## Validierung

J-Soft validiert Pflichtfelder, eindeutige IDs, Paketmanagerwerte und Paket-ID-Zeichen. Das formale Schema liegt in `schemas/application.schema.json`.

## Verifizierte Beispielpakete

Die Paket-IDs im aktuellen Katalog wurden lokal mit `winget show --id <ID> --exact` geprueft.
