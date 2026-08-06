function New-JSoftInstallQueue {
    # Eine leere Queue wird sonst von PowerShell als Pipeline-Enumeration
    # behandelt und kommt beim Aufrufer als $null an.
    return ,([System.Collections.Concurrent.ConcurrentQueue[object]]::new())
}

function Start-JSoftInstallRunspace {
    param(
        [Parameter(Mandatory)]
        [object[]]$Applications,

        [Parameter(Mandatory)]
        [string]$PackageManager,

        [Parameter(Mandatory)]
        [string]$RootPath,

        [Parameter(Mandatory)]
        [string]$LogPath,

        [Parameter(Mandatory)]
        [System.Collections.Concurrent.ConcurrentQueue[object]]$Queue
    )

    $scriptBlock = {
        param($apps, $manager, $rootPath, $logPath, $queue)

        . (Join-Path $rootPath "src\\Security\\Security.ps1")
        . (Join-Path $rootPath "src\\Logging\\Logging.ps1")
        . (Join-Path $rootPath "src\\PackageManagers\\Winget.ps1")
        . (Join-Path $rootPath "src\\PackageManagers\\Chocolatey.ps1")

        $script:JSoftLogPath = $logPath
        $script:JSoftLogDirectory = Split-Path -Parent $logPath

        $startedAt = Get-Date
        $successCount = 0
        $failedCount = 0
        $alreadyInstalledCount = 0

        foreach ($app in @($apps)) {
            $startTime = Get-Date
            $queue.Enqueue([pscustomobject]@{ Type = "status"; AppId = $app.id; Status = "Wird geprüft"; Message = "Prüfe $($app.name)"; Time = $startTime })

            try {
                $packageId = [string]$app.packageId
                $packageSource = if ([string]::IsNullOrWhiteSpace([string]$app.packageSource)) { "winget" } else { [string]$app.packageSource }
                $selectedManager = $manager
                if ($selectedManager -eq "chocolatey") {
                    if ([string]::IsNullOrWhiteSpace([string]$app.chocolateyPackageId)) {
                        $selectedManager = "winget"
                    } else {
                        $packageId = [string]$app.chocolateyPackageId
                    }
                }

                if (-not (Test-JSoftPackageId -PackageId $packageId)) {
                    throw "Ungültige Paket-ID: $packageId"
                }

                Write-JSoftLog -Message ("Anwendung: {0}; Paket-ID: {1}; Paketmanager: {2}" -f $app.name, $packageId, $selectedManager)

                if ($selectedManager -eq "winget" -and (Test-JSoftWingetPackageInstalled -PackageId $packageId -Source $packageSource)) {
                    $alreadyInstalledCount++
                    $queue.Enqueue([pscustomobject]@{
                        Type = "history"; AppId = $app.id; Name = $app.name; PackageId = $packageId; StartTime = $startTime; EndTime = Get-Date;
                        Status = "Bereits installiert"; ExitCode = 0; ErrorMessage = ""
                    })
                    $queue.Enqueue([pscustomobject]@{ Type = "status"; AppId = $app.id; Status = "Bereits installiert"; Message = "$($app.name) ist bereits installiert."; Time = Get-Date })
                    continue
                }

                $queue.Enqueue([pscustomobject]@{ Type = "status"; AppId = $app.id; Status = "Wird installiert"; Message = "Installiere $($app.name)"; Time = Get-Date })

                if ($selectedManager -eq "chocolatey") {
                    $result = Install-JSoftChocolateyPackage -PackageId $packageId
                } else {
                    $result = Install-JSoftWingetPackage -PackageId $packageId -Source $packageSource
                }

                Write-JSoftLog -Message ("Ausgeführte Argumente: {0}" -f ($result.Arguments -join " "))
                Write-JSoftLog -Message ("Exitcode für {0}: {1}" -f $app.name, $result.ExitCode)

                if ($result.Success) {
                    $successCount++
                    $queue.Enqueue([pscustomobject]@{ Type = "status"; AppId = $app.id; Status = "Erfolgreich"; Message = "$($app.name) erfolgreich installiert."; Time = Get-Date })
                    $historyStatus = "Erfolgreich"
                    $errorMessage = ""
                } else {
                    $failedCount++
                    $errorMessage = if ([string]::IsNullOrWhiteSpace($result.Output)) { "Installation fehlgeschlagen." } else { $result.Output }
                    Write-JSoftLog -Level "ERROR" -Message ("Fehler bei {0}: {1}" -f $app.name, $errorMessage)
                    $queue.Enqueue([pscustomobject]@{ Type = "status"; AppId = $app.id; Status = "Fehlgeschlagen"; Message = "$($app.name) fehlgeschlagen."; Time = Get-Date })
                    $historyStatus = "Fehlgeschlagen"
                }

                $queue.Enqueue([pscustomobject]@{
                    Type = "history"; AppId = $app.id; Name = $app.name; PackageId = $packageId; StartTime = $startTime; EndTime = Get-Date;
                    Status = $historyStatus; ExitCode = $result.ExitCode; ErrorMessage = $errorMessage
                })
            } catch {
                $failedCount++
                Write-JSoftLog -Level "ERROR" -Message ("Fehler bei {0}: {1}" -f $app.name, $_.Exception.Message)
                $queue.Enqueue([pscustomobject]@{ Type = "status"; AppId = $app.id; Status = "Fehlgeschlagen"; Message = $_.Exception.Message; Time = Get-Date })
                $queue.Enqueue([pscustomobject]@{
                    Type = "history"; AppId = $app.id; Name = $app.name; PackageId = $app.packageId; StartTime = $startTime; EndTime = Get-Date;
                    Status = "Fehlgeschlagen"; ExitCode = -1; ErrorMessage = $_.Exception.Message
                })
            }
        }

        $queue.Enqueue([pscustomobject]@{
            Type = "done"; StartedAt = $startedAt; EndedAt = Get-Date; Success = $successCount; Failed = $failedCount; AlreadyInstalled = $alreadyInstalledCount
        })
    }

    $powerShell = [powershell]::Create()
    [void]$powerShell.AddScript($scriptBlock)
    [void]$powerShell.AddArgument($Applications)
    [void]$powerShell.AddArgument($PackageManager)
    [void]$powerShell.AddArgument($RootPath)
    [void]$powerShell.AddArgument($LogPath)
    [void]$powerShell.AddArgument($Queue)

    $handle = $powerShell.BeginInvoke()
    return [pscustomobject]@{
        PowerShell = $powerShell
        Handle = $handle
        Queue = $Queue
    }
}
