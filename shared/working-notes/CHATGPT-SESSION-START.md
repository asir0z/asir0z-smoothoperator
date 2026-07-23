# SmoothOperator™ — ChatGPT Oturum Başlangıç Belgesi

> **Amaç:** Yeni ChatGPT oturumuna yapıştırılacak canonical context  
> **Tarih:** 2026-07-23  
> **Canonical state:** [`shared/certification/PLATFORM-STATE.md`](../certification/PLATFORM-STATE.md)  
> **Cursor karşılığı:** [`CURSOR-HANDOFF.md`](CURSOR-HANDOFF.md)

---

## 1. Bu belge ne işe yarar?

SmoothOperator, **evidence-first** bir operator engineering platformudur. Chat geçmişi veya VM disk state'i güvenilir kaynak değildir. Bu belge:

- Platformun **şu anki** durumunu tanımlar
- **Açık gate**'i (WS-2 Sprint 2 GUI) netleştirir
- Agent'ın **ne yapabileceğini / yapamayacağını** sınırlar
- Repo, evidence ve certification yapısını haritalar

**Temel prensip:**

```text
A VM may disappear tomorrow.
The engineering laboratory must not.
```

Kritik bilgi Git, evidence dosyaları ve reproducible script'lerde yaşar — chat'te değil.

---

## 2. SmoothOperator nedir?

| Alan | Açıklama |
|------|----------|
| **Ürün adı** | SmoothOperator™ |
| **Repo** | `https://github.com/asir0z/asir0z-smoothoperator.git` |
| **Amaç** | Operator engineering platform — Windows, Linux (Arch), shared certification/evidence |
| **Ayrım** | Production authority **ayrı repo:** `asir0z-devopslab` (DevOps Lab) |

```text
SmoothOperator™
├── windows/          WIN-0, WIN-1, WIN-1A, WIN-2.5, …
├── linux/            WS-1 (FROZEN), WS-2 (ACTIVE), bootstrap, install
├── shared/
│   ├── evidence/     Ham audit çıktıları, loglar, doğrulama metinleri
│   ├── certification/ Karar kayıtları (APPROVED / REJECTED / CHANGES REQUIRED)
│   └── working-notes/ Geçici handoff notları (bu dosya dahil)
└── scripts/          Operasyonel yardımcılar
```

---

## 3. Certification modeli

Evidence ile certification **ayrıdır**:

```text
Evidence        →  Reality (ne oldu?)
Certification   →  Decision (ne yapılacak?)
```

Operasyonel döngü:

```text
Platform State
      ↓
Observed Friction  (veya yeni evidence)
      ↓
Specification
      ↓
Implementation
      ↓
Evidence
      ↓
Review
      ↓
Certification
      ↓
Platform State   ← güncelle
```

**Karar sonuçları:**

| Sonuç | Anlam |
|-------|-------|
| **APPROVED** | Devam et veya FROZEN |
| **REJECTED** | Durdur |
| **CHANGES REQUIRED** | Revize et, yeniden gönder |

**Certification Authority** (DevOps Lab) sprint kapatma otoritesidir. Agent **self-certify yapmaz**.

**Tarihsel referans alınmaz:** `%95 Migration`, `P0 Pending`, bootstrap-era ifadeler — yalnızca [`PLATFORM-STATE.md`](../certification/PLATFORM-STATE.md) geçerlidir.

---

## 4. Platform snapshot (2026-07-23)

```text
Foundation / Governance / Lifecycle   CERTIFIED · FROZEN ✅
Migration                             100% · CERTIFIED · FROZEN ✅
WIN-1 Infrastructure                  CERTIFIED · FROZEN BASELINE ✅
WIN-1 Core                            OPEN — friction-driven
WS-2 Sprint 1                         APPROVED WITH CONDITIONS ✅
WS-2 Sprint 2                         APPROVED WITH CONDITIONS · GUI PENDING ⏳
Mission 20 (DevOps Lab / Contabo)     OBSERVATION
Arch VM                               ACTIVE DEVELOPMENT WORKSTATION (validation)
Windows                               SAFE FALLBACK
Bare-metal Arch install               FUTURE TARGET · NOT AUTHORIZED
```

**Varsayılan çalışma modu:**

```text
No new evidence.
Continue execution.
```

