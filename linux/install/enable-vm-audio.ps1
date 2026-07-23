# Enable VirtualBox audio on Arch-Engineering-Workstation (idempotent).
# Requires VM powered off — VBoxManage cannot modify audio while session is locked.
$VBox = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
$vm = "Arch-Engineering-Workstation"

$state = & $VBox showvminfo $vm --machinereadable 2>$null | Select-String '^VMState=' | ForEach-Object { $_ -replace 'VMState="([^"]+)"','$1' }
if ($state -and $state -ne "poweroff" -and $state -ne "aborted") {
  Write-Error "VM state is '$state'. Power off the VM first, then re-run this script."
  exit 1
}

& $VBox modifyvm $vm --audio-driver default --audio-out on
Write-Host "Audio enabled on $vm (driver=default, audio-out=on). Start the VM and verify playback."
