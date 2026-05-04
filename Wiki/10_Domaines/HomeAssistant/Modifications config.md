---
title: HA — Modifications config (recharger vs redémarrer)
created: 2026-04-25
updated: 2026-04-25
tags: [atome, ha/config, ha/yaml]
status: actif
---

# HA — Modifications config (recharger vs redémarrer)

Avant **toute** modification de la configuration HA, préciser à Mickael
si un rechargement simple suffit ou si un redémarrage complet est
nécessaire.

## Table de décision

| Type de modification | Action requise | Comment faire |
|---|---|---|
| `scripts.yaml` | Rechargement scripts | Paramètres → Outils de dev → YAML → Scripts |
| `automations.yaml` | Rechargement automations | Paramètres → Outils de dev → YAML → Automations |
| `configuration.yaml` | Rechargement config entière | Paramètres → Outils de dev → YAML → Recharger |
| `shell_command` (nouveau) | **Redémarrage complet** | Paramètres → Système → Redémarrer |
| Lovelace (dashboard) | Aucun rechargement | Modifs via `hass.callWS` en temps réel |
| Ajout d'intégration | **Redémarrage complet** | Paramètres → Système → Redémarrer |
| Modification core | **Redémarrage complet** | Paramètres → Système → Redémarrer |

## Lovelace — règles spécifiques

- **Toujours utiliser `hass.callWS`** pour lire/écrire la config Lovelace.
- Ne **pas** modifier les fichiers dashboard directement → passer par l'API
  WebSocket (skill `lovelace-edit`).
- Pas de rechargement nécessaire — modifications visibles immédiatement.

## Notes liées

- [[Procédures diagnostiques]] — quoi faire si HA ne reboot pas après redémarrage
- Skill : `.claude/skills/lovelace-edit/`
- Skill : `.claude/skills/yaml-automation/`

---

*Source : `Ressources/Competences/Home_Assistant.md` §4.*
