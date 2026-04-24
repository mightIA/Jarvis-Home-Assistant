---
name: browser-mod
description: Controle du navigateur via l'integration Browser Mod (HACS thomasloven, v2.10.2). Utilise pour le rafraichissement reel des pages Lovelace (F5), la navigation back/forward, l'execution de JavaScript, l'affichage de popups et notifications. Indispensable pour les badges universels presents sur les 19 vues Lovelace.
---

# Skill : Browser Mod

## Quand cette skill est declenchee

- Demande de rafraichir une page Lovelace (F5 reel).
- Demande de navigation back / forward dans le navigateur.
- Besoin d'afficher un popup ou une notification depuis HA.
- Configuration des badges de navigation sur une nouvelle vue.

## Integration

`thomasloven/hass-browser_mod` v2.10.2 (HACS) — installee le 18/04/2026.

## Services utiles

| Service                  | Usage                                          |
|--------------------------|------------------------------------------------|
| `browser_mod.refresh`    | Rafraichir la page (equivalent F5)             |
| `browser_mod.javascript` | Executer du JavaScript (ex: history.back())    |
| `browser_mod.navigate`   | Naviguer vers un chemin                        |
| `browser_mod.popup`      | Afficher un popup                              |
| `browser_mod.notification` | Afficher une notification                    |

## Utilisation dans les badges

Via `tap_action: fire-dom-event` + `browser_mod`. Exemple pour le badge
"Page precedente" :

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

## Badges universels (presents sur 19 vues)

| Badge                | Icone                       | Action                              |
|----------------------|-----------------------------|-------------------------------------|
| Rafraichir           | `mdi:refresh`               | `browser_mod.refresh` (F5 reel)     |
| Page precedente      | `mdi:arrow-left`            | `history.back()` via JS             |
| Page suivante        | `mdi:arrow-right`           | `history.forward()` via JS          |
| Jour                 | `scene.jour` (icone soleil) | Active `scene.jour`                 |
| Nuit                 | `scene.nuit` (icone lune)   | Active `scene.nuit`                 |
| Capteurs mouvement   | `mdi:motion-sensor`         | Active script capteurs              |

## Reference longue

Voir `Ressources/Competences/Home_Assistant.md` sections 7 et 8.
