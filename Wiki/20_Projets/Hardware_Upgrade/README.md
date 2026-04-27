---
title: Hardware Upgrade — Vue d'ensemble
created: 2026-04-27
migrated_from: Projets/Hardware_Upgrade/README.md
status: en-attente-phase-A-Hermes
phase: 0
budget_target: 2410 EUR
bloqueur: hermes-phase-1bis-d
tags: [projet, hardware, proxmox, ryzen]
---

# Hardware Upgrade — Architecture distribuée Jarvis

**Lancement** : 26/04/2026 (S55 Cowork)
**État** : Phase 0 — Pré-requis validés, BoM finalisée, en attente de commande
**Budget cible** : 2500 €
**Référent décision** : Mickael uniquement

---

## Objectif

Faire évoluer l'écosystème Jarvis d'un setup centralisé (Pi5 + PC unique) vers une **architecture distribuée à deux machines** :

- **Cerveau IA** : nouveau PC Ryzen 9 + RTX 3090 (Hermès, Ollama, Cowork)
- **Corps domotique** : ancien i9-9900K → Proxmox VE (HA OS, Frigate, services)

Communication brain ↔ body via **MQTT + API REST + Cloudflare Tunnel** (déjà en place).

---

## Contenu du dossier

| Fichier | Sujet | Statut |
|---|---|---|
| `README.md` | Ce fichier — vue d'ensemble | OK |
| `00_Decisions_et_audits.md` | Décisions Mickael + résultats des 3 audits pré-achat | OK |
| `01_Architecture_cible.md` | Schéma architecture, rôles machines, communication | OK |
| `02_BoM_finalisee.md` | Bill of Materials détaillé avec prix et modèles précis | OK |
| `03_Phasage_A_a_G.md` | 7 phases d'exécution avec checklist | OK |
| `04_Risques_et_mitigations.md` | Tableau risques + plan rollback | OK |
| `05_Onduleurs_NUT.md` | Config NUT/apcupsd Proxmox + PC | OK |
| `06_Migration_HA_Pi5_Proxmox.md` | Procédure pas-à-pas migration HA | OK |
| `07_Frigate_VM_Coral.md` | Sortie Frigate du Supervisor + passthrough Coral | OK |
| `08_Audit_S63_et_re_evaluation_hardware.md` | Re-cadrage post audit S63 (Hermès local OK) | OK |

---

## Statut actuel

```
Phase 0 — Pré-requis (en cours)
  Audit 1 — CM actuelle : ASUS ROG MAXIMUS XI HERO (WI-FI), Z390, IOMMU OK
  Audit 2 — Dongles Zigbee : 2× Sonoff ZBDongle-P (1 ZHA + 1 OpenThread/Matter)
  Audit 3 — Onduleurs : APC SMT2200IC + APC BR900G-FR
  BoM finalisée
  Génération docs phasage/risques (étape suivante)
  Validation finale Mickael
  Commande matériel
```

---

## Architecture en une page

```
┌─────────────────────────────────┐         ┌─────────────────────────────┐
│  PC RYZEN — CERVEAU IA          │  MQTT   │  i9-9900K — PROXMOX         │
│  Ryzen 9 7950X / 64 Go DDR5     │ ◄─────► │  64 Go DDR4 / 1 To NVMe     │
│  RTX 3090 24 Go (depuis ancien) │   API   │  + 8 To HDD Frigate         │
│                                 │  REST   │                             │
│  - Hermès Agent + Ollama        │         │  ┌─ VM HA OS (Pi5 migré)    │
│  - Cowork (Claude Desktop)      │         │  │  + 2× Zigbee passthrough │
│  - Skills CLI / Tasks 04h+23h30 │         │  ├─ VM Frigate (Coral USB)  │
│  - Modèles locaux + OpenRouter  │         │  ├─ VM Docker (services)    │
│                                 │         │  │   MQTT, Portainer,       │
│        APC BR900G-FR (540W)     │         │  │   Grafana, Uptime Kuma   │
│                                 │         │  └─ Proxmox Backup Server   │
└─────────────────────────────────┘         │                             │
                                            │  APC SMT2200IC (1500W)      │
                                            │     + Switch 2.5G + Box     │
                                            └─────────────────────────────┘
```

---

## Références internes

- **Auto-memory baseline** : `memory/reference_pc_config_might.md` (config i9-9900K actuelle)
- **Mode Réactif v1.1** : `Ressources/Competences/Mode_Reactif.md` (à migrer vers Ryzen)
- **Phase 1bis-d Hermès** : `memory/project_phase1bisd_b1_resultats.md` (préalable à valider)
- **OpenRouter setup** : `memory/reference_openrouter_setup_garde_fous.md` (S55, hybride local/cloud)
- **Connexion fibre** : `memory/reference_mickael_connexion_fibre.md` (1 Gbps WAN OK)

---

## Points d'attention permanents

1. **HA Pi5 reste en standby** pendant tout le projet — rollback chaud possible jusqu'à validation 7 jours en parallèle
2. **Network key Zigbee** stockée dans le flash des dongles → migration **physique** des dongles, pas de réappairage
3. **Cloudflare Tunnel** pointe vers 192.168.1.11 → bascule DNS à coordonner avec migration HA
4. **Mode Réactif scheduled tasks** sur PC actuel → migration vers Ryzen avant bascule Proxmox
5. **Aucune deletion** sans validation explicite (règle CLAUDE.md)

---

## Source originale conservée

Fichier source intact : `Projets/Hardware_Upgrade/README.md` (lecture seule pour ce vault).
