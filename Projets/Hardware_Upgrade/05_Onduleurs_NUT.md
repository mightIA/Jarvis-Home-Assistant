# 05 — Onduleurs : configuration NUT et apcupsd

**Date** : 26/04/2026 (S55)
**Phase concernée** : D (Proxmox install) + C (PC Ryzen)
**Onduleurs** : APC SMT2200IC + APC BR900G-FR (déjà possédés)

---

## 1. Plan d'affectation

```
┌──────────────────────────────────────────────────────────┐
│  APC Smart-UPS SMT2200IC (1500W)                         │
│                                                          │
│  Branchements secteur :                                  │
│   ├── Proxmox host (i9-9900K) ~250W                      │
│   ├── Switch TP-Link TL-SG108-M2 ~10W                    │
│   ├── Box Orange Livebox ~15W                            │
│   ├── Pi5 (standby rollback) ~5W                         │
│   └── Caméras IP PoE (selon switch) ~30W                 │
│                                                          │
│  Total typique : ~300W                                   │
│  Autonomie estimée : ~30-40 min sur batterie             │
│                                                          │
│  Communication : USB-B (carte serveur) → Proxmox host    │
│  Driver NUT : usbhid-ups (mode défaut) ou apc_modbus     │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│  APC Back-UPS Pro BR900G-FR (540W)                       │
│                                                          │
│  Branchements secteur :                                  │
│   ├── PC Ryzen idle 150W → peak 750W                     │
│   └── Écran(s) ~50W                                      │
│                                                          │
│  Total idle : ~200W → autonomie ~10-15 min               │
│  Total peak : 750W (>540W) mais transitoire OK shutdown  │
│                                                          │
│  Communication : USB direct → Windows 11 Ryzen           │
│  Driver : apcupsd (Windows) OU NUT client                │
└──────────────────────────────────────────────────────────┘
```

---

## 2. Configuration côté Proxmox (SMT2200IC)

### 2.1 Installation NUT

```bash
# Sur Proxmox host (sortie SSH ou console)
apt update
apt install nut nut-client nut-server

# Brancher câble USB SMT2200IC sur Proxmox host
# Vérifier détection
lsusb | grep -i american
# Sortie attendue : "American Power Conversion ... UPS"
```

### 2.2 Configuration `/etc/nut/ups.conf`

```ini
[smt2200]
    driver = usbhid-ups
    port = auto
    desc = "APC SMT2200IC Server room"
    pollinterval = 5
```

### 2.3 Mode serveur — `/etc/nut/nut.conf`

```ini
MODE=netserver
```

### 2.4 Listener réseau — `/etc/nut/upsd.conf`

```ini
LISTEN 127.0.0.1 3493
LISTEN 192.168.1.10 3493
```

### 2.5 Utilisateurs — `/etc/nut/upsd.users`

```ini
[admin]
    password = CHANGE_THIS_STRONG_PASSWORD
    actions = SET
    instcmds = ALL

[upsmon_local]
    password = CHANGE_THIS_OTHER_PASSWORD
    upsmon master

[upsmon_remote]
    password = CHANGE_THIS_THIRD_PASSWORD
    upsmon slave
```

> ⚠️ **Règle 0 sécurité** : générer 3 mots de passe forts distincts, stocker dans Vaultwarden (Phase G), JAMAIS commiter dans Git.

### 2.6 Monitor local Proxmox — `/etc/nut/upsmon.conf`

```ini
MONITOR smt2200@localhost 1 upsmon_local CHANGE_THIS_OTHER_PASSWORD master

MINSUPPLIES 1
SHUTDOWNCMD "/sbin/shutdown -h +0"
NOTIFYCMD /usr/sbin/upssched
POLLFREQ 5
POLLFREQALERT 5
HOSTSYNC 15
DEADTIME 15

# Seuil shutdown : 25% batterie restante (pas 5% pour éviter coupure brutale)
FINALDELAY 5
```

### 2.7 Démarrage services

```bash
systemctl enable nut-server nut-client
systemctl start nut-server nut-client

# Vérification
upsc smt2200@localhost
# Sortie attendue : battery.charge, ups.status, input.voltage, etc.
```

### 2.8 Test fonctionnel

```bash
# Test commande surveillance
upsc smt2200@localhost battery.charge
# Sortie attendue : 100 (ou similaire)

upsc smt2200@localhost ups.status
# Sortie attendue : OL (On Line) en marche normale, OB DISCHRG en coupure
```

### 2.9 Test simulation coupure (à faire 1× post-install)

1. Brancher l'onduleur normalement, charge complète batterie
2. Débrancher l'onduleur du mur (simule coupure secteur)
3. Vérifier dans `journalctl -u nut-monitor` : `Communications with UPS smt2200@localhost lost`... non, plutôt `On battery`
4. Attendre que batterie atteigne 25-30%
5. Proxmox doit déclencher shutdown gracieux automatique
6. Rebrancher avant que batterie tombe à 0
7. Reboot host, vérifier intégrité VMs