Yeni review yalnızca **Observed Friction** veya platform durumunu değiştiren **yeni evidence** ile tetiklenir.

---

## 5. Repository topology

### 5.1 Host path'ler

| Host | Path | Kullanıcı |
|------|------|-----------|
| **Windows** | `C:\Projects\asir0z-smoothoperator` | asir0z |
| **Arch VM** | `~/Projects/asir0z-smoothoperator` | asir0z |
| **Remote** | `https://github.com/asir0z/asir0z-smoothoperator.git` | — |

### 5.2 Git durumu (2026-07-23)

| Referans | Commit | Not |
|----------|--------|-----|
| `origin/master` HEAD | `ee2063d` | `docs(ws-2): complete sprint-2 evidence and remove legacy config` |
| Feature branch | `cursor/ws2-validation-evidence` @ `a55faaa` | Sprint-2 validation evidence güncellemeleri |
| Arch round-trip kanıtı | `6afa57e` | `feat(ws-2): activate Arch development workstation` |
| WS-2 Sprint 1 | `0875b25` | Readiness audit evidence |
| WIN-1 Infra cert | `8b57fe8` | Infrastructure baseline |

### 5.3 İlgili repolar (Arch `~/Projects/`)

| Repo | Durum | Rol |
|------|-------|-----|
| `asir0z-smoothoperator` | ✅ Active | Operator platform (bu repo) |
| `asir0z-devopslab` | ✅ Active | Production authority · Mission 20 |
| `asir0z-web` | ✅ Cloned | Web products |
| `asir0z-product-intelligence` | ✅ Cloned | Sonraki odak (Sprint 2 kapandıktan sonra) |
| `asir0z-cortex` | ⏸️ Deferred | GitHub repo bulunamadı — Sprint 2 blocker değil |

### 5.4 Git dışı bilinçli kararlar

- **Academetrica archive** Git'te değil — backup: `C:\Projects\asir0z-smoothoperator-sync-backup-20260723\`
- **SSH private keys** asla repo'ya commit edilmez — operator-controlled transfer only

---

## 6. Sprint geçmişi (kısa)

### Migration — FROZEN ✅

100% complete. Evidence: `shared/evidence/migration/p0-closeout-20260723.txt`  
Certification: `shared/certification/MIGRATION.md`

### WIN-1 — Infrastructure FROZEN · Core OPEN

- **Infrastructure:** Git · SSH · WSL · Docker Desktop · VirtualBox · terminal · dev tools — **CERTIFIED**
- **Core:** startup · temp · apps · disk · winget — **henüz başlamadı**, friction-driven
- Evidence: `shared/evidence/win-1/infrastructure/`
- Spec: `windows/win-1-baseline/WIN-1-INFRASTRUCTURE-SPEC.md`
- Ubuntu VM removal → **WIN-1A** (Mission 20 observation PASS sonrası)

### WS-2 Sprint 1 — APPROVED WITH CONDITIONS ✅

Arch VM operational readiness audit. Cursor yoktu; CLI/SSH/Hyprland temel doğrulandı.  
Evidence: `shared/evidence/ws-2/readiness-audit/`  
Decision: `READY WITH CONDITIONS` → Sprint 2'de kapatıldı

### WS-2 Sprint 2 — APPROVED WITH CONDITIONS · GUI PENDING ⏳

Arch development workstation activation:

- Cursor kurulumu + launcher
- Repo clone + dotfiles architecture
- Development round-trip (Arch commit → Windows pull)
- Secret scan PASS
- Timezone PASS
- Keyboard PASS (remote verify)
- Display scaling investigation (VM-specific, repo değişikliği yok)
- **Tek açık gate:** Operator GUI acceptance test

Evidence pack: `shared/evidence/ws-2/sprint-2/`

### Mission 20 — OBSERVATION

Production cutover Contabo'ya 2026-07-23'te yapıldı. Observation window aktif.  
Başarı kriteri: *Production users cannot tell that infrastructure changed.*  
Spec: `asir0z-devopslab/missions/phase-2/MISSION-20-PRODUCTION-RUNTIME-MIGRATION.md`  
WIN-1A (Ubuntu VM emekliliği) Mission 20 observation PASS'e bağlı.

---

## 7. WS-2 Sprint 2 — detaylı durum

### 7.1 Tamamlanan engineering

