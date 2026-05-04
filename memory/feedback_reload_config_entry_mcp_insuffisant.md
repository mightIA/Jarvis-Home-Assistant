---
name: reload_config_entry MCP souvent insuffisant pour Wyoming
description: S93 — `homeassistant.reload_config_entry` via MCP retourne success mais ne répare pas toujours une intégration Wyoming cassée. Restart HA Core fiable à 100 %.
type: feedback
---

# `reload_config_entry` MCP souvent insuffisant pour Wyoming

## Règle

Pour réparer une intégration Wyoming en erreur (Piper, Whisper, autres
TTS/STT), **ne pas se contenter** du service
`homeassistant.reload_config_entry` via MCP. Le call retourne
`success: true` et `"Successfully executed"`, mais l'entité reste
souvent `unavailable` côté HA. **Restart HA Core complet** est la
solution fiable.

## Symptôme observé S93 (03/05/2026)

Cas T#92 P1 — bug Wyoming Piper post-switch voix
(cf. `feedback_wyoming_piper_voice_switch_bug.md`) :

```
ha_call_service(
  domain="homeassistant",
  service="reload_config_entry",
  data={"entry_id": "01K6556YWH3Q2Q63KRX3H1PM0X"}
)
→ {"success": true, "message": "Successfully executed homeassistant.reload_config_entry"}
```

Mais l'entité `tts.piper` reste `state: unavailable`,
`last_changed: 2026-05-03T17:20:55` (= avant le reload, pas mise à
jour par le reload). Reload répété 2 fois → idem.

## Hypothèse cause

L'entry_id passé n'est peut-être pas le bon : l'`unique_id` de
l'entité TTS (`01K6556YWH3Q2Q63KRX3H1PM0X-tts`) suggère un préfixe
qui pourrait être l'entry_id Wyoming, mais le service de reload
demande probablement l'entry_id de la **config entry** racine de
l'intégration, pas celui spécifique à l'entité.

Alternative : le reload côté HA réussit mais Wyoming en interne ne
sait pas re-bootstrap correctement quand l'add-on Piper a changé de
"service ID" (voix par défaut différente).

## Solution fiable à 100 %

**Restart Home Assistant Core complet** :
- HA UI → Paramètres → Système → Redémarrer → **Restart Home Assistant Core**
- ~45s de downtime
- Wyoming se reconnecte proprement au démarrage

## Why

Le reload MCP donne une **fausse impression de succès** (réponse
positive de l'API) qui fait perdre du temps en diagnostic. La règle
permet de basculer plus vite vers la solution qui marche vraiment.

## How to apply

- Si une intégration HA (Wyoming en particulier, mais probablement
  aussi d'autres) reste en erreur après `reload_config_entry` MCP :
  ne pas insister, basculer direct sur restart HA Core
- Si on veut éviter le restart HA Core : essayer plutôt le reload
  manuel via UI HA (Paramètres → Périphériques → Intégration → ⋮ →
  Recharger) qui est plus fiable que la version MCP

## Lien

- Bug Wyoming Piper voice switch : `memory/feedback_wyoming_piper_voice_switch_bug.md`
- T#92 phase P1 abandonnée S93 : `tasks/task_092.md`
- Archive session S93 : `memory/historique/2026-05-03_session_93_hermes_v012_p1_p2_tts_pause.md`
