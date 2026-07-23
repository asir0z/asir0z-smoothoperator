# SmoothOperator™ — post-Cursor migration completion (operational)
# Run AFTER closing all Cursor/terminal handles on asir0z-engineering-platform.
# Authorized: rename, validation, VBox path update. Does NOT push to GitHub.

$ErrorActionPreference = 'Stop'
$Old = 'C:\Projects\asir0z-engineering-platform'
$New = 'C:\Projects\asir0z-smoothoperator'
$VBox = 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe'
$VmName = 'Arch-Engineering-Workstation'

Write-Host '=== SmoothOperator migration completion ===' -ForegroundColor Cyan

if (-not (Test-Path $Old)) {
    if (Test-Path $New) {
        Write-Host "Already renamed: $New" -ForegroundColor Green
    } else {
        throw "Neither $Old nor $New found."
    }
} elseif (Test-Path $New) {
    throw "Both $Old and $New exist. Resolve manually before continuing."
} else {
    Write-Host "Renaming $Old -> $New ..."
    Rename-Item $Old $New
    Write-Host 'Rename OK' -ForegroundColor Green
}

$Repo = $New
if (-not (Test-Path "$Repo\.git")) { throw "Missing .git at $Repo" }
Write-Host "git root: OK ($Repo\.git)" -ForegroundColor Green

$checks = @(
    "$Repo\linux\bootstrap\run-ws1-system.sh",
    "$Repo\shared\evidence\ws-1\verification.txt",
    "$Repo\windows\win-0-audit\WIN-0-SPEC.md",
    "$Repo\shared\certification\WIN-0.md"
)
foreach ($p in $checks) {
    if (-not (Test-Path $p)) { throw "Missing: $p" }
    Write-Host "OK $p"
}

if (-not (Test-Path $VBox)) {
    Write-Warning "VBoxManage not found — skip shared folder update."
} else {
    $state = & $VBox showvminfo $VmName --machinereadable 2>&1 | Select-String '^VMState=' | ForEach-Object { $_ -replace '^VMState="([^"]+)".*','$1' }
    if ($state -eq 'running') {
        Write-Warning "VM $VmName is running. Power off before shared folder update."
    } else {
        & $VBox sharedfolder remove $VmName --name bootstrap 2>$null
        & $VBox sharedfolder add $VmName --name bootstrap --hostpath "$Repo\linux\bootstrap" --automount
        Write-Host "VBox shared folder -> $Repo\linux\bootstrap" -ForegroundColor Green
    }
}

Write-Host ''
Write-Host '=== Reviewer gate (paste for Migration FROZEN) ===' -ForegroundColor Cyan
Push-Location $Repo
git status
git remote -v
git branch -vv
git log --oneline -5
Pop-Location
Write-Host ''
Write-Host 'When remote + push complete and output reviewed:'
Write-Host '  shared/certification/MIGRATION.md -> 100% COMPLETE · FROZEN'
