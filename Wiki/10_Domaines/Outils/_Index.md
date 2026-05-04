---
title: Outils & productivité — Hub
created: 2026-04-25
updated: 2026-05-02
tags: [moc, hub, outils]
parent: "[[00_Index/_Index]]"
status: actif
---

# Outils & productivité

Hub central des skills techniques transverses Jarvis qui ne sont pas
spécifiques à la domotique, à l'email, à la traduction ou à la vie perso.
Couvre la **mécanique du travail** : navigation HA, environnement Claude
Code, debannissement IP.

> **Règle 0 — Données sensibles** : avant tout accès à un mot de passe,
> token, ou donnée perçue comme sensible (session Windows, HA, sites web,
> API), Jarvis s'arrête, décrit ce qui serait vu, propose à Mickael de le
> faire lui-même, et n'agit que sous accord explicite. Exception unique :
> `ip_bans.yaml` (cf `[[Debannissement IP]]`).

## Atomes du domaine

- `[[Browser Mod]]` — contrôle navigateur HA via thomasloven/hass-browser_mod
- `[[Debannissement IP]]` — 3 méthodes (SSH local, File editor distant, MCP fallback)
- `[[Install Claude Code]]` — env dev Windows complet (Node + Git + CC + Python)
- `[[HA MCP add-on]]` — install homeassistant-ai/ha-mcp + expo CF Tunnel

> **Note S84 (2026-05-02)** : les atomes `[[Bascule conversation]]` et
> `[[Guidage photo etape]]` ont été retirés suite à la suppression des skills
> `bascule-conversation` et `guidage-photo-etape` (T#24 cancelled —
> obsolètes depuis mode PC permanent S24). Le mode pas-à-pas reste régi par
> la **règle pas-à-pas** (CLAUDE.md §4, S53).

## Skills NON migrées dans ce hub

Pour éviter les doublons, les skills techniques HA-spécifiques sont
déjà couvertes dans `[[10_Domaines/HomeAssistant/_Index]]` :

- `ha-status`, `ha-scripts`, `cameras-dahua`, `chaudiere-frisquet`,
  `dyson-purifier`, `home-assistant-best-practices`, `home-assistant-manager`,
  `lovelace-edit`, `yaml-automation`.
- `cloudflare-access-ha` → couvert dans `[[10_Domaines/Cloudflare/_Index]]`.
- Les 4 skills email (`tri-email-gmail`, `tri-email-outlook`,
  `tri-email-outlook-priorites`, `redaction-email`) → couvertes dans
  `[[10_Domaines/Email/_Index]]`.
- La skill `traduction` → couverte dans `[[10_Domaines/Traduction/_Index]]`.
- Les skills de clôture (`session-closure`) restent au niveau projet
  (cf `CLAUDE.md` section 8).

## Règles transverses outils

- **Mode Cowork par défaut** : Jarvis suppose toujours qu'il est en
  Cowork (Read/Edit/Write/Bash + MCP + skills + mémoire dispo). Bascule
  fallback Claude.ai uniquement si lecture fichier échoue ou Mickael le
  signale (cf `CLAUDE.md` §0-bis + auto-memory `feedback_cowork_default_mode`).
- **Navigation détaillée au switch d'apps** : quand Mickael jongle entre
  GCP/HA/Gmail/CF sur iPhone, redonner le chemin complet depuis racine,
  pas juste le nom de section (auto-memory `feedback_navigation_details_switch_apps`).
- **Texte à copier → bloc triple backtick** (bouton copier), URL à ouvrir
  → lien markdown `[texte](url)` cliquable, jamais en inline code
  (auto-memories `feedback_copy_paste_code_blocks` + `feedback_clickable_urls`).
- **2-3 erreurs 401/403 consécutives sur HA = arrêt + vérifier ban IP**
  (`[[Debannissement IP]]`). Pas d'auto-retry.

## Liens externes

- `Ressources/Protocoles/IP_Bans.md` — procédure officielle IP bans
- `Ressources/Protocoles/Backup_Jarvis.md` — backup OneDrive + Git privé
- `Ressources/Competences/Claude_Code_Aide_Memoire.md` — slash commands utiles
- `[[10_Domaines/HomeAssistant/_Index]]` — hub Home Assistant
- `[[10_Domaines/Cloudflare/_Index]]` — hub Cloudflare

## Tags

`#outils/browser-mod` `#outils/debannissement` `#outils/claude-code`
`#outils/ha-mcp`
