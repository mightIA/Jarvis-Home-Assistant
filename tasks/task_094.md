---
id: 94
title: "Nettoyage path-token ha-mcp + Niveau 2a/2b CF Access (suite T#60)"
status: open
priority: P3
session_opened: S102
tags: [ha-mcp, cloudflare, service-token, mcp, security]
source: "Suite T#60 résolution S102 — Niveau 1 acquis (Service Token actif Cowork+Hermès), reste path-token cleanup + Niveau 2a/2b"
---

# T#94 — Nettoyage path-token ha-mcp + Niveau 2a/2b CF Access

## Description

Suite directe de T#60 (résolution S102). Niveau 1 (path-token URL → headers Service Token CF Access) **acquis** bout-en-bout côté Cowork + Hermès. Reste 3 sous-objectifs pour boucler le durcissement complet :

### Niveau 1bis — Path-token cleanup

L'URL actuelle `https://mcp.might.ovh/private_6G36IXICr8K4HJv02SXU9OlE` conserve le secret_path comme défense en profondeur. Pour vraiment éliminer le path-token (objectif T#60 livrable b non atteint), 2 options :

| Option | Action | Avantage | Inconvénient |
|---|---|---|---|
| **A** | Régénérer secret_path ha-mcp en valeur **stable non-secret** (ex `/jarvis-mcp`) | Path lisible, plus de secret en clair en URL | Garde un path à maintenir |
| **B** | Désactiver entièrement secret_path côté add-on ha-mcp (si supporté) | URL nue `https://mcp.might.ovh` | À investiguer si l'add-on accepte (regarder `Runtime/ha-mcp/options.yaml` ou doc upstream) |

**Recommandation** : Option A. Path-token devient `/jarvis-mcp` (non-secret, descriptif). 1 commit Cowork + Hermès.

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

- (a) Niveau 1bis : URL `mcp.might.ovh/jarvis-mcp` (ou nue) — `.mcp.json` Cowork + `~/.hermes/config.yaml` Hermès patchés + tests bout-en-bout OK
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
