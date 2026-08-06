function Test-JSoftAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Start-JSoftElevated {
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath,

        [string[]]$Arguments = @()
    )

    $scriptArgument = '"{0}"' -f $ScriptPath
    $processArguments = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", $scriptArgument
    )
    $processArguments += $Arguments

    $powerShellPath = (Get-Command powershell.exe -ErrorAction Stop).Source
    Start-Process -FilePath $powerShellPath -ArgumentList $processArguments -WorkingDirectory (Split-Path -Parent $ScriptPath) -Verb RunAs -PassThru
}

function Test-JSoftPackageId {
    param(
        [Parameter(Mandatory)]
        [string]$PackageId
    )

    return ($PackageId -match '^[A-Za-z0-9][A-Za-z0-9._+\-]{1,127}$')
}
