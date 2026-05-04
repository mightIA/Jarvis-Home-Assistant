---
name: MCP ha_call_service pour script — entity_id dans data
description: Pour appeler un script HA via MCP `ha_call_service`, passer `entity_id: "script.NAME"` dans `data` (pas dans target), avec les paramètres du script à côté. Sinon erreur 500.
type: feedback
session: S84 (2026-05-02)
related_tasks: [T#53, T#88, T#89]
---

# MCP `ha_call_service` pour script HA — astuce S84

## Règle

Pour appeler un script Home Assistant via MCP `ha_call_service`, le format correct est :

```json
{
  "domain": "script",
  "service": "<script_id_sans_prefixe>",
  "data": {
    "entity_id": "script.<script_id>",
    "<param1>": "<valeur1>",
    "<param2>": "<valeur2>"
  }
}
```

**Why** : sans `entity_id` dans `data`, MCP renvoie HTTP 500 *« API error: 500 - 500 Internal Server Error / Server got itself in trouble »* avec suggestion *« Specify an entity_id for targeted service calls »*. Le MCP HA exige une cible explicite, qui pour les scripts est leur entity_id.

**How to apply** : à chaque appel de script depuis Cowork ou Claude Code via le tool `ha_call_service`.

## Exemple validé S84

```json
{
  "domain": "script",
  "service": "jarvis_voice",
  "data": {
    "entity_id": "script.jarvis_voice",
    "message": "Test deux. Cette fois le message doit s'afficher.",
    "title": "Jarvis test S84 v2"
  }
}
```

→ Réponse : `success: true`, state changes propres dans logbook.

## Anti-patterns

❌ Mettre `entity_id` dans un champ `target` séparé :
```json
{"target": {"entity_id": "tts.piper"}}
```
→ Erreur Pydantic « target: Unexpected keyword argument ».

❌ Appeler avec `script.turn_on` + `variables` au scope :
```json
{
  "domain": "script",
  "service": "turn_on",
  "data": {"entity_id": "script.NAME", "variables": {...}}
}
```
→ S'exécute mais les variables ne sont pas passées correctement au scope Jinja du script (rendu vide).

## Sessions précédentes pertinentes

- S84 : découverte empirique pendant tests `script.jarvis_voice` (T#53).
