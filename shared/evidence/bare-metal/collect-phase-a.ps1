# Phase A collection — run in Administrator PowerShell
# Usage: powershell -ExecutionPolicy Bypass -File collect-phase-a.ps1

$ErrorActionPreference = 'Continue'
$out = Join-Path $PSScriptRoot 'phase-a-output.txt'

@"
Phase A — Bare Metal Prep
Collected: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Host: $env:COMPUTERNAME
"@ | Set-Content $out

function Add-Section($title, $content) {
    "`n=== $title ===`n" | Add-Content $out
    ($content | Out-String).Trim() | Add-Content $out
}

try {
    Add-Section 'Secure Boot' (Confirm-SecureBootUEFI)
} catch {
    Add-Section 'Secure Boot' $_.Exception.Message
}

Add-Section 'BitLocker' (manage-bde -status C: 2>&1)

Add-Section 'UEFI bootmgfw' (bcdedit 2>&1 | Select-String bootmgfw)

Add-Section 'Fast Startup' (reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled 2>&1)

Write-Host "Wrote $out"
Get-Content $out
