---
name: Select-String -SimpleMatch désactive le regex
description: PowerShell `Select-String -Pattern "a|b|c" -SimpleMatch` cherche littéralement la chaîne "a|b|c" (pipe inclus), pas comme OR regex — retirer -SimpleMatch ou utiliser plusieurs Select-String séparés
type: feedback
session_capitalized: S112
related_tasks: [T#94]
---

# `Select-String -SimpleMatch` désactive le regex

## Règle

Le flag `-SimpleMatch` de `Select-String` (PowerShell) désactive **toute** interprétation regex du pattern. Un pattern OR `"a|b|c"` est cherché **littéralement** comme la chaîne `a|b|c` (pipe inclus, 5 caractères) — pas comme l'union de 3 alternatives.

## Why

Régression S112 lors d'un repérage `ha_|mcp|home-assistant|ha-mcp` dans 3 SKILL.md :

```powershell
Select-String -Path $s -Pattern "ha_|mcp|home-assistant|ha-mcp" -SimpleMatch
```

→ **0 match** sur 3 fichiers qui devraient en avoir des dizaines (faux négatif).

Cause : `-SimpleMatch` cherche littéralement la chaîne `ha_|mcp|home-assistant|ha-mcp` (29 caractères pipe inclus). Aucun fichier ne contient cette séquence exacte → 0 résultat, alors que chaque sous-pattern aurait matché individuellement.

## How to apply

```powershell
# ❌ MAUVAIS — SimpleMatch désactive le | OR regex
Select-String -Path $f -Pattern "ha_|mcp|home-assistant" -SimpleMatch

# ✅ BON option 1 — retirer SimpleMatch (| redevient OR regex)
Select-String -Path $f -Pattern "ha_|mcp|home-assistant"

# ✅ BON option 2 — patterns séparés si besoin de SimpleMatch (ex: pour échapper des chars regex)
$patterns = @("ha_", "mcp", "home-assistant")
foreach ($p in $patterns) {
  Select-String -Path $f -Pattern $p -SimpleMatch
}
```

## Quand utiliser `-SimpleMatch` quand même

Si le pattern contient des caractères regex spéciaux qu'on veut chercher littéralement (`.`, `*`, `[`, `]`, `(`, `)`, `?`, `+`, `|`, `^`, `$`, `\`) :

```powershell
# Recherche littérale "a.b.c" (pas "a + n'importe quel char + b + n'importe quel char + c")
Select-String -Path $f -Pattern "a.b.c" -SimpleMatch
```

Mais alors **un seul pattern à la fois**, jamais avec OR `|`.

Alternative regex échappée : `[regex]::Escape("a.b.c")` retourne `a\.b\.c` qu'on peut combiner avec OR :

```powershell
$p = ([regex]::Escape("a.b.c")) + "|" + ([regex]::Escape("d.e.f"))
Select-String -Path $f -Pattern $p
```

## Voir aussi

- Récit S112 : `memory/historique/2026-05-05_session_112_t94_1bis_path_token_cleanup.md`
- Doc officielle : `Get-Help Select-String -Parameter SimpleMatch`
