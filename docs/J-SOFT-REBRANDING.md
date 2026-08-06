# J-Soft Rebranding-Plan

## Ziel

J-Soft soll als eigenes angepasstes Projekt von Jonas Bernert auftreten, ohne die Herkunft von WinUtil/Chris Titus Tech zu verschleiern. Diese Phase ist nur Planung; es wurden keine produktiven Namen ersetzt.

## Lokale Branding-Treffer

Da lokal nur `winutil.ps1` vorhanden ist, beziehen sich die Treffer auf diese Datei.

| Kategorie | Beispiele | Bewertung |
| --- | --- | --- |
| Projektname in UI und Konsole | `WinUtil` in Fenstertitel, Dialogen, Tooltips, Logtexten | Muss fuer J-Soft geaendert werden |
| Funktionsnamen | `Invoke-WinUtil...`, `Set-WinUtil...`, `Install-WinUtil...` | Sollte langfristig geaendert werden, zunaechst aus Kompatibilitaetsgruenden behalten |
| Pfade | `%LocalAppData%\winutil`, `winutil_<timestamp>.log`, `%TEMP%\WinUtil_*` | Muss fuer produktives J-Soft geaendert werden, aber schrittweise |
| URLs | `github.com/ChrisTitusTech/winutil`, `christitus.com/win`, `winutil.christitus.com` | Externe technische Abhaengigkeiten; Self-Hosting braucht Ersatz |
| Autorenhinweise | Header, About-Dialog, GitHub-Links | Muss aus Lizenz-/Herkunftsgruenden erhalten oder korrekt ergaenzt werden |
| Logos/Assets | `Invoke-WinUtilAssets -Type logo` | Muss fuer J-Soft-Branding ersetzt werden |
| XAML Namespace | `clr-namespace:WinUtility` | Langfristig anpassen, aber Bindings pruefen |
| CTT PowerShell Profile | `CTT PowerShell Profile`, Download aus `ChrisTitusTech/powershell-profile` | Fachlich pruefen: fuer J-Soft eher entfernen, ersetzen oder klar als Upstream-Feature markieren |

## Kategorien fuer Aenderungen

### 1. Muss fuer J-Soft geaendert werden

| Bereich | Beispiel | Risiko |
| --- | --- | --- |
| Fenstertitel | `$Host.UI.RawUI.WindowTitle = "WinUtil"`, XAML `Title="WinUtil"` | gering |
| sichtbare UI-Texte | About, Documentation, Update-Hinweise | mittel, weil Dialoge/Eventhandler betroffen |
| Laufzeitpfade | `%LocalAppData%\winutil` | mittel, wegen Log-/Cache-/ISO-Restaurierung |
| Self-Hosting-URLs | GitHub latest Download, `christitus.com/win` | hoch, weil Startpfad kritisch ist |
| Logo | `Invoke-WinUtilAssets` | mittel |

### 2. Sollte langfristig geaendert werden

| Bereich | Beispiel | Grund |
| --- | --- | --- |
| Funktionspraefix | `Invoke-WinUtil...` | Konsistenz und Namespace |
| Sync-Variablennamen | `$winutildir`, `$script:WinUtilLogPath` | Wartbarkeit |
| Temp-Dateien | `WinUtil_Win11ISO_*`, `winutil_diskpart_*` | Auditierbarkeit |

Diese Aenderungen duerfen nicht global ersetzt werden, weil Funktionsaufrufe, Runspace-Injektion (`Name -imatch 'winutil|WPF'`), Eventhandler und Tests brechen koennen.

### 3. Darf zunaechst aus Kompatibilitaetsgruenden bestehen bleiben

- Interne Funktionsnamen `*-WinUtil*`.
- WPF-Control-Keys wie `WPFInstall...`.
- Exportierte Preset-Keys.
- Bestehende Importdateien mit alten Keys.

Empfehlung: Kompatibilitaetsaliasse und Migrationslogik einbauen, bevor technische IDs geaendert werden.

### 4. Muss aus Lizenz- oder Herkunftsgruenden erhalten bleiben

- Copyright-Hinweis aus der MIT-Lizenz.
- Hinweis auf Upstream-Projekt und wesentliche Autoren.
- Lizenztext in einer `LICENSE`- oder `NOTICE`-Datei.
- About-/README-Hinweis: J-Soft basiert teilweise auf WinUtil.

### 5. Externe technische Abhaengigkeiten, die ersetzt werden muessen

