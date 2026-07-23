# Run Hyprland bootstrap on Arch-Engineering-Workstation via SSH.
# Requires interactive password for asir0z (once per session).

$ErrorActionPreference = "Stop"
$vm = "Arch-Engineering-Workstation"
$VBox = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
$script = Join-Path $PSScriptRoot "..\bootstrap\hyprland-stack.sh"
$port = 2223

Write-Host "Waiting for SSH on 127.0.0.1:$port ..."
for ($i = 0; $i -lt 60; $i++) {
  if ((Test-NetConnection 127.0.0.1 -Port $port -WarningAction SilentlyContinue).TcpTestSucceeded) { break }
  Start-Sleep -Seconds 2
}

Write-Host "Copying bootstrap script..."
scp -P $port $script "asir0z@127.0.0.1:/tmp/hyprland-stack.sh"

Write-Host "Running bootstrap (sudo)..."
ssh -p $port asir0z@127.0.0.1 "chmod +x /tmp/hyprland-stack.sh && sudo bash /tmp/hyprland-stack.sh"

Write-Host "Done. Reboot VM from guest: sudo reboot"
Write-Host "Or from host: & '$VBox' controlvm '$vm' acpipowerbutton"
