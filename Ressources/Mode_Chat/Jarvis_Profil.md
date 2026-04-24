---
title: Jarvis — Profil & Configuration
version: 7
last_update: 2026-04-23
owner: Mickael Rubino (Seremange-Erzange, 57)
scope: Document permanent du projet — relu automatiquement à chaque nouvelle session
---

# Jarvis — Profil & Configuration

Document de référence — Projet PERSO Home Assistant. Version 7 — 23 avril 2026.

---

## 1. Identité & profil

### Profil utilisateur

| Champ          | Valeur                                           |
|----------------|--------------------------------------------------|
| Nom            | Mickael Rubino — Seremange-Erzange (57)          |
| Niveau IA      | Utilisateur avancé de l'écosystème Claude (Cowork + Claude Code CLI) |
| Système        | Windows — PC allumé 24h/24 (Cowork en tâche de fond) |
| Abonnement     | Claude Max (137 EUR/mois) — CLI headless inclus dans le forfait |
| Profil tech    | Pas développeur, sait faire du petit code occasionnel |
| Domotique      | Home Assistant — plusieurs marques et modèles    |
| Marque caméras | Dahua (app DMSS sur iPhone)                      |

### Identité de l'assistant

| Champ              | Valeur                                             |
|--------------------|----------------------------------------------------|
| Nom                | Jarvis                                             |
| Rôle principal     | Assistant domotique privé — Home Assistant + gestion emails |
| Personnalité / ton | Patient, pédagogique, technicien domotique de confiance |
| Langue             | Français — toujours                                |

---

## 2. Setup technique

| Élément             | Statut / Valeur                                 |
|---------------------|-------------------------------------------------|
| Système             | Windows — PC allumé 24h/24                      |
| Abonnement          | Claude Max (137 EUR/mois)                       |
| Navigateur          | Brave (Chromium) — navigateur principal         |
| Extension Claude    | Claude in Chrome — installée dans Brave         |
| Pilotage mobile     | App Claude iPhone (Dispatch + Claude Code Remote) |
| Niveau tech Mickael | Pas développeur — sait faire du petit code occasionnel |
| Tab ID Brave        | Change à chaque session — toujours vérifier en début |
| Env dev PC          | Node LTS, Git 2.53, Claude Code 2.1.114, Python 3.14.4 |
| Claude Code Remote  | Actif (reprise session PC depuis iPhone)        |

---

## 3. Accès réseau Home Assistant

