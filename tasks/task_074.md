---
id: 74
title: "Framework de génération de prompts optimisés pour 3 IA d'images (Midjourney V..."
status: testing
priority: P2
session_opened: S61
tags: [pdf]
source: "Session 61 / Demande Mickael conv parallèle ChatGPT"
---

# T#74 — Framework de génération de prompts optimisés pour 3 IA d'images (Midjourney V...

## Description

**[NOUVELLE session 61 — Projet AI Prompt Design]** Framework de génération de prompts optimisés pour 3 IA d'images (Midjourney V7 / DALL·E 3 + gpt-image-1 / Stable Diffusion 1.5+SDXL+SD3+FLUX). **25 fichiers** Markdown + 1 PDF pédagogique 12 pages dans `Projets/AI_Prompt_Design/`. **Architecture** : `README.md` + `01_PROJECT_TECHNICAL.md` (lu par Jarvis en début de conv) + `02_PROJECT_PEDAGOGIQUE.md/pdf` (doc projet) + `PROTOCOLE.md` + dossier `00_core/` transverse (6 fichiers : template global 12 dimensions, style_preferences vivant, lessons_learned vivant, library_styles ~50 entrées, error_patterns, scoring_grid /50) + 3 dossiers IA (5-6 fichiers chacun : README, prompt_template, parameters_reference, style_library, iterations_log + negative_prompt_baseline pour SD). **Pattern itératif Jarvis ↔ Mickael** : description FR → prompt EN optimisé → image générée → analyse comparative sur 12 dimensions + scoring 5×10 = /50 → v2 diff (pas de rewrite) → capitalisation `00_core/style_preferences.md` + `00_core/lessons_learned.md` + `<ia>/iterations_log.md` + `<ia>/style_library.md`. **5 améliorations intégrées** : scoring /50 / boucle d'amélioration formalisée / bibliothèque de styles réutilisables / catalogue erreurs fréquentes + correctifs / templates par IA. **Convergence** : score ≥ 40/50 = capitalisation et fin de boucle ; < 40 = v2 ciblée sur le critère le plus bas. **Règle clé** : Jarvis ne modifie jamais `00_core/*` sans accord explicite Mickael ; il propose, Mickael valide. **Hors scope v1** : IA vidéo (Runway/Pika/Kling/Luma), avatar (HeyGen/D-ID), LLM texte (Claude/Gemini/Copilot/Perplexity/Le Chat → projet jumeau possible `AI_Prompt_Text/`). **Référence** : auto-memory `project_ai_prompt_design.md`, `Projets/AI_Prompt_Design/01_PROJECT_TECHNICAL.md`, `Projets/AI_Prompt_Design/02_PROJECT_PEDAGOGIQUE.pdf`.

## Source / Échéance

Session 61 / Demande Mickael conv parallèle ChatGPT

## Statut

**S60** — système scaffolder (25 .md + PDF 12 pages).
**S69 (27/04/2026)** — audit web profond avec 4 sous-agents → rapport
`_audit_S69/RAPPORT.md` (11 P0 + 17 P1 + 12 P2 + branche vidéo 7 modèles
~45 fichiers).
**S91 (03/05/2026)** — Phase A appliquée (11 patches P0) + décisions
ouvertes Q1/Q2/Q3/Q4/Q5/Q6 actées :

- **Q1** : branche vidéo = 7 dossiers (Runway, Pika, Kling, Luma, Sora 2,
  Veo 3, Hailuo) ✅
- **Q2** : `dall-e/` renommé en `dall-e_gpt-image/` (matrice 4 modèles
  unifiée, pas de scission) ✅ — appliqué S91
- **Q3** : Option A — 12 dimensions image gardées, 3 dimensions vidéo
  séparées dans `00_core/dimensions_video.md` ✅
- **Q4** : avant Phases B/C/D → relancer WebSearch sur **FLUX.2**,
  **Pony V7**, **Veo 3 audio prompting**, **Sora 2 access status 2026** ⏳
- **Q5** : Phase A seule terminée S91, Phases B+C+D à programmer ⏳
- **Q6** : régénération `02_PROJECT_PEDAGOGIQUE.pdf` après stabilisation
  v1.1 complète (post Phase D) ⏳

