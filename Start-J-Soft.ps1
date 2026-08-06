param(
    [switch]$ValidateOnly
)

Set-StrictMode -Version Latest

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$mainScript = Join-Path $scriptRoot "J-Soft.ps1"

if (-not (Test-Path -LiteralPath $mainScript)) {
    throw "J-Soft.ps1 wurde nicht gefunden: $mainScript"
}

& $mainScript -ValidateOnly:$ValidateOnly
