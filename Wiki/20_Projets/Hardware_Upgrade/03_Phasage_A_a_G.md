---
title: 03 — Phasage A à G
created: 2026-04-27
migrated_from: Projets/Hardware_Upgrade/03_Phasage_A_a_G.md
status: en-attente-phase-A-Hermes
phase: 0
budget_target: 2410 EUR
bloqueur: hermes-phase-1bis-d
tags: [projet, hardware, proxmox, ryzen, phasage]
---

# 03 — Phasage A à G

**Date** : 26/04/2026 (S55)
**Durée totale estimée** : 3-4 weekends étalés
**Principe directeur** : Pi5 production INTACT jusqu'à validation 7 jours en parallèle

---

## Vue d'ensemble

```
Phase A — Pré-requis Hermès (avant achat Ryzen)         [1 weekend]
Phase B — Achat groupé matériel                          [1 commande]
Phase C — Montage PC Ryzen + migration Cowork           [1 weekend]
Phase D — Install Proxmox sur i9-9900K (HA Pi5 intact)  [1/2 journée]
Phase E — Migration HA Pi5 → VM Proxmox                 [1 journée]
Phase F — Frigate VM + Coral passthrough + caméras      [1/2 journée]
Phase G — Services secondaires + finalisation           [étalé 2-3 sem]
```

---

## Phase A — Pré-requis Hermès (AVANT achat)

**Objectif** : valider qu'un modèle local saura **écrire dans HA** (l'écriture est bloquée actuellement avec qwen3:32b cf S48+S53). Sinon → architecture hybride OpenRouter dimensionne différemment le besoin Ryzen.

**Préalable** : RTX 3090 sur PC actuel toujours disponible (pas encore migré).

### Checklist

- [ ] **A.1** Backup config Hermès actuelle (`~/.hermes/config.yaml` + `~/.hermes/.env`)
- [ ] **A.2** Test modèle 1 — `mistral-nemo:12b` sur HA (ha_call_write_tool)
  - [ ] Pull modèle : `ollama pull mistral-nemo:12b`
  - [ ] Lancer Hermès avec ce modèle
  - [ ] Test écriture HA : créer une input_boolean via Hermès
  - [ ] Logger résultat dans `Projets/Hermes_Phase1bis_d/test_b2.md`
- [ ] **A.3** Test modèle 2 — `llama3.3:70b-instruct-q3_K_M` (~33 Go VRAM, limite 3090)
  - [ ] Pull modèle (~30 Go download, prévoir ~5 min en fibre)
  - [ ] Tester si fits 24 Go VRAM ou crash OOM
  - [ ] Si OK : test écriture HA
- [ ] **A.4** Test modèle 3 — Hybride OpenRouter Claude Haiku 4.5 pour écriture
  - [ ] Hermès configuré avec routing : lecture local (qwen3) + écriture OpenRouter
  - [ ] Test écriture HA via OpenRouter
  - [ ] Mesure coût par appel
- [ ] **A.5** Verdict Phase A
  - [ ] Si A.2 ou A.3 fonctionne → 100% local viable, Ryzen 7950X + 64 Go OK
  - [ ] Si A.4 fonctionne uniquement → hybride confirmé, **Ryzen 7900X suffirait** (économie 120 €)
  - [ ] Si rien ne fonctionne → STOP achat, investigation supplémentaire

### Critères de sortie

- Au moins UN modèle teste l'écriture HA avec succès (taux ≥ 80% sur 10 tests)
- Architecture finale décidée (100% local OU hybride OpenRouter)
- Mickael valide explicitement le passage Phase B

### Risques

| Risque | Probabilité | Impact | Mitigation |
|---|---|---|---|
| Aucun modèle local n'écrit fiablement | Moyenne | Bloque achat Ryzen pertinent | Bascule hybride OpenRouter (cap $5/mois suffit) |
| Llama 3.3 70B crash OOM 24 Go | Élevée | Réduit choix modèles | Q3 ou Q2 quantization, ou attendre 128 Go RAM upgrade |

