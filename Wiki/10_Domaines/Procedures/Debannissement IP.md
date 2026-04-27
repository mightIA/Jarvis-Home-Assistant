---
title: Debannissement IP
created: 2026-04-27
tags: [procedure, securite, ha]
status: actif
domaine: Procedures
sources: [S10, S17, S18]
detail_executable: Ressources/Protocoles/IP_Bans.md
---

# Debannissement IP

## Quand utiliser

- 2 a 3 erreurs **401 / 403 consecutives** sur Home Assistant (local ou distant).
- Mickael signale ne plus pouvoir acceder a HA depuis un appareil donne.
- Apres une serie de tentatives d'authentification ratees (TOTP repetes faux, etc.).

## Pourquoi

HA active `ip_ban_enabled: true` + `login_attempts_threshold: 3` dans
`http:`. Au-dela du seuil, l'IP source est ecrite dans `ip_bans.yaml` et
toutes les requetes suivantes renvoient 403 — **y compris les appels MCP
ha-mcp**. La regle 0 du `CLAUDE.md` impose d'**arreter** apres 2-3 erreurs
401/403 consecutives plutot que de retenter en boucle (qui empire le ban).

## Vue d'ensemble (3 methodes)

1. **Methode 1 (PRIORITE)** — Terminal SSH local via Brave (LAN).
   Ouvrir `http://192.168.1.11:2096/hassio/addon/core_ssh/info`, lancer
   l'UI, executer la commande qui supprime `ip_bans.yaml` + `ha core restart`.
2. **Methode 2 (fallback distant)** — File Editor via `https://ha.might.ovh/...`.
   Naviguer dans `homeassistant/`, supprimer le fichier `ip_bans.yaml` si present.
3. **Methode 3 (MCP fallback)** — `ha_call_service("shell_command", "ha_clear_all_ip_bans")` + `ha_restart`.
   Quand Brave est inaccessible (Claude in Chrome bloque sur IPs RFC1918, ou Mickael est sur iPhone sans PC allume).

## Pieges connus

- **Claude in Chrome bloque sur IPs privees** : `192.168.x.x` n'est pas dans
  l'allowlist Brave par defaut. Passer par URL publique CF ou Methode 3 MCP.
- **Methode 3 vide TOUS les bans** d'un coup (pas de ciblage par IP) — les
  bans legitimes (attaquants externes) se reformeront naturellement.
- **NE PAS** ajouter de `shell_command` parametre type `sed -i '/{{ ip }}/d'` —
  risque d'injection shell si le LLAT HA est compromis (decision S18).
- **Premier ban de la session** : proposer la desactivation temporaire du
  bannissement (puis le reactiver en fin de session).
- **Apres debannissement** : toujours tester en LOCAL en premier
  (`http://192.168.1.11:2096`) avant de retenter en distant.
- **Auto-memory exception Regle 0** : `ip_bans.yaml` est NON sensible
  (`feedback_ha_ipbans_not_sensitive.md`) — pas besoin d'accord explicite,
  operation fluide.

## Detail executable

Voir : `Ressources/Protocoles/IP_Bans.md` (3 methodes complete avec commandes,
URLs, validations) et `.claude/skills/debannissement-ip/SKILL.md` (skill
auto-declenchee).

## Sources

- `memory/historique/2026-04-19_session_10_diagnostic_mcp_ban_ip_raccourcis.md`
- `memory/historique/2026-04-20_session_17_install_cli_validation_mcp.md`
- `memory/historique/2026-04-20_session_18_ban_ip_methode_mcp.md`
- Auto-memories : `feedback_ha_ipbans_not_sensitive`, `reference_ha_debannissement_mcp`, `feedback_claude_chrome_allowlist`
