---
title: AI Prompt Design — Index (MOC, pointeur)
created: 2026-04-27
migrated_from: Projets/AI_Prompt_Design/ (pointeur, pas copie)
type: moc-pointeur
domaine: AI_Prompt_Design
status: operationnel-en-attente-premier-brief
maintenance: vivant (style_preferences, lessons_learned, iterations_log mis à jour à chaque itération)
tags: [ai, prompts, midjourney, dall-e, stable-diffusion, framework, pointeur]
---

# AI Prompt Design — Map of Content (pointeur)

Cet atome est un **pointeur vers le projet vivant** `Projets/AI_Prompt_Design/`. Le projet contient des **fichiers d'itération vivants** (`style_preferences.md`, `lessons_learned.md`, `<ia>/iterations_log.md`, `<ia>/style_library.md`) qui sont mis à jour à chaque génération — les dupliquer dans le vault créerait du drift.

## Quoi

Framework de génération de prompts optimisés pour **3 IA d'images** :

- **Midjourney V7** (tags + paramètres `--ar/--s/--c`)
- **DALL·E 3 / gpt-image-1** (langage naturel + verrouillage `Use this exact prompt without rewriting:`)
- **Stable Diffusion** 1.5 / SDXL / SD3 / FLUX (tags pondérés `(word:1.2)` + negative + CFG/steps/sampler)

Pattern itératif Jarvis ↔ Mickael :
1. Description FR → 12 dimensions extraites
2. Prompt EN optimisé selon syntaxe IA
3. Image générée par Mickael
4. Analyse comparative 12 dimensions + scoring 5×10 = /50
5. v2 (diff, pas rewrite)
6. Capitalisation dans `style_preferences.md` + `lessons_learned.md` + `<ia>/iterations_log.md` + `<ia>/style_library.md`

## Statut

**Opérationnel — en attente du premier brief de génération Mickael.**

Démarrage type :

> *« Jarvis, on continue AI Prompt Design. Décris-moi : [description]. IA cible : [Midjourney / DALL·E / SD] »*

Jarvis lit alors :
- `01_PROJECT_TECHNICAL.md`
- `00_core/style_preferences.md`
- `00_core/lessons_learned.md`
- `<ia>/prompt_template.md`
- `<ia>/style_library.md`

Et délivre prompt v1 + hypothèses + variantes + paramètres.

## Source vivante

📍 **Tous les fichiers réels sont dans** :

```
D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Projets\AI_Prompt_Design\
```

Structure :

| Niveau | Contenu |
|---|---|
| Racine | `README.md`, `01_PROJECT_TECHNICAL.md`, `02_PROJECT_PEDAGOGIQUE.md` (+ PDF), `PROTOCOLE.md` |
| `00_core/` | 6 fichiers transverses : `prompt_template_global.md`, `style_preferences.md` ⚡vivant, `lessons_learned.md` ⚡vivant, `library_styles.md` (~50 entrées), `error_patterns.md`, `scoring_grid.md` |
| `midjourney/` | 5 fichiers : `README`, `prompt_template`, `parameters_reference`, `style_library` ⚡vivant, `iterations_log` ⚡vivant |
| `dall-e/` | 5 fichiers (structure identique) |
| `stable-diffusion/` | 6 fichiers (idem + `negative_prompt_baseline.md`) |

> ⚡ = fichier vivant, mis à jour à chaque itération.

## Hors scope v1

- IA vidéo (Runway / Pika / Kling / Luma)
- Avatar (HeyGen / D-ID)
- LLM texte (projet jumeau possible)

## Liens

- [Wiki `20_Projets/`](../) — autres projets vault
- [Hardware_Upgrade](../Hardware_Upgrade/README.md) — projet sœur
- Auto-memory : `project_ai_prompt_design.md`

## Pourquoi pas dupliqué dans le vault

- **Document vivant** : 3 fichiers `iterations_log.md` (un par IA) + `style_preferences.md` + `lessons_learned.md` se modifient à chaque itération. Maintenir 2 copies = drift garanti.
- **Pattern S67-S68** : pour les fichiers vivants critiques, on applique « pointer, don't embed ».
- **Source = projet `Projets/AI_Prompt_Design/`** reste l'autorité unique.
