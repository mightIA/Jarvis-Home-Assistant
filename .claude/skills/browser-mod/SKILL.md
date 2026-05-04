---
name: browser-mod
description: Controle du navigateur via Browser Mod (HACS thomasloven v2.10.2). DECLENCHEURS : 'rafraichis la page', 'F5 sur HA', 'back/forward', 'execute JS dans HA', 'popup HA', 'notification HA depuis automation', 'badge Lovelace navigation', 'configure badges nouvelle vue', 'fire-dom-event'. Utilise pour rafraichissement reel pages Lovelace (F5), navigation back/forward, execution JavaScript, popups et notifications. Indispensable pour les badges universels presents sur 19 vues Lovelace.
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


## Exemples d'invocation utilisateur

- « Rafraichis la page Salon » → `browser_mod.refresh` ciblant le navigateur Mickael.
- « Reviens en arriere dans le dashboard » → `browser_mod.javascript` code=`history.back()`.
- « Affiche un popup HA quand alerte chaudiere » → automation avec `browser_mod.popup` title/content.
- « Ajoute un badge Refresh sur la nouvelle vue Cuisine » → tap_action `fire-dom-event` + `browser_mod.refresh`.

## Quand NE PAS utiliser

- Pour piloter un onglet Brave HORS Home Assistant (Outlook, Gmail, etc.) — utiliser MCP `Claude in Chrome` (`browser_batch`, `navigate`, `find`).
- Pour modifier la STRUCTURE d'une vue Lovelace — passer a `lovelace-edit` (callWS).
- Pour creer une notification PERSISTANTE HA (badge cloche) — utiliser `persistent_notification.create`, pas `browser_mod.notification` (qui est ephemere et navigateur-only).
- Si le navigateur Mickael n'est pas enregistre dans Browser Mod (`browser_mod_browsers` integration) — l'appel echoue silencieusement.

## Pieges connus

- **Targeting** : par defaut Browser Mod cible le navigateur ACTIF (celui qui a fait l'appel). Pour cibler un autre navigateur, ajouter `browser_id` dans data. Tester avant de promettre.
- **`browser_mod.refresh` != F5 vrai** : recharge la page Lovelace mais sans casser le cache JS — equivalent du F5 standard, PAS Ctrl+F5 (hard reload). Pour vrai hard reload, `browser_mod.javascript` code=`location.reload(true)`.
- **JavaScript via `browser_mod.javascript`** : execute en contexte page Lovelace. PAS d'acces au DOM HA backend (uniquement frontend). Les appels `hass.callService` fonctionnent.
- **Notifications ephemeres** : `browser_mod.notification` disparait en quelques secondes — n'est pas memorisee. Pour persistant, utiliser `persistent_notification` (HA core).
- **Mobile vs Desktop** : Browser Mod fonctionne sur l'app HA mobile mais avec limitations (pas tous les services). Tester avant de scripter pour iPhone Mickael.

## Reference longue

Voir `Ressources/Competences/Home_Assistant.md` sections 7 et 8.
