# Inventaire Home Assistant — Installation Mickael

> Inventaire à jour de l'installation HA de Mickael, capturé session 15 — 19/04/2026.
> À maintenir à jour à chaque ajout/suppression pour que Jarvis ait toujours le contexte exact.

---

## 1. Version & environnement

- **Distribution :** Home Assistant OS (Supervisor actif, Add-ons dispo)
- **URL locale :** `http://192.168.1.11:2096/`
- **URL distante :** `https://ha.might.ovh/` (derrière Cloudflare Access)
- **UI utilisée par Mickael :** web principalement + HA iOS app + Dispatch (iPhone)

---

## 2. Renommages UI importants (versions 2025+)

| Ancienne terminologie | Nouvelle terminologie | Icône / Couleur |
|---|---|---|
| Modules complémentaires / Add-ons | **Apps** | puzzle jaune 🧩 |
| Boutique des modules complémentaires | Bouton **Installer l'application** (bas droite page Apps) | bleu |
| Intégrations | Appareils et services (inchangé) | téléviseur bleu |
| Add-on Store → Repositories | Apps → boutique → ⋮ → **Dépôts** | — |

---

## 3. Add-ons (Apps) installés

Liste vue dans `Paramètres → Apps` — **MAJ session 24 (21/04/2026)** :

| Add-on | Fonction | Notes |
|---|---|---|
| AdGuard Home | Bloqueur pubs/trackers DNS réseau | |
| Cloudflared | Tunnel CF pour accès distant HA | Tunnel `mcp.might.ovh` pour add-on ha-mcp |
| ESPHome Device Builder | Build ESPHome devices | |
| File editor | Édition de fichiers HA via navigateur | Outil fréquent Jarvis pour `configuration.yaml`, `ip_bans.yaml` |
| Frigate (Full Access) | NVR détection objets caméras IP | Voir skill `cameras-dahua` |
| Get HACS | Installation HACS | |
| go2rtc | Transcoding matériel Intel VAAPI / RPi V4L2 | |
| Home Assistant Google Drive Backup | Backups auto vers Google Drive | |
| **Home Assistant MCP Server** (add-on) | Serveur MCP via FastMCP+DCR (exposé publiquement `mcp.might.ovh/<secret>`) | v7.3.0 — installé S15/S16 — **utilisé par Cowork** comme connecteur principal |
| Log Viewer | Utilitaire logs HA dans navigateur | |
| MariaDB | DB SQL serveur | |
| Matter Server | WebSocket Matter | |
| Mosquitto broker | MQTT broker open source | |
| Music Assistant | Serveur bibliothèque musicale | |
| NGINX Home Assistant SSL proxy | Proxy SSL/TLS | Potentiellement utile pour reverse proxy futur |
| ngrok Client Installer (Unofficial) | Client ngrok | Expérimental |
| OpenThread Border Router | Border Router Thread | |
| Piper | Text-to-speech | |
| Samba share | Exposition dossiers HA SMB/CIFS | |
| Studio Code Server | VSCode intégré | Utile édition YAML avancée |
| Terminal & SSH | SSH vers HA | IP bans via skill `debannissement-ip` |
| Whisper | Speech-to-text | |
| ZeroTier One | Réseau virtuel VPN | |
| Zigbee2MQTT | Contrôle devices Zigbee sans hub fabricant | |
| ZigStar TI CC2652P/P7 | Flasher firmware ZigStar | Expérimental |

---

## 4. Dépôts custom ajoutés (Apps → Dépôts)

| Nom | Mainteneur | URL |
|---|---|---|
| AlexxIT addons repository | @AlexxIT | `https://github.com/AlexxIT/hassio-addons` |
| Cloudflared | Tobia Brenner | `https://github.com/brenner-tobias/ha-addons` |
| Frigate Add-ons | blakeblackshear | `https://github.com/blakeblackshear/frigate-hass-addons` |
| Home Assistant Addon ngrok client installer (Unofficial) | Phillip Camp | `https://github.com/pssc/ha-addon-ngrok` |
| Home Assistant App: Zigbee2MQTT | Koen Kanters | `https://github.com/zigbee2mqtt/hassio-zigbee2mqtt` |
| Home Assistant Community Store | HACS | `https://github.com/hacs/addons` |
| Home Assistant Google Drive Backup Repository | Stephen Beechen | `https://github.com/sabeechen/hassio-google-drive-backup` |
| **Home Assistant MCP Server** | Julien `github@qc-h.net` | `https://github.com/homeassistant-ai/ha-mcp` — **AJOUTÉ session 15 (19/04/2026)** |
| ZigStar Home Assistant add-on repository | ZigStar | `https://github.com/mercenaruss/zigstar_addons` |

