# 06 — Migration HA Pi5 → VM Proxmox

**Date** : 26/04/2026 (S55)
**Phase concernée** : E
**Durée estimée** : 1 journée (préparation + bascule + tests)
**Pré-requis** : Phase D Proxmox stabilisée

---

## 1. Stratégie générale

```
T-7j  ──► Backup HA Pi5 quotidien forcé + vérif intégrité
T-3j  ──► Test création VM HA OS jetable Proxmox (apprentissage)
T-1j  ──► Backup ZHA + Z2M coordinator (network keys)
       ──► Backup config Frigate addon (config.yml + zones)
T0    ──► Création VM HA OS de production
T0+1h ──► Restauration backup HA Pi5 dans VM
T0+2h ──► Bascule IP fixe 192.168.1.11 (Pi5 éteint)
T0+3h ──► Passthrough USB dongles + Coral
T0+4h ──► Tests fonctionnels complets
T0+5h ──► Validation Cloudflare Tunnel
T0+6h ──► Décision GO / NO GO production
T+7j  ──► Validation finale, Pi5 archivé physiquement
T+90j ──► Décommissionnement Pi5 définitif
```

---

## 2. Pré-requis stricts (T-7j → T-1j)

### 2.1 Backups

- [ ] **Backup HA OS** quotidien forcé pendant 7 jours (Settings → System → Backups)
- [ ] Backup le plus récent (T-1j) **téléchargé localement** sur PC Ryzen
- [ ] Copie sur **OneDrive** + **HDD externe** (3-2-1 rule)
- [ ] Vérification taille du backup (typique 500 Mo - 2 Go selon BD)
- [ ] **Test restore sur VM jetable** (non productive) pour valider intégrité

### 2.2 Backup Zigbee coordinator

**Pour ZHA :**
```yaml
Settings → Devices & Services → "Zigbee Home Automation" → ⋮ → Download diagnostics
```

Ou plus officiel :
```yaml
Settings → System → Backups → Create backup → "Full backup"
  (inclut le coordinator ZHA dans /config/zigbee.db)
```

**Pour Matter / OpenThread Border Router :**
- Pas de backup officiel actuellement (limite HA OS 2026)
- Note : la migration physique du dongle préserve l'état interne

### 2.3 Backup Frigate config

```bash
# Sur HA OS, via Terminal & SSH addon
cd /addon_configs/<frigate_uuid>
tar czf /backup/frigate_config_2026-04-26.tar.gz config.yml zones/ masks/
```

Téléchargement local via Samba HA OS share.

### 2.4 Inventaire devices

**Liste à archiver dans `Projets/Hardware_Upgrade/inventaire_pre_migration.md`** :

- Nombre devices Zigbee (Settings → Devices)
- Nombre devices Matter / Thread
- Nombre devices MQTT (43 selon capture S55)
- Nombre devices Frigate (6 selon capture)
- Liste automations actives (export YAML)
- Liste scenes
- Liste scripts shell

Cette liste sert de **référence post-migration** pour valider 0 perte.

---

## 3. T0 — Création VM HA OS Proxmox

### 3.1 Download image officielle

```bash
# Sur Proxmox host (ou via Web UI Proxmox)
cd /var/lib/vz/template/iso
wget https://github.com/home-assistant/operating-system/releases/download/<VERSION>/haos_ova-<VERSION>.qcow2.xz
xz -d haos_ova-<VERSION>.qcow2.xz
```

> ⚠️ Vérifier la dernière version sur https://www.home-assistant.io/installation/generic-x86-64

### 3.2 Création VM via Proxmox CLI

```bash
# Création VM avec ID 101 (réservé HA OS dans nomenclature projet)
qm create 101 \
  --name vm-haos \
  --memory 8192 \
  --cores 4 \
  --sockets 1 \
  --cpu host \
  --bios ovmf \
  --machine q35 \
  --efidisk0 local-lvm:1 \
  --net0 virtio,bridge=vmbr0 \
  --ostype l26 \
  --boot order=scsi0

# Importer le disque qcow2
qm importdisk 101 /var/lib/vz/template/iso/haos_ova-<VERSION>.qcow2 local-lvm

# Attacher le disque importé
qm set 101 --scsihw virtio-scsi-single --scsi0 local-lvm:vm-101-disk-1

# Premier boot
qm start 101
```

> Alternative GUI : Proxmox Web UI → Create VM, mêmes paramètres.

### 3.3 Premier boot HA OS

Console Proxmox VM 101 → onboarding HA OS minimal :
- Username Mickael
- Mot de passe (différent du PC, dans Vaultwarden)
- IP DHCP attribuée temporairement (sera changée à T+2h)

---

## 4. T0+1h — Restauration backup Pi5

### 4.1 Upload backup

UI HA OS VM (via IP DHCP temporaire) :
```
Settings → System → Backups → Upload backup
  → Sélectionner le .tar du Pi5 (T-1j)
  → Restore "Full"
  → Confirmer
```

Restore prend 5-15 min. HA OS reboot automatiquement.

### 4.2 Vérifications post-restore