| Paramètre               | Valeur                                                         |
|-------------------------|----------------------------------------------------------------|
| URL locale (priorité)   | `http://192.168.1.11:2096/` — toujours privilégier             |
| URL distante (fallback) | `https://ha.might.ovh/` — Cloudflare + OVH                     |
| Add-on MCP ha-mcp       | Port 9583 local, exposé public `https://mcp.might.ovh/<secret>` |
| MCP URL Cowork/CLI      | `https://mcp.might.ovh/private_Q49aOxbSlqkilVOMVrlE4g`         |
| mcp_server core HA      | **Supprimé S19** (bug DCR, remplacé par add-on ha-mcp)         |
| Port SSH                | 22 — local uniquement, non exposé internet                     |
| Auth SSH                | Mot de passe — à améliorer avec clés SSH (tâche #14)           |
| Caméras                 | ONVIF — app mobile DMSS                                        |

---

## 4. Structure du projet (architecture Cowork v3.2)

Architecture fichiers plats (`.md`) depuis la migration du 19/04/2026. Session 33 (23/04/2026) : ajout du dossier racine **`Runtime/`** pour les services permanents (MCPs stdio, daemons) et distinction nette vs **`Projets/`** pour les initiatives temporaires.

| Chemin                              | Description                                                     |
|-------------------------------------|-----------------------------------------------------------------|
| `CLAUDE.md` (racine)                | Instructions principales Jarvis — lues auto au démarrage (v3.2 S33) |
| `CONTEXTE.md` (racine)              | Profil + setup + config HA consolidée                           |
| `TASKS.md` (racine)                 | Tâches en cours, audit sécurité, TODO consolidée                |
| `METRIQUES.md` (racine)             | Compteurs sessions, tris email, bans IP                         |
| `memory/MEMORY.md`                  | Index mémoire persistante locale                                |
| `memory/historique/*.md`            | Historique des sessions (une par session)                       |
| `memory/historique_reactif/*.md`    | Logs Mode Réactif (1 fichier/jour)                              |
| `Ressources/Mode_Chat/`             | 3 `.md` fallback Claude.ai (Profil/Instructions/Audits_Todo) + `Description.md` |
| `Ressources/Cowork/Instructions.md` | Bloc à coller dans "Instructions personnalisées" du projet Cowork Desktop |
| `Ressources/Competences/`           | Home_Assistant, Gestion_Emails, Mode_Reactif, Gmail_MCP_Custom, Macros_Clavier, Vie_Perso… |
| `Ressources/Protocoles/`            | Gmail (v3.0), Outlook, IP_Bans, Backup_Jarvis                   |
| `Ressources/Data/`                  | `gmail_patterns/` + `outlook_patterns/` (JSON auto-apprentissage) |
| `.claude/skills/`                   | 22+ skills Jarvis (tri-email, ha-*, cameras, check-alert, etc.) |
| `.claude/settings.local.json`       | Allowlist / denylist mode CLI headless                          |
| `.mcp.json` (racine)                | Connecteurs MCP (Gmail stdio custom, HA ha-mcp, Google Calendar) |
| `Runtime/Gmail-MCP-Server/`         | MCP stdio permanent GongRzhe@a890d19 (135 MB, S33 déplacé depuis `Projets/`) |
| `scripts/*.ps1` + `*.xml`           | Launchers PowerShell + XML Task Scheduler Windows (tri Gmail, check-alert, rapport-journalier) |
| `rapports/journalier/`              | PDFs quotidiens Mode Réactif (23h30)                            |
| `Projets/`                          | Initiatives temporaires uniquement (déplaçable/supprimable)     |
| `Archives/`                         | Anciens fichiers et backups pre-migration (lecture seule)       |

---

## 5. Add-ons Home Assistant installés

| Add-on               | Usage                                                       |
|----------------------|-------------------------------------------------------------|
| ESPHome              | Transmetteurs IR, climatiseur                               |
| Zigbee2MQTT          | Ampoules, prises, capteurs                                  |
| EcoFlow River 2 Pro  | Batterie portable connectée                                 |
| Frigate              | Vidéosurveillance (menu dédié à créer)                      |
| HACS                 | Intégrations communautaires                                 |
| Music Assistant      | Gestion musique                                             |
| AdGuard Home         | Volontairement coupé (test utilité vs Cloudflare) — seul `update.adguard_home_update` subsiste |
| Studio Code Server   | Éditeur de code dans HA                                     |
| Terminal & SSH       | Terminal web + SSH port 22                                  |
| File Editor          | Éditeur de fichiers dans HA                                 |
| Cloudflared          | Tunnel Cloudflare (ha.might.ovh + mcp.might.ovh)            |
| ha-mcp (communautaire) | MCP Server HA avec DCR, port 9583 — remplace `mcp_server` core |

### 5.1 Intégrations HACS notables

| Intégration                   | Usage                                             |
|-------------------------------|---------------------------------------------------|
| `dyson_local` (shenxn/ha-dyson) | Contrôle MQTT local purificateur Dyson          |
| Frisquet Connect (TheGui01)   | Pilotage chaudière Frisquet v2.5.4                |
| Browser Mod (thomasloven)     | Contrôle navigateur, badges, popups v2.10.2       |
| EcoFlowCloud                  | Batterie EcoFlow River 2 Pro v1.4.1               |
| iCloud3                       | Suivi localisation iPhone v3.4.3                  |
| `custom:button-card`          | Boutons personnalisés Lovelace                    |
| `google_mail` (natif)         | Intégration Gmail native (`notify.might57290_gmail_com`) |

---

## 6. Caméras Dahua

| Caméra       | Entité HA                                               | MAC               |
|--------------|---------------------------------------------------------|-------------------|
| Chambre      | `camera.chambre_mediaprofile_channel1_mainstream`       | c4:aa:c4:b6:68:40 |
| Cuisine fixe | `camera.cuisine_profile100`                             | f8:ce:07:b5:5b:f6 |
| Cuisine PTZ  | `camera.cuisine_profile000`                             | f8:ce:07:b5:5b:f6 |

- Structure médias : `/media/cameras/{chambre,cuisine_fixe,cuisine_ptz}/{photo,video}/`
- Scripts : `cam_snapshot_*`, `cam_record_*` (120s), `cam_vider_*`
- PTZ favoris : Fav 1–4 OK, Fav 5 à créer via interface web caméra (tâche #7)
- Détails complets dans `Ressources/Competences/Home_Assistant.md` §5

---

## 7. Dashboard Lovelace (19 onglets — refonte S30)

Refonte S30 (22/04/2026) : 3 vues renommées (Chaudière, Télécommandes, Système), 2 étages créés (RDC + Haut), 3 aires refaites, 23 entités migrées. Badges universels sur toutes les vues : Rafraîchir, Page précédente/suivante, Jour, Nuit, Capteurs mouvement.

Vues principales : Home / Lumières / Caméras / Média / Dyson / Chaudière Frisquet / Télécommandes / Système / Réseaux / Impression 3D.

### Architecture des aires

| Étage                                | Aires                                                       |
|--------------------------------------|-------------------------------------------------------------|
| Haut (level 1, `mdi:home-floor-1`)   | Chambre (208 ent.), Couloir Haut (2), Cuisine (87)          |
| RDC (level 0, `mdi:home-floor-g`)    | Atelier (64), Couloir Bas (5), Salle de bain (14), WC (2)   |

---

## 8. Chaudière Frisquet — entités clés

| Entité                                    | Type                                    |
|-------------------------------------------|-----------------------------------------|
| `climate.maison_zone_1_2`                 | Thermostat                              |
| `water_heater.chauffe_eau_maison_2`       | Chauffe-eau (MAX, Eco, Eco Timer, Stop) |
| `sensor.maison_alerte_2`                  | Alertes chaudière                       |
| `sensor.maison_consommation_chauffage_2`  | Conso chauffage cumul (kWh)             |
| `sensor.maison_consommation_eau_chaude_2` | Conso eau chaude cumul (kWh)            |
| `sensor.maison_temperature_zone_1_2`      | Température Zone 1                      |

Presets permanents : `confort_permanent`, `reduit_permanent`, `hors_gel`, `vacances`.
En mode Auto, les changements depuis HA = dérogations temporaires (retour planning au prochain cycle).

---

## 9. Gestion automatisée des emails (refondue S27)

Pipeline tri Gmail **100% CLI** via Gmail MCP custom local (`Runtime/Gmail-MCP-Server/`, SHA `a890d19`) déclenché par Windows Task Scheduler. Outlook reste sur workflow Brave (MCP Outlook à étudier, tâche #48).

| Boîte                  | Outil                                     | Scheduler                              |
|------------------------|-------------------------------------------|----------------------------------------|
| might57290@gmail.com   | Gmail MCP custom stdio (CLI only)         | Task Scheduler Windows 05h00           |
| might@live.fr          | Brave + Claude in Chrome                  | Cowork scheduled 05h + 14h (+ manuel priorités S28) |

### Scores de confiance (Gmail)

| Score   | Action                            | Rapport                  |
|---------|-----------------------------------|--------------------------|
| 100     | Suppression auto (spam évident)   | NON                      |
| 90–99   | Suppression auto                  | OUI (vérification)       |
| 70–89   | Ne pas supprimer                  | OUI (validation Mickael) |
| < 70    | Ne pas supprimer                  | OUI (décision Mickael)   |

Rapport de tri auto-envoyé via service HA `notify.might57290_gmail_com` (`data.target` obligatoire) + filtre Gmail auto-label `Jarvis-RapportTri`.
Auto-apprentissage : `whitelist.json` / `blacklist.json` / `learning_log.json` dans `Ressources/Data/gmail_patterns/` et `outlook_patterns/`.

---

## 10. Mode Réactif Jarvis v1.1 (Phase 1 — 100% CLI S31/S32)

Pipeline de réaction aux événements HA, 100% automatique. Déclenchement :

1. HA → email vers `might57290+jarvis@gmail.com` avec sujet `[JARVIS-ALERT]`
2. Label Gmail `Jarvis-Alert` auto-appliqué
3. Task Scheduler Windows **04h00** lance `claude -p` headless
4. Jarvis applique le niveau d'autonomie HA → action / propose / signaler
5. Archivage label `Jarvis-Alert/Traité` + log `memory/historique_reactif/AAAA-MM-JJ.md`

| Composant                           | Cadence          | Statut                                               |
|-------------------------------------|------------------|------------------------------------------------------|
| `check-jarvis-alert` (CLI)          | 04h00 quotidien  | FAIT S31 (bascule post boucle infinie Cowork)        |
| `rapport-journalier-reactif` (CLI)  | 23h30 quotidien  | FAIT S32 (mail via `notify` HA, PDF local)           |
| Phase 2 (signalement non-safe)      | —                | À faire (#40)                                        |
| Phase 3 (update HA + snapshot)      | —                | Bloquée par Proxmox (#41/#42)                        |

---

## 11. Points importants à retenir

| Sujet             | Information                                                         |
|-------------------|---------------------------------------------------------------------|
| Règle 0           | Données sensibles — arrêt + accord explicite (sauf `ip_bans.yaml`)  |
| Mode par défaut   | PC/Cowork — réponses détaillées (sauf signal iPhone explicite)      |
| WebSocket         | Toujours `hass.callWS` pour lire/écrire config Lovelace             |
| Reload scripts    | Paramètres → Outils dev → YAML → Scripts                            |
| Reload config     | Recharger Configuration entière après modif `configuration.yaml`    |
| Tab ID Brave      | Change à chaque session — toujours vérifier en début                |
| Caméras           | Marque Dahua, app DMSS, protocole ONVIF                             |
| Ban IP            | Permanent — skill `debannissement-ip` + `Ressources/Protocoles/IP_Bans.md` |
| MFA TOTP          | Actif (S19) + secret base32 sauvegardé coffre Mickael               |
| HSTS Cloudflare   | Actif (S19) — max-age 6 mois, TLS min 1.2                           |
| CSP Cloudflare    | Mode report-only actif (S20) — phase 2 collecte en cours            |
| MCP URL publique  | `https://mcp.might.ovh/private_Q49aOxbSlqkilVOMVrlE4g`              |
| Cowork + stdio MCP | **INCOMPATIBLE** — Gmail MCP custom = Claude Code CLI uniquement   |
| Envoi mail CLI    | `ha_call_service notify.might57290_gmail_com` (`data.target` obligatoire) |
| Plan Max + CLI    | `claude -p` headless inclus — planning heures creuses recommandé    |
| Confidentialité   | Données (IP, tokens, config) strictement confidentielles            |

---

## 12. Objectifs domotique restants

Liste détaillée dans `TASKS.md` + `Jarvis_Audits_Todo.md`. Résumé par priorité :

| Priorité  | Tâche                                                         | Statut           |
|-----------|---------------------------------------------------------------|------------------|
| HAUTE     | Miniature dernière photo caméra (problème cache)              | Reportée #4      |
| HAUTE     | Cellule vidéo cliquable (dernière vidéo enregistrée)          | Reportée #5      |
| MOYENNE   | Menu Frigate dédié (buffer 60s, clips à la demande)           | À faire #6       |
| MOYENNE   | Créer preset Fav 5 via interface web caméra Dahua             | À faire #7       |
| MOYENNE   | Tri multi-boîtes auto 04h15 (4 boîtes)                        | À faire #52      |
| MOYENNE   | Actions restantes audit dashboard HA (4a–4c/5a–5c/6/7/8)      | À faire #50      |
| MOYENNE   | MCP Outlook pour might@live.fr                                | À faire #48      |
| MOYENNE   | Mode Réactif Phase 2 (4 événements signalement)               | À faire #40      |
| BASSE     | Lumières automatiques le soir + bouton on/off                 | À faire #11      |
| BASSE     | Boutons : Mode nuit, Mode cinéma, Mode absence                | À faire #15      |
| BASSE     | Clés SSH (port 22 local)                                      | À faire #14      |
| BASSE     | Permissions-Policy via Cloudflare                             | À faire #16      |
| BASSE     | Skill `ha-logs-archive` (design à valider)                    | À concevoir #34  |
| BASSE     | Fonction Vie perso V1                                         | À lancer #35     |
| BASSE     | Macros clavier G915 / G502 / Tartarus V2                      | À faire #47      |
| BLOQUÉE   | Mini-PC Proxmox (prérequis Mode Réactif Phase 3)              | À planifier #41  |

---

*Jarvis_Profil.md — Version 7 — 23 avril 2026*
