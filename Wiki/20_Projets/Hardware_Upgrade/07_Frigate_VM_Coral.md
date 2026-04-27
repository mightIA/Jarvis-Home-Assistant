---
title: 07 — Frigate VM dédiée et Coral USB passthrough
created: 2026-04-27
migrated_from: Projets/Hardware_Upgrade/07_Frigate_VM_Coral.md
status: en-attente-phase-A-Hermes
phase: 0
budget_target: 2410 EUR
bloqueur: hermes-phase-1bis-d
tags: [projet, hardware, proxmox, ryzen, frigate, coral]
---

# 07 — Frigate VM dédiée + Coral USB passthrough

**Date** : 26/04/2026 (S55)
**Phase concernée** : F
**Pré-requis** : Phase E stabilisée 7 jours minimum
**Cibles** : 5-6 caméras IP, accélération Coral USB, sortie du Supervisor HA

---

## 1. Objectifs

1. **Sortir Frigate du Supervisor HA OS** (actuellement addon, état "Échec de la configuration" vu en S55)
2. **Frigate en VM Proxmox dédiée** avec ressources cloisonnées
3. **Coral USB passthrough** vers la VM Frigate (depuis Pi5 d'origine, transféré au i9-9900K Phase E)
4. **Stockage vidéo dédié** sur HDD WD Purple 8 To
5. **Préparer ajout caméras 4-5-6** (3 actuelles + 2-3 futures)

---

## 2. Architecture cible Frigate

```
┌─────────────────────────────────────────────────────────────┐
│  VM Frigate (vm-frigate, ID 102 Proxmox)                    │
│  Ubuntu Server 24.04 LTS                                    │
│  6 vCPU, 12 Go RAM, 32 Go SSD système                       │
│                                                             │
│  ┌────────────────────────────────────────────────────┐     │
│  │  Docker Engine                                     │     │
│  │                                                    │     │
│  │  ┌──────────────────────────────────────────────┐  │     │
│  │  │  Container Frigate (latest)                  │  │     │
│  │  │  • config.yml                                │  │     │
│  │  │  • zones, masks                              │  │     │
│  │  │  • detector: edgetpu (Coral USB)             │  │     │
│  │  │  • cameras: 5-6 RTSP                         │  │     │
│  │  └──────────────────────────────────────────────┘  │     │
│  │                                                    │     │
│  │  ┌──────────────────────────────────────────────┐  │     │
│  │  │  Container go2rtc (optionnel, optim flux)    │  │     │
│  │  └──────────────────────────────────────────────┘  │     │
│  └────────────────────────────────────────────────────┘     │
│                                                             │
│  USB passthrough : Coral USB (Google)                       │
│  Disk passthrough : HDD WD Purple 8 To /media/frigate       │
└─────────────────────────────────────────────────────────────┘
                          │
                          │ MQTT events
                          ▼
              ┌──────────────────────────┐
              │  Mosquitto (VM Docker)   │
              │  topic: frigate/events   │
              └──────────────────────────┘
                          │
              ┌───────────┴───────────┐
              ▼                       ▼
        VM HA OS              PC Ryzen Hermès
        (automations,         (Mode Réactif
         alertes)              [JARVIS-ALERT])
```

---

## 3. Création VM Frigate

### 3.1 Ressources Proxmox

```bash
qm create 102 \
  --name vm-frigate \
  --memory 12288 \
  --cores 6 \
  --sockets 1 \
  --cpu host \
  --bios ovmf \
  --machine q35 \
  --efidisk0 local-lvm:1 \
  --net0 virtio,bridge=vmbr0 \
  --ostype l26 \
  --boot order=ide2

# CD-ROM Ubuntu Server 24.04 ISO
qm set 102 --ide2 local:iso/ubuntu-24.04.1-live-server-amd64.iso,media=cdrom

# Disque système 32 Go SSD NVMe
qm set 102 --scsihw virtio-scsi-single --scsi0 local-lvm:32

# Disque vidéo (passthrough HDD WD Purple)
# Méthode 1 : disque entier passthrough
qm set 102 --scsi1 /dev/disk/by-id/ata-WDC_WD80PURZ-XXXXXXXXX,backup=0,replicate=0,size=8T

# Méthode 2 (alternative) : LVM volume sur HDD pool
# qm set 102 --scsi1 hdd-pool:8000

qm start 102
```

### 3.2 Install Ubuntu Server

Procédure standard via console Proxmox VM 102 :
- Username : `frigate-admin`
- IP fixe : 192.168.1.12
- SSH server activé
- LVM partitioning sur disque 32 Go (système)
- Disque 8 To : ne PAS formater pendant l'install, gérer après

### 3.3 Configuration disque vidéo

Après install, depuis SSH `frigate-admin@192.168.1.12` :

```bash
# Identifier le disque vidéo (sda ou sdb selon ordre)
lsblk
# Sortie attendue : un disque ~7.3T (8 To = 8 × 10^12 bytes en marketing, 7.27 To en réalité)

# Formater en ext4 (alternative : xfs pour gros fichiers)
sudo mkfs.ext4 -L frigate-video /dev/sdb

# Monter
sudo mkdir -p /media/frigate
sudo mount /dev/sdb /media/frigate

# Persistance via /etc/fstab
echo "LABEL=frigate-video /media/frigate ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
sudo mount -a
```

### 3.4 Install Docker

```bash
# Méthode officielle Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Ajouter user au group docker
sudo usermod -aG docker frigate-admin
# Logout / login pour prise en compte

# Vérifier
docker --version
docker compose version
```

---

## 4. Récupération Coral USB depuis Pi5

### 4.1 Pré-requis

- Pi5 toujours en standby (Phase E.10.2 archivage)
- Frigate addon HA OS toujours actif (utilise Coral via passthrough Phase E.6)

### 4.2 Procédure

1. **Arrêter Frigate addon HA OS** :
   ```yaml
   UI HA OS VM : Apps → Frigate → Stop
   ```

2. **Retirer passthrough Coral** de la VM HA OS :
   ```bash
   # Sur Proxmox host
   qm set 101 -delete usb2
   qm reboot 101
   ```

3. **Débrancher physiquement le Coral USB** du i9-9900K (port qui était passthrough HA OS)

4. **Rebrancher Coral USB** sur un autre port USB du i9-9900K (idéalement USB 3.x rear, IOMMU groupe différent)

5. **Identifier Coral** :
   ```bash
   lsusb | grep -i google
   # Sortie attendue : Bus 001 Device XXX: ID 1a6e:089a Global Unichip Corp.
   # Note : après firmware loaded, le vendor:product peut devenir 18d1:9302
   ```

6. **Passthrough vers VM Frigate** :
   ```bash
   qm set 102 -usb0 host=1a6e:089a
   qm reboot 102
   ```

7. **Vérifier dans VM Frigate** :
   ```bash
   ssh frigate-admin@192.168.1.12
   lsusb | grep -i google
   ```

---

## 5. Install Frigate

### 5.1 Structure dossiers

```bash
mkdir -p ~/frigate
cd ~/frigate
mkdir -p config storage db
```

### 5.2 docker-compose.yml

```yaml
version: "3.9"

services:
  frigate:
    container_name: frigate
    image: ghcr.io/blakeblackshear/frigate:stable
    restart: unless-stopped
    privileged: true   # nécessaire pour Coral
    shm_size: "256mb"
    devices:
      - /dev/bus/usb:/dev/bus/usb   # Coral USB
      # - /dev/dri/renderD128:/dev/dri/renderD128   # iGPU si dispo
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./config:/config
      - /media/frigate:/media/frigate
      - type: tmpfs
        target: /tmp/cache
        tmpfs:
          size: 1000000000   # 1 Go RAM cache pour clips
    ports:
      - "5000:5000"   # Web UI HTTP
      - "8554:8554"   # RTSP go2rtc
      - "8555:8555/tcp"
      - "8555:8555/udp"
    environment:
      FRIGATE_RTSP_PASSWORD: "REDACTED_REPLACE_WITH_STRONG_PWD"
```

> ⚠️ Règle 0 sécurité : pas de mot de passe en clair commit. Utiliser `.env` file ou Vaultwarden Phase G.

### 5.3 Restauration config.yml depuis backup Phase E.2.3

```bash
# Backup Frigate addon HA OS récupéré Phase E
# /backup/frigate_config_2026-04-26.tar.gz

cd ~/frigate
tar xzf /chemin/vers/frigate_config_2026-04-26.tar.gz -C config/
ls config/
# Sortie : config.yml zones/ masks/
```

Adapter `config.yml` pour la VM (chemins, broker MQTT) :

```yaml
# config.yml — extraits à adapter
mqtt:
  enabled: true
  host: 192.168.1.X   # IP VM Docker Host (Mosquitto)
  port: 1883
  topic_prefix: frigate
  user: frigate
  password: "REDACTED"

detectors:
  coral:
    type: edgetpu
    device: usb

cameras:
  cam_entree:
    ffmpeg:
      inputs:
        - path: rtsp://USER:PASS@192.168.1.X:554/stream1
          roles:
            - record
            - detect
    detect:
      width: 1920
      height: 1080
      fps: 5
    record:
      enabled: true
      retain:
        days: 7
        mode: motion
      events:
        retain:
          default: 14
          mode: active_objects

  # ... cam_jardin, cam_garage, etc. (les 3 actuelles + futures)
```

### 5.4 Lancement

```bash
cd ~/frigate
docker compose up -d
docker compose logs -f
# Attendre "Frigate v0.X.X starting..."
# Vérifier : "Coral USB initialized successfully"
```

### 5.5 Test Web UI

http://192.168.1.12:5000 → page Frigate avec caméras visibles.

---

## 6. Reconfiguration intégration HA

### 6.1 Désinstallation addon Frigate HA OS

⚠️ **Uniquement après que VM Frigate fonctionne 1h sans erreur.**

```yaml
UI HA OS VM :
  Apps → Frigate → Désinstaller
```

### 6.2 Reconfiguration intégration Frigate dans HA

```yaml
Settings → Devices & Services :
  - Localiser intégration "Frigate" existante
  - ⋮ → Reconfigurer
  - URL : http://192.168.1.12:5000  (au lieu de http://localhost:5000)
  - Save
```

L'intégration HA Frigate se reconfigure auto via MQTT discovery, les entités `binary_sensor.*_motion` reprennent.

### 6.3 Vérification automations dépendantes

Lister automations utilisant Frigate (Settings → Automations → filter "frigate") :
- [ ] Notification présence détectée → fonctionne ?
- [ ] Enregistrement déclenché par mouvement → fonctionne ?
- [ ] Mode Réactif `[JARVIS-ALERT]` Frigate → fonctionne ?

---

## 7. Ajout caméras 4-5-6

### 7.1 Recommandations matériel

| Modèle | Prix indicatif | Caractéristiques |
|---|---|---|
| **Reolink RLC-820A** | ~110 € | 8 MP, PoE, IA personne/véhicule embarquée |
| **Dahua IPC-HFW2531T-AS** | ~140 € | 5 MP, IR 50m, robuste |
| **Hikvision DS-2CD2143G2-IS** | ~160 € | 4 MP, AcuSense (filtrage faux positifs) |

**Reco** : Reolink pour le rapport perf/prix, sauf si déjà du Dahua chez toi (cohérence skill `cameras-dahua`).

### 7.2 Switch PoE (si caméras PoE)

Le switch TP-Link TL-SG108-M2 est **non-PoE**. Si caméras PoE :
- Switch alternatif : **TP-Link TL-SG108PE** (PoE+ 64W, 8 ports, ~140 €)
- OU injecteurs PoE individuels (~15 €/cam)

### 7.3 Procédure ajout caméra

1. **Câblage** : Cat6 PoE jusqu'à la position
2. **Découverte IP** : router admin → DHCP leases → noter IP caméra
3. **Configuration caméra** :
   - Login admin (mot de passe par défaut → changer immédiatement)
   - Stream principal RTSP H.264 (Frigate digère mal H.265 sans transcoding)
   - Bitrate : 4 Mbps suffisant pour détection
   - FPS : 15 (suffit pour détection, économise CPU)
4. **Ajout dans config.yml Frigate** (cf section 5.3)
5. **Reload Frigate** :
   ```bash
   docker compose restart frigate
   ```
6. **Calibrage zones** : zones d'intérêt + masks via UI Frigate

---

## 8. Performance attendue

### 8.1 CPU usage

- Frigate idle 5 caméras : ~30% CPU (sur 6 vCPU alloués)
- Frigate inférence Coral : ~5% CPU (le Coral fait le boulot)
- Pic activité (mouvement détecté plusieurs cams) : ~60% CPU

### 8.2 Coral inference

- Latence inference : ~10ms par image
- Throughput : ~100 inférences/seconde
- Pour 5 caméras × 5 fps détection = 25 inf/s → **largement dans les capacités**

### 8.3 Stockage vidéo

- 5 caméras × 4 Mbps × 86400s/jour = ~22 Go/jour
- HDD 8 To = ~360 jours de vidéo continue
- Mode "motion only" (recommandé) = ~5 Go/jour = ~4 ans avec 5 cams

---

## 9. Checklist clôture Phase F

- [ ] VM Frigate démarre et redémarre proprement
- [ ] Coral USB détecté et utilisé
- [ ] 3 caméras initiales fonctionnelles (égalité fonctionnelle Pi5)
- [ ] Caméras 4-5-6 ajoutées (selon achat progressif)
- [ ] Intégration HA Frigate reconfigurée
- [ ] Automations dépendantes Frigate fonctionnelles
- [ ] Mode Réactif `[JARVIS-ALERT]` reçoit événements Frigate
- [ ] Backup PBS quotidien VM 102 actif
- [ ] Vidéo stockée sur HDD WD Purple
- [ ] Phase F officiellement clôturée

---

## 10. Dépannage rapide

| Symptôme | Cause probable | Fix |
|---|---|---|
| Coral non détecté dans VM | Passthrough mal configuré | `qm config 102` puis vérif `lsusb` dans VM |
| "Coral failed to load" | Driver libedgetpu manquant dans image | Image Frigate stable inclut le driver, vérifier version |
| Caméra "stream timeout" | Bitrate trop élevé / RTSP cassé | Tester URL RTSP avec VLC depuis VM Frigate |
| HDD pas monté au reboot | fstab incorrect | `sudo mount -a` test, ajouter `nofail` à options |
| Frigate UI 404 | Port 5000 bloqué | `ss -tlnp \| grep 5000` puis `iptables` ou ufw |

---

## 11. Évolution future

- **2e Coral USB** (~25 €) : double la capacité d'inférence si plus de caméras
- **GPU passthrough RTX 3090** : si Ryzen un jour libère la 3090, possibilité d'utiliser TensorRT au lieu de Coral. Pas prioritaire avec 5-6 cams.
- **NVR backup distant** : si vidéo critique, sync chiffrée vers Backblaze B2 ou cold storage. ~5 €/mois pour 1 To.
- **Frigate+** : modèle de détection custom payant (~50 €/an) pour faux positifs réduits

---

## Notes de migration vault (S68)

- Document copié depuis `Projets/Hardware_Upgrade/07_Frigate_VM_Coral.md` (S55).
- Aucun pattern sensible détecté.
- Aucune modification de contenu.
