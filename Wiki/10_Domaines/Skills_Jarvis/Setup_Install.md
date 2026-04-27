---
title: Skills Setup & Installation
created: 2026-04-27
tags: [skill, setup, installation]
status: actif
domaine: Skills_Jarvis
---

# Skills Setup & Installation

Catégorie regroupant les 3 skills de **procédures d'installation** (poste Mickael, add-on HA, exposition publique sécurisée).

## Skills incluses

### `install-claude-code-windows`

- **Déclencheur** :
  - Mickael demande à installer Claude Code ou Python
  - Erreurs : "claude n'est pas reconnu", "npm n'est pas reconnu", "git-bash required", "python n'est pas reconnu"
  - Problèmes ExecutionPolicy PowerShell
  - Scripts Python des skills qui échouent
- **Rôle** : installer Node.js + Git Bash + Claude Code CLI + Python sur Windows 11.
- **Dépendances** :
  - PowerShell (admin pour ExecutionPolicy)
  - Dossier cible : `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant`
  - Script `scripts/install-claude-code.ps1` (install natif PATH utilisateur)
  - Protocole backup : `Ressources/Protocoles/Backup_Jarvis.md` (OneDrive + Git privé)
- **Détail exécutable** : `.claude/skills/install-claude-code-windows/SKILL.md`
- **Auto-memory** : `reference_install_claude_code_windows`

### `ha-mcp-install`

- **Déclencheur** :
  - Mickael veut connecter Cowork/Claude.ai à HA via MCP
  - Pairage du `mcp_server` core HA échoue avec erreurs `ofid_*` malgré bypass CF
  - Bug DCR core HA confirmé (cf. auto-memory `feedback_mcp_server_core_no_dcr`)
- **Rôle** : installer l'add-on `homeassistant-ai/ha-mcp` (FastMCP avec DCR) en remplacement du `mcp_server` core HA qui ne supporte pas le Dynamic Client Registration.
- **Dépendances** :
  - HA UI → Apps → ⋮ Dépôts → ajout `homeassistant-ai/ha-mcp`
  - Flags safety OFF par défaut (dangereux)
  - Récupération du `secret_path` depuis options de l'add-on
  - Plan d'expo HTTPS publique (Cloudflare Tunnel) — Phase 3 réécrite et VALIDÉE S16
- **Détail exécutable** : `.claude/skills/ha-mcp-install/SKILL.md`
- **Liens vault** : [[Wiki/10_Domaines/Reseau_Securite/_Index]], [[Cloudflare_Access_HA]]
- **Auto-memory** : `reference_ha_mcp_addon`, `reference_ha_mcp_endpoint_validated`, `reference_ha_mcp_secret_regeneration`

### `cloudflare-access-ha`

- **Déclencheur** :
  - Mickael veut exposer une nouvelle instance HA via un domaine Cloudflare
  - Duplication de la config pour une autre maison ou un ami
  - Reconfiguration après migration ou reset Cloudflare
- **Rôle** : configuration Cloudflare complète (DNS + SSL/TLS + HSTS + Access Zero Trust) pour protéger une instance HA exposée sur internet, **avec bypass CF Access sur l'endpoint MCP** pour permettre l'appairage Cowork/Claude via OAuth 2.0 natif HA.
- **Dépendances** :
  - Compte Cloudflare + domaine (ex. `might.ovh`)
  - Tunnel Cloudflare (cloudflared) côté HA
  - Application Access Zero Trust pour le dashboard HA
  - **Bypass + Everyone** sur l'endpoint MCP (jamais Allow+MFA — cf. auto-memory `feedback_cf_mcp_bypass_not_allow`)
  - Testée sur `might.ovh` / `ha.might.ovh` le 19/04/2026
- **Détail exécutable** : `.claude/skills/cloudflare-access-ha/SKILL.md`
- **Liens vault** : [[Wiki/10_Domaines/Reseau_Securite/_Index]]
- **Auto-memory** : `reference_ui_nav_map`

## Patterns d'usage transversaux

### Sandbox Cowork ne charge PAS les MCP stdio (S26)

`.mcp.json` stdio (ex. `gmail-mcp-local`) n'est lu que par Claude Code CLI. Toute skill qui en a besoin = pattern brain(Cowork) + hands(CLI). Cf. auto-memory `feedback_cowork_no_stdio`.

### Sandbox Cowork bash bloque les opérations Git (S42)

Le sandbox Linux Cowork ne peut ni écrire dans `.git/` ni lire un `.git/config` créé par PowerShell. Toutes les commandes git passent par PowerShell côté Mickael (pattern brain+hands). Cf. auto-memory `feedback_git_sandbox_cowork_bloque`.

### Sortie réseau OFF dans la sandbox Cowork (S27)

Pas de `pip install` / `npm install` dans le sandbox. Cf. auto-memory `reference_cowork_capacites`.

### Connexion fibre Mickael ~100 MB/s (S48)

Pour estimations de pull/install/clone : 1 Go ≈ 10s, 10 Go ≈ 1 min 30, 20 Go ≈ 3 min, 50 Go ≈ 8 min. Ne plus prédire "10-15 min pour 20 Go". Cf. auto-memory `reference_mickael_connexion_fibre`.

### PS 5.1 exige BOM UTF-8 (S31)

Tout `.ps1` avec caractères non-ASCII DOIT avoir un BOM UTF-8, sinon PS 5.1 lit en CP1252 et casse les here-strings. `Tee-Object -Encoding` n'existe qu'en PS 7+. Utiliser `Out-File -Encoding UTF8` si encodage critique.

## Voir aussi

- [[_Index]] — MOC Skills Jarvis
- [[Wiki/10_Domaines/Reseau_Securite/_Index]] — domaine Réseau & Sécurité
- [[Wiki/10_Domaines/Procedures_Rares/_Index]] — procédures rares (rotation secret_path, débans)
- `Ressources/Protocoles/Backup_Jarvis.md` — protocole de sauvegarde
- `scripts/install-claude-code.ps1` — script d'install
