# ARCHITECTURE NOTE — Mac as the Primary Operator Console

```text
Status: Accepted Architecture Direction
Scope: Long-Term Platform Architecture
Priority: Informational
Implementation: Incremental
```

---

## Purpose

The long-term goal is **not** to make the Arch Linux workstation mandatory.

The goal is to make the entire ecosystem manageable from the Mac regardless of whether the Arch machine is powered on.

The Mac should become the **primary operator console**, while the server remains the always-on infrastructure.

---

## Long-Term Architecture

```text
                    GitHub
                       │
        ┌──────────────┴──────────────┐
        │                             │
     MacBook                    Arch Linux
 Primary Operator            AI Workstation
        │                             │
        └──────────────┬──────────────┘
                       │
                Ubuntu Server
             (DevOps Lab Core)
                       │
     Docker · n8n · Reverse Proxy
       Monitoring · Automation
                       │
      Telegram · APIs · Public Services
```

---

## System Roles

### Mac

Primary responsibilities:

* Daily development
* Cursor
* ChatGPT
* Git
* SSH
* Terminal
* Repository management
* Infrastructure operations
* Emergency recovery
* Monitoring
* Documentation

The Mac is the default operator environment.

---

### Ubuntu Server

Primary responsibilities:

* Always-on infrastructure
* Docker
* Reverse Proxy
* n8n
* Monitoring
* Automation
* Public services
* Scheduled jobs
* Telegram bots

The server must continue operating independently from both Mac and Arch.

---

### Arch Linux

Primary responsibilities:

* AI development
* CUDA workloads
* Heavy builds
* Local LLMs
* Experimental environments
* High-performance engineering work

Arch is a compute workstation, **not** infrastructure.

The ecosystem must continue functioning even if Arch remains powered off for extended periods.

---

## Synchronization Strategy

### Source of Truth

Git repositories remain the canonical source.

```text
GitHub
   │
 ┌─┴───────────────┐
 │                 │
Mac            Arch
```

No manual file duplication.

Repositories synchronize through Git.

---

### Large Files

For non-Git assets:

Possible options:

* Syncthing
* Tailscale + rsync
* External storage if required

Selection will be evidence-based when the need arises.

---

## Remote Operations

The Mac should be capable of managing every system remotely.

Examples:

```bash
ssh lab
ssh arch
ssh nas
```

The operator should be able to:

* deploy
* monitor
* update
* troubleshoot
* review logs
* restart services

without physically accessing any machine.

---

## Failure Independence

Desired behaviour:

### If Arch is OFF

System continues operating.

* Website remains online
* Telegram bots continue
* n8n continues
* Docker services continue
* Monitoring continues

No infrastructure outage.

---

### If Mac is unavailable

Infrastructure continues running.

Operator access can later be restored from another device.

---

### If Server restarts

Mac and Arch remain unaffected.

Responsibilities stay separated.

---

## Apple Ecosystem Integration

Future Project Pulse architecture:

```text
Apple Watch
      │
Apple Health
      │
     Mac
      │
Project Pulse
      │
Ubuntu Server
      │
Telegram
```

The Apple ecosystem naturally integrates through the Mac.

Arch should not become a dependency for personal health or operational workflows.

---

## Engineering Principles

1. Mac is the operator console.
2. Ubuntu Server is the production infrastructure.
3. Arch is the compute workstation.
4. Git is the synchronization authority.
5. Infrastructure must not depend on Arch being powered on.
6. Every operational task should be executable from the Mac.
7. Compute and infrastructure responsibilities remain separated.

---

## Future Work

Potential future improvements include:

* SSH configuration simplification
* Unified terminal profiles
* Remote development workflows
* Automated synchronization
* Backup verification
* Secret management
* Infrastructure dashboards
* Project Pulse integration with Apple ecosystem

These enhancements should be implemented incrementally and only when justified by operational needs.

---

## Target State

The desired long-term operating model is:

> **Mac becomes the primary operator console. Ubuntu Server provides continuous infrastructure. Arch Linux serves as an on-demand high-performance workstation.**

This architecture minimizes operational risk, improves flexibility, and ensures the ecosystem remains fully manageable regardless of the power state of the Arch workstation.

---

## Relationship to Current Operations

This document defines **long-term direction**, not immediate execution.

| Phase | Operator environment | Notes |
|-------|---------------------|-------|
| Bare-metal prep (now) | Windows | Disk shrink, install USB, transient operator shell |
| Post-install validation | Arch + Windows fallback | Arch bootstrap; Windows secondary |
| Long-term target | Mac | Primary operator console per this document |

Bare-metal install spec and shrink plan are unchanged. Arch remains a compute workstation from day one; operator role migration to Mac is incremental.

---

*SmoothOperator™ · Accepted Architecture Direction · Informational*
