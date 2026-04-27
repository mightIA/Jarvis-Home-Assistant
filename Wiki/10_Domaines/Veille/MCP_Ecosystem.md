---
title: MCP ecosystem
created: 2026-04-27
tags: [veille, mcp, ecosystem, anthropic]
status: actif
---

# MCP Ecosystem — etat avril 2026

Inventaire des serveurs MCP (Model Context Protocol) actifs ou pertinents
pour le projet Jarvis. Le protocole MCP est une creation Anthropic qui
devient le standard de fait pour les agents.

A rafraichir trimestriellement ou sur signalement nouveau MCP utile.

## MCP installes / utilises Jarvis

### Officiels Anthropic / Cowork

| MCP | Type | Usage Jarvis | Statut |
|---|---|---|---|
| **Gmail** (lecture + drafts + labels) | OAuth web | Tri auto Gmail (Cowork web) | ACTIF |
| **Google Calendar** | OAuth web | Optionnel, non active | DISPONIBLE |
| **Google Drive** | OAuth web | Connecte S23 | ACTIF |
| **Claude in Chrome** | Bureau | Workflows Brave (Outlook, dashboards) | ACTIF |
| **GitHub** (Cowork natif) | OAuth | Compte mightIA, App Claude installee S39 | ACTIF |

### Communautaires installes

| MCP | URL repo | Type | Usage Jarvis | Statut |
|---|---|---|---|---|
| **homeassistant-ai/ha-mcp** | https://github.com/homeassistant-ai/ha-mcp | HTTP (add-on HA) | 80+ outils `ha_*` pour pilotage HA. Add-on installe v7.3.0+. | ACTIF, expose via CF Tunnel |
| **GongRzhe/Gmail-MCP-Server** | https://github.com/GongRzhe/Gmail-MCP-Server | stdio | Ecriture Gmail (modify_email, batch_modify, create_label, create_filter). Cowork ne charge pas stdio -> CLI uniquement. | ACTIF (CLI) |
| **PDF Tools (pdf-toolkit)** | Open Document Alliance | bundle | 21 outils + 14 invites. Lecture, fill_pdf AcroForm, merge, split. | ACTIF |

### Officiels par editeur

| MCP | Repo | Note |
|---|---|---|
| **github/github-mcp-server** | https://github.com/github/github-mcp-server | Distinct du connecteur Cowork natif "Integration GitHub". Bouton Install propose VS Code uniquement. Voie install Cowork a explorer. |
| **modelcontextprotocol** servers officiels | https://github.com/modelcontextprotocol/servers | Catalogue Anthropic — filesystem, fetch, sqlite, etc. |

## Decouvertes a evaluer

| MCP | Source | Interet | A explorer |
|---|---|---|---|
| github.com/mcp registry | Catalogue public | Trouver nouveaux serveurs MCP (decouverte S40) | Quand besoin specifique |
| MCP Outlook officiel | Non existant a date | Permettrait de remplacer le workflow Brave + Claude in Chrome pour Outlook | Cf. tache #48 |
| Telegram gateway Hermes | https://hermes-agent.nousresearch.com/docs/integrations/gateways | Phase 2 architecture mobile (auto-memory `project_hermes_agent_phase1bis`) | Phase 2 Hermes |

## Pieges connus

- **Cowork ne charge PAS les MCP stdio** (auto-memory `feedback_cowork_no_stdio`).
  Le `.mcp.json` stdio est lu uniquement par Claude Code CLI. Toute skill
  utilisant `modify_email`, `batch_*` doit tourner en CLI.
- **DCR core HA `mcp_server` casse** (auto-memory `feedback_mcp_server_core_no_dcr`).
  Le MCP server core HA ne supporte pas DCR (RFC 7591). Solution :
  add-on `homeassistant-ai/ha-mcp` (FastMCP+DCR) avec bypass MFA Cloudflare.
- **gmail-mcp-local `list_filters` bug** (auto-memory `feedback_gmail_mcp_list_filters_bug`).
  `create_filter` OK mais `list_filters` renvoie vide. Toujours verifier
  UI Gmail web avant de retenter (risque doublons).
- **`enable_tool_search: true`** sur add-on ha-mcp passe de 87 a 20 outils
  exposes. Necessaire pour modeles <= 14B, optionnel pour modeles 27-32B.
  Compatible Anthropic deferred tools (cf. auto-memory
  `reference_ha_enable_tool_search_active`).
- **secret_path add-on ha-mcp** = mot de passe deguise. Regeneration
  documentee en 6 etapes (auto-memory `reference_ha_mcp_secret_regeneration`).
  21 surfaces a patcher en parallele.

## Convention MCP Hermes

Config dans `~/.hermes/config.yaml` :

```yaml
mcp_servers:
  ha-mcp:
    type: http
    url: https://<your-domain>/<SECRET_PATH>
```

Pieges Hermes :
- `hermes mcp add` ne persiste pas la config (cf. troubleshooting Symptome 9).
  Edition manuelle yaml obligatoire.
- Banner Hermes affiche le nombre de tools detectes au demarrage. Si
  `enable_tool_search: true` cote add-on, banner affiche 20 (au lieu de 87).

## Sources

- Cookbook RTX 3090 — `Projets/Cookbook_Hermes_RTX3090/docs/configs.md` §3 et §5.
- Sessions S15, S16 (install ha-mcp), S25-S27 (Gmail MCP custom),
  S33 (organisation Projets/Runtime), S35 (PDF Tools), S40 (registry MCP).
- Auto-memories `reference_ha_mcp_addon`, `reference_ha_mcp_endpoint_validated`,
  `reference_pdf_tools_mcp`, `reference_cowork_connectors_active`,
  `reference_github_mcp_registry`.

## Liens externes

- Specification MCP : https://modelcontextprotocol.io/
- Registry public MCP : https://github.com/mcp
- Hermes Agent providers + gateways :
  https://hermes-agent.nousresearch.com/docs/integrations/

## Liens internes

- [[_Index]] — Hub Veille
- [[Provider_Benchmarks]]
- [[Landscape_LLM_2026]]
