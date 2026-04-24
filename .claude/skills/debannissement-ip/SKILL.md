---
name: debannissement-ip
description: Procedure de suppression d'un ban IP sur Home Assistant. Detecte les bans via erreurs 401/403 repetees, propose la desactivation temporaire du bannissement si premier ban de la session, execute la suppression via Terminal SSH local (priorite), File Editor distant (fallback), ou **Methode MCP fallback** (`shell_command.ha_clear_all_ip_bans` via MCP ha-mcp — utile quand Claude in Chrome est bloque ou Mickael est sur iPhone sans PC allume). Procedure testee et validee.
---

# Skill : Debannissement IP Home Assistant

## Quand cette skill est declenchee

- 2 a 3 erreurs 401 / 403 consecutives sur HA.
- Mickael signale qu'il ne peut plus acceder a HA.
- Apres une serie de tentatives d'authentification ratees.

## Regles avant de supprimer un ban

- **Regle 1** : verifier l'heure du ban — si plus de 30 minutes, prevenir Mickael.
- **Regle 2** : verifier le nombre d'IPs bannies — si plusieurs, prevenir Mickael.
- **Regle 3** : apres debannissement, toujours tester la connexion locale.

Si **premier ban de la session** : proposer a Mickael de desactiver
temporairement le bannissement le temps de la session, et rappeler de le
reactiver a la fin (ou le faire automatiquement si possible).

## Methode 1 (PRIORITE) — Terminal SSH local via Brave

A utiliser en premier. Fonctionne sur le reseau local. Procedure testee
et validee depuis PC. A retester depuis Dispatch/iPhone (TASKS.md #17).

### Etape 1 — Ouvrir cette URL dans Brave
```
http://192.168.1.11:2096/hassio/addon/core_ssh/info
```

### Etape 2 — Cliquer sur le bouton bleu « Ouvrir l'interface utilisateur Web »

### Etape 3 — Dans le terminal, taper cette commande
```bash
cat /homeassistant/ip_bans.yaml 2>/dev/null && rm -f /homeassistant/ip_bans.yaml && ha core restart || echo 'Pas de ban IP actif'
```

### Etape 4 — Attendre 30 secondes puis tester
```
http://192.168.1.11:2096
```

## Methode 2 — File Editor via URL distante

A utiliser si la connexion locale est impossible.

- Ouvrir : `https://ha.might.ovh/hassio/addon/core_configurator/info`
- Naviguer dans les fichiers, chercher `ip_bans.yaml` dans `homeassistant/`
- Si absent = aucun ban actif. Sinon, supprimer le fichier.

## Methode 3 (MCP fallback) — `shell_command.ha_clear_all_ip_bans`

**Quand l'utiliser** :
- Claude in Chrome bloque (policy org, ajoutee session 17).
- Mickael sur iPhone sans PC allume ou sans acces visuel au Terminal.
- Preference rapide : on reste dans la conversation, aucun UI a naviguer.

**Pre-requis** (**deja en place** depuis session 17 du 20/04/2026) :
- Bloc suivant dans `configuration.yaml` :
  ```yaml
  shell_command:
    ha_clear_all_ip_bans: "truncate -s 0 /config/ip_bans.yaml"
  ```
- Service validable via : `ha_list_services(domain="shell_command")`.

**Procedure Jarvis** (via MCP ha-mcp) :
1. `ha_call_service("shell_command", "ha_clear_all_ip_bans", return_response=true)`
   - Attendu : `returncode: 0`, `stderr` vide.
2. `ha_restart(confirm=true)` pour que HA recharge le fichier `ip_bans.yaml` vide.
3. Attendre 1-3 min, puis `ha_get_overview(detail_level="minimal")` pour confirmer `state: RUNNING`.
4. Tester la connexion : `ha_get_state("light.ampoule_chambre")` doit repondre 200.

**Limites / securite** :
- Cette methode vide **TOUS** les bans d'un coup (pas d'IP ciblee — cf. refus de la version `sed` parametree pour raisons d'injection shell).
- Les bans legitimes (attaquants externes) se reformeront naturellement apres `login_attempts_threshold` tentatives echouees.
- Ne PAS ajouter de `shell_command` parametre type `sed -i '/{{ ip }}/d'` — injection shell si token HA compromis.

## Regles de detection

- Si **2-3 erreurs 401/403 consecutives** : ARRETER, verifier ban IP.
- Ne pas repeter les appels API qui echouent.
- Apres debannissement : toujours tester `http://192.168.1.11:2096` et
  basculer en local.

## Reference longue

Voir `Ressources/Protocoles/IP_Bans.md` (procedure officielle).
