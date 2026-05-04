---
title: Cloudflare — Setup complet (Tunnel, DNS, Access, bypass MCP)
created: 2026-04-27
updated: 2026-04-27
tags: [atome, reseau, cloudflare, tunnel, dns, access]
status: actif
domaine: Reseau
sources: [S08, S15, S16, S17]
---

# Cloudflare — Setup complet

## Contexte

L'instance HA de Mickael (`http://192.168.1.11:2096`) est exposée
publiquement via Cloudflare en deux flux distincts :

1. **`ha.might.ovh`** — dashboard web HA (humain), protégé par CF Access
   `Allow + Email Mickael + MFA TOTP` via app `Might-HA`.
2. **`mcp.might.ovh/<secret>`** — endpoint MCP add-on `ha-mcp` (machine,
   Cowork/Hermès), en **Bypass + Everyone** (auto-memory
   `feedback_cf_mcp_bypass_not_allow`).

L'add-on HA **Cloudflared** (Tobia Brenner — `brenner-tobias/ha-addons`)
gère le tunnel local. Le dashboard CF gère le DNS + les apps Access.

## Configuration

### 1. Tunnel Cloudflared (add-on HA)

- Tunnel : `homeassistant` (type cloudflared, géré localement par l'add-on)
- Hostname principal : `ha.might.ovh` → `http://192.168.1.11:2096`
- Hôte supplémentaire : `mcp.might.ovh` → `http://192.168.1.11:9583`
- ⚠️ `disableChunkedEncoding: OFF` pour `mcp.might.ovh` (streaming MCP)
- ⚠️ Toujours **Stop + 5 s + Start** après modif (pas Restart)

### 2. DNS Cloudflare classique

L'add-on Cloudflared **ne crée le DNS auto que pour le hostname principal**.
Tout `additional_hosts` nécessite un CNAME manuel :

- Type : `CNAME`
- Nom : `mcp` (par exemple)
- Cible : `<tunnel-id>.cfargotunnel.com`
- Proxy : **Proxied** (nuage orange ON)

Tunnel ID récupérable dans les logs add-on :
`Starting tunnel tunnelID=<uuid>` (ID actuel S15-S16 documenté dans
[[../Cloudflare/_Index]]).

### 3. SSL/TLS Edge Certificates (FAIT S19)

| Réglage              | Valeur                |
|----------------------|-----------------------|
| Always Use HTTPS     | ON                    |
| Minimum TLS Version  | TLS 1.2               |
| HSTS                 | max-age 6 mois        |
| includeSubDomains    | OFF (prudent)         |
| Preload              | OFF                   |
| No-sniff header      | ON                    |

Détails : [[MFA_HSTS_HTTPS]].

### 4. Apps Access

#### App `Might-HA` (dashboard humain)

- Type : Self-hosted
- Domaine : `ha.might.ovh`
- Politique : **Allow + Email Mickael + MFA TOTP**
- Activée 19/04/2026 (S15 matin)

#### App `HA MCP Server Bypass` (machine — créée S15, consolidée S15)

- Type : Self-hosted
- Politique : **Bypass + Everyone** (3 destinations consolidées) :
  - `ha.might.ovh/mcp_server`
  - `ha.might.ovh/auth/*`
  - `ha.might.ovh/.well-known/*`
- Limite CF : 5 destinations max par app → 2 slots libres
- Couvre : OAuth authorize + token + revoke + 2 OAuth discovery

> Note S15 : la consolidation 5→3 a été motivée par l'ajout de
> `auth/revoke` initialement manquant. Plus résilient, plus simple.

### 5. Pas de bypass sur `mcp.might.ovh`

Le sous-domaine `mcp.might.ovh` n'a **aucune** app CF Access. L'add-on
`ha-mcp` utilise son propre **secret path** comme authentification
zero-config (équivalent à un mot de passe d'URL).

## Pièges connus

- **Tunnel local — JAMAIS cliquer "Migrer"** dans CF Zero Trust Networks
  > Tunnels : action irréversible qui détache le tunnel de l'add-on HA.
- **additional_hosts ne crée PAS de DNS auto** : CNAME manuel obligatoire.
- **Type DNS "Tunnel" introuvable** dans le dropdown UI : utiliser
  CNAME + cible `<tunnel-id>.cfargotunnel.com`.
- **Stop + Start > Restart** : un simple Redémarrer ne recharge pas
  toujours proprement la config additional_hosts.
- **Trailing slash** : `https://mcp.might.ovh/<secret>/` retourne 404.
  Toujours sans slash final (FastMCP/Uvicorn sensibles).
- **Limite 5 destinations bypass / app** : consolider en wildcards
  larges plutôt que paths spécifiques (cf. consolidation S15).
- **Cowork n'enchaîne pas le SSO CF Access** : ne jamais mettre
  Allow+MFA sur un endpoint MCP, toujours Bypass+Everyone
  (auto-memory `feedback_cf_mcp_bypass_not_allow`).

## Liens internes

- [[MFA_HSTS_HTTPS]] — détails HSTS + TLS minimum + headers
- [[CSP_Audit_Securite]] — Content-Security-Policy déployée via CF Transform Rules
- [[MCP_HA_OAuth]] — add-on ha-mcp + flow OAuth DCR
- [[../Cloudflare/_Index|Hub Cloudflare]] — vue synthétique apps + tunnels

## Sources

- `memory/historique/2026-04-19_session_15_pivot_ha_mcp_dcr.md` (Phase F : consolidation 5→3)
- `memory/historique/2026-04-19_session_16_phase3_expo_mcp.md` (Phase 3 : tunnel + DNS + pièges)
- `memory/historique/2026-04-20_session_17_install_cli_validation_mcp.md` (validation finale)
- `memory/historique/2026-04-19_session_08_securite_HSTS_MCP.md` (Phase 1 setup HSTS/TLS)
- `Ressources/Competences/Home_Assistant_Inventaire.md` §6
- `.claude/skills/cloudflare-access-ha/SKILL.md`
