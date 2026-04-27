---
title: Débannissement IP HA — 3 méthodes
created: 2026-04-25
tags: [outils/debannissement, ha/securite]
parent: "[[_Index]]"
status: actif
---

# Débannissement IP — skill `debannissement-ip`

Procédure de suppression d'un ban IP sur Home Assistant. **Exception
unique à la Règle 0** : `ip_bans.yaml` n'est pas considéré comme une
donnée sensible — opération fluide, pas besoin d'accord explicite
(auto-memory `feedback_ha_ipbans_not_sensitive`).

## Quand cette skill est déclenchée

- 2 à 3 erreurs **401/403 consécutives** sur HA.
- Mickael signale qu'il ne peut plus accéder à HA.
- Après une série de tentatives d'authentification ratées.

## Règles avant suppression

- Vérifier l'**heure du ban** — si plus de 30 min, prévenir Mickael.
- Vérifier le **nombre d'IPs bannies** — si plusieurs, prévenir Mickael.
- Après débannissement, **toujours tester en local** (`http://192.168.1.11:2096`).
- Si **premier ban de la session** : proposer la désactivation
  temporaire du bannissement le temps de la session, et rappeler de le
  réactiver à la fin.

## Méthode 1 (PRIORITÉ) — Terminal SSH local via Brave

Fonctionne sur réseau local. Procédure testée et validée depuis PC.
À retester depuis Dispatch/iPhone (TASKS.md #17).

1. Ouvrir : [http://192.168.1.11:2096/hassio/addon/core_ssh/info](http://192.168.1.11:2096/hassio/addon/core_ssh/info)
2. Cliquer **Ouvrir l'interface utilisateur Web**.
3. Dans le terminal :

```bash
cat /homeassistant/ip_bans.yaml 2>/dev/null && rm -f /homeassistant/ip_bans.yaml && ha core restart || echo 'Pas de ban IP actif'
```

4. Attendre 30 s, puis tester [http://192.168.1.11:2096](http://192.168.1.11:2096).

## Méthode 2 — File Editor via URL distante

Si la connexion locale est impossible.

- Ouvrir : [https://ha.might.ovh/hassio/addon/core_configurator/info](https://ha.might.ovh/hassio/addon/core_configurator/info)
- Naviguer dans les fichiers, chercher `ip_bans.yaml` dans `homeassistant/`.
- Si absent = aucun ban actif. Sinon, supprimer le fichier.

## Méthode 3 (MCP fallback) — `shell_command.ha_clear_all_ip_bans`

Quand l'utiliser :
- Claude in Chrome bloqué (policy org, ajoutée S17).
- Mickael sur iPhone sans PC allumé ou sans accès visuel au Terminal.
- Préférence rapide : on reste dans la conversation, aucun UI à naviguer.

**Pré-requis** (déjà en place depuis S17) : bloc `shell_command:` dans
`configuration.yaml` :

```yaml
shell_command:
  ha_clear_all_ip_bans: "truncate -s 0 /config/ip_bans.yaml"
```

**Procédure Jarvis via MCP ha-mcp** :

1. `ha_call_service("shell_command", "ha_clear_all_ip_bans", return_response=true)`
   → attendu : `returncode: 0`, `stderr` vide.
2. `ha_restart(confirm=true)` pour recharger `ip_bans.yaml` vide.
3. Attendre 1-3 min, puis `ha_get_overview(detail_level="minimal")` →
   confirme `state: RUNNING`.
4. Test : `ha_get_state("light.ampoule_chambre")` → 200.

**Limites / sécurité** :
- Vide **TOUS** les bans d'un coup (pas d'IP ciblée). Refus de la
  version `sed` paramétrée pour raisons d'injection shell si token HA
  compromis (auto-memory `reference_ha_debannissement_mcp`).
- Les bans légitimes (attaquants externes) se reformeront naturellement.

## Liens

- Skill source : `.claude/skills/debannissement-ip/SKILL.md`
- Référence longue : `Ressources/Protocoles/IP_Bans.md`
- Hub HA — débannissement détaillé : `[[10_Domaines/HomeAssistant/Debannissement IP]]`
