#Requires -Modules Posh-SSH
$ErrorActionPreference = "Stop"

$cred = if ($env:ARCH_WS_PASSWORD) {
  [PSCredential]::new("asir0z", (ConvertTo-SecureString $env:ARCH_WS_PASSWORD -AsPlainText -Force))
} else {
  Get-Credential -UserName "asir0z" -Message "Arch workstation SSH password (arch-ws)"
}
if (-not $cred) { throw "Credential required." }

$pw = $cred.GetNetworkCredential().Password
$session = New-SSHSession -ComputerName 127.0.0.1 -Port 2223 -Credential $cred -AcceptKey -Force
try {
  Write-Host "Running WS-1 system layer..."
  $cmd = @'
set -e
sudo mkdir -p /mnt/bootstrap
sudo mount -t vboxsf bootstrap /mnt/bootstrap 2>/dev/null || true
for f in dev-stack.sh run-ws1-system.sh verify/verify-ws1.sh; do
  sudo sed -i 's/\r$//' "/mnt/bootstrap/$f" 2>/dev/null || true
done
echo "$SUDO_PW" | sudo -S bash /mnt/bootstrap/run-ws1-system.sh
'@ -replace '\$SUDO_PW', ($pw -replace "'", "'\\''")

  $r = Invoke-SSHCommand -SessionId $session.SessionId -Command $cmd -TimeOut 3600
  Write-Host $r.Output
  if ($r.Error) { Write-Host $r.Error -ForegroundColor Yellow }
  if ($r.ExitStatus -ne 0) { throw "WS-1 system layer failed (exit $($r.ExitStatus))" }

  Write-Host "Running WS-1 evidence capture..."
  $ev = Invoke-SSHCommand -SessionId $session.SessionId -Command "bash /mnt/bootstrap/verify/verify-ws1.sh" -TimeOut 120
  Write-Host $ev.Output
  $evPath = Join-Path $PSScriptRoot "..\..\shared\evidence\ws-1-evidence-$(Get-Date -Format yyyyMMdd-HHmmss).txt"
  New-Item -ItemType Directory -Force -Path (Split-Path $evPath) | Out-Null
  $ev.Output | Out-File -FilePath $evPath -Encoding utf8
  Write-Host "Evidence saved: $evPath"
  Write-Host "User layer (manual as asir0z): gh auth login; git config --global ..."
}
finally {
  Remove-SSHSession -SessionId $session.SessionId | Out-Null
}