---

## Phase B — Achat groupé

**Objectif** : commande unique, 2500 € budget, livraison D+3 à D+7.

### Checklist

- [ ] **B.1** Comparaison prix sur 3 vendeurs (LDLC / TopAchat / Materiel.net)
  - [ ] Remplir tableau dans `02_BoM_finalisee.md` section 6
  - [ ] Identifier vendeur principal (souvent meilleur prix global = LDLC ou TopAchat)
- [ ] **B.2** Validation finale BoM Mickael
  - [ ] Re-checker dispo stock chez vendeur principal
  - [ ] Si rupture sur 1 composant → variante équivalente (cf section "Choix non retenus")
- [ ] **B.3** Commande
  - [ ] Paiement (CB Mickael)
  - [ ] **NE PAS** sauvegarder CB chez le vendeur (cf règles auto-memory `feedback_openrouter_one_time_payment_toggle`)
  - [ ] Confirmation reçue par mail
- [ ] **B.4** Suivi livraison
  - [ ] Dates estimées notées
  - [ ] Préparation espace de travail (table dégagée, antistatique)
- [ ] **B.5** Réception
  - [ ] Inventaire complet (cf BoM checklist)
  - [ ] Aucun composant manquant ou abîmé
  - [ ] Si problème → contact vendeur immédiat avant ouverture des autres

### Critères de sortie

