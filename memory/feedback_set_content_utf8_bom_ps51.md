---
name: Set-Content -Encoding UTF8 ajoute un BOM en PS 5.1
description: En Windows PowerShell 5.1, `Set-Content -Encoding UTF8` ajoute un BOM (Byte Order Mark) en début de fichier. Visible cosmétiquement dans messages de commit Git ou autres outils sensibles aux 3 octets `EF BB BF` initiaux.
type: feedback
session_origine: 108
date: 2026-05-04
applies_to: ["scripts PowerShell", "commit messages Git", "fichiers texte interpretes"]
tags: [powershell, encoding, utf8-bom, ps51, git, piege]
---

# Set-Content -Encoding UTF8 = BOM en PS 5.1

## Règle

En **Windows PowerShell 5.1** (la version installée par défaut sur Windows 10/11), la commande `Set-Content -Encoding UTF8` écrit le fichier avec un **BOM** (Byte Order Mark, 3 octets `EF BB BF` au début).

En **PowerShell 7+** (Core), c'est l'inverse : `-Encoding UTF8` écrit sans BOM par défaut, et il faut spécifier `-Encoding utf8BOM` pour en avoir un.

## Why

Mickael est sur **Windows PowerShell 5.1** (et non PS 7), comme révélé S108 par un caractère parasite `﻿` apparu en début du message de commit `971d838` après push :

```
971d838 2026-05-04 ﻿chore(s108): catch-up massif S70->S108 (~328 fichiers)
```

Le BOM est silencieux dans la plupart des contextes, mais visible dans les outils qui interprètent strictement le contenu (Git log, parsers JSON stricts, certains éditeurs). Pour un commit message, c'est cosmétique mais pas joli sur GitHub UI.

## How to apply

Quand on génère un fichier texte via PowerShell pour qu'il soit consommé par un autre outil (Git commit message, JSON, YAML, scripts shell), **éviter `Set-Content -Encoding UTF8`** sur PS 5.1.

### Solution recommandée — .NET WriteAllText

```powershell
$content = @'
chore(s108): catch-up massif
...
'@
[System.IO.File]::WriteAllText($path, $content, [System.Text.UTF8Encoding]::new($false))
```

Le `UTF8Encoding($false)` force "no BOM". Compatible PS 5.1 et PS 7+, comportement identique.

### Alternative PS 7+ uniquement

```powershell
$content | Set-Content -Path $path -Encoding utf8NoBOM
```

⚠️ `utf8NoBOM` n'existe pas en PS 5.1 (lèvera une erreur).

### Détection version PS

```powershell
$PSVersionTable.PSVersion
```

PS 5.1 = `5.1.x.x`. PS 7+ = `7.x.x`.

## Cas qui en pâtissent

| Cas | Symptôme |
|---|---|
| Commit Git (message via `-F <fichier>`) | `git log` affiche `﻿chore:...` (caractère invisible début) |
| Parser JSON strict | Erreur "Unexpected character ï at line 1 col 1" |
| Script bash interprété par bash sandbox | Premier caractère lu = `﻿` (peut casser la lecture du shebang) |
| Fichier YAML | Certains parsers (ex `yq` strict) refusent |

## Cas qui s'en moquent

- Lecture par PowerShell lui-même (`Get-Content` saute le BOM silencieusement)
- Affichage dans la plupart des éditeurs texte (Notepad++, VSCode, Notepad, etc.)
- Git pour le **contenu** des fichiers commités (mais pas pour le **message** de commit)

## Sources

- Doc Microsoft `about_Character_Encoding` PS 5.1 vs 7
- S108 session — commit `971d838` BOM apparu via `Set-Content -Encoding UTF8` dans bloc commit big bang