---

## 5. Intégrations HA configurées

**MAJ session 24 (21/04/2026) — liste exhaustive récupérée via MCP `ha_get_integration` : 62 entrées**

État global : `loaded: 58` / `not_loaded: 2` / `setup_retry: 1` / `setup_in_progress: 1`

### 5.1 Système & onboarding (core HA)

| Domaine | Titre | État |
|---|---|---|
| `sun` | Sun | loaded |
| `hassio` | Supervisor | loaded |
| `raspberry_pi` | Raspberry Pi | loaded |
| `rpi_power` | Raspberry Pi Power Supply Checker | loaded |
| `local_ip` | local_ip | loaded |
| `time_date` | Time & Date | loaded |
| `uptime` | Uptime | loaded |
| `systemmonitor` | System Monitor | loaded |
| `backup` | Backup | loaded |
| `shopping_list` | Shopping list | loaded |
| `color_extractor` | Color extractor | loaded |
| `met` | Home (météo par défaut onboarding) | loaded |
| `google_translate` | Google Translate TTS | loaded |
| `radio_browser` | Radio Browser | loaded |

### 5.2 Réseaux & protocoles

| Domaine | Titre | État |
|---|---|---|
| `bluetooth` | RPi BT (2C:CF:67:6F:5D:03) | loaded |
| `mqtt` | 127.0.0.1 (Mosquitto local) | loaded |
| `matter` | Matter | loaded |
| `thread` | Thread | loaded |
| `otbr` | OpenThread Border Router | loaded |
| `zha` | Sonoff Zigbee 3.0 USB Dongle Plus | **not_loaded** (ignore — utilisation Zigbee2MQTT) |
| `ibeacon` | iBeacon Tracker | loaded |

### 5.3 Box / TV / Media

| Domaine | Titre | État |
|---|---|---|
| `upnp` | Orange Livebox | loaded |
| `livebox` | Livebox | loaded |
| `dlna_dmr` | Décodeur TV UHD | loaded |
| `dlna_dmr` | [TV] Samsung Q80 Series (65) | loaded |
| `samsungtv` | Samsung Q80 Series 65 (QE65Q82RATXXC) | loaded |
| `apple_tv` | Salle de bain | loaded |
| `music_assistant` | Music Assistant | loaded |
| `go2rtc` | go2rtc | loaded |

### 5.4 Caméras & vidéo

| Domaine | Titre | État |
|---|---|---|
| `onvif` | Chambre (c4:aa:c4:4b:68:40) | loaded |
| `onvif` | Cuisine (f8:ce:07:b5:5b:f6) | loaded |
| `webrtc` | WebRTC Camera | loaded |
| `frigate` | ccab4aaf-frigate-fa:5000 | **setup_retry** (à diagnostiquer) |

### 5.5 Appareils connectés

| Domaine | Titre | État |
|---|---|---|
| `frisquet_connect` | Maison (chaudière) | loaded |
| `dyson_local` | MyDyson: might@live.fr (FR) | loaded |
| `dyson_local` | Dyson Purifier | loaded |
| `ecoflow_cloud` | River 2 Pro | loaded |
| `moonraker` | Creality Ender 3 S1 Pro | **setup_in_progress** (erreurs réseau 192.168.1.81:7125) |

### 5.6 Localisation & calendrier

| Domaine | Titre | État |
|---|---|---|
| `meteo_france` | Serémange-Erzange - Lorraine (57) - FR | loaded |
| `proximity` | Maison | loaded |
| `local_calendar` | Might | loaded |
| `local_calendar` | Might-ha | loaded |
| `google_tasks` | Mickaël RUBINO | loaded |
| `downloader` | Downloader | loaded |

### 5.7 HomeKit Bridges (pont HA → iOS)

