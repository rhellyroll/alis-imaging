# ALIS Imaging & Disaster Recovery Platform  
**Automated Bare-Metal Recovery Using ReaR on STIG-Hardened RHEL 9**

---

## Executive Summary

This project implements an **automated imaging and bare-metal disaster recovery solution** for mission-critical Linux systems using **Relax-and-Recover (ReaR)** on **STIG-hardened Red Hat Enterprise Linux 9**.

The lab is modeled after **F-35 ALIS-style operational constraints**, where systems must be recoverable in **disconnected, security-sensitive environments** with minimal operator interaction. The imaging solution is built **on top of** an existing hardened Linux baseline and integrates with **external secrets management**, ensuring recovered systems remain compliant and operational post-restoration.

This README focuses specifically on the **imaging and disaster recovery layer**. Secure build and secrets management are documented in their respective repositories and referenced here as platform dependencies.

---

## Operational Problem

Mission systems operating in shipboard, forward-deployed, or restricted environments must support:

- Rapid recovery from hardware or system failure  
- Consistent restoration across replacement hardware  
- Recovery without continuous network access  
- Preservation of hardened security posture after rebuild  
- Operator-driven recovery under time pressure  

Manual rebuilds are slow, error-prone, and inconsistent. This project addresses those risks through **standardized, image-based Linux recovery**.

---

## Imaging & Recovery Architecture

### Recovery Model

- Full system capture using **ReaR**
- Bootable **ISO-based recovery media** (USB or network boot)
- NETFS backup storage with version retention
- Automated recreation of disk layout and bootloader

### Recovery Flow

1. Capture system state from hardened RHEL 9 host  
2. Generate bootable recovery ISO  
3. Validate backup and image integrity  
4. Deploy recovery media to USB  
5. Boot target system and confirm detected layout  
6. Automated bare-metal restoration  
7. Reboot into recovered system  
8. Post-recovery validation and service checks  

**Observed Recovery Time Objective (RTO): 30–45 minutes**

---

## Why ReaR for ALIS-Style Environments

ReaR was selected because it aligns with real operational constraints:

- Designed for **bare-metal recovery**, not just file restore  
- Handles disk layout and bootloader restoration automatically  
- Supports **disconnected recovery scenarios**  
- Requires minimal operator decision-making during restore  
- Proven tooling commonly used in enterprise Linux environments  

This makes it suitable for **field recovery**, hardware replacement, and system reconstitution scenarios.

---

## Platform Dependencies (Referenced, Not Duplicated)

This imaging solution is intentionally layered on top of existing platform components:

### Hardened Base OS
- STIG-hardened RHEL 9 baseline  
  <https://github.com/rhellyroll/rhel9-disa-stig-automation>
- Security controls applied **prior to imaging**
- Ensures recovered systems return to a compliant state

### Storage & Disaster Recovery Foundation
- LVM snapshot-based backup automation  
  <https://github.com/rhellyroll/lvm-snapshot-dr>
- Storage layer disaster recovery testing
- Disk layout and volume management foundations

### External Secrets Management
- Secrets and certificates managed via HashiCorp Vault  
  <https://github.com/rhellyroll/vault-secrets-management>
- No credentials embedded in images or recovery media
- Secrets re-issued post-recovery

This separation of concerns prevents credential exposure and preserves security posture during recovery.

---

## Related Labs & Portfolio

This imaging solution is part of a comprehensive infrastructure portfolio demonstrating defense-ready Linux administration:

- **RHEL9 STIG Automation**  
  <https://github.com/rhellyroll/rhel9-disa-stig-automation>

- **LVM Snapshot DR**  
  <https://github.com/rhellyroll/lvm-snapshot-dr>

- **Vault Secrets Management**  
  <https://github.com/rhellyroll/vault-secrets-management>

- **STIG Podman Hardening**  
  <https://github.com/rhellyroll/STIG-Podman-Hardening>

**Full Portfolio:** <https://github.com/rhellyroll>

---

## Technical Stack

