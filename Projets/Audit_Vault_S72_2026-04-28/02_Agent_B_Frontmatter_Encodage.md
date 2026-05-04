# Agent B — Audit Frontmatter & Encodage

**Date** : 2026-04-28
**Périmètre** : `Wiki/` (143 fichiers .md)

## Section 1 — Frontmatter YAML manquant

- 99,3% de couverture (133/134 fichiers atomiques avec FM)
- **1 fichier sans FM** : `Wiki/10_Domaines/Email/Gmail_MCP_Custom.md` (artefact au chemin imbriqué `Wiki/Wiki/...`)

## Section 2 — Frontmatter mal formé

- **Aucune malformation détectée**
- Tous les FM sont correctement délimités par `---`
- Pas d'erreur de syntaxe YAML

## Section 3 — Cohérence des champs

| Champ | Présence |
|-------|----------|
| `title` | 100% |
| `created` | 100% |
| `tags` | 100% |
| `status` | 95% (6 fichiers sans) |
| `domaine` | 39% (variabilité attendue selon dossier) |
| `updated` | **0%** (champ jamais utilisé) |

**Constat** : pas de champ `updated` dans le vault — aucune traçabilité des modifications via FM.

## Section 4 — Tags incohérents

220 tags distincts identifiés. Variantes problématiques :
- `ha/*` (namespace hiérarchique) vs `ha-mcp` (flat) vs `hardware`
- Coexistence flat/hiérarchique non harmonisée
- À normaliser pour faciliter les requêtes Dataview

## Section 5 — Encodage / BOM

- **100% UTF-8 sans BOM**
- Aucun mojibake (`Ã©`, `Ã¨`, etc.)
- Encodage cohérent

## Section 6 — Line endings

- Cohérents par fichier (LF ou CRLF, pas de mix interne)
- Pas de fichier corrompu sur ce critère

## Section 7 — Templates non remplis

- 5 marqueurs `TODO` localisés (non-bloquants)
- Patterns `{{ }}` détectés = templates Jinja **intentionnels** (exemples HA), pas des placeholders oubliés

## Section 8 — Statistiques

- Atomes avec FM : 99,3%
- Tags uniques : 220
- Atomes sans `status` : 6
- Atomes sans `updated` : 134 (champ jamais introduit)

---

## Verdict

**État général : BON** — vault propre côté métadonnées. 2 points d'attention mineurs :
1. Absence systématique de `updated` (à introduire ?)
2. Normalisation des tags (hiérarchique vs flat) à arbitrer

---

*Source : sortie Agent B sous-agent Explore — vague 1 audit S72*
