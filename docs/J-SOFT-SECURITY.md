# J-Soft Sicherheitskonzept

## Ausgangslage

J-Soft wird administrative Installationen, Windows-Konfigurationen und Systemaenderungen ausfuehren. Das vorhandene `winutil.ps1` erzwingt Adminrechte und loggt Aktionen, fuehrt aber auch externe Skripte und konfigurierte Scriptblocks aus. Fuer J-Soft muss die Sicherheit deshalb Teil der Kernarchitektur sein.

## Bedrohungsmodell

| Risiko | Beispiel | Auswirkung |
| --- | --- | --- |
| Manipulierte Downloadquelle | `irm | iex`, externe EXE/ZIP | Vollstaendige Codeausfuehrung als Admin |
| Command Injection | freie Installationsbefehle im Editor | Ausfuehrung beliebiger Befehle |
| Manipulierte JSON-Konfiguration | geaenderte IDs, Scriptblocks | falsche Pakete oder Schadcode |
| Unsichere Paketquellen | fremde WinGet-/Chocolatey-Quelle | Supply-Chain-Risiko |
| Fehlbedienung | kritische Tweaks ohne Vorschau | Systeminstabilitaet |
| Unvollstaendige Fehlerbehandlung | Paketmanager-Exitcode nur geloggt | falscher Erfolg |

## Sicherheitsprinzipien

- Standardpfad ist deklarativ, nicht imperativ.
- Paketmanager werden ueber strukturierte Argumentlisten aufgerufen.
- Freie Custom Commands sind Ausnahme, nicht Normalfall.
- Jede systemveraendernde Aktion hat Preview, Confirm, Log und Ergebnis.
- Konfigurationen sind versioniert, validiert und optional signiert.
- Downloads haben Hash und nach Moeglichkeit Signaturpruefung.
- Keine Zugangsdaten im Klartext.

## Eingabevalidierung

| Eingabe | Regel |
| --- | --- |
| App-ID | Regex z.B. `^[a-z0-9][a-z0-9._-]{2,100}$` |
| WinGet-ID | Keine Shell-Metazeichen; nur als Argumentwert an `--id` uebergeben |
| Chocolatey-ID | Allowlist-Zeichen, keine zusammengesetzten Befehle |
| URLs | Nur HTTPS, keine eingebetteten Credentials |
| Dateipfade | Normalisieren, Zielbereiche begrenzen |
| Kategorie/Profile | Stabile IDs, Anzeigenamen separat |
| Custom Commands | Separates Modell, Warnlevel, Review-Flag |

## Schutz vor Command Injection

Paketmanagerbefehle duerfen nicht als ein grosser String gebaut werden. Stattdessen:

```powershell
$arguments = @("install", "--id", $PackageId, "--source", "winget", "--silent")
Start-Process -FilePath "winget" -ArgumentList $arguments -Wait -PassThru
```

Chocolatey sollte ebenfalls argumentweise ausgefuehrt werden. Der aktuelle Code baut bei Chocolatey `install $Programs -y` als String; das sollte umgestellt werden.

## Custom Commands im Editor

Eigene Installationsbefehle sind der kritischste geplante Bereich.

Empfohlene Regeln:

1. Standardmaessig deaktiviert.
2. Nur pro App explizit aktivierbar.
3. Immer sichtbare Warnung "benutzerdefinierter Admin-Befehl".
4. Befehl, Arbeitsverzeichnis, Argumente und erlaubte Umgebungsvariablen getrennt speichern.
5. Keine Pipeline-/Shell-Strings als Standardformat.
6. Keine Ausfuehrung ueber `iex`.
7. Vor Ausfuehrung Preview anzeigen.
8. Bestaetigungsdialog mit App, Befehl, Quelle, Hash, Adminstatus.
9. Audit-Log mit Hash der Konfiguration.
10. Optional nur signierte lokale Skripte erlauben.

Beispiel fuer ein sichereres Modell:

```json
{
  "customCommand": {
    "enabled": false,
    "risk": "high",
    "executable": "C:\\Installers\\setup.exe",
    "arguments": ["/quiet", "/norestart"],
    "expectedSha256": "...",
    "requiresConfirmation": true
  }
}
```

## Whitelist fuer Paketmanager

Zulaessige Manager in Version 1:

| Manager | Status |
| --- | --- |
| `winget` | Standard |
| `msstore` | ueber WinGet-Prefix `msstore:` |
| `chocolatey` | optional |

Weitere Manager nur ueber Plugin/Adapter mit eigener Validierung.

## Kritische Aktionen

Vor diesen Aktionen ist eine explizite Bestaetigung noetig:

- Deinstallation.
- Registry-Aenderungen unter HKLM.
- Services deaktivieren.
- Windows Update deaktivieren.
- AppX-Provisioning entfernen.
- ISO/USB schreiben.
- Custom Command.
- Download und Start externer EXE.

## Logging

Mindestens loggen:

- Zeitpunkt.
- Benutzer und Adminstatus.
- J-Soft-Version.
- Konfigurationsdatei und SHA256.
- Aktionstyp.
- Paketmanager.
- Paket-ID.
- Vollstaendige Argumentliste ohne Geheimnisse.
- Exitcode.
- Fehlerdetails.

Optional: JSON Lines fuer maschinelle Auswertung.

## Hash- und Signaturpruefung

| Artefakt | Mindestschutz |
| --- | --- |
| `jsoft.ps1` Release | SHA256 in Manifest, optional Authenticode |
| Bootstrap | So klein wie moeglich, fest gepinnt |
| Externe EXE/ZIP | SHA256 pro Version |
| Konfigurationspaket | SHA256 und Schema-Version |
| Offline-Bundle | Manifest mit Hashes fuer alle Dateien |

## Sichere temporaere Dateien

- Unter `%LocalAppData%\JSoft\Temp` oder eindeutigem `%TEMP%\JSoft_*`.
- Zufallsname mit GUID.
- Keine vorhersehbaren Namen fuer ausfuehrbare Dateien.
- Vor Schreiboperation Zielpfad normalisieren.
- Nach Abschluss bereinigen oder bewusst als Recovery-Ordner markieren.

## Rollback

| Aktion | Rollback |
| --- | --- |
| App-Installation | Uninstall-Plan speichern |
| App-Deinstallation | Kein verlaesslicher Rollback; Backup/Hinweis |
| Registry-Tweak | Vorherwert exportieren |
| Service-Aenderung | Vorheriger Starttyp speichern |
| Config-Save | Atomic Save plus `.bak` |
| ISO-Arbeit | Arbeitsordner erhalten, Original nie ueberschreiben |

## Mindestanforderungen vor produktiver Nutzung

1. JSON-Schemas fuer Apps, Kategorien, Profile.
2. Zentrale Execution-API.
3. Kein freies `Invoke-Expression` fuer eigene Daten.
4. Hashpruefung fuer Self-Hosted Downloads.
5. Sichtbare Vorschau fuer kritische Aktionen.
6. Tests fuer Befehlsaufbau und Validierung.