- **Operating System**: Red Hat Enterprise Linux 9  
- **Security Baseline**: DISA STIG-aligned hardening  
- **Disaster Recovery**: Relax-and-Recover (ReaR)  
- **Backup Method**: NETFS  
- **Automation**: Bash scripting  
- **Recovery Artifacts**: Bootable ISO / USB media  

## Disaster Recovery Implementation Details (ReaR)

The imaging and recovery layer is implemented using **Relax-and-Recover (ReaR)** and serves as the primary mechanism for bare-metal disaster recovery in this lab.

### ReaR Configuration (Representative Excerpt)

The following excerpt highlights the intentional recovery strategy used. Defaults were reviewed and overridden only where operationally justified.

```ini
OUTPUT=ISO
BACKUP=NETFS
BACKUP_URL=file:///tmp/rear-backups
NETFS_KEEP_OLD_BACKUP_COPY=yes
GRUB_RESCUE=y

Design intent:

Bootable ISO generation for operator-friendly recovery

File-based backups suitable for disconnected environments

Retention of previous backups for rollback and auditability

Explicit bootloader recovery support

## Core Automation Components

The ALIS Imaging lab leverages **Relax-and-Recover (ReaR)** to enable **bare-metal disaster recovery** in disconnected, security-sensitive environments. This section details the automation layers, validation processes, and deployment packaging.

---

## Recovery Image Generation

Recovery images capture the **complete system state**, including:

- Disk layout  
- Partition tables  
- Bootloader  
- System configuration  
- Critical applications and dependencies  

These images produce **bootable ISOs** suitable for USB or offline network deployment.

**Command to generate recovery ISO:**
```bash
sudo rear -v mkbackup

Deployment Automation

Deployment automation ensures repeatable, operator-friendly recovery workflows:

Pre-flight system validation checks

Automated backup execution with detailed status reporting

Error detection with controlled failure handling

Logging for audit and troubleshooting

Recovery Verification

All recovery artifacts are validated to guarantee operational integrity and readiness:

ISO integrity verification

Backup archive verification

Configuration presence and correctness checks

System readiness assessment prior to deployment

Field Deployment Packaging

Recovery media is prepared for field deployment and offline use:

Creation of bootable USB recovery drives

Operator-focused recovery documentation

Distribution-ready deployment bundles (tar.gz)

Validation & Testing

Recovery processes were validated across five RHEL 9 virtual machines with diverse hardware and disk configurations.

Tested scenarios:

Complete system loss

Hardware replacement or migration

Corrupted or missing bootloader

Recovery from USB or local media

Results: All scenarios achieved full system restoration with services operational.

Post-Recovery Validation Checklist

After recovery, the system is verified against operational standards:

System boots automatically without manual intervention

SELinux enforcing

Network interfaces restored

Offline RPM repository accessible

Vault connectivity verified

Required services enabled and running

This checklist is designed for operators and reflects realistic field recovery procedures.

Scope Definition
In-Scope

Bare-metal imaging and disaster recovery

Rapid, operator-driven recovery workflows

Recovery in disconnected and constrained Linux environments

Out-of-Scope

High availability or live replication

Cloud-native or Kubernetes-managed deployments

Immutable infrastructure or CI/CD pipelines

Boundaries are aligned with enterprise and defense-grade operational constraints.

Skills Demonstrated

Linux system administration (RHEL 9)

STIG-aligned operational awareness

Bare-metal disaster recovery

Imaging and recovery automation

Disconnected operations and field deployment

Bash scripting for automation and validation

Operator-focused documentation practices

Requirements

RHEL 9 or compatible distribution

ReaR 2.6+

Root or sudo privileges

≥10 GB backup storage

≥8 GB USB drive for recovery media

Project Metadata

Author: Caleb Sims

Environment: RHEL 9 Virtual Machines

Estimated Build Time: 1–2 hours (imaging layer)

Portfolio: https://github.com/rhellyroll

This lab demonstrates enterprise-grade bare-metal disaster recovery capabilities required for mission-critical Linux systems operating in disconnected, security-sensitive environments.
