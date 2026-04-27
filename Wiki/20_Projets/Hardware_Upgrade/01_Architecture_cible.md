---
title: 01 — Architecture cible
created: 2026-04-27
migrated_from: Projets/Hardware_Upgrade/01_Architecture_cible.md
status: en-attente-phase-A-Hermes
phase: 0
budget_target: 2410 EUR
bloqueur: hermes-phase-1bis-d
tags: [projet, hardware, proxmox, ryzen]
---

# 01 — Architecture cible

**Date** : 26/04/2026 (S55)
**Statut** : verrouillée pour Phase 1 (achat groupé)

---

## 1. Vision globale — Brain / Body

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│              ARCHITECTURE DISTRIBUÉE JARVIS — 2026               │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────┐
│         CERVEAU IA                  │
│                                     │
│   PC RYZEN 9 (NEUF)                 │
│   • Ryzen 9 7950X (16C/32T)         │
│   • 64 Go DDR5-6000 (2×32)          │
│   • RTX 3090 24 Go (transfert)      │
│   • 2× NVMe Gen4 2 To               │
│   • Win 11 Pro                      │
│                                     │
│   Rôles :                           │
│   - Hermès Agent (orchestrateur)    │
│   - Ollama (LLM locaux)             │
│   - OpenRouter (Claude Haiku 4.5)   │
│   - Cowork (Claude Desktop)         │
│   - Skills CLI (tâches headless)    │
│   - Mode Réactif scheduled tasks    │
│                                     │
│   APC Back-UPS BR900G-FR (540W)     │
└─────────────────────────────────────┘
                  │
                  │ MQTT (Mosquitto VM)
                  │ API REST / Webhooks
                  │ HTTPS via Cloudflare Tunnel
                  │ SSH (admin)
                  │
═════════════════ ▼ ═══════════════════════════════════════════════

┌───────────────────────────────────────────────────────────────┐
│                    CORPS DOMOTIQUE                            │
│                                                               │
│   PROXMOX VE 8.x — i9-9900K (RÉUTILISÉ)                       │
│   • i9-9900K (8C/16T, 95W TDP)                                │
│   • 64 Go DDR4-2666 (4×16)                                    │
│   • CM ASUS ROG MAXIMUS XI HERO Z390                          │
│   • 1 To NVMe (système + VMs hors Frigate)                    │
│   • 8 To HDD WD Purple (Frigate vidéo)                        │
│   • 2× LAN Intel I219-V + I211-AT                             │
│                                                               │
│   ┌─────────────────────────────────────────────────────────┐ │
│   │  VM 1 — Home Assistant OS (CRITIQUE)                    │ │
│   │  • 4 vCPU, 8 Go RAM, 64 Go SSD                          │ │
│   │  • Image .qcow2 officielle, restore backup Pi5          │ │
│   │  • USB passthrough : 2× Sonoff ZBDongle-P + Coral USB   │ │
│   │  • IP fixe : 192.168.1.11 (récup IP Pi5)                │ │
│   │  • Interface : http://192.168.1.11:2096/                │ │
│   └─────────────────────────────────────────────────────────┘ │
│                                                               │
│   ┌─────────────────────────────────────────────────────────┐ │
│   │  VM 2 — Frigate (NVR + IA vision)                       │ │
│   │  • 6 vCPU, 12 Go RAM, 32 Go SSD système                 │ │
│   │  • HDD 8 To dédié vidéo (passthrough disque ou NFS)     │ │
│   │  • Coral USB passthrough (depuis Pi5)                   │ │
│   │  • 5-6 caméras RTSP (3 actuelles + 2-3 futures)         │ │
│   │  • go2rtc inclus pour optimisation flux                 │ │
│   └─────────────────────────────────────────────────────────┘ │
│                                                               │
│   ┌─────────────────────────────────────────────────────────┐ │
│   │  VM 3 — Docker Host (services)                          │ │
│   │  • 4 vCPU, 16 Go RAM, 64 Go SSD                         │ │
│   │  • Ubuntu Server 24.04 LTS                              │ │
│   │  • Containers (voir 02_Stack_Docker.md à créer) :       │ │
│   │    - Eclipse Mosquitto (MQTT broker)                    │ │
│   │    - Portainer (gestion containers)                     │ │
│   │    - Grafana + Prometheus (monitoring)                  │ │
│   │    - Uptime Kuma (alertes pannes)                       │ │
│   │    - Vaultwarden (mots de passe perso)                  │ │
│   │    - Watchtower (notifications updates, pas auto-apply) │ │
│   └─────────────────────────────────────────────────────────┘ │
│                                                               │
│   ┌─────────────────────────────────────────────────────────┐ │
│   │  VM 4 — Proxmox Backup Server (PBS)                     │ │
│   │  • 2 vCPU, 4 Go RAM, 16 Go SSD                          │ │
│   │  • Datastore sur HDD 8 To (partition séparée)           │ │
│   │  • Backups quotidiens HA OS + Frigate config            │ │
│   │  • Rétention : 7 jours daily / 4 weekly / 3 monthly     │ │
│   └─────────────────────────────────────────────────────────┘ │
│                                                               │
│   Total alloc : ~16 vCPU (oversubscription OK)                │
│   Total RAM   : ~40 Go alloués / 64 Go disponibles            │
│                                                               │
│   APC Smart-UPS SMT2200IC (1500W)                             │
└───────────────────────────────────────────────────────────────┘

           │
           │ Switch 2.5G TP-Link TL-SG108-M2
           │
   ┌───────┴───────────────┬──────────────────┐
   ▼                       ▼                  ▼
