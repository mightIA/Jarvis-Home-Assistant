---
title: Hardware — Map of Content (MOC)
created: 2026-04-27
migrated_from: (synthèse de plusieurs auto-memories Cowork)
type: moc
domaine: Hardware
tags: [hardware, moc, index, pc, gpu, reseau, onduleur, zigbee]
---

# Hardware — Map of Content

Domaine matériel de Mickael : PC, GPU, dongles Zigbee, onduleurs, connexion réseau. Couvre l'**état actuel** (S67) et les **projets en cours** (Hardware_Upgrade T#73).

## Atomes du domaine

| Atome | Sujet | Statut |
|---|---|---|
| [`PC_MIGHT-1000D.md`](PC_MIGHT-1000D.md) | PC principal Windows 11 (i9-9900K + 32 Go + RTX 3090) | actuel |
| [`Dongles_Zigbee.md`](Dongles_Zigbee.md) | 2× Sonoff ZBDongle-P sur Pi5 (1 ZHA + 1 OpenThread/Matter) | actuel |
| [`Onduleurs_APC.md`](Onduleurs_APC.md) | APC SMT2200IC (1500 W) + APC BR900G-FR (540 W) | possédés |
| [`Connexion_Fibre.md`](Connexion_Fibre.md) | Fibre ~1 Gbps, ~110 MB/s soutenu mesuré | actuel |
| [`Inventaire_HA.md`](Inventaire_HA.md) | Pointeur vers `Ressources/Competences/Home_Assistant_Inventaire.md` | vivant |

## État actuel (S67 — 27/04/2026)

| Brique | Hardware | Logiciel |
|---|---|---|
| **PC principal** | i9-9900K + 32 Go DDR4 + RTX 3090 24 Go | Win 11 Pro 24H2 + Cowork + Hermès local (WSL2) |
| **Pi5 HA** | Raspberry Pi 5 + Coral USB | HA OS + 25 add-ons + 63 intégrations |
| **Réseau** | Box Orange Livebox + switch TP-Link TL-SG108-M2 (non-PoE) | NTP synchro, fibre ~1 Gbps |
| **Stockage** | NVMe principal + HDD secondaire + OneDrive backup | Backup HA quotidien Google Drive |
| **Énergie** | 2× APC (déjà possédés, **pas branchés** côté PC actuel) | (à brancher Phase D/C projet hardware) |

## Projets liés

### Hardware_Upgrade (T#73) — Phase 0

Projet d'évolution vers une architecture **brain/body** sur 2 machines :
- **Brain** : nouveau PC Ryzen 9 7950X + 64 Go DDR5 + RTX 3090 (transférée) — Hermès, Ollama, Cowork
- **Body** : i9-9900K → Proxmox VE — HA OS VM, Frigate VM, Docker host services

📍 [`Wiki/20_Projets/Hardware_Upgrade/_Index ?`](../../20_Projets/Hardware_Upgrade/) (pas d'index dédié encore — voir README et 08_Audit_S63 pour les variantes)

3 variantes BoM (S65 ré-évaluation) :
- V1 originale : 2410 € (Ryzen 7950X + 64 Go DDR5 + RTX 3090 + Proxmox add-ons + switch 2.5G)
- V2 allégée CPU : 2150-2290 € (Ryzen 7700X ou 7900X)
- V3 minimale Proxmox uniquement : 1100-1400 € (NUC Ryzen 7 + 32 Go + 8 To HDD Frigate, garde i9-9900K en cerveau IA)

**Verdict S63** : **NO-GO confirmé sur upgrade hardware urgent** — `qwen35-agent` V1 valide la stack actuelle pour Mode Réactif. Mais **upgrade pertinent à terme** côté corps domotique (Pi5 limité Proxmox + Frigate).

### Cookbook Hermès RTX 3090

📍 [`Wiki/15_Hermes_Agent/Cookbook_RTX3090/_Index.md`](../../15_Hermes_Agent/Cookbook_RTX3090/_Index.md)

Retour d'expérience reproductible (cookbook public GitHub MIT) sur le pilotage HA via Hermes Agent + Ollama + RTX 3090. Justifie la viabilité de la config actuelle pour le Mode Réactif.

## Auto-memories Cowork sources

- `reference_pc_config_might.md` — PC MIGHT-1000D
- `reference_zigbee_dongles_might.md` — dongles ZBDongle-P
- `reference_onduleurs_might.md` — APC SMT2200IC + BR900G-FR
- `reference_mickael_connexion_fibre.md` — fibre 1 Gbps
- `feedback_local_llm_faisable_rtx3090.md` — RTX 3090 24 Go inference LLM faisable
- `project_hardware_upgrade.md` — projet upgrade T#73

## Liens transverses

- [Domotique](../Domotique/_Index.md) — domaine Zigbee + ZHA + Matter (s'appuie sur les dongles d'ici)
- [Réseau](../Reseau/) — domaine réseau (s'appuie sur la fibre + switch d'ici)
- [Hermès Agent](../../15_Hermes_Agent/) — exploite la RTX 3090 du PC MIGHT-1000D
- [Hardware_Upgrade (projet)](../../20_Projets/Hardware_Upgrade/README.md) — évolution prévue
