# asir0z-engineering-platform

Personal engineering workstation — reproducible bootstrap, separate from [asir0z-devopslab](https://github.com/asir0z/asir0z-devopslab).

**VM:** `Arch-Engineering-Workstation` (VirtualBox) · not production.

**ChatGPT directive (DevOps Lab):** [DEVOPS-CHATGPT-WORKSTATION-DEVSTACK.md](https://github.com/asir0z/asir0z-devopslab/blob/main/docs/cross-project/DEVOPS-CHATGPT-WORKSTATION-DEVSTACK.md)

---

## How to install (WS-1)

**Principle:** system mutations as root; user state as operator.

```bash
# system layer (root TTY or sudo)
mount -t vboxsf bootstrap /mnt/bootstrap 2>/dev/null || true
sudo bash /mnt/bootstrap/run-ws1-system.sh

# evidence (asir0z — not root)
bash /mnt/bootstrap/verify/verify-ws1.sh | tee ~/ws-1-evidence.txt

# user layer (asir0z — not root)
gh auth login
git config --global user.name "Asır"
git config --global user.email "asir01oz@gmail.com"
```

`run-ws1-system.sh` strips CRLF, runs `dev-stack.sh`, installs Windows SSH pubkey for passwordless `ssh arch-ws`.

Shared folder `bootstrap` maps to this repo's `bootstrap/` directory only — not the repo root.

---

## Not installed by WS-1

Scope guard — do not add without WS-2 review:

- Docker / Podman
- Cloud CLIs (Azure, AWS, gcloud)
- Language version managers (fnm, pyenv, rustup via script)
- Dotfiles / Hyprland rice
- Merge into `asir0z-devopslab`

---

## First install (from zero)

1. Start VM from VirtualBox GUI (or `install/start-vm.ps1`).
2. Follow Arch `archinstall` on live ISO (`bootstrap/base-install.md`).
3. Run `bootstrap/hyprland-stack.sh` → SDDM + Hyprland.
4. Run `bootstrap/dev-stack.sh` → WS-1 developer CLI.
5. Daily use → WS-1 freeze → only then consider WS-2.
