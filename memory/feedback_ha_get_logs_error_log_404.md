---
name: HA ha_get_logs source=error_log retourne 404
description: Endpoint MCP HA pour source=error_log inexistant dans cette version HA. Workaround utiliser source=system (ERROR + WARNING) à la place.
type: feedback
---

# HA `ha_get_logs source=error_log` → 404

## Règle découverte (S91, 2026-05-03)

L'appel MCP `ha_get_logs source=error_log` (qui devait récupérer le contenu brut du fichier `home-assistant.log`) retourne **404 Not Found** dans cette version HA + add-on `ha-mcp` v7.4.1 :

```json
{
  "success": false,
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "API error: 404 - 404: Not Found",
    "suggestion": "Check Home Assistant connection",
    "suggestions": [
      "Check Home Assistant connection",
      "The error log may be empty if no errors have occurred"
    ]
  },
  "source": "error_log"
}
```

## Why

L'endpoint REST API `/api/error_log` côté HA Core a probablement été déplacé / renommé / supprimé dans une version récente. Le tool MCP n'a pas été mis à jour pour s'aligner. À investiguer côté repo `ha-mcp` GitHub si le souci persiste sur d'autres versions.

## How to apply

**Pour toute skill qui voulait `source=error_log`** :

1. Utiliser **`source=system`** avec `level=ERROR` puis `level=WARNING` séparément, puis combiner les retours
2. Ou utiliser **`source=supervisor` slug=core_<add-on>`** pour les logs add-on (à valider)
3. Ne plus jamais référencer `source=error_log` dans une nouvelle skill

⚠️ Conséquence : on perd la **traçabilité brute** des bans IP, reboots HA, et stack traces complètes du fichier `home-assistant.log`. La consolidation `.md` doit utiliser des `search=` filtrés sur `source=system` à la place :

```
ha_get_logs source=system search="banned" limit=500
ha_get_logs source=system search="invalid authentication" limit=500
```

## Skills concernées

- `ha-logs-archive` v2 (T#34) — `source=error_log` retiré du design v2 (S91)
- Toute future skill qui voudrait du log brut

## Bonus pièges associés

- `end_time` est **ignoré** sur `source=system` (warning explicite MCP). Fonctionne uniquement sur `source=logbook`.
- Logbook 24h dépasse 25 KB output MCP → pattern `find tmp + cp` obligatoire (cf. SKILL `ha-logs-archive` v2).
- Compteurs system_log reset à chaque restart HA Core.

## Référence

- Test S91 (2026-05-03), `memory/historique/2026-05-03_session_91_t34_skill_ha_logs_archive_v2.md`
- Add-on ha-mcp v7.4.1 (mis à jour S91 depuis 7.4.0)
- HA Core version au moment du test : à confirmer (probablement 2026.4.x ou 2026.5.x)
