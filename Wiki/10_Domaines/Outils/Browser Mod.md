---
title: Browser Mod — contrôle navigateur HA
created: 2026-04-25
updated: 2026-04-28
tags: [atome, outils/browser-mod, ha/integration, domotique/ha-tools, ha/lovelace]
parent: "[[_Index]]"
status: actif
source: Ressources/Competences/Home_Assistant.md §7-§8
---

> **Note S72 (28/04/2026)** — fusion de l'ancien atome `Domotique/Browser Mod.md` dans celui-ci. Source unique pour Browser Mod désormais. Le hub `Domotique/_Index.md` redirige ici.

# Browser Mod — skill `browser-mod`

Intégration `thomasloven/hass-browser_mod` (HACS) v2.10.2 — installée
le 18/04/2026. Permet à Home Assistant de contrôler le navigateur côté
client (rafraîchir, naviguer, exécuter du JS, popups, notifications).
Indispensable pour les **badges universels** présents sur les 19 vues
Lovelace.

## Quand cette skill est déclenchée

- Demande de rafraîchir une page Lovelace (F5 réel).
- Navigation back / forward dans Brave depuis HA.
- Affichage d'un popup ou d'une notification depuis HA.
- Configuration des badges de navigation sur une nouvelle vue.

## Services utiles

| Service                    | Usage                                       |
|----------------------------|---------------------------------------------|
| `browser_mod.refresh`      | Rafraîchir la page (équivalent F5)          |
| `browser_mod.javascript`   | Exécuter du JavaScript (ex. `history.back()`) |
| `browser_mod.navigate`     | Naviguer vers un chemin                     |
| `browser_mod.popup`        | Afficher un popup                           |
| `browser_mod.notification` | Afficher une notification                   |

## Pattern badge avec `tap_action`

Via `tap_action: fire-dom-event` + `browser_mod`. Exemple badge "Page
précédente" :

```yaml
type: custom:button-card
icon: mdi:arrow-left
tap_action:
  action: fire-dom-event
  browser_mod:
    service: browser_mod.javascript
    data:
      code: history.back()
```

## Badges universels (présents sur 19 vues — installés 18/04/2026)

| Badge                | Icône                       | Action                              |
|----------------------|-----------------------------|-------------------------------------|
| Rafraîchir           | `mdi:refresh`               | `browser_mod.refresh` (F5 réel)     |
| Page précédente      | `mdi:arrow-left`            | `history.back()` via JS             |
| Page suivante        | `mdi:arrow-right`           | `history.forward()` via JS          |
| Jour                 | `scene.jour` (icône soleil) | Active `scene.jour`                 |
| Nuit                 | `scene.nuit` (icône lune)   | Active `scene.nuit`                 |
| Capteurs mouvement   | `mdi:motion-sensor`         | Active script capteurs              |

**Prérequis** : Browser Mod doit être installé et configuré (intégration HA reconnue dans `Paramètres → Appareils et services`).

## Liens

- Skill source : `.claude/skills/browser-mod/SKILL.md`
- Référence longue : `Ressources/Competences/Home_Assistant.md` sections 7 et 8
- Hub HA : [[10_Domaines/HomeAssistant/_Index|HomeAssistant]]
- Apps installées (HACS) : [[10_Domaines/HomeAssistant/Apps installées|Apps installées]]
- Intégrations HA (`browser_mod` loaded) : [[10_Domaines/HomeAssistant/Intégrations|Intégrations]]
- Auto-memory : `reference_lovelace_patterns` (popups Réglages via Browser Mod)
- Hub Domotique appareils : [[10_Domaines/Domotique/_Index|Domotique]] (redirige ici depuis fusion S72)

---

*Source : `Ressources/Competences/Home_Assistant.md` §7 + §8. Atome créé S43 puis enrichi S72 par fusion de l'atome Domotique homonyme.*
