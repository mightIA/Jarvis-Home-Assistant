---
title: Browser Mod
created: 2026-04-25
tags: [domotique/ha-tools, ha/lovelace]
status: actif
source: Ressources/Competences/Home_Assistant.md §7-§8
---

# Browser Mod

Intégration HACS `thomasloven/hass-browser_mod` v2.10.2 — installée le
18/04/2026. Permet à Home Assistant de contrôler le navigateur depuis
les automations / dashboards / badges.

## Services utiles

| Service | Usage |
|---|---|
| `browser_mod.refresh` | Rafraîchir la page (équivalent F5) |
| `browser_mod.javascript` | Exécuter du JavaScript (ex : `history.back()`) |
| `browser_mod.navigate` | Naviguer vers un chemin |
| `browser_mod.popup` | Afficher un popup |
| `browser_mod.notification` | Afficher une notification |

## Utilisation dans les badges

Pattern Lovelace : `tap_action: fire-dom-event` + service `browser_mod.<x>`.

## Badges de navigation (toutes les vues)

Les 19 onglets Lovelace ont 6 badges ajoutés le 18/04/2026 :

| Badge | Icône | Action |
|---|---|---|
| Rafraîchir | `mdi:refresh` | `browser_mod.refresh` (F5 réel) |
| Page précédente | `mdi:arrow-left` | `history.back()` via `browser_mod.javascript` |
| Page suivante | `mdi:arrow-right` | `history.forward()` via `browser_mod.javascript` |
| Jour | `scene.jour` (icône soleil) | Active `scene.jour` |
| Nuit | `scene.nuit` (icône lune) | Active `scene.nuit` |
| Capteurs mouvement | `mdi:motion-sensor` | Active script capteurs |

**Prérequis** : Browser Mod doit être installé et configuré (intégration
HA reconnue dans `Paramètres → Appareils et services`).

## Notes liées

- [[../HomeAssistant/_Index]]
- [[../HomeAssistant/Apps installées]] — HACS
- [[../HomeAssistant/Intégrations]] — `browser_mod` loaded
- Skill : `.claude/skills/browser-mod/`
- Auto-memory : `reference_lovelace_patterns` (popups Réglages via Browser Mod)

---

*Source : `Ressources/Competences/Home_Assistant.md` §7 + §8.*
