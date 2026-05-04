---
id: 60
title: "L'endpoint `https://mcp"
status: testing
priority: P2
session_opened: S48
tags: [ha-mcp, hermes, cloudflare, mcp, cowork]
source: "Session 48 / Risque path-token identifié pendant install Hermes"
---

# T#60 — L'endpoint `https://mcp

## Description

**[NOUVELLE session 48 — durcir auth ha-mcp]** L'endpoint `https://mcp.might.ovh/private_[REDACTED-OLD-SECRET-S70]` repose sur un **path-token unique** (bypass CF Access activé S20). Entropie ~130 bits = brute force infaisable, mais paths apparaissent en clair dans logs CF Analytics, `~/.bash_history`, sortie `hermes mcp list`, captures d'écran terminal, et `git diff` si push raté `.mcp.json`. Bonne pratique défense en profondeur = passer en header d'auth. **3 niveaux à mettre en œuvre par étapes** (du plus simple au plus propre) : **Niveau 1 (~30 min, prioritaire)** — créer un **Cloudflare Access Service Token** (dash CF → Zero Trust → Access → Service Auth) → renommer le path en non-secret (`mcp.might.ovh/jarvis-mcp`) → reconfigurer `hermes mcp` avec `--auth header` et headers `CF-Access-Client-Id` / `CF-Access-Client-Secret` → patcher `.mcp.json` + `.mcp.json.template` côté projet + skills + CLAUDE.md + archives. **Niveau 2 (~1h)** — ajouter rate limiting CF (max 100 req/min par IP) + IP allowlist (uniquement IPs PC + serveurs Hermès, exclure le reste du monde) + Service Token rotatif (rotation manuelle tous les 90 jours, calendrier rappel). **Niveau 3 (~30 min, idéal)** — basculer sur OAuth DCR direct sur l'add-on ha-mcp (déjà supporté via `--auth oauth` côté Hermes Agent). Plus aucun secret long terme à manipuler, jeton frais à chaque session. ⚠ Cowork ne sait PAS faire OAuth DCR (validé S16, c'est précisément pour ça que le bypass CF avec path-token a été choisi initialement) — donc Niveau 3 est compatible Hermès CLI uniquement, pas Cowork. **Stratégie recommandée** : faire Niveau 1 avant le push GitHub mightIA (D2 #58), puis Niveau 2 dans la foulée, puis Niveau 3 quand Hermès Phase 1bis-d sera bouclée. Niveau 3 peut **coexister** avec Niveau 1 (Cowork garde le path/header, Hermès passe en OAuth DCR). **Audit côté CF Analytics avant migration** : récupérer les 30 derniers jours de logs `mcp.might.ovh/<path>` pour vérifier qu'aucune IP inattendue n'a déjà découvert le path-token (si oui, rotation immédiate). **Livrables attendus** : (a) Service Token CF créé + stocké 1Password, (b) URL changée, (c) test bout-en-bout depuis Cowork + Hermès + ha-mcp, (d) doc `Ressources/Competences/Cloudflare_Access_Ha-mcp.md` mise à jour, (e) skill `cloudflare-access-ha` patchée, (f) auto-memory `reference_ha_mcp_endpoint_validated` mise à jour, (g) note dans CLAUDE.md sur la nouvelle URL. **Pré-requis** : compte CF Access activé (déjà OK S20), accès dash.cloudflare.com Zero Trust. **Durée totale niveaux 1+2+3** : ~2 h sur session dédiée.

## Source / Échéance

Session 48 / Risque path-token identifié pendant install Hermes

## Statut

🟢 `open` — **scope ajusté S83 (01/05/2026)** suite revue T#60 avec Mickael.

**Plan ajusté (~70 min au lieu des 2h initiales)** :

| Niveau | Action | Statut S83 |
|---|---|---|
| **1** | Migration path-token URL → Header CF Access (Service Token Client ID/Secret) | À faire (~30 min) — **prioritaire** |
| **2a** | IP allowlist (PC Mickael + serveur Hermès uniquement) | À faire (~30 min) |
| **2b** | Rate limiting (100 req/min/IP) | À faire (~10 min) |
| ~~2c~~ | ~~Rotation auto 90 j~~ | **Abandonné** S83 — décision Mickael : trop contraignant. Rotation **sur événement uniquement** (suspicion fuite, comme S70). |
| **3** | OAuth DCR Hermès | **Bonus optionnel** — Cowork ne supporte pas (validé S16). Possible côté Hermès CLI uniquement, pas urgent. |

**Justifications scope ajusté** :
- Niveau 1 = 80 % du gain sécu (élimine 4 des 5 canaux de fuite : logs CF, bash_history, `hermes mcp list`, screenshots)
- Niveau 2a/2b = défense en profondeur réaliste
- Rotation 90 j abandonnée car contraignante en pratique (oubli si manuelle, fragile si auto)

**Pré-requis avant attaque** :
- Mickael devant dashboard `dash.cloudflare.com` → Zero Trust
- Client ID + Secret CF Access stockés dans gestionnaire mdp (Bitwarden / 1Password / KeePass)
- Session dédiée 45-60 min réelle (pas en plein milieu d'une revue tâches)
- Test `curl` bout-en-bout planifié avant bascule

**À livrer en fin de session dédiée** :
- (a) Service Token CF créé + stocké safe
- (b) URL `mcp.might.ovh/jarvis-mcp` (sans secret dans path)
- (c) `.mcp.json` Cowork patché (headers `CF-Access-Client-Id` / `CF-Access-Client-Secret`)
- (d) `.mcp.json` Hermès Agent patché
- (e) Test bout-en-bout depuis Cowork + Hermès
- (f) Création skill `cloudflare-access-ha` (n'existe pas en S83)
- (g) Création doc `Ressources/Competences/Cloudflare_Access_Ha-mcp.md`
- (h) MAJ CLAUDE.md §6 endpoint
- (i) Auto-memory `reference_ha_mcp_endpoint_validated` mise à jour

⚠ **Règle 0** : Client ID + Client Secret = données sensibles. Mickael les gère seul, jamais via Jarvis. Placeholders dans `.mcp.json`, Mickael remplac