**Patches P0 appliqués S91** (11/11) :
- P0-1 : `midjourney/parameters_reference.md` — `::` cassé V7 documenté
- P0-2 : idem — `--oref` + `--ow 0-1000` ajoutés, `--cref/--cw` marqués legacy
- P0-3 : idem — `--exp 0-100` + `--draft` ajoutés
- P0-4 : `midjourney/prompt_template.md` — anti-patterns V7 (`::`, biais
  photoréaliste, pixel art régression)
- P0-5 : `dall-e_gpt-image/parameters_reference.md` — matrice 4 modèles
- P0-6 : idem — params `moderation`, `background`, `output_format`,
  `partial_images`, `n` étendus, `input_fidelity`
- P0-7 : `dall-e_gpt-image/prompt_template.md` — clarif rewriter (DALL·E 3
  UI uniquement)
- P0-8 : `dall-e_gpt-image/README.md` — modèles supportés (gpt-image-1.5,
  gpt-image-2, déprécation Sora 2)
- P0-9 : `stable-diffusion/parameters_reference.md` — section SD 3.5
  (Large/Turbo/Medium, CFG 3.5-4.5, sampler couplé `dpmpp_2m + sgm_uniform`)
- P0-10 : idem — section FLUX étendue (Pro/Pro Ultra/Krea/Tools, samplers
  couplés, distilled models)
- P0-11 : `stable-diffusion/prompt_template.md` — sections Pony Diffusion
  V6 XL et Illustrious-XL avec tags qualité spécifiques

**Phase B appliquée S91** (61 nouveaux fichiers) :

- Q4 WebSearch ciblées effectuées : Sora 2 access (web/app discontinued
  26/04/2026, API jusqu'au 24/09/2026), Veo 3.1 audio prompting (format
  formel Dialogue/SFX/Ambient/Music), Runway Gen-4 + Aleph + Act-Two
  (Aleph = video-to-video novel view + shot continuation).
- `_video_common/` (3) : `camera_vocabulary_global.md`,
  `temporal_cues.md`, `image_to_video_workflow.md`
- `00_core/dimensions_video.md` : 3 dim ajoutées (Duration, Camera
  Movement, Audio) — Option A actée Q3, scoring vidéo /65.
- 7 dossiers vidéo × 6 fichiers tronc commun = 42 fichiers (README,
  prompt_template, parameters_reference, camera_vocabulary, style_library,
  iterations_log)
- 15 extras spécifiques : runway (references, act_two, aleph) ; pika
  (scene_ingredients, pikaffects) ; kling (motion_brush, master_shot) ;
  luma (keyframes, camera_concepts) ; sora (audio, cameos, access_status)
  ; veo3 (audio, structured_prompt) ; hailuo (pricing_vs_quality).

**Ajustements vs plan audit S69** :

- Renommage `act_one_guide.md` → `act_two_guide.md` (Act-One remplacé
  par Act-Two en 2026, finding WebSearch).
