# OFFLINE-1 Phase A — fresh Windows BEFORE capture
# Run in Administrator PowerShell on the Windows host immediately before Arch ISO boot.
# Usage:
#   cd C:\Projects\asir0z-smoothoperator\shared\evidence\bare-metal
#   powershell -ExecutionPolicy Bypass -File .\collect-offline-1-before.ps1
#
# Paste output into offline-shrink-evidence.txt Phase A (or replace that section).

$ErrorActionPreference = 'Continue'
$stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
Write-Output "=== PHASE A FRESH CAPTURE ==="
Write-Output "Date: $stamp"
Write-Output "Operator: asir0z"
Write-Output "Host: $env:COMPUTERNAME"
Write-Output ""

Write-Output "--- Get-Disk 0 ---"
Get-Disk 0 | Format-List Number, FriendlyName, SerialNumber, Size, PartitionStyle, OperationalStatus, HealthStatus

Write-Output "--- Get-Partition -DiskNumber 0 ---"
Get-Partition -DiskNumber 0 |
  Select-Object PartitionNumber, Type, DriveLetter,
    @{N='SizeGB';E={[math]::Round($_.Size/1GB,2)}},
    @{N='OffsetGB';E={[math]::Round($_.Offset/1GB,2)}} |
  Format-Table -AutoSize

Write-Output "--- Get-Volume C ---"
Get-Volume C | Format-List DriveLetter, FileSystem, DriveType, HealthStatus,
  @{N='SizeGB';E={[math]::Round($_.Size/1GB,2)}},
  @{N='FreeGB';E={[math]::Round($_.SizeRemaining/1GB,2)}}

Write-Output "--- fsutil dirty query C: ---"
fsutil dirty query C:

Write-Output "--- BitLocker (manage-bde -status C:) ---"
manage-bde -status C: 2>&1

Write-Output "--- Fast Startup (HiberbootEnabled) ---"
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled 2>&1

Write-Output ""
Write-Output "Paste the above into offline-shrink-evidence.txt Phase A."
Write-Output "Then boot ARCH_202607 (UEFI) and continue Phase B per OFFLINE-1-NTFS-SHRINK.md"
