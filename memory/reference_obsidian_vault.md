---
name: Obsidian vault Jarvis Wiki
description: Chemin + structure + plugins du vault Obsidian Phase 1bis-a, créé S41 25/04/2026
type: reference
---

# Vault Obsidian "Wiki" — Jarvis Phase 1bis

**Créé** : session 41, 25 avril 2026 (Phase 1bis-a clôturée).

## Chemin

```
D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Wiki\
```

Versionné avec le projet Jarvis (décision D1-S41). Ouvert dans Obsidian
via "Ouvrir un dossier comme coffre" — **NE PAS** ouvrir le projet
racine (indexerait 1000+ fichiers).

## Structure (5 dossiers PARA + Karpathy)

| Dossier | Rôle |
|---|---|
| `00_Index/` | MOC, points d'entrée navigation (`_Index.md` racine) |
| `10_Domaines/` | Domaines persistants (HA, Frisquet, Cloudflare, Cameras…) |
| `20_Projets/` | Projets actifs avec début/fin (Hermes_Agent, Tri_Email_Multi…) |
| `30_References/` | Manuels, datasheets, captures externes |
| `90_Archives/` | Projets clos, notes obsolètes (pas de réécriture) |

## Plugins activés (4 gratuits)

- **Dataview** v0.5.68 ([blacksmithgu](https://github.com/blacksmithgu/obsidian-dataview)) — requêtes TABLE/LIST sur le vault
- **Templater** v2.19.3 ([SilentVoid13](https://github.com/SilentVoid13/Templater)) — templates dynamiques (toggle JS scripts laissé OFF Règle 0)
- **Excalidraw** v2.22.0 ([zsviczian](https://github.com/zsviczian/obsidian-excalidraw-plugin)) — schémas dessinés
- **Git** v2.38.2 ([Vinzent03](https://github.com/Vinzent03/obsidian-git)) — versioning auto (inactif tant que projet pas repo Git)

**Pas de plugin payant** (D3-S41, rappel D4-S38).

## Conventions

- Nommage `snake_case` ou `PascalCase`, pas d'espaces ni accents (compat WSL2 + Hermès).
- Dates ISO `YYYY-MM-DD`.
- Tags hiérarchiques `#domaine/sous-domaine`.
- Frontmatter YAML systématique (`title`, `created`, `tags`, `status`).
- Une idée = une note, liens `[[wikilinks]]`.

## Doc complète

`Ressources/Competences/Obsidian.md` (8 sections, 185 lignes).
