---
title: PC MIGHT-1000D — config matérielle
created: 2026-04-27
migrated_from: memory/reference_pc_config_might.md (auto-memory Cowork)
type: atome
domaine: Hardware
hostname: MIGHT-1000D
allume_24_7: true
tags: [hardware, pc, asus, i9-9900k, rtx-3090, windows-11]
---

# PC MIGHT-1000D — fiche matérielle

PC Windows 11 Pro principal de Mickael. **Allumé 24h/24** (contraintes domotique + Mode Réactif + scheduled tasks). C'est la base hardware actuelle pour Cowork + Jarvis + Hermès local.

## Identifiants

- **Hostname** : `MIGHT-1000D`
- **Manufacturer** : ASUS desktop
- **BIOS** : 1802 UEFI
- **Compte Windows** : `Might`
- **User folder** : `C:\Users\Might`
- **Dossier projet Jarvis** : `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant`

## Hardware confirmé (DxDiag partiel S36 + affirmation Mickael)

| Composant | Détail | Impact Jarvis |
|---|---|---|
| **CPU** | Intel Core i9-9900K @ 3.6 GHz (8 cores / 16 threads, Coffee Lake 2018) | Solide pour workload général. Pas d'AVX-512 (Icelake+ uniquement). CPU inference LLM limité, mais pas un bottleneck si GPU offload. |
| **RAM** | 32 Go DDR4 (32768 MB, Available OS 32684 MB) | Un peu juste pour LLM 70B en offload VRAM→RAM. Suffisant pour modèles qui tiennent en 24 Go VRAM (Qwen 3 32B Q4, Llama 3.1 8B). |
| **Page File** | 21,8 Go utilisé / 12,9 Go disponible | Sain, 32 Go RAM bien exploités |
| **GPU** | **RTX 3090 24 Go VRAM** (Mux Target = dGPU + affirmation orale Mickael S36) | **Game changer** pour inference locale. Validé `qwen35-agent` V1 S63 (Mode Réactif). |
| **OS** | Windows 11 Pro 64-bit, build 26200 (24H2 / 25H1) | Build récent. Supporte WSL2 + GPU passthrough CUDA → nécessaire pour Ollama / Hermès. |
| **DirectX** | DirectX 12 | OK pour tout |
| **DPI** | 144 (150 %) | Écran haute densité — captures Brave plus lourdes en tokens |
| **Carte mère probable** | ASUS Z390 (socket LGA 1151 v2 pour i9-9900K) | À confirmer DxDiag complet |

## Cas d'usage actuels (S36-S67)

- **Cowork Desktop Claude** (principal — toi en train de me lire)
- **Claude Code CLI** 2.1.114 (`claude -p` headless + interactif)
- **Task Scheduler Windows** :
  - Jarvis-TriGmail-Quotidien 05h + 14h
  - Jarvis-CheckAlert 04h
  - Jarvis-RapportJournalier 23h30
- **Runtime/Gmail-MCP-Server** (stdio Node, ~135 Mo)
- **WSL2 Ubuntu 24.04 LTS** + **Ollama** + **Hermes Agent v0.11.0** (Phase 1bis-c S48)
- **Brave Browser** + extension Claude in Chrome (allowlist sites HA)
- **OneDrive** + **HDD externe** pour backups

## Contraintes à retenir

- **Windows natif** → Cowork OK, mais Hermes Agent exige WSL2 (pas de build Windows natif listé)
- **RAM 32 Go** → viser modèles quantifiés Q4/Q5 qui tiennent en VRAM seule (pas d'offload), ou pattern `.wslconfig` 28 GB pour 70B Q3
- **24/7** → consommation GPU au repos ~20-30 W (vs 350 W en inference full tilt)

## Dans le projet Hardware_Upgrade (T#73)

- Le **i9-9900K + 32 Go DDR4** devient le **corps domotique** (Proxmox + HA OS VM + Frigate VM) selon plan brain/body
- La **RTX 3090** est **transférée** dans le nouveau PC Ryzen (cerveau IA)
- Voir [`Wiki/20_Projets/Hardware_Upgrade/01_Architecture_cible.md`](../../20_Projets/Hardware_Upgrade/01_Architecture_cible.md)

Variante 3 BoM (ré-évaluation S65) : **garder le i9-9900K comme cerveau IA actuel** + ajouter un mini-PC Proxmox dédié pour le corps domotique. Voir [`08_Audit_S63`](../../20_Projets/Hardware_Upgrade/08_Audit_S63_et_re_evaluation_hardware.md).

## Liens

- [`_Index.md`](_Index.md) — MOC Hardware
- [`Connexion_Fibre.md`](Connexion_Fibre.md) — fibre 1 Gbps
- [Cookbook Hermes RTX 3090](../../15_Hermes_Agent/Cookbook_RTX3090/_Index.md) — pilotage HA via Hermès local sur cette config
