<#
.SYNOPSIS
    Restores the original Rocket League body package from backup\.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File scripts\uninstall.ps1
.EXAMPLE
    powershell -ExecutionPolicy Bypass -File scripts\uninstall.ps1 -GamePath "D:\Games\rocketleague"
#>
[CmdletBinding()]
param(
    [string]$GamePath
)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$Config   = Get-Content (Join-Path $RepoRoot 'config\roadster.json') -Raw | ConvertFrom-Json

function Write-Ok($msg) { Write-Host "  OK $msg" -ForegroundColor Green }
function Fail($msg)     { Write-Host "  !! $msg" -ForegroundColor Red; exit 1 }

if (Get-Process -Name 'RocketLeague' -ErrorAction SilentlyContinue) {
    Fail "Rocket League is running. Close the game first."
}

if (-not $GamePath) {
    foreach ($p in $Config.game.defaultPaths) {
        $candidate = $p -replace '/', '\'
        if (Test-Path (Join-Path $candidate 'TAGame\CookedPCConsole')) { $GamePath = $candidate; break }
    }
}
if (-not $GamePath) { Fail "Rocket League not found. Re-run with -GamePath, or use 'Verify' in your launcher." }

$Backup = Join-Path $RepoRoot ("backup\" + $Config.replace.targetPackage)
if (-not (Test-Path $Backup)) {
    Fail "No backup found at $Backup.`n     Use 'Verify' in the Epic Games / Steam launcher to restore the original files."
}

$Target = Join-Path $GamePath ("TAGame\CookedPCConsole\" + $Config.replace.targetPackage)
Copy-Item $Backup $Target -Force
Write-Ok "Original package restored. The Roadster is uninstalled."