- [ ] Login admin avec credentials Pi5
- [ ] Dashboards visibles
- [ ] Liste integrations correspond à pre-migration
- [ ] Devices Zigbee : encore "Unavailable" (normal, dongles pas branchés)

---

## 5. T0+2h — Bascule IP fixe 192.168.1.11

### 5.1 Éteindre Pi5

```bash
# SSH Pi5 ou via HA UI
ha host shutdown
# Attendre 30s
# Débrancher alim Pi5
```

> ⚠️ **NE PAS débrancher les dongles USB Pi5 immédiatement** — d'abord vérifier l'IP libérée puis migrer dongles à T0+3h.

### 5.2 Configurer IP fixe VM HA OS

```yaml
UI HA OS VM (via IP DHCP actuelle) :
  Settings → System → Network → Configure
    Network: enp3s0 (ou interface VirtIO détectée)
    IPv4 method: Static
    Address: 192.168.1.11
    Netmask: 255.255.255.0
    Gateway: 192.168.1.1
    DNS: 1.1.1.1, 192.168.1.1
```

### 5.3 Reboot VM HA OS

```bash
# Sur Proxmox host
qm reboot 101
```

### 5.4 Vérification

- Ping `192.168.1.11` répond
- http://192.168.1.11:2096/ accessible (port HA Mickael)

---

## 6. T0+3h — Passthrough USB

### 6.1 Identifier dongles + Coral sur Proxmox host

```bash
lsusb
# Sortie attendue inclut :
# Bus 001 Device XXX: ID 1a86:7523 QinHeng Electronics CH340 (les 2 Sonoff)
# Bus 001 Device XXX: ID 1a6e:089a Global Unichip Corp. (Coral)
```

```bash
# Vérifier serial uniques
ls -la /dev/serial/by-id/
# Sortie attendue :
# usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_b0ceb8bea7dbed118dd6f22d62c613ac-if00-port0 -> ../../ttyUSB0
# usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_0c02a8a414a6ed11b263e8a32981d5c7-if00-port0 -> ../../ttyUSB1
# usb-Google_Inc._Coral... -> ...
```

### 6.2 Branchement physique

⚠️ **Migration physique** des 3 dongles du Pi5 vers les ports USB du i9-9900K (rear panel CM ROG Maximus XI Hero).

**Conseil** : utiliser des ports USB 3.0 différents pour Zigbee (USB 2.0 suffit, mais les ports 3.0 ont parfois IOMMU groupes mieux séparés).

### 6.3 Passthrough configuration Proxmox

```bash
# Zigbee 1 (ZHA)
qm set 101 -usb0 host=1a86:7523,serial=b0ceb8bea7dbed118dd6f22d62c613ac

# Zigbee 2 (Matter / OpenThread)
qm set 101 -usb1 host=1a86:7523,serial=0c02a8a414a6ed11b263e8a32981d5c7

# Coral USB (sera utilisé par Frigate VM Phase F, mais pour l'instant addon Frigate HA)
qm set 101 -usb2 host=1a6e:089a
```

> ⚠️ Si plusieurs dongles ont le **même** vendor:product (1a86:7523), le matching par `serial` est OBLIGATOIRE.

### 6.4 Reboot VM HA OS

```bash
qm reboot 101
```

### 6.5 Vérification dongles dans VM

```yaml
UI HA OS VM :
  Settings → System → Hardware → "All hardware"
  → Chercher : Sonoff (×2), Coral (×1)
```

```yaml
Settings → Devices & Services :
  - "Zigbee Home Automation" → status OK, ~30 devices Online
  - "Open Thread Border Router" → status OK
  - "Matter" → status OK
```

---

## 7. T0+4h — Tests fonctionnels

### 7.1 Checklist tests

- [ ] Login HA UI fonctionne local + distant
- [ ] Dashboards Lovelace s'affichent correctement
- [ ] Devices Zigbee tous "Online"
- [ ] Lampe / interrupteur Zigbee → toggle depuis HA fonctionne
- [ ] Devices Matter / Thread Online (selon ce que tu as)
- [ ] Frigate addon démarre, caméras streament
- [ ] MQTT integration : 43 devices Online
- [ ] Automations actives (test au moins 3 critiques)
- [ ] HACS : 50 services chargés sans erreur
- [ ] Music Assistant, Dyson, Frisquet Connect : OK
- [ ] OpenAI integration : OK (pas critique)

### 7.2 Si quelque chose casse

| Symptôme | Cause probable | Fix |
|---|---|---|
| Devices Zigbee "Unavailable" | Passthrough dongle KO | Vérifier `qm config 101` USB lines, reboot VM |
| Cloudflare tunnel disconnected | cloudflared addon non démarré | Logs addon → restart |
| Frigate caméras KO | Coral pas détecté | `lsusb` dans VM, refaire passthrough |
| MQTT non connecté | Mosquitto Pi5 éteint mais HA pointe encore vers lui | MAJ adresse broker → 127.0.0.1 (interne) ou IP VM Docker (192.168.1.X) |

---

## 8. T0+5h — Validation Cloudflare Tunnel

### 8.1 Vérification cloudflared addon