┌─────────┐          ┌──────────┐      ┌────────────┐
│ Box     │          │ Caméras  │      │ Pi5        │
│ Orange  │          │ IP RTSP  │      │ (standby   │
│ Livebox │          │ (3 → 5-6)│      │  rollback) │
└─────────┘          └──────────┘      └────────────┘
   │
   ▼ Internet
   Cloudflare Tunnel → ha.might.ovh (HA distant)
                    → mcp.might.ovh (ha-mcp endpoint)
```

---

## 2. Allocation ressources Proxmox

| VM | vCPU | RAM | Disque système | Stockage data | Priorité |
|---|---|---|---|---|---|
| HA OS | 4 | 8 Go | 64 Go NVMe | — | **CRITIQUE** |
| Frigate | 6 | 12 Go | 32 Go NVMe | 8 To HDD | Haute |
| Docker Host | 4 | 16 Go | 64 Go NVMe | — | Moyenne |
| PBS (backup) | 2 | 4 Go | 16 Go NVMe | partition HDD | Haute |
| **Total** | **16 vCPU** | **40 Go** | **176 Go** | **8 To** | |
| Réserve Proxmox host | — | 4 Go | — | — | Système |
| **Disponible 64 Go RAM** | | **20 Go libre** | | | Marge croissance |

i9-9900K = 8 cœurs / 16 threads → oversubscription 1:1, OK car pas tout en pleine charge simultané.

---

## 3. Communication brain ↔ body

### Bus principal : MQTT

```
Frigate (VM Proxmox)
  └── MQTT publish "frigate/events" → Mosquitto (VM Docker Proxmox)
                                          ▲
                                          │ subscribe
                                          │
HA OS (VM Proxmox) ───────────────────────┤
                                          │
PC Ryzen (Hermès Agent) ──────────────────┘
  └── peut publier des commandes (skills CLI)
```

### Bus secondaire : API REST + Webhooks

- **HA REST API** : exposée sur 192.168.1.11:8123 (LAN) et ha.might.ovh (CF Tunnel)
- **ha-mcp endpoint** : mcp.might.ovh (URL publique pour Hermès / Cowork)
- **Webhooks Frigate** : alertes vers HA + éventuellement Hermès
- **OpenRouter API** : appelée par Hermès depuis PC Ryzen pour Claude Haiku 4.5 (T#69)

### Bus admin : SSH

- PC Ryzen → Proxmox host (gestion VM)
- PC Ryzen → VM HA OS (HA Terminal addon)
- Mickael (clés perso) sur tout

---

## 4. Sécurité réseau

| Couche | Protection actuelle | Évolution |
|---|---|---|
| WAN | Cloudflare (HSTS, CSP report-only, Access dashboard) | Inchangé S55 |
| Tunnel | Cloudflare Tunnel (cloudflared sur Pi5 actuellement) | À migrer vers VM Docker Proxmox Phase 5 |
| LAN | 192.168.1.0/24 derrière box Orange | OK |
| Isolation VM | Bridge `vmbr0` Proxmox | Optionnel : VLAN si besoin futur |
| Auth HA | TOTP MFA + HSTS (S19) | Inchangé |
| Backup | OneDrive + Git privé (S17) | + PBS local quotidien |

---

## 5. Continuité de service (RTO / RPO)

| Composant | RTO cible | RPO cible | Plan |
|---|---|---|---|
| HA OS | 30 min | 24h | Backup quotidien PBS + Pi5 standby (rollback chaud) |
| Frigate | 1h | 24h | Config dans Git, vidéo non critique |
| Docker services | 1h | 7j | docker-compose dans Git, données dans volumes backupés |
| Proxmox host | 4h | — | Réinstall depuis ISO + import VMs depuis PBS externe |

**Pi5 reste opérationnel et éteint** pendant 90 jours après bascule HA → rollback ultime possible (SD card intacte).

---

## 6. Évolutions prévisibles 12-24 mois

| Évolution | Déclencheur | Impact |
|---|---|---|
| Ajout 2-3 caméras Frigate | Mickael → 5-6 cams cible | RAM Frigate à monter à 16-20 Go |
| Carte AP9631 SmartSlot SMT2200IC | Si besoin SNMP / résilience monitoring | ~250 € |
| Upgrade RAM Ryzen 64 → 128 Go | Si modèles LLM 70B Q4 nécessaires | ~250 € (2×32 supplémentaires) |
| 2e GPU sur Ryzen | Si parallèle LLM + Frigate cloud-failover | ~600-1500 € selon modèle |
| Cluster Proxmox 2-3 nœuds | Si haute disponibilité critique | Achat 2e mini-PC (~600 €) |
| 10 GbE LAN | Si NAS dédié vidéo | ~200-400 € (switch + cartes) |

Toutes ces évolutions sont **réversibles ou additives** : aucune décision d'architecture actuelle ne les bloque.

---

## Source originale conservée

Fichier source intact : `Projets/Hardware_Upgrade/01_Architecture_cible.md` (lecture seule pour ce vault).
