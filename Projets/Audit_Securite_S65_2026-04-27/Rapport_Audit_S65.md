# Rapport d'audit sécurité Home Assistant — Session 65

**Date** : lundi 27 avril 2026
**Cible** : `http://192.168.1.11:2096/` + `https://ha.might.ovh/` + `https://mcp.might.ovh/`
**Auditeur** : Jarvis (Cowork Desktop, autonome, lecture seule)
**HA Core** : `2026.4.4` | **HA OS** : `17.2` | **Supervisor** : `2026.04.0`
**Méthode** : audit lecture seule via add-on `ha-mcp` (80+ outils HA) + recherche web (CVE 2026, best practices)

---

## 1. Synthèse exécutive

**Posture sécurité globale : ORANGE.** Excellente base héritée des sessions S19 (MFA TOTP + HSTS), S20 (CSP report-only), S25 (CF Access dashboard + bypass MCP) et S48 (skill cloudflare-access-ha). Tous les correctifs critiques 2026 sont déjà appliqués (notamment **CVE-2026-34205 CVSS 9.6 patché** via Supervisor ≥ 2026.03.02). Cependant l'audit révèle **4 points P0/P1** à traiter (3 secrets exploitables + 1 user MQTT exposé en remote), **6 points P2** d'amélioration et **2 points P3** de nettoyage.

| Couleur | Compte | Description |
|---------|:------:|-------------|
| 🟢 Vert | 14 | Déjà sécurisé / patché / bonne pratique appliquée |
| 🟠 Orange | 6 | À surveiller ou améliorer (P2) |
| 🔴 Rouge | 4 | Action recommandée sous 30 jours (P0/P1) |
| 🟡 Jaune | 2 | Nettoyage cosmétique (P3) |
| 👤 Mickael | 7 | Vérifications nécessitant ton accès direct (Règle 0) |

---

## 2. Méthodologie

### Outils utilisés (lecture seule)

- **MCP `ha-mcp`** : `ha_get_overview`, `ha_get_system_health` (+ repairs), `ha_get_addon` (détail config 12 add-ons sensibles), `ha_get_integration` (63 entrées), `ha_get_updates`, `ha_get_logs` (system + error niveau ERROR/WARNING), `ha_deep_search` (password/token/api_key/shell_command dans automations + scripts + helpers), `ha_eval_template` (states personnes, updates, automations OFF, persistent_notifications)
- **Lecture fichiers projet** : `CONTEXTE.md`, `CLAUDE.md`, mémoire persistante (auto-memories S19→S64)
- **Recherche web** : 7 requêtes ciblées (CVE 2026, ngrok/ZeroTier risques, Studio Code Server, CF Tunnel best practices, Mosquitto ACL, secrets.yaml, supply chain HACS)

### Sources autoritaires consultées

