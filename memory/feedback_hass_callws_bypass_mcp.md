---
name: Bypass MCP HA via hass.callWS JavaScript dans Brave
description: Quand le MCP HA est down (Session terminated, add-on ha-mcp inactif, tunnel CF coupé), utiliser hass.callWS via JavaScript direct dans Brave MCP comme fallback fiable pour lire/écrire la config Lovelace
type: feedback
created: 2026-04-25
session: 50
---

# Bypass MCP HA via `hass.callWS` JavaScript dans Brave

**Règle** : quand le MCP HA est cassé (`Session terminated` persistant,
add-on ha-mcp arrêté, tunnel CF `mcp.might.ovh` down, ou tout autre
défaut côté chaîne MCP), **basculer sur `hass.callWS` via JavaScript
direct** depuis le tab Claude in Chrome ouvert sur `https://ha.might.ovh/`
(ou tout autre URL HA accessible).

## Why

- Méthode déjà déclarée comme **officielle Jarvis** dans `CLAUDE.md §3`
  (« Utiliser `hass.callWS` pour lire/ecrire la config Lovelace, jamais
  editer les fichiers dashboard directement »).
- `hass.callWS` n'a aucune dépendance sur l'add-on `ha-mcp` ni le tunnel
  CF `mcp.might.ovh` — il utilise la WebSocket native HA déjà ouverte par
  le frontend que Mickael a auth.
- Plus rapide que l'éditeur Lovelace UI (clic crayon → 3 points → YAML
  brut → copier-coller → save) car tout est en 2-3 calls JS.
- Permet aussi des opérations atomiques (lire toute la config, modifier
  une vue précise par index, save) sans clic-clic-clic dans l'UI.
- Ne dépend pas de l'état du serveur MCP — utile justement quand on
  voudrait diagnostiquer pourquoi ha-mcp est down.

## How to apply

### Étape 1 — Récupérer le contexte Brave MCP

Avoir un tab MCP ouvert sur HA distant (`https://ha.might.ovh/`).
Si IP locale `http://192.168.1.11:2096/` est nécessaire, ne pas oublier
qu'elle est bloquée par allowlist Cowork (auto-memory
`feedback_claude_chrome_allowlist` S20) — passer par l'URL publique CF
Tunnel à la place.

### Étape 2 — Lire la config

```javascript
document.querySelector('home-assistant').hass.connection
  .sendMessagePromise({type: 'lovelace/config', url_path: null})
  .then(c => {
    window.__jarvis_config = c;  // stocker pour réutiliser
    return {ok: true, views_count: c.views.length};
  })
```

- `url_path: null` cible le dashboard par défaut (`lovelace`).
- Pour un autre dashboard, mettre son `url_path` (ex: `'lovelace-mobile'`).
- Le retour est l'objet config complet (views, badges, resources via
  l'autre call `lovelace_resources`).

### Étape 3 — Modifier en mémoire

Construire l'objet view modifié, remplacer `fullConfig.views[idx]` :

```javascript
const oldView = window.__jarvis_config.views[17];
window.__jarvis_old_view = JSON.parse(JSON.stringify(oldView));  // backup
const newView = {
  title: oldView.title,
  path: oldView.path,
  icon: oldView.icon,
  type: 'sections',
  max_columns: 2,
  badges: oldView.badges,  // PRÉSERVER les badges
  sections: [ /* nouvelles sections */ ]
};
window.__jarvis_config.views[17] = newView;
```

### Étape 4 — Save

```javascript
await document.querySelector('home-assistant').hass.connection
  .sendMessagePromise({
    type: 'lovelace/config/save',
    url_path: null,
    config: window.__jarvis_config
  });
```

### Étape 5 — Vérifier le rendu

Re-navigate vers la vue cible + screenshot. ⚠ Le 1er reload après save
peut mettre 5-7 s à rendre une vue `type: sections` + badges (auto-memory
`feedback_lovelace_sections_render_delay`) — ne pas paniquer. Naviguer
vers une autre vue puis revenir débloque proprement.

## Limites

- Ne fonctionne **que si Brave MCP a un tab ouvert et auth sur HA**. Si
  le SSO CF Access bloque le tab, il faut résoudre l'auth d'abord (Mickael
  drag le tab hors du groupe MCP, valide CF Access en personne, drag back
  — pattern S25 `feedback_claude_chrome_sensitive_drag`).
- Pour les opérations non-Lovelace (services, automations, scripts,
  helpers), utiliser plutôt l'API REST HA (`/api/services/...`) via
  `fetch` dans javascript_tool, ou attendre que le MCP HA refonctionne.
- Pas de validation YAML/schema côté JS — si l'objet view est mal
  construit, HA peut afficher une vue vide ou crasher le rendu. Toujours
  garder `window.__jarvis_old_view` en mémoire pour rollback rapide.

## Validé S50 sur

Refonte vue Réseaux (`/lovelace/reseaux`, dashboard `lovelace` index 17)
de masonry 1 colonne → `type: sections, max_columns: 2`. Lecture +
modification + save complets en ~3 calls JS, rendu validé visuellement
au 2ᵉ reload (1er reload vide à cause du délai de rendu sections).