---

## 3. Configuration côté VM HA OS (client NUT)

### 3.1 Pourquoi un client NUT côté HA

Pour exposer les sensors batterie/charge/ups.status dans Home Assistant → automations possibles (ex: "si batterie < 50%, envoyer notification").

### 3.2 Méthode addon HA

```yaml
Settings → Apps → Add-on store → Search "Network UPS Tools"
  → Install
  → Configuration :
      mode: client
      ups_config:
        - name: "smt2200"
          host: "192.168.1.10"
          port: 3493
          user: "upsmon_remote"
          password: "CHANGE_THIS_THIRD_PASSWORD"
  → Start
```

### 3.3 Intégration HA NUT

```yaml
Settings → Devices & Services → Add Integration → "Network UPS Tools"
  → Host: 192.168.1.10
  → Port: 3493
  → Username: upsmon_remote
  → Password: ***
  → UPS: smt2200
```

Sensors disponibles :
- `sensor.smt2200_battery_charge`
- `sensor.smt2200_ups_status`
- `sensor.smt2200_input_voltage`
- `sensor.smt2200_battery_runtime`

### 3.4 Automation HA exemple

```yaml
automation:
  - alias: "Onduleur Proxmox - Batterie faible"
    trigger:
      - platform: numeric_state
        entity_id: sensor.smt2200_battery_charge
        below: 50
    action:
      - service: notify.might57290_gmail_com
        data:
          target: ["might57290@gmail.com"]
          title: "🔋 Onduleur Proxmox batterie 50%"
          message: "SMT2200IC à {{ states('sensor.smt2200_battery_charge') }}%, autonomie {{ states('sensor.smt2200_battery_runtime') }} min"
```

---

## 4. Configuration côté PC Ryzen (BR900G-FR)

### 4.1 Choix du logiciel

Deux options sous Windows 11 :

| Option | Avantage | Inconvénient |
|---|---|---|
| **PowerChute Personal Edition** (officiel APC) | Simple, GUI native, support officiel | Pas de NUT compat, isolé Windows |
| **apcupsd Windows** (port open source) | Léger, compatible scripts | GUI minimaliste |
| **NUT Windows client** | Cohérent avec Proxmox | Setup plus complexe sur Windows |

**Reco** : **PowerChute Personal Edition** pour le PC Ryzen (suffit pour shutdown gracieux), pas besoin d'intégration HA pour cet onduleur.

### 4.2 Installation PowerChute

1. Brancher câble USB BR900G-FR sur PC Ryzen
2. Télécharger https://www.apc.com/us/en/product/SFPCPE43/powerchute-personal-edition-v4-3/ (vérifier version 2026)
3. Install standard
4. Configuration :
   - Seuil shutdown : 25% batterie ou 5 min restantes
   - Shutdown command : Hibernation (préserve session) OU Shutdown gracieux
   - Notifications : email Mickael (optionnel)

### 4.3 Test fonctionnel

Même procédure que SMT2200IC — débrancher onduleur du mur, attendre seuil, vérifier shutdown.

---

## 5. Récap configuration

| Onduleur | Host | Logiciel | Port com | Seuil shutdown |
|---|---|---|---|---|
| SMT2200IC | Proxmox | NUT serveur | USB-B | 25% batterie |
| SMT2200IC client | VM HA OS | NUT addon | LAN 3493 | (lecture seule) |
| BR900G-FR | PC Ryzen | PowerChute PE | USB | 25% / 5 min |

---

## 6. Évolution future — Carte AP9631 (optionnel)

Le SMT2200IC a un **SmartSlot vide**. Si plus tard on veut :
- Monitoring SNMP indépendant de Proxmox host
- Alertes email natives onduleur (sans dépendre HA)
- Logs séparés (audit trail)
- Web interface IP propre

➡️ Achat **APC AP9631 Network Management Card 2** (~250 €).

Bénéfice : si Proxmox host crash hardware, l'onduleur continue à monitorer / alerter via SNMP. Pas critique pour homelab, intéressant si projet grandit.

---

## 7. Liens utiles

- [NUT Network UPS Tools — documentation officielle](https://networkupstools.org/)
- [NUT Hardware Compatibility List](https://networkupstools.org/stable-hcl.html) — chercher "SMT2200" et "BR900G"
- [Proxmox VE NUT integration tutorial](https://pve.proxmox.com/wiki/UPS) (wiki officiel)
- [Home Assistant NUT integration](https://www.home-assistant.io/integrations/nut/)
- [APC PowerChute Personal Edition](https://www.apc.com/us/en/product/SFPCPE43/powerchute-personal-edition-v4-3/)