| Alan | Durum | Evidence |
|------|-------|----------|
| Windows sync | ✅ PASS | HEAD `ee2063d` |
| Cursor install | ✅ PASS | `cursor-installation.txt`, `cursor-validation.md` |
| Repositories | ✅ PASS | `repository-inventory.md` |
| Dotfiles | ✅ PASS | `dotfiles-inventory.md`, `linux/arch-workstation/` |
| Secret scan | ✅ PASS | `secret-scan.txt` |
| Dev round-trip | ✅ PASS | `development-round-trip.md` (`6afa57e` → Windows) |
| Timezone | ✅ PASS | `timezone-verification.txt` — `Europe/Istanbul` |
| Keyboard config | ✅ PASS | `keyboard-verification.txt` — `tr,us` · Alt+Shift |
| Display scaling | ✅ Closed | `display-scaling-investigation.md` — VM-specific |

### 7.2 Açık gate — Operator GUI acceptance

**Dosya:** `shared/evidence/ws-2/sprint-2/gui-validation.md`  
**Durum:** 12 interaktif test ⏸️ — operator Hyprland session'da çalıştıracak

**Şu an yapılmaması gerekenler:**

- Yeni sprint açmak
- Mimari redesign
- Marginal dokümantasyon eklemek
- Sprint 2'yi self-certify etmek
- GUI PASS öncesi evidence finalize commit'i (final PASS commit'i GUI sonrası)

### 7.3 Sprint 2 karar özeti

```text
APPROVED WITH CONDITIONS
```

GUI PASS + DevOps Lab review → **APPROVED · CLOSED** → odak Product Intelligence'a kayar.

---

## 8. Arch Engineering Workstation

### 8.1 VM bilgisi

| Alan | Değer |
|------|-------|
| VM adı | `Arch-Engineering-Workstation` |
| Hypervisor | VirtualBox (Windows host) |
| Hostname | `arch-workstation` |
| User | `asir0z` |
| Desktop | Hyprland (Wayland) |
| Timezone | `Europe/Istanbul` (+03) |
| Locale | `en_US.UTF-8` |

### 8.2 SSH erişimi (Windows host'tan)

```text
Host arch-ws
  HostName 127.0.0.1
  Port 2223
  User asir0z
  IdentityFile ~/.ssh/id_ed25519
```

```bash
ssh arch-ws
```

