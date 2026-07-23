#Requires -Modules Posh-SSH
$ErrorActionPreference = "Stop"

$port = 2223
$hostName = "127.0.0.1"
$user = "asir0z"
$scriptUrl = "http://10.0.2.2:8765/hyprland-stack.sh"

$cred = if ($env:ARCH_WS_PASSWORD) {
  $secure = ConvertTo-SecureString $env:ARCH_WS_PASSWORD -AsPlainText -Force
  [PSCredential]::new($user, $secure)
} else {
  Get-Credential -UserName $user -Message "Arch workstation ($user@$hostName`:$port) password"
}
if (-not $cred) { throw "Credential required." }

$pw = $cred.GetNetworkCredential().Password

Write-Host "Connecting..."
$session = New-SSHSession -ComputerName $hostName -Port $port -Credential $cred -AcceptKey -Force
try {
  $stream = New-SSHShellStream -SessionId $session.SessionId -TerminalWidth 200 -TerminalHeight 50
  Start-Sleep -Seconds 1
  $stream.Read() | Out-Null

  Write-Host "Fetching bootstrap script..."
  $stream.WriteLine("curl -fsSL '$scriptUrl' -o /tmp/hyprland-stack.sh && wc -c /tmp/hyprland-stack.sh")
  Start-Sleep -Seconds 3
  $out = $stream.Read()
  Write-Host $out

  Write-Host "Running bootstrap (sudo) — may take several minutes..."
  $stream.WriteLine("sudo bash /tmp/hyprland-stack.sh")
  Start-Sleep -Seconds 2
  $out = $stream.Read()
  if ($out -match '[Pp]assword') {
    $stream.WriteLine($pw)
  }

  $deadline = (Get-Date).AddMinutes(25)
  while ((Get-Date) -lt $deadline) {
    Start-Sleep -Seconds 15
    $chunk = $stream.Read()
    if ($chunk) { Write-Host $chunk }
    if ($chunk -match '\[6/6\] done') { break }
    if ($chunk -match 'error:') { throw "Bootstrap failed: $chunk" }
  }

  Write-Host "Rebooting VM..."
  $stream.WriteLine("sudo reboot")
  Start-Sleep -Seconds 2
  $out = $stream.Read()
  if ($out -match '[Pp]assword') { $stream.WriteLine($pw) }
  Write-Host "Hyprland bootstrap complete. Log in via VirtualBox GUI (SDDM -> Hyprland)."
}
finally {
  if ($session) { Remove-SSHSession -SessionId $session.SessionId | Out-Null }
}
