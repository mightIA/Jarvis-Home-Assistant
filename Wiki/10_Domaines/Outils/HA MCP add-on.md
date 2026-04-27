---
title: HA MCP add-on (homeassistant-ai/ha-mcp)
created: 2026-04-25
tags: [outils/ha-mcp, ha/integration, mcp]
parent: "[[_Index]]"
status: actif
---

# HA MCP add-on — skill `ha-mcp-install`

Add-on `homeassistant-ai/ha-mcp` (FastMCP avec DCR) installé en
remplacement du MCP Server core HA, qui ne supporte pas le **Dynamic
Client Registration** (RFC 7591) requis par Claude.ai/Cowork (cf
auto-memory `feedback_mcp_server_core_no_dcr`).

## Quand cette skill est déclenchée

- Pairage Cowork/Claude.ai → HA via MCP qui échoue avec erreurs
  `ofid_*` malgré bypass CF Access correct.
- Diagnostic confirme bug DCR côté `mcp_server` core (issue GitHub
  homeassistant-ai/ha-mcp#245).

## Versions de référence (S15 — 19/04/2026)

- Add-on ha-mcp : **7.3.0**
- ha-mcp Python module : **7.2.0**
- FastMCP : **3.2.3**
- Hostname container : `81f33d0f-ha-mcp`
- Port : `9583/tcp`
- Auth : Supervisor token (zero token côté utilisateur)

## Phase 1 — Pré-bascule

1. **Sauvegarde HA complète** (Paramètres > Système > Sauvegardes).
2. Vérifier `ip_bans.yaml` vide (sinon `[[Debannissement IP]]`).
3. Désactiver journal de débogage du `mcp_server` core.
4. Supprimer anciens connecteurs Cowork/Claude.ai (tokens stale).
5. **Garder l'app CF Access `HA MCP Server Bypass`** existante (réutilisée Phase 3).

## Phase 2 — Installation

### Repo custom

HA → **Paramètres > Apps** (icône puzzle jaune) → **Installer
l'application** → ⋮ **Dépôts** → coller :

```
https://github.com/homeassistant-ai/ha-mcp
```

→ + Ajouter → Fermer.

### Installer la version stable

Boutique Apps → section **Home Assistant MCP Server** :

- **`Home Assistant MCP Server`** (sans badge) — **STABLE — installer celle-ci** ✅
- `Home Assistant MCP ... Expérimentale` — **NE PAS installer** ❌

### Configuration safe

Onglet **Configuration** :

- Backup hint : `normal` ✅
- Enable skills : ON ✅
- Enable skills as tools : ON ✅
- Enable tool search : OFF ✅
- **Toggle "options facultatives inutilisées" : OFF** ✅ — cache les
  3 flags dangereux qui restent désactivés par défaut :
  - `HAMCP_ENABLE_FILESYSTEM_TOOLS` — **JAMAIS activer**
  - `ENABLE_YAML_CONFIG_EDITING` — **JAMAIS activer**
  - `HAMCP_ENABLE_CUSTOM_COMPONENT_INTEGRATION` — **JAMAIS activer**

### Démarrage

Onglet **Informations** → toggles **Lancer au démarrage** ON, **Chien
de garde** ON. Démarrer. Onglet **Journaux** → attendre :

```
🔒 MCP Server URL: http://<ip>:9583/private_XXXXXXXXXXXXXXXXXX
   Secret Path: /private_XXXXXXXXXXXXXXXXXX
```

Sauvegarder le secret path (généré 128-bit, sert d'auth zero-config OAuth).

## Phase 3 — Expo HTTPS publique (validée S16, Option A Cloudflare Tunnel)

⚠️ **NE JAMAIS utiliser** la procédure officielle CF "Networks > Tunnels >
Migration" sur un tunnel local (add-on Cloudflared HA) — irréversible.
Toute config passe par l'add-on HA, le DNS par dashboard CF classique.

### 3.1 — Hôtes supplémentaires

HA → **Paramètres > Apps > Cloudflared > Configuration**.
Section **Hôtes supplémentaires** → Ajouter :

- **hostname** : `mcp.might.ovh`
- **service** : `http://192.168.1.11:9583`
- `disableChunkedEncoding` : **OFF** (important pour streaming MCP).

⚠️ Cliquer **Enregistrer** sur la page Configuration (sinon saisie perdue).

### 3.2 — CNAME DNS manuel dans Cloudflare

L'add-on CF HA crée le DNS auto **uniquement** pour le hostname
principal, **PAS** pour les `additional_hosts`.

1. Récupérer **tunnel ID** dans logs add-on :
   `Starting tunnel tunnelID=e37fbcdc-7943-4bdc-9990-36cce788fe20`
2. [dash.cloudflare.com](https://dash.cloudflare.com/) → domaine
   `might.ovh` → **Enregistrements DNS**.
3. + Ajouter :
   - Type : `CNAME`
   - Nom : `mcp`
   - Cible : `<tunnel-id>.cfargotunnel.com`
   - Proxy : **Proxied** (nuage orange ON)
4. Enregistrer.

### 3.3 — Recharger Cloudflared (STOP + START)

⚠️ Un simple "Redémarrer" **ne recharge pas** toujours proprement.

1. Onglet Informations Cloudflared → **Arrêter**.
2. Attendre 5 s.
3. **Démarrer**.
4. Vérifier journaux : `Registered tunnel connection`.

### 3.4 — Test (sans trailing slash)

⚠️ L'add-on retourne 404 si l'URL se termine par `/`.

[https://mcp.might.ovh/[REDACTED-SECRET]](https://mcp.might.ovh/[REDACTED-SECRET])

→ Réponse attendue : `HA-MCP server is up and running!` + 6 étapes
instructions Cloudflare Users.

**Aucun bypass CF Access à ajouter** sur `mcp.might.ovh` (l'add-on
utilise son propre secret path comme auth).

## Phase 4 — Connexion Cowork

claude.ai → Settings > Connecteurs > **+ Ajouter un connecteur
personnalisé** :

- Nom : `Jarvis HA Add-on`
- URL : `https://mcp.might.ovh/<secret_path>`

Pairage DCR/OAuth automatique.

## Coexistence avec mcp_server core

Le `mcp_server` core HA continue d'exister après install ha-mcp.
Cowork utilise uniquement l'add-on. Le core reste inutilisé pour Cowork
— peut être désinstallé pour propreté.

## Liens

- Skill source : `.claude/skills/ha-mcp-install/SKILL.md`
- Repo : https://github.com/homeassistant-ai/ha-mcp
- Doc complète : https://homeassistant-ai.github.io/ha-mcp/
- Issue DCR : https://github.com/homeassistant-ai/ha-mcp/issues/245
- Hub HA : `[[10_Domaines/HomeAssistant/_Index]]`
- Hub Cloudflare : `[[10_Domaines/Cloudflare/_Index]]`