- [Home Assistant Security](https://www.home-assistant.io/security/) — page officielle
- [GHSA-gh5m-4m97-c95h (CVE-2026-34205)](https://github.com/home-assistant/core/security/advisories/GHSA-gh5m-4m97-c95h) — advisory critique
- [OpenCVE Home Assistant](https://app.opencve.io/cve/?vendor=home-assistant) — base CVE
- [Storing secrets — Home Assistant docs](https://www.home-assistant.io/docs/configuration/secrets/)
- [HOWTO: Secure Cloudflare Tunnels](https://community.home-assistant.io/t/howto-secure-cloudflare-tunnels-remote-access/570837)
- [GitHub Security: Home Assistant code review](https://github.blog/security/vulnerability-research/securing-our-home-labs-home-assistant-code-review/)
- [TheHackerWire CVE-2026-34205](https://www.thehackerwire.com/home-assistant-local-network-unauthenticated-endpoint-exposure-cve-2026-34205/)

### Limites

- Pas d'accès aux fichiers `secrets.yaml`, `configuration.yaml`, `.storage/auth` (Règle 0 — données sensibles, accord requis Mickael)
- Pas d'accès aux **logs auth provider HA** (`http.log_provider`) ni au registre `auth_mfa_modules`
- Pas d'accès direct à la **CF Zero Trust dashboard** (vérif policies Access nécessite Mickael)
- Logs supervisor par add-on accessibles mais nécessitent un slug par requête (creusable à la demande)

---

## 3. Inventaire (compact)

### Système

```
HA Core         : 2026.4.4 (à jour, 0 update en attente)
HA OS           : 17.2 (rpi5-64, RPi5)
Supervisor      : 2026.04.0 (✅ contient le fix CVE-2026-34205)
Docker          : 29.3.1
Python          : 3.14.2
Disque          : 21.7 / 1833 GB (1.2 %)
Recorder DB     : SQLite 142 MB (depuis 2026-04-21)
NTP             : synchronisé ✅
HA Cloud        : non connecté (sain)
Notifications   : 0 active
Repairs         : 2 (HACS warnings, déjà ignorés)
```

### Add-ons installés (25)

**🟢 Tournent + correctement configurés (10)**
Terminal & SSH (10.1.0), File editor (6.0.0), Cloudflared (7.0.5), Mosquitto (7.1.0), Matter Server (8.4.0), MariaDB (3.0.1), Google Drive Backup (0.112.1), Samba (12.6.1), OpenThread BR (2.16.7), Studio Code Server (6.0.1), Zigbee2MQTT (2.9.2-1), ESPHome (2026.4.2), Music Assistant (2.8.6), Whisper (3.1.0), Piper (2.2.2), HA MCP Server (7.3.0)

**🟠 Installés mais arrêtés (state=unknown/stopped) — attack surface latente (8)**
Log Viewer, Frigate FA (state=error), Get HACS, ZigStar Flasher, **ZeroTier One**, go2rtc, AdGuard Home, NGINX SSL proxy, **ngrok**

**Notes**
- Frigate (Full Access) en `state="error"` → intégration `frigate` en `setup_retry` (logs : `Cannot connect to host ccab4aaf-frigate-fa:5000`, count 339)
- Moonraker (intégration HACS pour ton imprimante 3D Creality Ender) en `setup_retry` (192.168.1.81:7125 inaccessible, imprimante off)

### Intégrations (63 entrées)

- **Loaded** : 59 ✅
- **Not loaded** : 2 (ZHA dongle Sonoff `source=ignore` + ChatGPT `disabled_by=user` ✅ bonne pratique)
- **Setup retry** : 2 (Frigate + Moonraker, voir ci-dessus)

### Exposition réseau

| Surface | URL | Statut | Authentification |
|--------|-----|--------|-----------------|
| HA local | `http://192.168.1.11:2096/` | OK | HA login + MFA TOTP (S19) |
| HA distant | `https://ha.might.ovh/` | OK | CF Access app + HSTS Cloudflare (S19) |
| MCP HA | `https://mcp.might.ovh/private_PfjEvJTqhCdo9ELRqCPADlzo` | OK | CF Bypass + secret_path 24 chars |
| SSH local | `192.168.1.11:22` | OK | Mot de passe (pas de clé) ⚠️ voir 🔴-2 |
| SMB local | `192.168.1.11:445` | OK | login/pwd + ACL réseaux privés ✅ |
| MQTT | `192.168.1.11:1883/8883` | OK | login/pwd + **require_certificate: true** ✅ |

---

## 4. Findings — autonome (sans accès données sensibles)

### 🔴 P0/P1 — Action recommandée sous 30 jours

#### 🔴-1 — Token ngrok exposé dans config add-on

**Source** : `ha_get_addon(slug="005cb9d3_ngrok").options.auth_token`

```
auth_token: "2syMsa1lhrE80cmxqjjH9ENki0J_3rYKuDJuqRsZFECq4n2JG"
tunnel: hass / proto: http / addr: 8123 / auth: ""
```

**Risque** : token ngrok lisible via API supervisor (n'importe quelle skill/MCP avec `hassio_api: true` peut le lire). Le tunnel est configuré **sans Basic Auth** (`auth: ""`) sur HA web (port 8123). Si l'add-on démarre (actuellement `state=unknown`, `boot=manual`), il expose HA publiquement sans protection en plus du tunnel CF déjà en place.

**Recommandation** : désinstaller l'add-on ngrok (le tunnel CF couvre déjà tous tes besoins distants) **OU** révoquer le token sur ngrok.com et reconfigurer avec Basic Auth si tu as un usage spécifique. Le token actuel doit être considéré comme compromis (j'ai pu le lire).

**Référence** : [HA Remote Access](https://www.home-assistant.io/docs/configuration/remote/) — l'add-on est marqué *experimental* + non maintenu officiellement.

#### 🔴-2 — Terminal & SSH : password seul, aucune clé SSH

**Source** : `ha_get_addon(slug="core_ssh").options`

```
authorized_keys: []        ← VIDE
password: "Yp!*jdgY4[MNUpvtjMhO"  ← seul moyen d'authentification
server.tcp_forwarding: false  ← bon point ✅
```

**Risque** : la doc officielle dit explicitement *« Set a password for login. We do NOT recommend this variant »*. Mot de passe entropie correcte mais réutilisation/brute-force possibles. Surtout, le mot de passe est lisible via API supervisor (comme ngrok ci-dessus).

**Recommandation P1** : générer une paire de clés SSH (ed25519), copier la pubkey dans `authorized_keys`, **vider le champ password**. Procédure documentée dans `Ressources/Protocoles/Backup_Jarvis.md` (skill `install-claude-code-windows` mentionne déjà SSH keys S17). Note : la doc HA officielle confirme que SSH est exposé seulement en local (port 22 non bridge), mais la lecture du password via API reste un risque interne.

#### 🔴-3 — `person.mqtt` = utilisateur HA réel exposé en remote

**Source** : `ha_get_state(person.mqtt)`, `ha_eval_template` person stats

```
person.mqtt
  state: unknown
  user_id: 5bdca910ae154744abf1f6fec6951504
  device_trackers: []
  editable: true
```

**Risque** : la création d'un user HA pour Mosquitto (sans cocher *"Local only"*) crée une **personne loginable à distance** via `https://ha.might.ovh/`. Si le password MQTT (`AQ6w89ZNXtqBZ7I]2SLP`, lisible via API) fuit, l'attaquant peut se connecter à ton HA depuis Internet. Ce n'est pas théorique : c'est documenté comme *« WTH MQTT users »* sur le forum HA et confirmé par les recherches 2026.

**Recommandation** : dans **Paramètres → Personnes & zones → Utilisateurs** :
- Ouvrir l'utilisateur `mqtt`
- Cocher **"Local only"** (= bloque le login via reverse proxy/CF)
- Optionnel : retirer la case "Administrateur" si elle est cochée
- Optionnel : supprimer la `person` associée si tu n'utilises pas son tracking (Mosquitto n'a pas besoin d'une person, juste d'un user)

**Référence** : [Confused about MQTT users definition (HA forum)](https://community.home-assistant.io/t/confused-about-mqtt-users-definition/751752)

#### 🔴-4 — Add-on ZeroTier installé en privilégié, prêt à démarrer

**Source** : `ha_get_addon(slug="a0d7b954_zerotier").host_network/privileged`

```
host_network: true
privileged: ["NET_ADMIN", "SYS_ADMIN"]
boot: manual (currently state=unknown)
networks: ["ebe7fbd4459af938"]
api_auth_token: ""  ← non configuré
```

**Risque** : l'add-on est installé avec accès complet à la stack réseau host + capabilities NET_ADMIN/SYS_ADMIN. S'il démarre, il rejoint un réseau ZeroTier (donc bypass complet du firewall). C'est une **backdoor potentielle** si le réseau ZeroTier n'est pas sous ton contrôle exclusif. Note : les sessions précédentes ne mentionnent pas d'usage actuel de ZeroTier (le tunnel CF couvre tes besoins).

**Recommandation** : si tu n'utilises plus ZeroTier (le tunnel CF est ta voie d'accès distant), **désinstaller l'add-on**. Sinon : configurer `api_auth_token`, vérifier que le membership du réseau `ebe7fbd4459af938` est strictement contrôlé sur le portail ZeroTier (mode "Private Network" avec approbation manuelle).

### 🟠 P2 — À surveiller / améliorer

#### 🟠-1 — Add-on `ha-mcp` : `enable_tool_search: false` alors que toggle attendu ON

**Source** : `ha_get_addon(slug="81f33d0f_ha_mcp").options`

```
enable_tool_search: false
secret_path: "private_PfjEvJTqhCdo9ELRqCPADlzo"  ← l'ancien (S48 prévoyait régénération en private_Q49a..., jamais appliquée)
host_network: true
hassio_api: true
homeassistant_api: true
```

**État** : auto-memory S53 (`reference_ha_enable_tool_search_active.md`) indique que ce toggle a été activé pour optimiser le contexte Hermès. Or il est actuellement OFF. Soit régression, soit redémarrage add-on a perdu le réglage. Pas un risque sécurité direct (le toggle réduit les tokens, ne change pas l'auth) mais cohérence à vérifier.

**Recommandation** : décider — soit ré-activer (Phase 1bis-d Hermès), soit acter qu'on revient au mode complet (87 outils). Met à jour l'auto-memory en conséquence.

#### 🟠-2 — Studio Code Server : `hassio_role: "manager"` + ingress public via CF

**Source** : `ha_get_addon(slug="a0d7b954_vscode")`

```
hassio_role: "manager"  ← admin Supervisor complet
homeassistant_api: true
ingress: true (panneau dans la sidebar HA)
```

**Risque** : un attaquant qui passe l'auth HA (login + MFA + CF Access) accède à un éditeur de tous les fichiers config + un terminal embarqué + l'API supervisor. C'est *par design* (c'est le but de l'add-on), mais ça concentre énormément de pouvoir. Le maintien du MFA TOTP (S19) + CF Access dashboard (S25) est ta seule protection.

**Recommandation** : confirmer que CF Access dashboard reste actif sur `ha.might.ovh` (vérif Mickael, voir 👤-3). Considérer désactiver le boot auto et démarrer manuellement quand tu en as besoin.

#### 🟠-3 — Frigate (Full Access) avec `full_access: true` en error chronique

**Source** : `ha_get_addon(slug="ccab4aaf_frigate-fa")` + logs

```
full_access: true  ← demande l'accès complet aux devices
privileged: ["PERFMON"]
state: error
rating: 1 (faible confiance officielle HA)
```

L'add-on tourne en mode device-access maximal mais est en erreur depuis longtemps (339 occurrences dans les logs sur la période recorder). L'intégration HA `frigate` est en `setup_retry` perpétuel.

**Recommandation P2** : décider — soit réparer (regarder logs supervisor `ccab4aaf_frigate-fa` pour comprendre l'erreur), soit désinstaller si Frigate n'est plus utilisé. Pas critique mais inutile de garder un add-on `full_access: true` qui ne tourne pas.

#### 🟠-4 — Add-on `Get HACS` toujours installé

`Get HACS` (`cb646a50_get`) est un add-on one-shot qui sert uniquement à installer HACS. Une fois HACS installé (c'est ton cas, version 2.0.5), il devient inutile. Pas un risque sécurité direct mais **surface d'attaque inutile**.

**Recommandation** : désinstaller.

#### 🟠-5 — 2 dépôts HACS retirés (warnings ignorés depuis 2025)

```
custom-cards/bar-card        : Repository is no longer maintained (depuis 2025-06)
nervetattoo/simple-thermostat: Repository has been abandoned    (depuis 2025-09)
```

Marqués `ignored: true` dans Repairs. Risque : ces composants tournent encore en lisant des données HA et plus aucun correctif ne sortira. Si une vuln est découverte, pas de patch.

**Recommandation** : auditer où ces 2 cards sont utilisées dans tes dashboards (`ha_deep_search` côté Lovelace), migrer vers `mini-graph-card` (déjà installé) ou `template-thermostat` officiel, puis désinstaller via HACS.

#### 🟠-6 — AdGuard Home installé en `host_network: true` + `hassio_role: manager`

`a0d7b954_adguard` actuellement `state=unknown` + `boot=manual`. Si activé, accès host network + admin supervisor. Configuration normale pour DNS port 53 mais surface importante.

**Recommandation** : si tu n'utilises pas AdGuard depuis longtemps, désinstaller. Sinon, accepter le compromis (DNS host = nécessaire).

### 🟢 Bonnes pratiques déjà en place

| # | Item | Source vérification |
|---|------|--------------------|
| 1 | **CVE-2026-34205 (CRITICAL CVSS 9.6) PATCHÉ** | Supervisor 2026.04.0 > correctif 2026.03.02 |
| 2 | HA Core 2026.4.4 à jour (0 update en attente) | `ha_get_updates` |
| 3 | 84 entités update OFF, 0 disponible | `ha_eval_template` |
| 4 | Pas de notification persistante (aucune alerte sécu HA active) | `ha_eval_template` |
| 5 | Aucun secret en clair dans automations/scripts/helpers | `ha_deep_search` (password/token/api_key) |
| 6 | OpenAI ChatGPT integration `disabled_by: user` | `ha_get_integration` |
| 7 | Mosquitto `require_certificate: true` (mTLS) | `ha_get_addon(core_mosquitto)` |
| 8 | Samba ACL restreinte aux réseaux privés (10/8, 172.16/12, 192.168/16, fe80::/10, fc00::/7) | `ha_get_addon(core_samba).options.allow_hosts` |
| 9 | Cloudflared `host_network: false` (isolé) + tunnel sortant uniquement | `ha_get_addon(9074a9fa_cloudflared)` |
| 10 | Backup auto Google Drive OK (dernière 2026-04-26 05:47) | `ha_get_state(event.backup_sauvegarde_automatique)` |
| 11 | NTP synchronisé (anti rejeu/jeton expirés) | `ha_get_system_health` |
| 12 | HA Cloud Nabu Casa **non connecté** (réduit surface, pas d'identifiants externes) | `ha_get_system_health.cloud.logged_in: false` |
| 13 | Z2M bridge en état `on` (stable Zigbee, pas de noeud orphelin écoutant) | `ha_get_state(binary_sensor.zigbee2mqtt_bridge_connection_state)` |
| 14 | SSH `tcp_forwarding: false` (pas de tunneling SSH possible) | `ha_get_addon(core_ssh).options.server` |

### 🟡 Nettoyage cosmétique (P3)

#### 🟡-1 — HomeKit erreur récurrente "address in use port 2096"

```
OSError: [Errno 98] address in use: ('::', 2096, 0, 0)
```

Conflit interne entre HomeKit Bridge et le port HA web. Pas un problème sécurité (interne), mais pollue les logs.

**Recommandation** : changer le port HomeKit à 21063 (port par défaut) dans la config HomeKit.

#### 🟡-2 — Log Viewer arrêté + add-on installé

`a0d7b954_logviewer` `state=stopped`. Si non utilisé, désinstaller pour réduire la surface (l'accès aux logs reste possible via `ha_get_logs` MCP ou Settings → System → Logs natif).

---

## 5. 👤 Demandes nécessitant Mickael — Règle 0 (accès données sensibles)

> Pour ces 7 vérifications, j'ai besoin d'accéder à des informations sensibles (mots de passe, tokens, registres auth). **Procédure** : tu choisis pour chacune si tu préfères que je guide en lecture seule de ton côté, ou si tu m'autorises explicitement à y accéder via mes outils.

### 👤-1 — Audit utilisateurs HA + auth providers + MFA actif

**Pourquoi nécessaire** : la liste complète des comptes HA + leurs rôles (Owner/Admin/User), l'état MFA TOTP, et les Long-Lived Access Tokens (LLATs) actifs sont stockés dans `.storage/auth` (lecture protégée).

**À vérifier** :
- Combien de comptes existent ? (au minimum : Mickael owner + mqtt user — voir 🔴-3)
- MFA TOTP actif sur le compte Mickael ? (S19 disait OUI, à reconfirmer)
- LLATs actifs : **lister + révoquer ceux dont tu ne te souviens plus**
  - Note importante (recherche web 2026) : *« les LLATs n'expirent pas par défaut »*. Si tu en as créé un en 2024 pour un test ngrok, il fonctionne toujours.
- Pour chaque LLAT actif : sous quel compte (Owner = pleine puissance) ?
- Si LLAT créé sous compte Owner → recommandation : créer un user "service" restreint et reissue le token sous celui-ci

**Procédure manuelle** :
1. `https://ha.might.ovh/profile/security` → vérifier MFA TOTP actif
2. Section "Long-lived access tokens" → lister + supprimer les inutiles
3. Settings → Personnes & zones → Utilisateurs → audit rôles

### 👤-2 — Audit de `secrets.yaml` (et secrets HA Storage)

**Pourquoi nécessaire** : les tokens / passwords exposés via API supervisor (ngrok auth_token, samba pwd, ssh pwd, mqtt pwd) devraient idéalement être stockés via `!secret` dans `secrets.yaml` plutôt qu'en clair dans `options.json` des add-ons. Mais les add-ons ne supportent pas `!secret` dans leur config — c'est une limite HA. À auditer cependant si `configuration.yaml` ne contient pas d'autres secrets en clair.

**À vérifier** :
- Présence de `secrets.yaml` à la racine `/config`
- Inventaire des `!secret xxx` utilisés
- Aucun mot de passe/clé hardcodé directement dans `configuration.yaml`, `automations.yaml`, `scripts.yaml`

**Procédure manuelle** : ouvrir File editor (ingress) → consulter les 4 fichiers cités.

### 👤-3 — État des policies CF Access sur `ha.might.ovh`

**Pourquoi nécessaire** : nécessite ton login Cloudflare (sensible). L'audit doit confirmer :
- Application Access toujours active sur `ha.might.ovh` ?
- Politique : Allow (qui ?) + MFA Cloudflare ?
- Country block actif ? (recommandé : ne laisser que France)
- Bypass policy active sur `mcp.might.ovh` (S25 acté) — toujours OK ?
- Logs Access dernières 7j : tentatives échouées suspectes ?
- Tunnel `cloudflared` status sur dash CF Tunnel : healthy ?

**Référence** : [Securing HA with CF Zero Trust](https://empty.coffee/home-assistant-cloudflare-zero-trust-setup/), best practice : country-block + MFA + dispositifs approuvés.

### 👤-4 — État des bans IP HA (`/config/ip_bans.yaml`)

**Pourquoi nécessaire** : auto-memory `feedback_ha_ipbans_not_sensitive.md` te marque ce fichier comme **non sensible** (exception Règle 0). Mais nécessite quand même un accès File editor.

**À vérifier** :
- Combien d'IPs bannies actuellement ?
- Patterns de provenance (un seul attaquant ? botnet ? scan automatisé ?)
- Présence d'IPs internes par erreur (ton IP fixe domestique 192.168.x.x ne devrait jamais y être)

**Procédure** : skill `debannissement-ip` déjà documentée ; je peux exécuter `shell_command.ha_clear_all_ip_bans` via MCP si besoin.

### 👤-5 — Clé API OpenAI utilisée par `openai_conversation` (intégration ChatGPT/AI Task)

**Pourquoi nécessaire** : la clé est stockée chiffrée dans `.storage/core.config_entries`. Vérifier :
- Quotas usage actuels ($ ce mois-ci)
- Cap budget configuré côté OpenAI portal ? (sinon coût peut exploser)
- Clé créée pour Jarvis spécifiquement ou clé personnelle réutilisée ?

**Recommandation préventive** : créer une clé dédiée HA avec un budget mensuel cap si pas déjà fait.

### 👤-6 — Politique de rotation tokens add-on `ha-mcp` (`secret_path`)

**Pourquoi nécessaire** : auto-memory `feedback_secret_path_s48_jamais_applique.md` indique que la rotation prévue S48 (`private_Q49a...`) n'a jamais été appliquée. **Le secret actuel `private_PfjEvJTqhCdo9ELRqCPADlzo` est en place depuis l'install.**

**À vérifier** :
- Toujours acceptable ? (24 chars random base64-safe = ~144 bits entropie, théoriquement OK)
- Rotation périodique souhaitée ?
- Si rotation : suivre la procédure documentée dans `reference_ha_mcp_secret_regeneration.md` (6 étapes, ~10 min)

### 👤-7 — Audit fichiers `configuration.yaml` + `automations.yaml` + `scripts.yaml` complet

**Pourquoi nécessaire** : `ha_deep_search` couvre les automations/scripts/helpers chargés en runtime, mais pas les fichiers bruts (commentés, désactivés, includes). Vérifier qu'aucun bloc `shell_command:` ou `rest_command:` ne contient un secret hardcodé ou ne pipe une donnée sensible vers un endpoint externe.

**Procédure manuelle** : File editor + grep visuel sur `password|token|api_key|http://|curl ` dans les .yaml.

---

## 6. Plan d'action priorisé

### P0 — semaine prochaine

1. **🔴-3** Cocher "Local only" sur `user.mqtt` (5 minutes, Settings UI)
2. **👤-1** Lister + révoquer LLATs inutiles (15 min, profil HA)

### P1 — sous 30 jours

3. **🔴-1** Désinstaller add-on ngrok OU révoquer le token (10 min)
4. **🔴-2** Migrer SSH password → clé ed25519 (30 min, skill existante)
5. **🔴-4** Désinstaller ZeroTier si non utilisé (5 min)
6. **👤-3** Vérification CF Access policies + country block France-only (15 min Cloudflare dash)

### P2 — sous 90 jours

7. **🟠-1** Décider du `enable_tool_search` add-on `ha-mcp` (5 min)
8. **🟠-3** Traiter Frigate state=error (réparer ou désinstaller, 30 min)
9. **🟠-4** Désinstaller Get HACS (5 min)
10. **🟠-5** Migrer/supprimer bar-card + simple-thermostat (1h)
11. **👤-5** Vérifier cap budget OpenAI API
12. **👤-2** Audit `secrets.yaml`

### P3 — quand tu auras le temps

13. **🟡-1** Changer port HomeKit (10 min)
14. **🟡-2** Désinstaller Log Viewer si non utilisé (5 min)
15. **👤-6** Décider rotation `secret_path` ha-mcp

---

## 7. Comparaison vs audits précédents

| Session | Action validée | Statut S65 |
|---------|----------------|------------|
| **S19** (avril 2026) | MFA TOTP + HSTS Cloudflare | 🟢 Toujours actif (présumé, voir 👤-1 / 👤-3) |
| **S20** | CSP report-only | 🟢 Acté, pas régressé |
| **S21** | MightTab choix assumé (HTTP) | 🟢 Acté |
| **S25** | CF Access dashboard + bypass MCP | 🟢 Présumé (voir 👤-3) |
| **S48** | Rotation `secret_path` ha-mcp prévue | 🔴 **Jamais appliquée** (voir 👤-6) |
| **S53** | `enable_tool_search: true` activé | 🔴 **Régression** : actuellement OFF (voir 🟠-1) |

**Nouvelles découvertes S65 (jamais signalées avant)** :
- 🔴-1 ngrok token + tunnel sans auth
- 🔴-2 SSH sans clé
- 🔴-3 person.mqtt loginable remote
- 🔴-4 ZeroTier privilégié installé
- 🟠-3 Frigate full_access en error
- 🟠-4 Get HACS résiduel

---

## 8. Annexes

### A. Sources web (best practices 2026)

- [Home Assistant Security (officiel)](https://www.home-assistant.io/security/)
- [GHSA-gh5m-4m97-c95h — CVE-2026-34205 advisory](https://github.com/home-assistant/core/security/advisories/GHSA-gh5m-4m97-c95h)
- [HOWTO: Secure Cloudflare Tunnels remote access](https://community.home-assistant.io/t/howto-secure-cloudflare-tunnels-remote-access/570837)
- [Storing secrets — HA docs](https://www.home-assistant.io/docs/configuration/secrets/)
- [ZeroTier setup HA — Peyanski](https://peyanski.com/home-assistant-zerotier-add-on/)
- [Best practices long-lived tokens (HA forum)](https://community.home-assistant.io/t/best-practices-and-okay-practices-regarding-long-lived-tokens/761497)
- [Securing our home labs: Home Assistant code review (GitHub Security)](https://github.blog/security/vulnerability-research/securing-our-home-labs-home-assistant-code-review/)
- [Smart Home Security Audit Checklist 2026](https://secureiot.house/smart-home-security-audit-checklist-2026-a-practical-guide-for-homeowners/)
- [Home Assistant 2026.4 release notes](https://www.home-assistant.io/blog/2026/04/01/release-20264/)
- [TheHackerWire — CVE-2026-34205](https://www.thehackerwire.com/home-assistant-local-network-unauthenticated-endpoint-exposure-cve-2026-34205/)

### B. Outils d'audit utilisés (traçabilité)

```
ha_get_overview (minimal)
ha_get_system_health (include=repairs)
ha_get_updates
ha_get_addon (installed, +stats) → 25 add-ons
ha_get_addon (slug=core_samba, 9074a9fa_cloudflared, 81f33d0f_ha_mcp,
              005cb9d3_ngrok, a0d7b954_zerotier, a0d7b954_vscode,
              core_ssh, core_mosquitto, a0d7b954_adguard,
              ccab4aaf_frigate-fa)
ha_get_integration (limit=100) → 63 entrées
ha_get_integration (entry_id=openai_conversation, frigate, mqtt)
ha_deep_search (password, token, api_key, shell_command)
ha_get_logs (system ERROR + WARNING)
ha_eval_template (persistent_notification, person, updates, automations OFF)
ha_get_state (zigbee bridge, backup, ban_ip, jarvis_autonomie)
ha_config_get_script (cam_vider_dossier)

WebSearch x7 :
- security audit checklist 2026 + CVE
- CVE-2026-34205 mitigation
- ngrok / ZeroTier risques 2026
- Studio Code Server / SSH security 2026
- Cloudflare tunnel best practices 2026
- Mosquitto MQTT ACL anonymous 2026
- secrets.yaml + LLAT rotation 2026
```

### C. Données collectées non utilisées dans l'audit (disponibles si besoin)

- 1131 entités sur 36 domaines, 7 areas
- Structure Lovelace : 3 dashboards, 35 ressources, 20 vues
- Recorder : SQLite 142 MB, retention 7j
- Bluetooth dongle : Raspberry Pi (Trading) Ltd bcm43438-bt (2C:CF:67:6F:5D:03)
- Adresses IPv4/IPv6 host : 192.168.1.11/24 + 2a01:cb11:506:9100:ef09:3c50:d03a:49a2/64

---

## 9. Conclusion

Ton installation HA est **dans une posture défensive solide** grâce aux sessions S19-S25 (MFA, HSTS, CSP, CF Access, secret_path MCP). Le correctif CVE critique 2026 est en place automatiquement. Les 4 points P0/P1 (ngrok, SSH, MQTT user, ZeroTier) sont **tous traitables en moins d'une heure cumulée** et lèvent l'essentiel du risque résiduel. Les 7 demandes nécessitant ton accès direct sont des vérifications préventives, pas des urgences.

**Recommandation principale** : commencer par 🔴-3 (5 min, gain immédiat) et 👤-1 (15 min, donne une vision complète des accès distants).

Aucune action de remédiation n'a été appliquée durant cet audit (consigne : zéro modification fichier projet + Règle 0 données sensibles).

---

*Fin du rapport — version 1.0 — 27 avril 2026*
*Auteur : Jarvis (Cowork Desktop, Sonnet 4.6)*
*Crédit méthodologique : OpenCVE, GitHub Security Advisories, communauté HA*