| Abhaengigkeit | Ersatz |
| --- | --- |
| `github.com/ChrisTitusTech/winutil/releases/latest/download/winutil.ps1` | eigener Release-Endpunkt |
| `christitus.com/win` | eigener Bootstrap-Endpunkt |
| `winutil.christitus.com` | eigene Dokumentation oder als Upstream-Link markieren |
| `github.com/sponsors/ChrisTitusTech` | entfernen oder durch eigenen Supportbereich ersetzen, Herkunft separat belassen |

## Keine globale Ersetzungsstrategie

Eine globale Ersetzung von `WinUtil` durch `JSoft` wuerde Risiken erzeugen:

- Runspace-Funktionssammlung sucht aktuell per Regex `winutil|WPF`.
- Eventhandler rufen konkrete Funktionsnamen auf.
- JSON-Felder enthalten Funktionsnamen fuer Features/Tweaks.
- WPF-Control-Namen und Auswahlkeys sind Datenformat.
- Import/Export nutzt alte Keys.
- Temp-Pfade koennen fuer Recovery bestehender ISO-Arbeit relevant sein.

## Empfohlene Reihenfolge

1. Zentrale Branding-Konfiguration einfuehren.
2. Sichtbare Texte und URLs ueber diese Konfiguration lesen.
3. Lizenz- und Herkunftshinweise ergaenzen.
4. Neue J-Soft-Pfade mit Migration alter WinUtil-Pfade.
5. Erst danach Funktionsnamespace refaktorieren.
6. Kompatibilitaetsaliases fuer alte Preset-/Import-Keys behalten.

## Vorgeschlagener Herkunftshinweis

Vorbehaltlich finaler Lizenzdatei:

> J-Soft basiert teilweise auf dem Open-Source-Projekt WinUtil von Chris Titus Tech und wurde von Jonas Bernert angepasst und erweitert. Die urspruenglichen Copyright- und Lizenzhinweise bleiben erhalten.

## Lizenz und Herkunft

Lokaler Befund: In dieser Arbeitskopie existiert keine `LICENSE`-Datei. Der Upstream `ChrisTitusTech/winutil` wird auf GitHub als MIT-lizenziert gefuehrt; die Lizenzdatei nennt `Copyright (c) 2022 CT Tech Group LLC`. Diese Aussage muss beim Beschaffen des vollstaendigen Repositories lokal nochmals gegen die konkrete `LICENSE` geprueft werden.

Konsequenzen der MIT-Lizenz, sofern die lokale Vollversion denselben Lizenztext enthaelt:

| Frage | Bewertung |
| --- | --- |
| Sind Aenderungen erlaubt? | Ja, Nutzung, Kopie, Aenderung, Zusammenfuehrung, Veroeffentlichung, Unterlizenzierung und Vertrieb sind erlaubt. |
| Welche Hinweise muessen bleiben? | Copyright-Hinweis und MIT-Lizenztext muessen in Kopien oder wesentlichen Teilen der Software enthalten bleiben. |
| Muss J-Soft unter derselben Lizenz veroeffentlicht werden? | MIT ist permissiv; eine Weitergabe muss den MIT-Hinweis erhalten, erzwingt aber nicht zwingend dieselbe Lizenz fuer eigene Zusatzteile. |
| Private Nutzung/eigenes Hosting | Im Regelfall erlaubt, solange Lizenzhinweise bei Kopien/Weitergabe erhalten bleiben. |
| Eigener Fork | README, About-Dialog und ggf. `NOTICE` sollten klar sagen, dass J-Soft auf WinUtil basiert und angepasst wurde. |

Empfohlene Dateien spaeter:

- `LICENSE`: MIT-Lizenztext des Upstreams erhalten.
- `NOTICE.md`: Herkunft, Anpassungen, eigener Projektname, Jonas Bernert als Maintainer der Anpassung.
- `README.md`: Kurzabschnitt "Herkunft und Lizenz".
- About-Dialog: Herkunftshinweis plus Link zum Upstream und zur eigenen Version.

Keine Rechtsberatung: Vor oeffentlicher Weitergabe oder kommerziellem Einsatz sollte die finale Formulierung rechtlich geprueft werden.

## Pruefpunkte vor produktivem Rebranding

- Start mit UI.
- Start mit `-Preset Standard`, `-Preset Minimal`, `-Preset Advanced`.
- Start mit `-Config`.
- Installieren, Deinstallieren, Upgrade.
- Import/Export alter und neuer Formate.
- Runspace-Funktionen erreichbar.
- XAML laedt ohne Parserfehler.
- Logs entstehen im gewuenschten Zielpfad.
- Dokumentations- und Supportlinks zeigen auf die richtigen Ziele.