Remote/automated check için Hyprland runtime socket kullanılabilir (Sprint 2 evidence'te kanıtlandı).

### 8.3 VM başlatma ve config apply

```bash
# 1. VirtualBox → Arch-Engineering-Workstation → Start
# 2. Hyprland session'a giriş (asir0z)
# 3. Config apply:

cd ~/Projects/asir0z-smoothoperator
bash linux/arch-workstation/apply-config.sh
hyprctl reload    # Hyprland session içinde
```

**Profile detection:** `systemd-detect-virt` → `vm` veya `baremetal`  
Force: `WORKSTATION_PROFILE=vm bash linux/arch-workstation/apply-config.sh`

### 8.4 Dotfiles mimarisi

```text
linux/arch-workstation/
├── apply-config.sh              # Ana apply script
├── BAREMETAL-READINESS.md       # Bare-metal planlama (henüz authorized değil)
├── dotfiles/
│   ├── hypr/
│   │   ├── hyprland.base.conf   # Shared: monitor, keyboard, binds
│   │   ├── hyprland.vm.conf     # VM profile overlay
│   │   └── hyprland.baremetal.conf
│   ├── waybar/
│   ├── ssh/config.template      # contabo, devops-lab aliases
│   ├── git/gitconfig.fragment
│   └── bash/profile.d/
└── scripts/
    ├── install-cursor.sh
    └── set-operator-timezone.sh
```

**Apply sonrası guest'te:**

```text
~/.config/hypr/hyprland.conf       → sources base + profile
~/.config/hypr/hyprland.base.conf  → repo copy
~/.config/hypr/hyprland.profile.conf
```

**Authoritative keyboard config (Hyprland session):**

```text
kb_layout = tr,us
kb_options = grp:alt_shift_toggle
```

`localectl` sırası (`us,tr`) farklı olabilir — Hyprland session'da repo config geçerlidir (by design).

### 8.5 Hyprland kısayolları

| Key | Action |
|-----|--------|
| **Win + Enter** | Terminal (kitty) |
| **Win + E** | App launcher (wofi) — Cursor dahil |
| **Win + Q** | Close window |
| **Win + M** | Logout |

### 8.6 Cursor

```bash
bash linux/arch-workstation/scripts/install-cursor.sh
cursor ~/Projects/asir0z-smoothoperator
```

Canonical install path: `~/.local/opt/cursor/Cursor.AppImage`  
Launcher: `~/.local/bin/cursor`

### 8.7 Timezone

```bash
bash linux/arch-workstation/scripts/set-operator-timezone.sh
# veya root:
sudo timedatectl set-timezone Europe/Istanbul
timedatectl | grep "Time zone"
# Expected: Europe/Istanbul
```

---

## 9. Windows operator environment

### 9.1 Rol

Windows **safe fallback** — Arch VM kaybolsa bile engineering devam edebilmeli.

### 9.2 Canonical paths

| Windows | Arch parity |
|---------|-------------|
| `C:\Projects\asir0z-smoothoperator` | `~/Projects/asir0z-smoothoperator` |
| `C:\Projects\asir0z-devopslab` | `~/Projects/asir0z-devopslab` |

### 9.3 VirtualBox bootstrap share

WS-1 frozen install path:

```text
Host: C:\Projects\asir0z-smoothoperator\linux\bootstrap\
Guest mount: /mnt/bootstrap (vboxsf)
```

### 9.4 Display scaling notu

Operator "her şey büyük görünüyor" raporu → investigation tamamlandı.  
Hyprland `scale: 1.00` @ 1920×1080 — repo regression yok.  
**VM-specific** (VBox host zoom / auto-resize). Certification FAIL kriteri değil.

VM-only düzeltme adayları (repo'ya girmez):

1. VirtualBox **View → Virtual Screen 1 → Scale to 100%**
2. **View → Auto-resize Guest Display** toggle
3. Cursor **Settings → Window: Zoom Level** (yalnızca IDE büyükse)

---

## 10. Operator GUI acceptance test — adım adım

**Ortam:** Arch Hyprland interactive session (SSH değil — gerçek GUI)

### Hazırlık

```bash
# VM çalışıyor, Hyprland'a login olunmuş olmalı
cd ~/Projects/asir0z-smoothoperator
git pull origin master    # veya feature branch merge durumuna göre
bash linux/arch-workstation/apply-config.sh
hyprctl reload
```

### Test tablosu

Her maddeyi PASS/FAIL işaretle → `gui-validation.md`

| # | Test | Nasıl doğrulanır |
|---|------|------------------|
| 1 | Cursor launches | `Win+E` → Cursor seç **veya** terminal: `cursor ~/Projects/asir0z-smoothoperator` |
| 2 | Repo opens | Cursor'da `~/Projects/asir0z-smoothoperator` açılır |
| 3 | Terminal clipboard | kitty'de metin seç → `Ctrl+Shift+C` → `Ctrl+Shift+V` |
| 4 | Cursor ↔ Terminal | Cursor'dan kopyala → kitty'ye yapıştır ve tersi |
| 5 | Turkish keyboard | `ğüşiöç` yaz — karakterler doğru mu? |
| 6 | Alt+Shift toggle | TR ↔ US layout değişimi |
| 7 | US keyboard | `[]{}@#` — US layout'ta doğru mu? |
| 8 | Audio | Test sesi veya video playback |
| 9 | Reboot → Hyprland | `sudo reboot` → Hyprland otomatik başlar |
| 10 | Reboot → keyboard | Layout `tr,us` + Alt+Shift korunmuş |
| 11 | Reboot → timezone | `timedatectl \| grep "Time zone"` → `Europe/Istanbul` |
| 12 | Reboot → Cursor + repo | Cursor açılır, repo erişilebilir |

### Post-reboot timezone check

```bash
timedatectl | grep "Time zone"
# Expected: Time zone: Europe/Istanbul (+03, +0300)
```

### Keyboard remote verify (zaten PASS — interactive confirm bekliyor)

```bash
hyprctl devices | grep -A3 "at-translated"
# rules: l "tr,us", o "grp:alt_shift_toggle"
```

---

## 11. GUI PASS sonrası — Sprint 2 kapatma prosedürü

### Adım 1 — Evidence güncelle

`shared/evidence/ws-2/sprint-2/gui-validation.md`:

1. Operator acceptance tablosunda tüm maddeler → **PASS**
2. **Overall status** bölümünü şununla değiştir:

```text
PASS

WS-2 Sprint 2 is ready for certification review.

Outstanding issues:
None.

Interactive GUI validation completed.
Evidence complete.
```

3. `final-report.md` ve `README.md` (sprint-2) durum satırlarını güncelle
4. Gerekirse `shared/certification/PLATFORM-STATE.md` WS-2 bölümünü güncelle (certification review sonrası)

### Adım 2 — Commit

```text
docs(ws-2): finalize sprint-2 validation evidence
```

Commit'e dahil olması beklenen dosyalar:

- `shared/evidence/ws-2/sprint-2/gui-validation.md`
- `shared/evidence/ws-2/sprint-2/final-report.md`
- `shared/evidence/ws-2/sprint-2/README.md`
- (gerekirse) `shared/certification/PLATFORM-STATE.md`

### Adım 3 — DevOps Lab certification review isteği

```text
WS-2 Sprint 2
Timezone PASS
GUI PASS
Windows Sync PASS
Evidence Complete
Ready for Certification Review.
```

**Beklenen sonuç:** `APPROVED · CLOSED`  
**Sonraki odak:** Product Intelligence (`asir0z-product-intelligence`)

---

## 12. Agent kuralları (ChatGPT + Cursor)

### 12.1 Zorunlu prensipler

1. **Evidence before conclusions** — infra sorunlarında tahmin yok; kanıt topla
2. **Smallest correct fix** — spekülatif redesign yok
3. **No secrets in repo** — SSH keys, tokens, `.env` asla commit edilmez
4. **Sprint boundaries:**
   - Windows friction → **WIN-1 Core**
   - Arch / bare-metal → **WS-2**
   - Production → **DevOps Lab**
5. **Do not self-certify** — sprint closeout DevOps Lab otoritesinde
6. **VM disposable** — tüm kritik state Git + evidence + script'te

### 12.2 Yapılmaması gerekenler (şu an)

- WS-2 Sprint 3 veya yeni sprint açmak
- Bare-metal Arch install authorize etmek
- Hyprland dotfiles'ı VBox ergonomisi için değiştirmek
- `asir0z-cortex` için workaround sprint açmak
- Bootstrap automount'u Sprint 2 blocker yapmak
- Chat'teki bilgiyi evidence yerine kullanmak

### 12.3 Yapılabilecekler (şu an)

- GUI acceptance test rehberliği
- GUI FAIL durumunda root-cause investigation (evidence ile)
- `gui-validation.md` güncelleme (operator PASS raporladıktan sonra)
- Commit message ve certification request draft
- WIN-1 Core friction kaydı (Observed Friction formatında)
- Mission 20 observation soruları (DevOps Lab scope)

---

## 13. Evidence pack indeksi — WS-2 Sprint 2

```text
shared/evidence/ws-2/sprint-2/
├── README.md                          Sprint index
├── preflight.txt                      Phase 1 — system validation
├── cursor-installation.txt            Phase 2 — Cursor install
├── cursor-validation.md               Phase 2 — Cursor validation
├── display-scaling-investigation.md   Phase 2 — VM display (closed)
├── repository-inventory.md            Phase 3 — repos
├── dotfiles-inventory.md              Phase 4 — dotfiles
├── secret-scan.txt                    Phase 4 — pre-commit scan
├── timezone-verification.txt          Phase 4 — timezone PASS
├── keyboard-verification.txt          Phase 4 — keyboard PASS
├── development-round-trip.md            Phase 5 — git round-trip PASS
├── gui-validation.md                  Phase 5 — GUI checklist (OPEN)
└── final-report.md                    Phase 6 — certification decision
```

---

## 14. Certification kayıtları indeksi

| Dosya | Durum |
|-------|-------|
| [`PLATFORM-STATE.md`](../certification/PLATFORM-STATE.md) | **Canonical living state** |
| [`MIGRATION.md`](../certification/MIGRATION.md) | 100% · FROZEN ✅ |
| [`WIN-1.md`](../certification/WIN-1.md) | Infra CERTIFIED · Core OPEN |
| [`WIN-0.md`](../certification/WIN-0.md) | APPROVED |
| [`WS-1.md`](../certification/WS-1.md) | CERTIFIED · FROZEN |
| [`WIN-2.5.md`](../certification/WIN-2.5.md) | SPEC APPROVED · WAITING FOR WIN-1 |
| [`TRANSITION-INFRASTRUCTURE-REVIEW.md`](../certification/TRANSITION-INFRASTRUCTURE-REVIEW.md) | APPROVED ✅ |

---

## 15. SSH / network topology (özet)

```text
Windows host
├── ssh arch-ws        → 127.0.0.1:2223 (Arch VM)
├── ssh devops-lab     → 127.0.0.1:2222 (Transition VM, NAT only)
└── ssh contabo        → 169.58.62.107 (Production, DevOps Lab)

Arch VM (guest)
├── ssh contabo        → direct (key installed Sprint 1 audit)
└── ssh devops-lab     → 127.0.0.1:2222 (NAT — bare-metal'de Tailscale gerekir)
```

Template: `linux/arch-workstation/dotfiles/ssh/config.template`

---

## 16. ChatGPT ↔ Cursor rol ayrımı

| Kanal | Güçlü olduğu alan |
|-------|-------------------|
| **ChatGPT (SmoothOperator)** | Strateji, certification review hazırlığı, sprint scope, evidence yorumlama, operator rehberliği, DevOps Lab koordinasyon metinleri |
| **Cursor (SmoothOperator)** | Repo edit, script çalıştırma, SSH evidence toplama, commit/PR, dotfiles değişikliği, linter |

**Senkronizasyon kuralı:** Kararlar ve durum güncellemeleri **Git'e** girer (`PLATFORM-STATE.md`, evidence). Chat'ler arası handoff bu dosya veya güncel commit hash ile yapılır.

**Güncel commit referansı verirken:**

```text
origin/master: ee2063d
cursor/ws2-validation-evidence: a55faaa (validation evidence branch)
```

---

## 17. Deferred / backlog (Sprint 2 blocker değil)

| Item | Not |
|------|-----|
| `asir0z-cortex` repo restore | GitHub'da yok — defer |
| Bootstrap automount | Manual mount çalışıyor — backlog |
| Bare-metal Arch install | Plan var (`BAREMETAL-READINESS.md`) — **NOT AUTHORIZED** |
| WIN-1 Core | Friction-driven — henüz başlamadı |
| WIN-1A Ubuntu VM removal | Mission 20 observation PASS sonrası |
| Academetrica archive ingest | Bilinçli olarak Git dışı — ayrı ADR gerekir |

---

## 18. İlk oturum prompt önerisi (ChatGPT'ye yapıştır)

```text
SmoothOperator™ operator engineering assistant olarak çalış.

Canonical state: shared/certification/PLATFORM-STATE.md
Açık gate: WS-2 Sprint 2 — Operator GUI acceptance (gui-validation.md)
Engineering complete; GUI PASS bekleniyor.

Kurallar:
- Evidence before conclusions
- Self-certify yok
- GUI kapanmadan yeni sprint / redesign yok
- VM disposable — Git + evidence authoritative

Şu anki görev: [buraya operator intent yaz — örn. "GUI test rehberliği" veya "certification request draft"]
```

---

## 19. Durum güncelleme checklist (agent)

Platform durumu değiştiğinde:

- [ ] Evidence dosyası oluştur/güncelle (`shared/evidence/...`)
- [ ] Sprint report güncelle (varsa)
- [ ] Certification review iste veya kayıt ekle
- [ ] `PLATFORM-STATE.md` güncelle
- [ ] Commit + push
- [ ] Bu handoff belgesindeki snapshot'ı güncelle (opsiyonel — working note)

---

## 20. Hızlı komut referansı

```bash
# === Arch (Hyprland session) ===
cd ~/Projects/asir0z-smoothoperator
bash linux/arch-workstation/apply-config.sh && hyprctl reload
cursor ~/Projects/asir0z-smoothoperator
timedatectl
hyprctl monitors
hyprctl devices | grep -A3 keyboard

# === Windows ===
cd C:\Projects\asir0z-smoothoperator
git pull origin master
ssh arch-ws

# === Evidence path ===
shared/evidence/ws-2/sprint-2/gui-validation.md
```

---

*SmoothOperator™ · ChatGPT session start · 2026-07-23 · WS-2 Sprint 2 GUI gate open*