Si cloudflared était addon HA OS sur Pi5 → restauré automatiquement avec backup.

```yaml
UI HA OS VM :
  Apps → Cloudflared → status RUNNING
  Logs : "Connection established"
```

### 8.2 Test public

Depuis téléphone 4G/5G (pas LAN) :
- [ ] https://ha.might.ovh/ → page login HA
- [ ] Login OK avec MFA TOTP
- [ ] Dashboards s'affichent

### 8.3 Test ha-mcp endpoint

```bash
# Depuis PC Ryzen (Cowork)
curl -I https://mcp.might.ovh/private_PfjEvJTqhCdo9ELRqCPADlzo
# Sortie attendue : HTTP/2 405 Method Not Allowed (normal, GET non supporté)
```

> Note : le secret_path `private_PfjEvJTqhCdo9ELRqCPADlzo` est l'actif réel (cf auto-memory `feedback_secret_path_s48_jamais_applique.md`). NE PAS utiliser `private_Q49aOxbSlqkilVOMVrlE4g` qui est une régénération non appliquée.

---

## 9. T0+6h — Décision GO / NO GO

### Critères GO (production validée)

✅ Tous les tests 7.1 passent
✅ CF Tunnel public fonctionnel
✅ ha-mcp endpoint répond 405 (signe de vie)
✅ 0 device manquant vs inventaire pré-migration
✅ Mode Réactif scheduled task tourne sur Ryzen et envoie un mail test

### Critères NO GO (rollback)

❌ ≥10% devices Zigbee "Unavailable" persistant
❌ CF Tunnel impossible à restaurer
❌ Erreur HA OS répétée bootloop / OOM

### Procédure rollback (si NO GO)

```bash
# 1. Éteindre VM HA OS
qm shutdown 101

# 2. Débrancher dongles du Proxmox host
# (physiquement)

# 3. Rebrancher dongles sur Pi5

# 4. Rallumer Pi5
# (alim secteur)

# 5. Vérifier IP 192.168.1.11 reprise par Pi5
ping 192.168.1.11

# 6. Test login HA UI Pi5
```

Durée rollback : <30 min. Pi5 reprend exactement comme avant.

### Investigation post-rollback

- Logs Proxmox : `/var/log/syslog`, `/var/log/messages`
- Logs VM HA OS : sortir backup logs avant reboot rollback
- Issue tracker GitHub HA OS si bug confirmé

---

## 10. T+7j — Validation finale + archivage Pi5

### 10.1 Période d'observation 7 jours

Surveiller quotidiennement :
- Mode Réactif scheduled task → email reçu chaque jour
- Aucune alerte device "Unavailable"
- Latence HA UI < 200ms local
- Backup PBS quotidien réussit

### 10.2 Archivage Pi5

À J+7 si stabilité confirmée :

- [ ] Pi5 reste **éteint mais SD card intacte**
- [ ] Boîte étiquetée : "Pi5 HA backup pre-migration 2026-XX-XX, ne pas effacer"
- [ ] Stockage à l'abri humidité/chaleur
- [ ] **Conservation 90 jours minimum** avant décommissionnement

### 10.3 T+90j — Décommissionnement final

Si zéro problème en 90 jours :
- [ ] Pi5 peut être réutilisé pour autre projet (mais pas effacer SD HA tant que pas validé)
- [ ] OU Pi5 reste dispo en standby permanent (consommation négligeable, sécurité ultime)

---

## 11. Notes spécifiques projet Mickael

### 11.1 Mode Réactif v1.1

Les scheduled tasks tournent sur **PC Ryzen** (Phase C.12), pas sur HA. Donc la migration HA n'impacte pas directement le Mode Réactif **sauf** :

- L'envoi mail HA → Gmail dépend de l'intégration `notify.might57290_gmail_com` côté HA
- Si HA est down 30 min pendant migration → mail rapport non envoyé
- Conséquence : le mail check-jarvis-alert 04h00 du jour de migration peut arriver vide. Pas critique.

### 11.2 Cloudflare Access policies

Si tu as des Access policies (MFA via SSO Google) → vérifier qu'elles continuent de pointer vers le hostname `ha.might.ovh`, pas vers IP. L'IP a changé mais le hostname reste.

### 11.3 Backup PBS automatique

Activer **dès J0** (pas J+7) un backup quotidien VM 101 → datastore PBS. Premier backup = filet de sécurité immédiat.

```bash
# Sur Proxmox Web UI :
Datacenter → Backup → Add
  Storage: pbs-local (à créer)
  Schedule: Daily 03:00
  Selection mode: Include selected VMs
  VMs: 101 (vm-haos)
  Compression: zstd
  Retention: 7d / 4w / 3m
```

---

## 12. Checklist finale T+7j

- [ ] HA tourne en VM Proxmox depuis 7 jours sans incident
- [ ] 0 device perdu vs inventaire pré-migration
- [ ] CF Tunnel stable
- [ ] Mode Réactif daily mail OK
- [ ] Backup PBS quotidien réussi 7/7
- [ ] Pi5 archivé physiquement
- [ ] Phase E officiellement clôturée
- [ ] Phase F (Frigate VM) peut démarrer
