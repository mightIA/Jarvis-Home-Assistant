---
name: Get-Content sans -Encoding UTF8 = double-encodage sur fichiers UTF-8 sans BOM
description: PowerShell — `Get-Content -Raw` sans `-Encoding UTF8` explicite lit en CP1252 par défaut sur Windows FR puis `WriteAllText UTF8` réencode → mojibake aggravé sur caractères non-ASCII
type: feedback
session_capitalized: S112
related_tasks: [T#94]
---

# Get-Content sans `-Encoding UTF8` explicite = double-encodage

## Règle

Toujours utiliser `Get-Content -Raw -Encoding UTF8` sur les fichiers UTF-8 sans BOM (.json, .yaml, .md, .toml, etc.) avant ré-écriture via `WriteAllText`.

## Why

`Get-Content -Raw` sans `-Encoding` utilise l'encodage par défaut du shell PowerShell, qui sur Windows FR est souvent **CP1252** (pas UTF-8). Sur un fichier UTF-8 sans BOM contenant des caractères non-ASCII (emoji, accents, em-dash, etc.), PowerShell interprète chaque byte UTF-8 comme un caractère CP1252, puis convertit vers Unicode interne. Ensuite `WriteAllText (..., UTF8Encoding($false))` réencode ces caractères Unicode en UTF-8 → **chaque caractère non-ASCII est encodé deux fois**, produisant un mojibake aggravé.

Régression S112 sur `.mcp.json` L35 (`_legacy_url`) :
- Avant 1er patch : `Ã¢â‚¬â€` (em-dash `—` initial mojibake = UTF-8 `E2 80 94` lu comme CP1252)
- Après 2 patches : `ÃƒÂ¢Ã¢â€šÂ¬Ã¢â‚¬Â` (double-encodé)

Impact zéro fonctionnel sur `.mcp.json` car ces caractères sont dans des champs `_description`/`_legacy_url` cosmétiques que JSON parser ignore. Mais sur du code Python/JS/YAML actif, le double-encodage casserait le parsing.

## How to apply

```powershell
# ❌ MAUVAIS — encodage shell par défaut (CP1252 sur Windows FR)
$content = Get-Content $path -Raw
$content_new = $content.Replace("ancien", "nouveau")
[System.IO.File]::WriteAllText($path, $content_new, (New-Object System.Text.UTF8Encoding($false)))

# ✅ BON — encodage UTF-8 explicite à la lecture
$content = Get-Content $path -Raw -Encoding UTF8
$content_new = $content.Replace("ancien", "nouveau")
[System.IO.File]::WriteAllText($path, $content_new, (New-Object System.Text.UTF8Encoding($false)))
```

## Détection a posteriori

Pour vérifier si un fichier a été double-encodé après patch, chercher des séquences de mojibake longues :

```powershell
Select-String -Path $path -Pattern '[-ÿ]{6,}' | ForEach-Object { "L$($_.LineNumber): $($_.Line)" }
```

Une chaîne de 6+ caractères `Ã`/`â`/`€`/etc. d'affilée = double-encodage probable. Restaurer depuis backup et refaire avec `-Encoding UTF8`.

## Voir aussi

- `feedback_set_content_utf8_bom_ps51.md` — piège complémentaire S108 sur `Set-Content -Encoding UTF8` qui ajoute un BOM en PS 5.1.
- Récit S112 : `memory/historique/2026-05-05_session_112_t94_1bis_path_token_cleanup.md`
