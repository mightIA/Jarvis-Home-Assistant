---
title: Debannissement IP
created: 2026-04-27
updated: 2026-04-30
tags: [procedure, securite, ha, debannissement]
status: actif
domaine: Procedures
sources: [S10, S17, S18, S81-fusion]
detail_executable: Ressources/Protocoles/IP_Bans.md
---

# Debannissement IP

> ℹ️ **Source de vérité unique depuis S81** — fusion de 3 fichiers (`Procedures/Debannissement IP.md` + `Outils/Debannissement IP.md` + `HomeAssistant/Débannissement IP.md`). Les 2 autres sont devenus des pointeurs vers cette fiche pour éviter le drift.

> ⚠️ **Exception Règle 0** — `ip_bans.yaml` est explicitement non sensible (cf. auto-memory `feedback_ha_ipbans_not_sensitive.md`). Pas besoin d'accord explicite avant de manipuler ce fichier — opération fluide.

## Quand utiliser

- 2 à 3 erreurs **401 / 403 consécutives** sur Home Assistant (local ou distant).
- Mickael signale ne plus pouvoir accéder à HA depuis un appareil donné.
- Après une série de tentatives d'authentification ratées (TOTP répétés faux, etc.).

## Pourquoi

HA active `ip_ban_enabled: true` + `login_attempts_threshold: 3` dans `http:`. Au-delà du seuil, l'IP source est écrite dans `ip_bans.yaml` et toutes les requêtes suivantes renvoient 403 — **y compris les appels MCP ha-mcp**. La règle 0 du `CLAUDE.md` impose d'**arrêter** après 2-3 erreurs 401/403 consécutives plutôt que de retenter en boucle (qui empire le ban).

## Règles avant suppression

| Règle | Action |
|---|---|
| 1 | Si **ban > 30 min**, prévenir Mickael avant action |
| 2 | Si **plusieurs IPs bannies**, prévenir Mickael |
| 3 | Toujours **retester la connexion locale** après débannissement (`http://192.168.1.11:2096`) |
| 4 | Si **premier ban de la session**, proposer la désactivation temporaire du bannissement (puis réactiver en fin de session) |

## Vue d'ensemble (3 méthodes)

| # | Méthode | Quand l'utiliser |
|---|---|---|
| 1 | Terminal SSH local via Brave (LAN) | **PRIORITÉ** — réseau local accessible |
| 2 | File Editor via URL distante | Réseau local impossible |
| 3 | MCP `ha_call_service` + `ha_restart` | Brave inaccessible (allowlist), iPhone seul, ou préférence "rester dans la conv" |

---

### Méthode 1 (PRIORITÉ) — Terminal SSH local via Brave

Validée depuis PC. À retester depuis Dispatch/iPhone (TASKS.md T#17).

1. Ouvrir dans Brave : `http://192.168.1.11:2096/hassio/addon/core_ssh/info`
2. Cliquer sur **Ouvrir l'interface utilisateur Web** (bouton bleu)
3. Dans le terminal, exécuter :

```bash
cat /homeassistant/ip_bans.yaml 2>/dev/null && rm -f /homeassistant/ip_bans.yaml && ha core restart || echo 'Pas de ban IP actif'
```

4. Attendre 30 s, puis tester `http://192.168.1.11:2096`

### Méthode 2 — File Editor via URL distante

Fallback si réseau local impossible.

1. Ouvrir `https://ha.might.ovh/hassio/addon/core_configurator/info`
2. Naviguer dans `homeassistant/`, chercher `ip_bans.yaml`
3. Si absent = aucun ban actif. Sinon, supprimer le fichier.

### Méthode 3 (MCP fallback) — `shell_command.ha_clear_all_ip_bans`

**Quand l'utiliser** :
- Claude in Chrome bloqué (allowlist Brave ne couvre pas les IPs privées RFC1918, policy ajoutée S17).
- Mickael sur iPhone sans PC allumé ou sans accès visuel au Terminal.
- Préférence rapide : on reste dans la conversation, aucun UI à naviguer.

**Pré-requis** (déjà en place depuis S17) — bloc `shell_command:` dans `configuration.yaml` :

```yaml
shell_command:
  ha_clear_all_ip_bans: "truncate -s 0 /config/ip_bans.yaml"
```

**Procédure Jarvis via MCP ha-mcp** :

1. `ha_call_service("shell_command", "ha_clear_all_ip_bans", return_response=true)`
   → attendu : `returncode: 0`, `stderr` vide.
2. `ha_restart(confirm=true)` pour recharger `ip_bans.yaml` vide.
3. Attendre 1-3 min, puis `ha_get_overview(detail_level="minimal")` → confirme `state: RUNNING`.
4. Test : `ha_get_state("light.ampoule_chambre")` → 200.

**Limites / sécurité** :
- Vide **TOUS** les bans d'un coup (pas d'IP ciblée). Refus de la version `sed` paramétrée pour raisons d'injection shell si LLAT HA compromis (décision S18, auto-memory `reference_ha_debannissement_mcp`).
- Les bans légitimes (attaquants externes) se reformeront naturellement.

## Pièges connus

- **Claude in Chrome bloqué sur IPs privées** : `192.168.x.x` n'est pas dans l'allowlist Brave par défaut. Passer par URL publique CF ou Méthode 3 MCP.
- **Méthode 3 vide TOUS les bans** d'un coup (pas de ciblage par IP) — les bans légitimes (attaquants externes) se reformeront naturellement.
- **NE PAS** ajouter de `shell_command` paramétré type `sed -i '/{{ ip }}/d'` — risque d'injection shell si le LLAT HA est compromis (décision S18).
- **Premier ban de la session** : proposer la désactivation temporaire du bannissement (puis le réactiver en fin de session).
- **Après débannissement** : toujours tester en LOCAL en premier (`http://192.168.1.11:2096`) avant de retenter en distant.
- **Auto-memory exception Règle 0** : `ip_bans.yaml` est NON sensible (`feedback_ha_ipbans_not_sensitive.md`) — pas besoin d'accord explicite, opération fluide.

## Detail executable

- Skill auto-déclenchée : `.claude/skills/debannissement-ip/SKILL.md`
- Procédure complète + commandes + URLs : `Ressources/Protocoles/IP_Bans.md`

## Notes liées

- [[../HomeAssistant/Connexion et accès]] — règle 2-3 erreurs 401/403 → arrêt automatique
- [[../Cloudflare/_Index|Cloudflare]] — bypass MCP qui contourne CF Access

## Sources

- `memory/historique/2026-04-19_session_10_diagnostic_mcp_ban_ip_raccourcis.md`
- `memory/historique/2026-04-20_session_17_install_cli_validation_mcp.md`
- `memory/historique/2026-04-20_session_18_ban_ip_methode_mcp.md`
- Auto-memories : `feedback_ha_ipbans_not_sensitive`, `reference_ha_debannissement_mcp`, `feedback_claude_chrome_allowlist`
- Fusion S81 (30/04/2026) — 3 fichiers vault unifiés sous cette source de vérité
