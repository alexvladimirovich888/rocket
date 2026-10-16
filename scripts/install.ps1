<#
.SYNOPSIS
    Installs the Roadster car body into Rocket League (client-side, visual only).

.DESCRIPTION
    1. Finds the Rocket League install (Epic or Steam), or uses -GamePath.
    2. Backs up the original body package to backup\ inside this repo.
    3. Copies the Roadster package over it.

    Only you see the new model. Other players still see the original car.
    Run uninstall.ps1, or "Verify" the game in the Epic/Steam launcher, to restore.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File scripts\install.ps1
.EXAMPLE
    powershell -ExecutionPolicy Bypass -File scripts\install.ps1 -GamePath "D:\Games\rocketleague"
#>
[CmdletBinding()]
param(
    [string]$GamePath
)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$Config   = Get-Content (Join-Path $RepoRoot 'config\roadster.json') -Raw | ConvertFrom-Json

function Write-Step($msg) { Write-Host "  > $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "  OK $msg" -ForegroundColor Green }
function Fail($msg)       { Write-Host "  !! $msg" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "  ROADSTER for Rocket League - installer v$($Config.version)" -ForegroundColor White
Write-Host ""

# --- Refuse to run while the game is open ----------------------------------
if (Get-Process -Name 'RocketLeague' -ErrorAction SilentlyContinue) {
    Fail "Rocket League is running. Close the game first."
}

# --- Locate the game --------------------------------------------------------
if (-not $GamePath) {
    foreach ($p in $Config.game.defaultPaths) {
        $candidate = $p -replace '/', '\'
        if (Test-Path (Join-Path $candidate 'TAGame\CookedPCConsole')) { $GamePath = $candidate; break }
    }
}
if (-not $GamePath) { Fail "Rocket League not found. Re-run with -GamePath ""<folder that contains TAGame>""." }

$Cooked = Join-Path $GamePath 'TAGame\CookedPCConsole'
if (-not (Test-Path $Cooked)) { Fail "Folder not found: $Cooked" }
Write-Ok "Game found: $GamePath"

# --- Check the mod package exists -------------------------------------------
$Source = Join-Path $RepoRoot ($Config.replace.sourcePackage -replace '/', '\')
if (-not (Test-Path $Source)) {
    Fail "Mod package not built yet: $Source`n     See docs\BUILDING.md, or download a release package into dist\."
}

$Target = Join-Path $Cooked $Config.replace.targetPackage
if (-not (Test-Path $Target)) {
    Fail "Target package '$($Config.replace.targetPackage)' not found in CookedPCConsole.`n     Check the name in config\roadster.json against your game files."
}

# --- Backup -----------------------------------------------------------------
$BackupDir = Join-Path $RepoRoot 'backup'
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
$Backup = Join-Path $BackupDir $Config.replace.targetPackage
if (-not (Test-Path $Backup)) {
    Write-Step "Backing up original package"
    Copy-Item $Target $Backup
    Write-Ok "Backup saved: $Backup"
} else {
    Write-Ok "Backup already exists, keeping it: $Backup"
}

# --- Install ----------------------------------------------------------------
Write-Step "Copying Roadster package"
Copy-Item $Source $Target -Force
Write-Ok "Installed. Pick the $($Config.hitbox.preset) body in the garage to see the Roadster."
Write-Host ""
Write-Host "  To remove: powershell -ExecutionPolicy Bypass -File scripts\uninstall.ps1" -ForegroundColor DarkGray
Write-Host ""
