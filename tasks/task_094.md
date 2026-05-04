---
id: 94
title: "Nettoyage path-token ha-mcp + Niveau 2a/2b CF Access (suite T#60)"
status: in_progress
priority: P3
session_opened: S102
session_attempt_blocked: S109
session_1bis_acquis: S112
tags: [ha-mcp, cloudflare, service-token, mcp, security]
source: "Suite T#60 résolution S102 — Niveau 1 acquis (Service Token actif Cowork+Hermès), reste path-token cleanup + Niveau 2a/2b"
---

> **✅ État S112 (05/05/2026)** : sous-objectif 1bis **acquis** — path-token `/private_6G36IXICr8K4HJv02SXU9OlE` remplacé par `/jarvis-mcp` (non-secret stable). HA UI add-on patché + Stop/Start, `.mcp.json` Cowork patché (1 occurrence L29), `~/.hermes/config.yaml` patché (1 occurrence L373, perms 600 préservées). Tests bout-en-bout : curl nouvelle URL → 405 ✅, ancienne URL → 404 ✅, `hermes mcp test ha-mcp` → ✓ Connected (951ms, 83 outils) ✅. CLI claude reste en `Failed to connect` (statu quo, bug `${env:VAR}` non interpolé dans headers — voir mini-tâche orthogonale ouverte sur les 3 skills CLI qui paraissent fonctionner malgré ce Failed). Reste à faire : Niveau 2a (IP allowlist) + Niveau 2b (rate limiting). Voir récit S112 pour détail.

> **Historique S109 (04/05/2026)** : 1ère tentative 1bis bloquée par leak Service Tokens dans le chat (workaround `claude mcp add` scope local affichait Service Tokens en clair via `claude mcp get`). Rollback complet, ouverture T#100 P0 rotation Service Tokens (closed S111), reprise propre S112.

# T#94 — Nettoyage path-token ha-mcp + Niveau 2a/2b CF Access

## Description

Suite directe de T#60 (résolution S102). Niveau 1 (path-token URL → headers Service Token CF Access) **acquis** bout-en-bout côté Cowork + Hermès. Reste 3 sous-objectifs pour boucler le durcissement complet :

### Niveau 1bis — Path-token cleanup ✅ ACQUIS S112

URL passée de `https://mcp.might.ovh/private_6G36IXICr8K4HJv02SXU9OlE` à `https://mcp.might.ovh/jarvis-mcp` (Option A retenue : path stable, non-secret, descriptif).

**Procédure 7 étapes capitalisées S112** :
1. Backups (`.mcp.json.bak.t94-1bis-pre-cleanup`, `~/.hermes/config.yaml.bak.t94-1bis-pre-cleanup`)
2. HA UI Apps → ha-mcp → Configuration → `secret_path: /jarvis-mcp` → SAVE → Stop+Start → vérif logs
3. Tests curl côté Cowork (PS) avec headers Service Tokens : nouvelle URL = 405, ancienne = 404
4. Patch `.mcp.json` via PowerShell `[System.IO.File]::WriteAllText(... UTF8Encoding($false))` (anti-piège BOM S108) — hook `check-secrets.sh` ne se déclenche pas car PS user-side, pas l'agent
5. Patch `~/.hermes/config.yaml` via `wsl bash -c "sed -i 's|...|...|g' ..."` — séparateur `|` au lieu de `/` pour éviter conflit avec URL
6. Tests bout-en-bout : `hermes mcp test ha-mcp` → ✓ Connected
7. Grep résiduels : 3 fichiers MAJ (`Cloudflare_Access_Ha-mcp.md` L48, `task_094.md` L13+L23, `.mcp.json` L37 commentaire `_cf_access_service_token`)

**À retenir** : la stratégie CF Access "HA MCP Service Token" exige les Service Tokens (HTTP 403 sans), donc le path-token n'était que `security-through-obscurity` et non une vraie auth. Sa suppression ne dégrade pas la posture sécu. Le path-token n'avait jamais bypassé CF Access (testé S112 avant cleanup : path seul sans headers = 403).

### Niveau 2a — IP allowlist

Limiter l'accès à l'app CF Access "mcp" uniquement aux IPs :
- IP publique PC Mickael (varie si IP fibre dynamique — vérifier)
- IP publique serveur Hermès (= même PC actuellement)

Procédure : Zero Trust → Settings → Network → Add IP allowlist OU Stratégie CF Access "Inclure" + sélecteur **IP**.

⚠ Si IP fibre Mickael est dynamique, prévoir mécanisme de fallback (ex range CIDR opérateur).

### Niveau 2b — Rate limiting

Cloudflare → Domaine `might.ovh` → Security → WAF → Rate limiting rules.
- Règle : `mcp.might.ovh/*` → max **100 req/min/IP**.
- Path à exclure : aucun (ha-mcp n'a pas de SSE long-running, OK pour limit).

---

## Pré-requis

- Mickael devant dashboard CF Zero Trust + dashboard CF DNS
- Session dédiée 30-45 min
- Backup `.mcp.json` + `~/.hermes/config.yaml` avant (déjà présents en `.bak.s100*`)
- IP publique PC connue (`curl ifconfig.me` ou Brave → whatismyip.com)

## Livrables attendus

- (a) Niveau 1bis ✅ S112 : URL `mcp.might.ovh/jarvis-mcp` — `.mcp.json` Cowork + `~/.hermes/config.yaml` Hermès patchés + tests bout-en-bout OK (curl 405/404, `hermes mcp test ha-mcp` ✓ Connected 951ms 83 outils)
- (b) Niveau 2a : IP allowlist active sur app CF Access "mcp" — `curl` depuis IP non-allowed = 403
- (c) Niveau 2b : rate limiting actif — script test `for i in {1..120}; do curl ...; done` retourne 429 après 100 req
- (d) MAJ `.mcp.json` + `~/.hermes/config.yaml` + skill `cloudflare-access-ha` Phase 7 + auto-memory `reference_cloudflare_service_token_pattern.md` + CLAUDE.md §6
- (e) Suppression backups `.bak.s100*` après 30j sans regression
- (f) Clôture T#60 + T#94 simultanée

---

## Liens

- Tâche source : [T#60](task_060.md)
- Snapshot S102 : [`memory/project_t60_cf_service_token_s100.md`](../memory/project_t60_cf_service_token_s100.md)
- Pattern réutilisable : [`memory/reference_cloudflare_service_token_pattern.md`](../memory/reference_cloudflare_service_token_pattern.md)
- Skill : [`.claude/skills/cloudflare-access-ha/SKILL.md`](../.claude/skills/cloudflare-access-ha/SKILL.md)
