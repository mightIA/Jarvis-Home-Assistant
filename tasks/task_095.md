---
id: 95
title: "Proxy local HA-MCP injection headers Service Token CF Access (post-Proxmox)"
status: open
priority: P3
session_opened: S107
tags: [ha-mcp, cowork, cloudflare, service-token, proxy, hardware-upgrade]
source: "Session 04/05/2026 — bascule à faire après migration Proxmox + PC domotique (BoM v4 S101)"
---

# T#95 — Proxy local HA-MCP injection headers Service Token CF Access (post-Proxmox)

## Contexte

Suite à la migration Service Token CF Access (T#60 résolue S102), le connecteur **"Jarvis HA"** dans **Cowork desktop** ne fonctionne plus :

- Côté serveur tout va bien : tunnel CF + Service Token + path-token + add-on `ha-mcp` répondent (HTTP 405 sur HEAD = transport MCP OK, vérifié par curl PowerShell avec headers `CF-Access-Client-Id`/`Secret` étape 8 session courante)
- Côté Cowork desktop : **l'UI ne supporte pas l'injection de headers HTTP custom** pour les connecteurs MCP. Le formulaire d'ajout propose bien des champs ID/Secret quand l'URL contient `/private_<secret>` mais les utilise pour un **flow OAuth standard** (`"auth": "oauth"` dans la résolution interne), pas comme headers `CF-Access-Client-Id`/`CF-Access-Client-Secret`. → 403 Forbidden CF Access lors du clic "Connecter"
- La config interne des connecteurs Cowork desktop est stockée en **base binaire LevelDB Chromium** (`%APPDATA%\Claude\Local Storage\leveldb\` + `IndexedDB\`), pas dans un JSON éditable. Modification directe = risque corruption Cowork.

## Choix conservation Service Token (S104, refus régression sécu)

3 options évaluées en session courante :

| Option | HA dans Cowork | Sécu CF Access | Effort | Décision |
|---|---|---|---|---|
| A — bascule CLI | ❌ | ✅ | 0 | **Refusée** (Mickael : CLI réservé Hermès Agent à terme pour tri email) |
| B — désactiver CF Access | ✅ | ❌ régression | 5 min | **Refusée** (perte sécurité Service Token acquise S102 inutile) |
| **C — proxy local** | ✅ | ✅ | 1-2h | **Choisie, reportée post-Proxmox** |

## Description de la solution choisie (Option C)

Petit script Node ou Python qui tourne en local (port `localhost:9999`) et qui :

1. Reçoit les requêtes MCP de Cowork desktop sur `http://localhost:9999/<path>`
2. Y ajoute les headers `CF-Access-Client-Id` / `CF-Access-Client-Secret` (lus depuis les variables d'env Windows User `CF_ACCESS_CLIENT_ID` / `CF_ACCESS_CLIENT_SECRET`)
3. Forwarde vers `https://mcp.might.ovh/<path>` (URL réelle ha-mcp avec path-token actuel ou nettoyé via T#94)
4. Renvoie la réponse MCP à Cowork

Côté Cowork : le connecteur "Jarvis HA" pointe sur `http://localhost:9999/private_<secret>` (ou `/jarvis-mcp` si T#94 path cleanup fait). Cowork voit un MCP local sans CF Access → pas de 403, pas de blocage UI. Le Service Token est appliqué au niveau du proxy → sécurité S102 préservée.

## Pourquoi reporté post-Proxmox / PC domotique

Mickael décision S104 : pas de nouveau composant runtime sur le PC actuel (already running Gmail-MCP-Server, Hermès, Ollama, Brave + Cowork + Claude Code). Le proxy s'installera proprement sur :
- soit le PC domotique dédié à venir
- soit en VM Proxmox dédiée (cohérent avec project_hardware_upgrade_bom_v4_s101.md)

Acceptable transitoire : pas de HA dans Cowork pour l'instant. Mickael consulte HA UI directement [http://192.168.1.11:2096/](http://192.168.1.11:2096/) ou via dashboard pour les besoins ad hoc. Mode Réactif Jarvis v1.1 (CLI headless 04h00 + 23h30) continue de tourner indépendamment.

## Pré-requis

- Migration Proxmox + PC domotique livrée (BoM v4 S101 commandée et installée)
- T#94 résolue (path cleanup Niveau 1bis) — facultatif mais cohérent
- Choix techno : Node.js (cohérent Runtime Gmail-MCP-Server) ou Python (plus léger)

## Livrables attendus

- (a) Script proxy `Runtime/HA-MCP-Proxy/proxy.js` (ou `.py`) — ~50 lignes max, dépendances minimales (`express`+`http-proxy-middleware` ou `aiohttp`)
- (b) Service Windows / systemd auto-start au boot
- (c) Test bout-en-bout : connecteur Cowork "Jarvis HA" sur `localhost:9999` → `ha_get_state` répond
- (d) MAJ `.mcp.json` projet Jarvis (si on garde aussi le CLI direct vers `mcp.might.ovh`, conserver les 2 entrées)
- (e) Doc dans skill `cloudflare-access-ha` Phase 8
- (f) Auto-memory `reference_proxy_local_ha_mcp_pattern.md` (pattern réutilisable pour autres MCP CF Access)

## Liens

- Source du blocage : memory/feedback_cowork_no_custom_http_headers_mcp.md (auto-memory créée S107)
- Tâche source : [T#60](archive_2026-Q2/task_060.md) → résolution S102
- Tâche connexe : [T#94](task_094.md) — path cleanup + Niveau 2a/2b
- Hardware : [BoM v4 S101](../memory/project_hardware_upgrade_bom_v4_s101.md)
- Note : T#27 dans `.mcp.json` ligne 32 (`_task_27_note`) est obsolète (T#27 clôturée S17 — pairage Cowork web HA fonctionnait avant migration Service Token). Référence à mettre à jour vers T#95.
