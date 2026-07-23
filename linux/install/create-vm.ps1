# Creates Arch-Engineering-Workstation (idempotent-ish: skips if VM exists)
$VBox = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
$vm = "Arch-Engineering-Workstation"
$vdi = "$env:USERPROFILE\VirtualBox VMs\$vm\$vm.vdi"
$iso = Join-Path $PSScriptRoot "archlinux-x86_64.iso"

$existing = & $VBox list vms 2>$null | Select-String $vm
if (-not $existing) {
  New-Item -ItemType Directory -Force -Path (Split-Path $vdi) | Out-Null
  & $VBox createvm --name $vm --register --ostype ArchLinux_64
  & $VBox modifyvm $vm --memory 8192 --cpus 4 --vram 128 --graphicscontroller vmsvga `
    --boot1 dvd --boot2 disk --nic1 nat --natpf1 "archssh,tcp,,2223,,22" --audio-driver none `
    --clipboard-mode disabled --draganddrop disabled --ioapic on --rtcuseutc on
  & $VBox createmedium disk --filename $vdi --size 65536 --format VDI
  & $VBox storagectl $vm --name "SATA" --add sata --controller IntelAhci --portcount 2 --hostiocache on
  & $VBox storageattach $vm --storagectl "SATA" --port 0 --device 0 --type hdd --medium $vdi
  & $VBox storagectl $vm --name "IDE" --add ide --controller PIIX4 --portcount 2 --hostiocache on
  $bootstrap = Join-Path (Split-Path $PSScriptRoot -Parent) "bootstrap"  # linux/bootstrap
  & $VBox sharedfolder add $vm --name bootstrap --hostpath $bootstrap --automount
}

if ((Test-Path $iso) -and -not (& $VBox showvminfo $vm 2>$null | Select-String "archlinux-x86_64.iso")) {
  & $VBox storageattach $vm --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium $iso
}

Write-Host "VM ready: $vm"
& $VBox showvminfo $vm --details | Select-String "Name:|Memory size:|Number of CPUs:|State:"
