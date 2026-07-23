# WIN-1 Infrastructure — read-only baseline collectors
# Output: shared/evidence/win-1/infrastructure/collectors/

$ErrorActionPreference = 'Continue'
$Repo = if ($PSScriptRoot) { Split-Path $PSScriptRoot -Parent } else { 'C:\Projects\asir0z-smoothoperator' }
$Out = Join-Path $Repo 'shared\evidence\win-1\infrastructure\collectors'
New-Item -ItemType Directory -Force -Path $Out | Out-Null
$ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

function Write-Section($name, [scriptblock]$Block) {
    $path = Join-Path $Out $name
    & {
        "=== $name ==="
        "Collected: $ts"
        ''
        & $Block
    } | Out-File -FilePath $path -Encoding utf8
    Write-Host "Wrote $path"
}

Write-Section 'git-global.txt' {
    git --version
    git config --global --list 2>&1
}

Write-Section 'git-projects.txt' {
    foreach ($p in @(
            'C:\Projects\asir0z-smoothoperator',
            'C:\Projects\asir0z-devopslab',
            'C:\Projects\asir0z-web',
            'C:\Projects\asir0z-product-intelligence'
        )) {
        if (-not (Test-Path $p)) { continue }
        "=== $p ==="
        Push-Location $p
        git remote -v 2>&1
        git status -sb 2>&1 | Select-Object -First 1
        Pop-Location
        ''
    }
}

Write-Section 'ssh-config.txt' {
    ssh -V 2>&1
    ''
    '--- config (hosts only, no IdentityFile values) ---'
    $cfg = Join-Path $env:USERPROFILE '.ssh\config'
    if (Test-Path $cfg) {
        Get-Content $cfg | Where-Object { $_ -match '^(Host |  HostName|  Port|  User)' }
    } else {
        'No ~/.ssh/config'
    }
}

Write-Section 'wsl.txt' {
    wsl --status 2>&1
    ''
    wsl -l -v 2>&1
    ''
    wsl --version 2>&1
}

Write-Section 'docker.txt' {
    docker version 2>&1
    ''
    docker context ls 2>&1
    ''
    docker info 2>&1 | Select-String 'Server Version|Operating System|Docker Root Dir|Total Memory|CPUs|Context'
}

Write-Section 'virtualbox.txt' {
    $VBox = 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe'
    if (-not (Test-Path $VBox)) { 'VBoxManage not found'; return }
    & $VBox --version
    ''
    & $VBox list vms
    ''
    & $VBox showvminfo 'Arch-Engineering-Workstation' --machinereadable 2>&1 |
        Select-String 'SharedFolder|VMState'
}

Write-Section 'toolchain.txt' {
    winget --version 2>&1
    pwsh -NoProfile -Command '$PSVersionTable.PSVersion' 2>&1
    node -v 2>&1
    python --version 2>&1
    git lfs version 2>&1
}

Write-Section 'ssh-connectivity.txt' {
    foreach ($target in @('devops-lab', 'contabo')) {
        "=== ssh $target ==="
        ssh -o BatchMode=yes -o ConnectTimeout=10 $target 'hostname' 2>&1
        ''
    }
    '=== ssh arch-ws (expected FAIL when VM off) ==='
    ssh -o BatchMode=yes -o ConnectTimeout=5 arch-ws 'hostname' 2>&1
}

Write-Host "Collectors complete -> $Out" -ForegroundColor Green
