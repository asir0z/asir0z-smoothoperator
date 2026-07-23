# WIN-2.5 verification skeleton
# Spec: windows/win-2.5-workflow-convergence/WIN-2.5-SPEC.md
# Run after authorized execution. Draft — expand when components are pinned.

param(
    [switch]$BaselineOnly
)

$ErrorActionPreference = 'Continue'
$pass = 0
$fail = 0
$warn = 0

function Test-Check {
    param([string]$Label, [scriptblock]$Test)
    if (& $Test) {
        Write-Host "PASS  $Label"
        $script:pass++
    } else {
        Write-Host "FAIL  $Label"
        $script:fail++
    }
}

function Test-Warn {
    param([string]$Label, [scriptblock]$Test)
    if (& $Test) {
        Write-Host "PASS  $Label"
        $script:pass++
    } else {
        Write-Host "WARN  $Label"
        $script:warn++
    }
}

Write-Host "=== WIN-2.5 Verification ==="
Write-Host (Get-Date -Format o)
Write-Host "Host: $env:COMPUTERNAME"
Write-Host "BaselineOnly: $BaselineOnly"
Write-Host ""

Write-Host "=== Prerequisites ==="
Test-Check "PowerShell 7 available" { Get-Command pwsh -ErrorAction SilentlyContinue }
Test-Check "winget available" { Get-Command winget -ErrorAction SilentlyContinue }
Test-Check "Git configured" { git config --global user.email 2>$null }

if ($BaselineOnly) {
    Write-Host ""
    Write-Host "=== summary (baseline) ==="
    Write-Host "PASS=$pass WARN=$warn FAIL=$fail"
    exit 0
}

Write-Host ""
Write-Host "=== P0 Components (post-execution) ==="
Test-Warn "Windows Terminal installed" { Get-Command wt -ErrorAction SilentlyContinue }
Test-Warn "PowerToys installed" { Get-AppxPackage -Name '*PowerToys*' -ErrorAction SilentlyContinue }
Test-Warn "Everything installed" { Test-Path "${env:ProgramFiles}\Everything\Everything.exe" }
Test-Warn "Launcher (TBD) configured" { $false }  # replace when component selected
Test-Warn "Nerd Font in Terminal" { $false }        # replace with font check

Write-Host ""
Write-Host "=== Reproducibility ==="
Test-Warn "install script present" { Test-Path "$PSScriptRoot\..\scripts\install-win-2.5.ps1" }
Test-Warn "config directory present" { Test-Path "$PSScriptRoot\..\config" }

Write-Host ""
Write-Host "=== summary ==="
Write-Host "PASS=$pass WARN=$warn FAIL=$fail"
if ($fail -gt 0) { exit 1 }
if ($warn -gt 0) { exit 2 }
exit 0
