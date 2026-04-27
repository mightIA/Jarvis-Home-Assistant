---
title: MCP HA — add-on ha-mcp + OAuth DCR
created: 2026-04-27
tags: [reseau, mcp, oauth, ha-mcp]
status: actif
domaine: Reseau
sources: [S15, S16, S17, S48, S53]
---

# MCP HA — add-on ha-mcp + OAuth DCR

## Contexte

Le `mcp_server` core de Home Assistant ne supporte **pas** le Dynamic
Client Registration (DCR — RFC 7591) requis par Cowork/Claude.ai
(auto-memory `feedback_mcp_server_core_no_dcr`). Diagnostic confirmé S15
(19/04/2026) après 4 bans IP et 6 tentatives de pairage.

**Bascule** : add-on communautaire `homeassistant-ai/ha-mcp` (FastMCP +
DCR natif) installé S15 (Phase 2), exposé HTTPS public S16 (Phase 3),
validé Cowork S17.

## Configuration

### Add-on installé

| Champ                | Valeur                                    |
|----------------------|-------------------------------------------|
| Repo                 | `https://github.com/homeassistant-ai/ha-mcp` |
| Version add-on       | **7.3.0** (stable, pas dev)               |
| Version ha-mcp       | 7.2.0                                     |
| FastMCP              | 3.2.3                                     |
| Hostname container   | `81f33d0f-ha-mcp`                         |
| Port                 | `9583/tcp`                                |
| Auth                 | Supervisor token (zero token utilisateur) |

### Endpoints

| Type     | URL                                                        |
|----------|------------------------------------------------------------|
| Local    | `http://192.168.1.11:9583/[REDACTED-SECRET]`               |
| Public   | `https://mcp.might.ovh/[REDACTED-SECRET]`                  |
| Transport| Streamable HTTP                                            |
| Auth     | OAuth DCR (zero-config) + secret_path (URL)                |

> Le **secret_path** est généré automatiquement par l'add-on (128 bits).
> Stocké côté add-on dans `/data/secret_path.txt`. Sa connaissance suffit
> à atteindre l'add-on (équivalent mot de passe d'URL).

### Configuration safe (onglet Configuration de l'add-on)

| Option                                          | Valeur |
|-------------------------------------------------|--------|
| Backup hint                                     | `normal` |
| Enable skills                                   | ON     |
| Enable skills as tools                          | ON     |
| Enable tool search                              | **ON** (depuis S53 — passe de 87→20 outils côté Hermès) |
| Toggle "options facultatives inutilisées"       | OFF (cache les 3 flags dangereux) |
| `HAMCP_ENABLE_FILESYSTEM_TOOLS`                 | **JAMAIS activer** |
| `ENABLE_YAML_CONFIG_EDITING`                    | **JAMAIS activer** |
| `HAMCP_ENABLE_CUSTOM_COMPONENT_INTEGRATION`     | **JAMAIS activer** |

### Exposition publique (Phase 3 — S16)

Voir [[Cloudflare_Setup]] pour le détail. Résumé :

1. Add-on Cloudflared → Configuration → Hôtes supplémentaires :
   `mcp.might.ovh` → `http://192.168.1.11:9583` (chunked encoding OFF)
2. CNAME manuel dans CF DNS : `mcp` → `<tunnel-id>.cfargotunnel.com` (proxied)
3. Stop + 5 s + Start de l'add-on Cloudflared (pas Restart)
4. Test sans trailing slash : `https://mcp.might.ovh/[REDACTED-SECRET]`
   → `HA-MCP server is up and running!`

### App CF Access (héritage avant ha-mcp)

L'app `HA MCP Server Bypass` (3 destinations consolidées) reste utile
pour le `mcp_server` core HA si jamais réactivé un jour. Pour `ha-mcp`
sur `mcp.might.ovh`, **pas de bypass nécessaire** (secret path = auth).

## Flow OAuth DCR

1. Cowork POST sur `https://mcp.might.ovh/[REDACTED-SECRET]/sse`
2. Add-on répond `401 + WWW-Authenticate: Bearer resource_metadata=...`
3. Cowork enregistre dynamiquement un client (DCR — RFC 7591) via
   `.well-known/oauth-protected-resource` puis `register`
4. Cowork récupère un token Bearer, retente la requête `/sse` avec
   le token → 200, session MCP établie

L'utilisateur n'a **rien à faire** côté Cowork/Claude.ai (zero token,
zero ID/secret OAuth — DCR gère tout).

## Pièges connus

- **Bug DCR mcp_server core** — issue [homeassistant-ai/ha-mcp#245](https://github.com/homeassistant-ai/ha-mcp/issues/245).
  Ne **JAMAIS** retenter le mcp_server core avec Cowork/Claude.ai.
  Auto-memory `feedback_mcp_server_core_no_dcr`.
- **Bans IP HA pendant pairage en boucle** : range Anthropic outbound
  `160.79.104.0/21`. Penser à `ip_ban_enabled: false` temporairement
  pendant le debug (à retabir après).
- **Trailing slash** : `https://mcp.might.ovh/[REDACTED-SECRET]/` → 404.
  Toujours sans slash final.
- **3 feature flags dangereux** OFF par défaut, **jamais** activer sans
  accord explicite Mickael (modifient la sandbox MCP).
- **Régénération secret_path** : procédure transposable en 6 étapes
  (auto-memory `reference_ha_mcp_secret_regeneration`). Synchroniser
  21 surfaces : `.mcp.json`, config Hermès, auto-memories, dashboards.
- **`enable_tool_search: true`** (S53) : passe de 87 outils à 20 côté
  Hermès, compatible Anthropic deferred tools. Côté Cowork : reconfigurer
  le connecteur après toggle. Sauvegarde HA pré-toggle indispensable.
- **Secret_path S48 jamais appliqué** : la régénération documentée S48
  (`[REDACTED-PREFIX]`) **n'a pas** été appliquée côté add-on. Le vrai
  secret actif reste celui historique. 21 surfaces désynchronisées
  (auto-memory `feedback_secret_path_s48_jamais_applique`).

## Liens internes

- [[Cloudflare_Setup]] — exposition tunnel + DNS
- [[../Outils/HA MCP add-on]] — fiche skill détaillée
- [[../HomeAssistant/Apps installées]] — add-on dans l'inventaire
- ADR à créer : choix add-on ha-mcp vs mcp_server core (bug DCR)
- ADR à créer : `enable_tool_search: ON` vs OFF

## Sources

- `memory/historique/2026-04-19_session_15_pivot_ha_mcp_dcr.md` (diagnostic + install)
- `memory/historique/2026-04-19_session_16_phase3_expo_mcp.md` (expo HTTPS)
- `memory/historique/2026-04-20_session_17_install_cli_validation_mcp.md` (validation finale)
- `memory/historique/2026-04-25_session_48_phase1bisc_cloture.md` (régénération secret_path)
- `memory/historique/2026-04-26_session_53_phase1bisd_b1_enable_tool_search.md` (toggle activé)
- `.claude/skills/ha-mcp-install/SKILL.md`
- Auto-memory `reference_ha_mcp_addon`, `reference_ha_mcp_endpoint_validated`,
  `feedback_mcp_server_core_no_dcr`, `reference_ha_enable_tool_search_active`,
  `reference_ha_mcp_secret_regeneration`
