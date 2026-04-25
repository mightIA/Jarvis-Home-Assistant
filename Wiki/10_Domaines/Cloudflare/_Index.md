---
title: Cloudflare — Index du domaine
created: 2026-04-25
tags: [moc, reseau/cloudflare]
status: actif
source: Ressources/Competences/Home_Assistant_Inventaire.md §6 + Ressources/Competences/Home_Assistant.md
---

# Cloudflare — Index du domaine

Tout ce qui concerne la protection Cloudflare de l'instance Home Assistant
de Mickael : Access apps, Tunnels, HSTS, MFA.

## Domaines protégés

| Domaine | Protection | Rôle |
|---|---|---|
| `ha.might.ovh` | CF Access (Allow + Email + MFA) via app `Might-HA` | Dashboard HA distant |
| `mcp.might.ovh/<secret>` | **Bypass + Everyone** via app `HA MCP Server Bypass` | Endpoint MCP add-on `ha-mcp` |
| `ha.might.ovh/auth/*` | **Bypass + Everyone** | OAuth authorize + token + revoke |
| `ha.might.ovh/.well-known/*` | **Bypass + Everyone** | OAuth discovery (2 endpoints) |

## App `Might-HA` (dashboard web)

- Type : SaaS / Self-hosted
- Politique : **Allow + Email Mickael + MFA TOTP**
- Activée 19/04/2026 (S15 matin)

## App `HA MCP Server Bypass` (créée S15)

- Type : Self-hosted
- Politique : **Bypass + Everyone** (3 destinations)
  - `ha.might.ovh/mcp_server`
  - `ha.might.ovh/auth/*`
  - `ha.might.ovh/.well-known/*`
- ⚠️ Limite : **5 destinations max par app** → 2 slots libres
- ⚠️ Règle : MCP HA toujours **Bypass + Everyone**, jamais Allow + MFA
  (Cowork n'enchaîne pas le SSO CF — auto-memory `feedback_cf_mcp_bypass_not_allow`)

## Tunnel Cloudflared

- Add-on HA : **Cloudflared** (Tobia Brenner — `brenner-tobias/ha-addons`)
- Tunnel actif : `mcp.might.ovh` → exposition publique de l'add-on `ha-mcp`
  (port 9583, secret path `/private_Q49aOxbSlqkilVOMVrlE4g`)
- ⚠️ **Pas de slash final** sur l'URL MCP : `base + /` → 307 redirect vers
  `http://` (bug tunnel CF, déjà noté S16)

## Sécurité HTTPS

| Réglage | Valeur |
|---|---|
| HSTS | `max-age=15768000` (6 mois), `includeSubDomains` actif |
| TLS minimum | 1.2+ |
| `X-Content-Type-Options` | `nosniff` ON |
| Activé | 19/04/2026 (S15) |

## MFA HA (compte Mickael)

- TOTP actif depuis 19/04/2026 matin (S15)
- ⚠️ HA n'a **pas** de module « codes de secours » → sauvegarder la
  chaîne base32 sous le QR (auto-memory `feedback_ha_totp_no_backup_codes`)

## IP Bans HA

- Défaut : `ip_ban_enabled: true` + seuil 5 échecs consécutifs
- Temporairement désactivé pendant les tests `ha-mcp` S15 :
  ```yaml
  http:
    ip_ban_enabled: false
    login_attempts_threshold: -1
  ```
- À réactiver après stabilisation Mode Réactif Phase 2

## Notes liées

- [[../HomeAssistant/Connexion et accès]] — URLs locale/distante
- [[../HomeAssistant/Débannissement IP]] — quand le ban revient
- [[../HomeAssistant/Apps installées]] — add-on Cloudflared
- Skill : `.claude/skills/cloudflare-access-ha/`
- Auto-memory : `reference_ha_mcp_endpoint_validated`, `reference_ha_mcp_addon`

---

*Source : `Ressources/Competences/Home_Assistant_Inventaire.md` §6 + footer CLAUDE.md S15-S20.*
