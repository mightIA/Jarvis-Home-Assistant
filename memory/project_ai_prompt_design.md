---
name: AI Prompt Design — projet personnel framework prompts IA images + vidéo
description: Système structuré de génération de prompts optimisés pour 10 IA (3 images + 7 vidéo), workflow itératif Jarvis ↔ Mickael, scoring /50 image et /65 vidéo
type: project
created: 2026-04-26 (S60 — scaffold v1.0)
updated: 2026-05-03 (S90 — v1.1 = audit S69 phases A→D appliquées)
---

# Projet AI Prompt Design

## Identité

- **Nom** : AI Prompt Design
- **Localisation** : `Projets/AI_Prompt_Design/`
- **Tâche associée** : T#74 (`tasks/task_074.md`) — status `in_progress`
- **Audit en cours** : `Projets/AI_Prompt_Design/_audit_S69/RAPPORT.md`
  (4 sous-agents, 27/04/2026)

## Résumé en 30 secondes

Framework où Mickael décrit une image en FR, Jarvis génère le prompt EN
optimisé pour l'IA cible, Mickael teste, on score, on capitalise dans
les fichiers projet. Itération jusqu'à convergence (score ≥ 40/50 image
ou ≥ 52/65 vidéo).

## Architecture (post-S90)

```
Projets/AI_Prompt_Design/
├── README.md, 01_PROJECT_TECHNICAL.md (lu en début de conv),
│   02_PROJECT_PEDAGOGIQUE.md/pdf, PROTOCOLE.md
│
├── 00_core/  (transverse — base commune)
│   ├── prompt_template_global.md  (12 dim + 3 dim vidéo)
│   ├── style_preferences.md       (vivant, goûts Mickael)
│   ├── lessons_learned.md         (vivant, capitalisation)
│   ├── library_styles.md
│   ├── error_patterns.md          (+ section vidéo S90)
│   ├── scoring_grid.md            (/50 image + /65 vidéo)
│   └── dimensions_video.md        (S90 — Duration/Camera/Audio)
│
├── _audit_S69/   (audit profond avec WebSearch agents A-D)
│
├── _video_common/   (S90 — référence transverse vidéo)
│   ├── camera_vocabulary_global.md
│   ├── temporal_cues.md
│   └── image_to_video_workflow.md
│
├── midjourney/                (V7, --oref, Stack créatif, V8 mention)
├── dall-e_gpt-image/          (renommé S90, matrice 4 modèles)
├── stable-diffusion/          (SD 3.5, FLUX.2, Pony V7 AuraFlow, PuLID-FLUX)
│
├── runway/                    (Gen-4 + Aleph + Act-Two)
├── pika/                      (Scene Ingredients, Pikaffects)
├── kling/                     (Master shots, Motion Brush, physique)
├── luma/                      (Keyframes start+end, Camera Concepts)
├── sora/                      (⚠️ déprécié 24/09/2026, migrer Veo 3.1)
├── veo3/                      (Veo 3.1, audio natif structuré)
└── hailuo/                    (rapport qualité/prix)
```

## Workflow itératif Jarvis ↔ Mickael

```
1. Mickael décrit en FR
2. Jarvis lit 01_PROJECT_TECHNICAL + 00_core/style_preferences + 00_core/lessons_learned + <ia>/prompt_template
3. Jarvis extrait les 12 dim image (+ 3 dim vidéo si applicable)
4. Jarvis applique le template IA cible
5. Jarvis livre prompt + hypothèses + variantes + paramètres + suggestion v2
6. Mickael colle, génère, renvoie l'image / vidéo
7. Jarvis analyse comparative + score (/50 ou /65) + identifie gap principal
8. Jarvis propose v2 (diff uniquement) jusqu'à convergence
9. Capitalisation : update lessons_learned / style_library / iterations_log
```

## Règle clé

**Jarvis ne modifie JAMAIS `00_core/*` sans accord explicite Mickael.**
Il propose, Mickael valide.

## Décisions actées audit S69 (S90)

| Q | Décision |
|---|---|
| Q1 — branche vidéo | 7 dossiers (Runway/Pika/Kling/Luma/Sora/Veo3/Hailuo) |
| Q2 — DALL·E | renommé `dall-e/` → `dall-e_gpt-image/` (matrice 4 modèles) |
| Q3 — dimensions vidéo | Option A : 12 image + 3 vidéo séparées |
| Q4 — WebSearch | effectués sur Sora 2 access, Veo 3.1 audio, Runway Gen-4, FLUX.2, Pony V7 |
| Q5 — phasage | A → B → C → D toutes appliquées en S90 |
| Q6 — PDF | régénéré post-stabilisation v1.1 (S90) |

## Pièges 2026 critiques (intégrés post-S90)

- **MJ V7** : `::` multi-prompt cassé silencieusement (rester V6 pour ça)
- **gpt-image-2** : sorti 21/04/2026, cohérence personnages native batch n=1..8
- **Sora 2** : web/app discontinued 26/04/2026, API jusqu'au 24/09/2026 → migrer **Veo 3.1**
- **Pony V7** : architecture **AuraFlow** (pas SDXL), tags qualité différents de V6
- **`background=transparent`** ignoré silencieusement sur `client.images.edit(...)` gpt-image-1
- **`tilt`** confondu avec `pedestal` (Pika, Hailuo) — préciser

## Hors scope v1.1

- IA vidéo avatar (HeyGen, D-ID)
- LLM texte (projet jumeau possible `AI_Prompt_Text/`)
- Auto-scoring (Jarvis voit l'image et score auto)
- Export presets ComfyUI/A1111

## Liens

- Tâche : [tasks/task_074.md](../tasks/task_074.md)
- Audit S69 : [Projets/AI_Prompt_Design/_audit_S69/RAPPORT.md](../Projets/AI_Prompt_Design/_audit_S69/RAPPORT.md)
- Spec technique : [Projets/AI_Prompt_Design/01_PROJECT_TECHNICAL.md](../Projets/AI_Prompt_Design/01_PROJECT_TECHNICAL.md)
- PDF pédagogique v1.1 : [Projets/AI_Prompt_Design/02_PROJECT_PEDAGOGIQUE.pdf](../Projets/AI_Prompt_Design/02_PROJECT_PEDAGOGIQUE.pdf)