- Tous les composants reçus en bon état
- Documentation et garanties archivées dans `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Projets\Hardware_Upgrade\factures\` (à créer)

---

## Phase C — Montage PC Ryzen + migration Cowork

**Objectif** : nouveau PC Ryzen opérationnel avec Win 11, Cowork, Hermès. Ancien i9-9900K reste actif (pas encore Proxmox).

### Checklist montage hardware (1/2 journée)

- [ ] **C.1** Préparation
  - [ ] Espace antistatique
  - [ ] Outils (tournevis cruciforme, pince à dents, lampe)
  - [ ] Vidéo de référence Gigabyte X670E AORUS Elite AX
- [ ] **C.2** Montage CM dans boîtier Define 7
  - [ ] Entretoises montées
  - [ ] CM fixée
  - [ ] I/O shield aligné
- [ ] **C.3** CPU + ventirad
  - [ ] Ryzen 7950X dans socket AM5 (attention orientation triangle)
  - [ ] Pâte thermique (point central, taille petit pois)
  - [ ] Noctua NH-D15 monté (vérifier serrage)
- [ ] **C.4** RAM
  - [ ] 2× G.Skill 32 Go dans slots **A2 et B2** (recommandation manuel CM)
  - [ ] Clip bien enclenché
- [ ] **C.5** SSD
  - [ ] Samsung 990 Pro dans M.2_1 (système Windows)
  - [ ] Crucial T500 dans M.2_2 (modèles IA)
  - [ ] Visses M.2 serrées
- [ ] **C.6** Alimentation
  - [ ] Corsair RM1000x dans boîtier
  - [ ] Câbles modulaires : 24-pin ATX, 8-pin EPS CPU, **2× 8-pin PCIe** pour 3090
- [ ] **C.7** Transfert RTX 3090
  - [ ] Démontage du PC actuel
  - [ ] Installation slot PCIe x16 principal CM
  - [ ] Branchement 2× 8-pin PCIe
- [ ] **C.8** Boot test (sans OS)
  - [ ] Premier démarrage → BIOS visible
  - [ ] BIOS update vers dernière version (Q-Flash via clé USB FAT32)
  - [ ] Profil EXPO RAM activé (DDR5-6000 CL30)
  - [ ] Re-test stabilité (memtest86 1 cycle, ~1h)

### Checklist install OS + Cowork (1/2 journée)

- [ ] **C.9** Install Windows 11 Pro
  - [ ] Clé USB Rufus avec ISO Win 11
  - [ ] Compte local recommandé (pas Microsoft account si possible)
  - [ ] Drivers chipset AMD
  - [ ] Drivers NVIDIA RTX 3090 (Studio Driver, pas GeForce Game Ready)
- [ ] **C.10** Install Claude Cowork (Claude Desktop)
  - [ ] Téléchargement claude.ai/download
  - [ ] Login compte might57290@gmail.com
  - [ ] Sync workspace folder D:\Might\IA\Projets Cowork\Jarvis - Home Assistant
  - [ ] Plugins : skills-plugin, anthropic-skills, etc. (cf liste actuelle)
  - [ ] `.mcp.json` copié depuis ancien PC
  - [ ] Test : ouvrir Cowork, lire CLAUDE.md, vérifier MCP connectés
- [ ] **C.11** Install Hermès Agent
  - [ ] WSL2 Ubuntu 24.04 (via Windows Store ou commande wsl --install)
  - [ ] Clone repo Hermès
  - [ ] `~/.hermes/config.yaml` migré depuis ancien PC
  - [ ] `~/.hermes/.env` recréé (ne PAS copier l'ancien — clés à régénérer)
  - [ ] Ollama installé natif Windows + serveur OLLAMA_HOST=0.0.0.0:11434
  - [ ] Test Hermès → MCP ha-mcp → ha_get_overview
- [ ] **C.12** Migration Mode Réactif scheduled tasks
  - [ ] Export tâches Windows depuis ancien PC : `schtasks /Query /TN "JarvisAlert" /XML > task_alert.xml`
  - [ ] Import sur Ryzen : `schtasks /Create /TN "JarvisAlert" /XML task_alert.xml`
  - [ ] Idem pour rapport-journalier-reactif
  - [ ] **Désactiver** les tâches sur l'ancien PC (ne pas supprimer encore)

### Critères de sortie

- Ryzen boot stable, BIOS à jour, EXPO actif
- Cowork fonctionne avec MCP ha-mcp
- Hermès tourne et écrit dans HA (cf Phase A)
- Mode Réactif tâches déclenchent à 04h00 et 23h30 sur Ryzen
- Ancien PC encore actif (sécurité)

---

## Phase D — Install Proxmox sur i9-9900K

**Objectif** : Proxmox 8.x fonctionnel, VM Docker Host avec stack monitoring de base. **HA Pi5 INTACT pendant tout Phase D.**

### Pré-requis avant démarrage

- [ ] Phase C terminée (Ryzen autonome pour Cowork/Hermès)
- [ ] Backup complet de l'i9-9900K Windows actuel (Macrium Reflect ou clone disque)
  - [ ] Stocké sur HDD externe + OneDrive
  - [ ] Vérifier intégrité backup
- [ ] **DÉCISION** : SSD Win 11 actuel reste-t-il dans la machine ou est-il déposé ? Reco : **déposer le SSD Windows actuel et le mettre en sécurité hors machine** pendant tout Phase D. Boot Proxmox sur le NEUF Crucial P3 Plus 1 To uniquement.

### Checklist install Proxmox

- [ ] **D.1** Préparation hardware i9-9900K
  - [ ] Démontage SSD Windows existant → mise en sécurité
  - [ ] Installation Crucial P3 Plus 1 To (M.2_1)
  - [ ] Installation HDD WD Purple 8 To (SATA)
  - [ ] Ajout 2× 16 Go DDR4 Crucial → total 4×16 = 64 Go
  - [ ] BIOS : activer **VT-d** + **Virtualization** + IOMMU
  - [ ] BIOS : désactiver WiFi, audio, RGB (économie ressources)
- [ ] **D.2** Audit IOMMU avant install (LIVE Linux)
  - [ ] Boot Ubuntu 24.04 live USB
  - [ ] Commande : `dmesg | grep -i -e DMAR -e IOMMU` → vérifier "DMAR: IOMMU enabled"
  - [ ] Commande : `find /sys/kernel/iommu_groups/ -type l | sort -V` → vérifier groupes séparés pour USB ports (passthrough Zigbee+Coral)
  - [ ] Logger résultat dans ce fichier
- [ ] **D.3** Install Proxmox VE 8.x
  - [ ] Download ISO depuis proxmox.com/en/downloads
  - [ ] Clé USB Rufus mode DD (PAS ISO)
  - [ ] Boot, install sur Crucial P3 Plus
  - [ ] Hostname : `proxmox-jarvis`
  - [ ] IP fixe : 192.168.1.10 (NE PAS prendre 192.168.1.11 qui reste pour le Pi5/futur HA OS)
  - [ ] FQDN : `proxmox-jarvis.local`
  - [ ] Mot de passe root fort (cf règle 0 sécurité)
- [ ] **D.4** Configuration post-install
  - [ ] Ajout repo no-subscription dans /etc/apt/sources.list.d/pve-no-subscription.list
  - [ ] `apt update && apt full-upgrade`
  - [ ] Activation IOMMU dans GRUB : `intel_iommu=on iommu=pt`
  - [ ] Reboot
  - [ ] Vérifier : `dmesg | grep -i iommu` montre "IOMMU enabled"
- [ ] **D.5** Storage configuration
  - [ ] Pool LVM-thin sur Crucial P3 Plus (déjà fait par installer)
  - [ ] Add HDD WD Purple comme storage "frigate-video" (LVM ou dir)
  - [ ] Datastore PBS partition séparée HDD (50 Go suffit pour PBS DB)
- [ ] **D.6** VM Docker Host (Ubuntu Server 24.04)
  - [ ] Création VM `vm-docker` (ID 100)
  - [ ] 4 vCPU, 16 Go RAM, 64 Go SSD système
  - [ ] Install Docker Engine + Compose
  - [ ] Premier docker-compose : Mosquitto + Portainer + Uptime Kuma
- [ ] **D.7** VM Proxmox Backup Server (PBS)
  - [ ] Création VM `vm-pbs` (ID 110)
  - [ ] 2 vCPU, 4 Go RAM, 16 Go SSD système
  - [ ] Datastore sur partition HDD dédiée
  - [ ] Backup task quotidien (à activer Phase E quand HA migré)

### Critères de sortie

- Proxmox web UI accessible https://192.168.1.10:8006
- IOMMU activé, groupes séparés pour USB
- VM Docker Host démarre, Mosquitto pingable depuis LAN
- PBS opérationnel, datastore configuré
- HA Pi5 toujours **INTACT et actif** sur 192.168.1.11

---

## Phase E — Migration HA Pi5 → VM Proxmox

**Objectif** : HA tourne en VM Proxmox, Pi5 conservé éteint en rollback chaud.

### Pré-requis avant démarrage

- [ ] Phase D validée
- [ ] Backup complet HA Pi5 (Settings → System → Backups → Create backup)
  - [ ] Téléchargement local PC Ryzen
  - [ ] Copie sur OneDrive
  - [ ] Vérification taille et intégrité

### Checklist migration

- [ ] **E.1** Création VM HA OS
  - [ ] Download image officielle haos_ova-X.X.X.qcow2 (home-assistant.io/installation/generic-x86-64)
  - [ ] Création VM `vm-haos` (ID 101) sur Proxmox
  - [ ] 4 vCPU, 8 Go RAM, 64 Go SSD
  - [ ] BIOS : OVMF (UEFI) — REQUIS pour HA OS
  - [ ] Disque SCSI VirtIO
  - [ ] Boot order : disque qcow2
- [ ] **E.2** Premier boot HA OS
  - [ ] Onboarding HA en mode minimal
  - [ ] Note IP DHCP attribuée (sera changée)
- [ ] **E.3** Restauration backup Pi5
  - [ ] Settings → System → Backups → Upload backup
  - [ ] Restore complet (~5-15 min selon taille)
  - [ ] HA reboot automatique
- [ ] **E.4** Configuration IP fixe 192.168.1.11
  - [ ] **D'abord** : éteindre Pi5 actuel (libère l'IP)
  - [ ] Settings → System → Network → IP statique 192.168.1.11
  - [ ] Reboot HA OS
- [ ] **E.5** Passthrough USB
  - [ ] Identifier dongles : `lsusb` sur Proxmox host
  - [ ] Passthrough Zigbee 1 (ZHA) : `qm set 101 -usb0 host=1a86:7523,serial=b0ceb8bea7dbed118dd6f22d62c613ac`
  - [ ] Passthrough Zigbee 2 (Matter/Thread) : `qm set 101 -usb1 host=1a86:7523,serial=0c02a8a414a6ed11b263e8a32981d5c7`
  - [ ] Passthrough Coral USB : `qm set 101 -usb2 host=1a6e:089a` (Google Coral, vendor:product à vérifier)
  - [ ] Reboot VM
- [ ] **E.6** Vérification fonctionnelle HA
  - [ ] Login http://192.168.1.11:2096/ → dashboards visibles
  - [ ] Devices Zigbee tous "Online" (~30 devices)
  - [ ] Matter / Thread devices "Online"
  - [ ] Frigate addon démarre (sera retiré Phase F)
  - [ ] Cloudflare tunnel actif (mêmes credentials, IP même)
- [ ] **E.7** Bascule Cloudflare DNS
  - [ ] Vérifier que ha.might.ovh pointe toujours bien vers tunnel cloudflared
  - [ ] Test public : https://ha.might.ovh/ → login OK
- [ ] **E.8** Backup PBS quotidien activé
  - [ ] Tâche backup `vm-haos` → datastore PBS quotidien 03h00
  - [ ] Rétention 7d/4w/3m

### Critères de sortie

- HA accessible local + distant CF tunnel
- Tous les devices Online (Zigbee, Matter, MQTT, etc.)
- Pi5 éteint physiquement et SD card protégée
- Backup PBS du 1er jour réalisé
- Test 7 jours en parallèle (Pi5 prêt à reprendre si problème)

### Période d'observation 7 jours

Pendant 7 jours après bascule :
- Surveiller : alertes Mode Réactif, dashboards HA, latence
- Pi5 reste éteint mais SD intacte
- Si problème majeur : rallumer Pi5, éteindre VM HA OS, retour arrière en <30 min

---

## Phase F — Frigate VM + Coral passthrough + caméras

**Objectif** : Frigate sort du Supervisor HA, tourne en VM Proxmox dédiée, accélération Coral USB.

### Pré-requis

- [ ] Phase E stabilisée (7 jours minimum)
- [ ] Backup config Frigate actuel (config.yml + zones / masks)
- [ ] Liste 3 caméras actuelles (RTSP URLs, credentials)

### Checklist

- [ ] **F.1** Création VM Frigate
  - [ ] VM `vm-frigate` (ID 102)
  - [ ] 6 vCPU, 12 Go RAM, 32 Go SSD système
  - [ ] HDD WD Purple 8 To passthrough disque OU NFS share
  - [ ] Ubuntu Server 24.04 + Docker
- [ ] **F.2** Récup Coral USB depuis Pi5
  - [ ] Débrancher Coral du Pi5
  - [ ] Brancher sur i9-9900K (USB 3.x rear)
  - [ ] Identifier : `lsusb | grep -i google`
  - [ ] Passthrough vers VM Frigate : `qm set 102 -usb0 host=1a6e:089a`
- [ ] **F.3** Install Frigate Docker
  - [ ] docker-compose.yml standard Frigate
  - [ ] Mount HDD vidéo en /media/frigate
  - [ ] config.yml restauré depuis backup
  - [ ] Détecteur : edgetpu (Coral USB) au lieu de cpu
- [ ] **F.4** Désinstallation addon Frigate côté HA OS
  - [ ] HA → Apps → Frigate → Désinstaller (UNIQUEMENT après que F.3 marche)
  - [ ] Intégration HA "Frigate" reconfigurée pour pointer vers VM (192.168.1.12 par exemple)
- [ ] **F.5** Achat caméras 4 et 5 (et 6 plus tard)
  - [ ] Modèles compatibles Frigate (Reolink RLC-820A ou Dahua IPC-HFW2531T)
  - [ ] PoE recommandé (alim simplifiée)
  - [ ] Ajout dans config.yml Frigate
- [ ] **F.6** Tests détection
  - [ ] Détection personne / véhicule / animal sur les 5 caméras
  - [ ] Latence détection < 1s
  - [ ] Coral usage CPU < 50% en pleine charge

### Critères de sortie

- Frigate VM stable, 5 caméras détectées
- Coral détecte ~50 inférences/s
- HA reçoit événements MQTT depuis Frigate
- Mode Réactif `[JARVIS-ALERT]` toujours opérationnel

---

## Phase G — Services secondaires + finalisation

**Objectif** : finaliser l'écosystème avec services optionnels, documentation finale, archivage.

**Étalement** : 2-3 semaines selon dispo et utilité ressentie.

### Checklist (chaque ligne indépendante, à activer au besoin)

- [ ] **G.1** Vaultwarden (mots de passe perso)
  - [ ] docker-compose dans VM Docker Host
  - [ ] Reverse proxy via Traefik ou Nginx Proxy Manager (à arbitrer si nécessaire)
  - [ ] Backup quotidien sur PBS
- [ ] **G.2** Nextcloud OU Immich (au choix selon usage)
  - [ ] Nextcloud = files sync + agenda + contacts
  - [ ] Immich = photos avec IA (face recognition)
  - [ ] Stockage sur HDD WD Purple ou disque dédié
- [ ] **G.3** Grafana + Prometheus monitoring complet
  - [ ] Exporters Proxmox + node_exporter sur chaque VM
  - [ ] Dashboards : CPU/RAM/disk/net par VM
  - [ ] Alertes Telegram ou email sur seuils
- [ ] **G.4** WireGuard ou Tailscale (optionnel)
  - [ ] Accès distant alternative à Cloudflare Tunnel
  - [ ] Si CF Tunnel suffit (probable) → SKIP
- [ ] **G.5** Mise à jour CLAUDE.md projet
  - [ ] Section "Infrastructure en place" mise à jour avec nouvelle archi
  - [ ] URLs Proxmox + PBS ajoutées
  - [ ] Procédure backup documentée
- [ ] **G.6** Décommissionnement Pi5
  - [ ] Après 90 jours de stabilité Proxmox
  - [ ] Pi5 archivé physiquement (boîte étiquetée)
  - [ ] SD card sauvegardée et étiquetée "HA backup avant migration 2026-XX-XX"
- [ ] **G.7** Auto-memories MAJ
  - [ ] `reference_pc_config_might.md` → MAJ avec nouvelle config Ryzen + Proxmox
  - [ ] `project_jarvis_architecture.md` → nouvelle topology
  - [ ] Création `reference_proxmox_architecture.md`

---

## Récap dépendances entre phases

```
Phase A (Hermès)  ─┐
                   ├─► Phase B (Achat) ─► Phase C (Ryzen) ─┐
                   │                                       │
                   │                                       ├─► Phase D (Proxmox)
                   │                                       │       │
                   │                                       │       ▼
                   │                                       │   Phase E (HA migration)
                   │                                       │       │
                   │                                       │       ▼ (7 jours obs)
                   │                                       │   Phase F (Frigate)
                   │                                       │       │
                   │                                       │       ▼
                   │                                       └─► Phase G (services)
                   │
                   └─ Phase A peut tourner en parallèle de tout (test sur RTX 3090 actuelle)
```

**Chemin critique** : B → C → D → E (Phase F et G sont en aval).

---

## Source originale conservée

Fichier source intact : `Projets/Hardware_Upgrade/03_Phasage_A_a_G.md` (lecture seule pour ce vault).