- Ajout `runway/aleph_guide.md` (Aleph mérite son propre guide vu
  l'ampleur des features novel view / shot continuation / object insertion).
- `sora/README.md` + `access_status.md` annoncent clairement la
  déprécation 24/09/2026 et orientent vers Veo 3.1.
- `veo3/` documente Veo **3.1** (pas Veo 3) avec format prompt structuré
  recommandé par Google.

**Total Phase B** : 61 fichiers créés sur ~45 prévus dans l'audit
(différence = extras enrichis et `_video_common/` plus dense que prévu).

**Phases C et D appliquées S91** (40 patches au total sur 4 phases) :

- **Phase C — 17 patches P1** :
  - WebSearch effectués : **FLUX.2** (sortie nov 2025, 4 modèles dont
    [dev] 32B + [klein] open génération <1s + [pro]) + **Pony V7**
    (sortie oct 2025, **architecture AuraFlow et NON SDXL**, donc
    convention différente de V6).
  - P1-1 workflow Draft V7 ; P1-2 stack créatif V7 (jusqu'à 6 références
    combinées : 2 personalization + 2 moodboards + 2 srefs + oref) ;
    P1-3 texte image V7 (--s 50, guillemets, fallback Ideogram).
  - P1-4 : 12 nouveaux styles tendance 2026 (Liminal Space / Y2K /
    Brutalist / Wabi-sabi / Solarpunk / Risograph / Editorial Fashion /
    Cozy Storybook / Dark Academia / Vaporwave / Cottagecore / Brut Tech)
    + colonnes sref/moodboard codes.
  - P1-5 : 5 techniques cohérence personnage gpt-image-2 (single-block,
    layout keywords, gen_id, batch n=8 native, multi-input edits).
  - P1-6 : modération 2026 (substitutions + `moderation="low"`).
  - P1-7 : streaming `partial_images` (1-3, +100 image tokens / partial).
  - P1-8 : 7 nouveaux styles DALL·E (Editorial Photo / Infographic Vector
    / Manga Panel / Slide Deck Hero / 3D Product Render / Watercolor
    Botanical / Pixel Art Game).
  - P1-12 : checkpoints communautaires (Pony V6 + V7 AuraFlow,
    Illustrious-XL, NoobAI, Animagine 4, Juggernaut XI, RealVisXL V5,
    EpicRealism XL, FLUX merges incl. FLUX.2 [dev]/[klein]).
  - P1-13 : **ControlNet Union SDXL** (xinsir, 12 modes en 1 fichier)
    + FLUX Tools (Depth/Canny/Fill/Redux).
  - P1-14 : **PuLID-FLUX** (best-in-class 2026 identité personnage 1 photo).
  - P1-15 : negative_prompt_baseline étendu (Pony V6 score_X tags, Pony
    V7 AuraFlow différent, Illustrious, Animagine 4, FLUX.1/2, SD 3.5).
  - P1-16 : `negativeXL_D` + `unaestheticXL` remplacent `EasyNegative`
    en SDXL.
  - P1-17 : section vidéo dans `00_core/error_patterns.md` (morphing,
    mains, `cut to`, audio désynchronisé, etc.).

- **Phase D — 12 patches P2 + régen PDF** :
  - P2-1 : section Web App vs Discord MJ (Moodboards/Personalization/
    Style Creator/Editor = web only) dans `midjourney/README.md`.
  - P2-2 : template iterations_log MJ enrichi avec Stack créatif V7
    (sref/moodboard/oref codes documentés).
  - P2-3 : mention V8/V8.1 + choix volontaire V7 dans projet.
  - P2-7 : workflow ComfyUI FLUX.1 dev + Hyper-FLUX 8 steps LoRA
    (gain ×3 vitesse, ~95% qualité).
  - P2-8 : pattern PuLID-FLUX détaillé (1 photo référence, strength
    0.7-0.9, prompt scène uniquement sans redécrire visage).
  - P2-9 : scoring vidéo /65 (/60 sans audio) intégré dans
    `00_core/scoring_grid.md`.
  - P2-10 : section "Extension vidéo" (3 dim) dans
    `00_core/prompt_template_global.md`.
  - P2-12 : `01_PROJECT_TECHNICAL.md` mis à jour §4 (convention vidéo
    7 modèles), §6 (amélioration #6 = branche vidéo), §8 (vidéo plus
    dans extensions futures, ajouts MJ V8 + FLUX.2 [pro] futurs).
  - **P2-11 = régénération `02_PROJECT_PEDAGOGIQUE.pdf` v1.1** via pandoc
    + xelatex (109 KB, section "Mise à jour v1.1 — S91" en tête, 40
    patches résumés, table comparatif v1.0 vs v1.1, 6 décisions Q1-Q6
    actées, pièges 2026 critiques).

**Avancement final S91** :

- ✅ **3 dossiers vides supprimés** (`midjourney_v7`, `dalle3_gptimage1`,
  `stable_diffusion`) via `allow_cowork_file_delete` puis `rmdir`.
- ✅ **Memory CLI local créée** : `memory/project_ai_prompt_design.md`
  + entrée dans `memory/MEMORY.md` section "Projets en cours".
- ✅ **40 patches sur 4 phases appliqués** dans la session S91.
- ✅ **6 questions ouvertes audit S69 actées** (Q1 à Q6).
- ✅ **PDF pédagogique v1.1 régénéré** post-stabilisation.

**Statut T#74** : passable en `testing` (validation usage par Mickael
sur premier brief réel) ou `done` (livrable v1.1 stabilisé). À décider.

**Prochaines étapes (hors scope T#74)** :

- Premier brief réel Mickael → cycle itératif normal (test du système)
- Migration FLUX.2 [pro] et MJ V8 quand stables
- Création éventuelle projet jumeau `AI_Prompt_Text/` (LLM texte)

**3 dossiers vides à supprimer** (créés par erreur S91 avant inspection) :
`midjourney_v7/`, `dalle3_gptimage1/`, `stable_diffusion/` — Cowork bloque
`rmdir`, à supprimer manuellement dans l'explorateur Windows ou via
`allow_cowork_file_delete`.