| Entry | Type | Usage |
|---|---|---|
| `HASS Bridge:21064` | Bridge principal | loaded |
| `HASS Bridge VN:21072` | Bridge | loaded |
| `HASS Bridge BM:21065` | Bridge | loaded |
| `Home Assistant Bridge:21063` | Bridge importé | loaded |
| `Prise fixe cuisine porte Child lock:21067` | Accessory | loaded |
| `Prise mobile 1 Child lock:21068` | Accessory | loaded |
| `Prise mobile 2 Child lock:21069` | Accessory | loaded |
| `Prise fixe PC Chambre Child lock:21070` | Accessory | loaded |
| `Samsung Q80 Series (65):21071` | Accessory | loaded |

### 5.8 Mobile apps

| Domaine | Titre | État |
|---|---|---|
| `mobile_app` | Might iPhone | loaded |
| `mobile_app` | MightTab | loaded |

### 5.9 Automatisation & IA

| Domaine | Titre | État |
|---|---|---|
| `nodered` | Node-RED | loaded |
| `browser_mod` | Browser Mod | loaded |
| `hacs` | HACS | loaded |
| `openai_conversation` | OpenAI Conversation | loaded |
| `openai_conversation` | ChatGPT | **not_loaded** (désactivé par user) |
| `wyoming` | Piper | loaded |
| `wyoming` | Whisper | loaded |

### 5.10 MCP / Cowork

- **Add-on `ha-mcp` (homeassistant-ai)** utilisé comme serveur MCP Cowork via `https://mcp.might.ovh/<secret>` (exposition publique via CF Tunnel)
- L'intégration core `mcp_server` HA (ne supporte pas DCR) n'est plus utilisée pour Cowork — bascule actée S15

### 5.11 À surveiller

- `frigate` en **setup_retry** — diagnostiquer (potentiellement lié à redémarrage add-on ou perte réseau)
- `moonraker` en **setup_in_progress** — imprimante 3D éteinte ou injoignable (192.168.1.81:7125)
- `zha` **not_loaded** (ignore) — normal, Mickael utilise Zigbee2MQTT

---

## 6. Sécurité & protection

- **Cloudflare Access** protège `https://ha.might.ovh` (dashboard web) en Allow+Email+MFA via l'app `Might-HA`
- **Cloudflare Access bypass** sur 3 destinations via l'app `HA MCP Server Bypass` (créée session 15) :
  - `ha.might.ovh/mcp_server`
  - `ha.might.ovh/auth` (couvre authorize + token + revoke + tout `/auth/*`)
  - `ha.might.ovh/.well-known` (couvre les 2 endpoints OAuth discovery)
- Limite CF Access : 5 destinations max par app → on a 2 slots libres
- **MFA HA** : TOTP actif sur compte Mickael (activé 19/04/2026 matin)
- **HSTS** : max-age 6 mois, TLS 1.2+, no-sniff ON (activé 19/04/2026)
- **IP Bans HA** : défaut `ip_ban_enabled: true` + seuil 5 échecs consécutifs. Temporairement désactivé (`ip_ban_enabled: false` + `login_attempts_threshold: -1`) pendant les tests ha-mcp session 15.

---

## 7. Comptes & rôles HA

- **Mickael** (admin, propriétaire) — MFA TOTP actif
- **MightTab** (compte secondaire — à restreindre en local_only, voir TASKS #9)

---

## 8. Éléments de config connus dans `configuration.yaml`

(à compléter en inspectant directement — exclure du git si secrets)

Section `http:` — modifiée session 15 temporairement :
```yaml
http:
  ip_ban_enabled: false          # temporaire — tests ha-mcp
  login_attempts_threshold: -1   # temporaire — tests ha-mcp
```

Section `logger:` — DEBUG activé temporairement pour `homeassistant.components.mcp_server` (via UI intégration MCP Server — bouton "Activer le journal de débogage").

---

## 9. Raccourcis clavier HA activés (vu session 10-11)

Toggle "Raccourcis clavier" ON dans profil utilisateur Mickael.

| Raccourci | Action | Note AZERTY FR |
|---|---|---|
| `Shift + ?` | Afficher panneau raccourcis | Obtenu physiquement par `Shift+,` (touche qui produit `?`) |
| `A` | Ouvrir Assist | |
| `C` | Créer | |
| `E` | Entités | |
| `D` | Appareils | |
| `M` | Ma barre latérale | |
| `Ctrl+K` | Recherche rapide | |

---

*Dernière mise à jour : session 24 — 21/04/2026 — inventaire complet des 62 intégrations + confirmation add-ons (Phase 1 Mode Réactif v1.1)*
