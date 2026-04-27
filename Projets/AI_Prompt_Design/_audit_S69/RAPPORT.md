# Audit AI Prompt Design — S69 (27/04/2026)

> **Périmètre** : analyse approfondie du dossier `Projets/AI_Prompt_Design/`
> v1.0 (créé 26/04/2026 en session S60), recherche des patterns 2026 efficaces
> par modèle, recommandations d'amélioration, ajout de la branche vidéo.
>
> **Contrainte** : modifications confinées à `Projets/AI_Prompt_Design/`. Aucun
> patch encore appliqué — ce rapport recense les recommandations pour validation
> Mickael avant écriture sur les fichiers existants.

---

## Synthèse exécutive

| Indicateur | État |
|---|---|
| Structure projet | ✅ Solide (12 dimensions, scoring /50, error patterns, library_styles) |
| Couverture IA images | 🟠 Bonne mais obsolète sur 2 points critiques (V7 syntaxe, gpt-image-2) |
| Couverture IA vidéo | ❌ Inexistante (à créer) |
| Posture cible | v1.1 — corrections V7, gpt-image-2, FLUX écosystème, branche vidéo 7 modèles |

**Volumétrie estimée des patches** :
- **P0 (critique)** : 11 patches sur fichiers existants
- **P1 (important)** : 17 patches sur fichiers existants
- **P2 (nice-to-have)** : 12 patches + ajouts styles
- **Création** : 7 dossiers vidéo (~42 fichiers) + 1 dossier `_video_common/` (3 fichiers)

**Effort total estimé** : ~3-4h étalable sur 2 sessions, dont 1h pour la branche vidéo seule.

---

## 1. Méthodologie

4 sous-agents lancés en parallèle, chacun avec un brief ciblé sur un domaine :

| Agent | Périmètre | Tool uses (recherche web réelle) | Fiabilité findings |
|---|---|---|---|
| A | Midjourney V7 | 14 (WebSearch + WebFetch docs.midjourney.com) | 🟢 Haute |
| B | DALL·E 3 / gpt-image-1/1.5/2 | 19 (cookbook OpenAI + community + VentureBeat) | 🟢 Haute |
| C | SD 1.5 / SDXL / SD 3.5 / FLUX | 0 (knowledge cutoff janv. 2026) | 🟡 Moyenne — à valider web pour FLUX.2, Pony V7, Illustrious v2 |
| D | Modèles vidéo | 0 (knowledge cutoff janv. 2026) | 🟡 Moyenne — couverture 7 modèles solide mais sans recoupement web temps réel |

**Sources principales consultées (agents A+B)** :
- docs.midjourney.com (Version, Draft & Conversational, Omni Reference, Personalization, Moodboards, Style Reference, Text Generation)
- updates.midjourney.com (V7 update, --exp, Profiles & Moodboards)
- cookbook.openai.com (gpt-image-1.5 prompting guide, gpt-image-1 high input fidelity)
- community.openai.com (input_fidelity, transparent backgrounds, moderation regression)
- VentureBeat, PixVerse, DataCamp (gpt-image-2 review)
- srefcodes.com, midlibrary.io, srefs.co (libs sref publiques 4800+ codes)

**Recommandation** : pour les findings C et D, relancer une recherche web ciblée (skill `WebSearch` sur **FLUX.2 release**, **Pony Diffusion V7**, **Veo 3 audio prompting**, **Sora 2 access status 2026**) avant d'appliquer les patches majeurs.

---

## 2. Findings par modèle

### 2.1 Midjourney V7 — 6 nouveautés majeures non documentées

| Feature | Statut dans doc actuelle | Action |
|---|---|---|
| **Draft Mode** (10× plus rapide, bouton Enhance) | ❌ Absent | Ajouter section workflow |
| **Conversational Mode** (LLM écrit le prompt, multilingue dont FR) | ❌ Absent | Mention README |
| **Omni-Reference `--oref` + `--ow 0-1000`** (remplaçant V7 de `--cref`) | ❌ Absent | Ajouter param table, sweet spot 600-1000 |
| **Personalization V2** activée par défaut V7, blend 2 profils simultanés | 🟠 Mention `--p` mais pas V2 | Réécrire section Personalization |
| **Moodboards** (web app, code utilisable comme `--p`) | ❌ Absent | Ajouter section "Stack créatif V7" |
| **`--exp 0-100`** (deuxième dimension stylize, sweet spots 5/10/25/50) | ❌ Absent | Ajouter param table |
| **Style Creator** (génère sref code à partir d'un texte) | ❌ Absent | Mention README |

**🔴 Piège critique à corriger immédiatement** :
- `parameters_reference.md` lignes 38-40 documente `concept A ::2 concept B`, `concept ::-0.5` comme valides. **CASSÉ EN V7** — ne marche que sur V6 et antérieures. Source : aitooldiscovery.com 2026 + thecodersblog.com.

**Régression observée** :
- V7 a un **biais photoréaliste fort** : si on veut illustration/peinture, expliciter "oil painting" / "watercolor" sinon V7 dérape vers la photo.
- **Pixel art régresse en V7** : recommander de basculer en `--v 6` pour ce style.

**Sweet spots actualisés** :
- `--s` prod : **55-100** (75 = inclination communauté)
- `--c` prod : **0-25**, exploration 30-50, moodboards 60-80
- `--exp` : ne pas dépasser 50 si combiné avec `--s` ou `--p`

### 2.2 DALL·E / gpt-image — découverte majeure

**🔴 OpenAI a sorti gpt-image-2 le 21 avril 2026** (6 jours avant cette session). Le doc v1.0 du 26/04 ne le mentionne pas et liste seulement DALL·E 3 + gpt-image-1.

**Matrice modèles à intégrer** (4 modèles désormais, paramètres divergents) :

| Param | DALL·E 3 | gpt-image-1 | gpt-image-1.5 | gpt-image-2 |
|---|---|---|---|---|
| `size` | 1024² / 1024×1792 / 1792×1024 | idem | idem + 2K | idem + 2K |
| `quality` | standard/hd | high/medium/low | idem | idem |
| `style` | vivid/natural | — | — | — |
| `n` | 1 | 1-10 | 1-10 | 1-8 (cohérence native) |
| `input_fidelity` | — | low/high (edits) | ignoré | ignoré |
| `background` | — | transparent/opaque/auto | idem (generate only) | idem |
| `output_format` | — | png/jpeg/webp | idem | idem |
| `moderation` | — | auto/low | idem | idem |
| `partial_images` | — | 1-3 (streaming) | idem | idem |
| Aspect ratios | 3 standards | 3 standards | 3+ étendus | 3:1 à 1:3 |
| Prompt rewriting | ✅ actif (à bypasser) | ❌ pas de rewriter API | ❌ idem | ❌ idem |

**Implications majeures** :
1. **gpt-image-1+ via API directe = pas de prompt rewriter** → la consigne "Use this exact prompt without rewriting:" est **inutile** côté API directe (utile uniquement via ChatGPT UI ou Responses API).
2. **gpt-image-2 a la cohérence personnages native** dans un batch `n=1..8` → premier modèle OpenAI à offrir l'équivalent fonctionnel de `--cref` MJ.
3. **Texte dans l'image** : DALL·E 3 ~1-3 mots fiables, gpt-image-2 = step change (multi-line headlines, posters, manga). Ideogram reste meilleur pour typo prod fine.
4. **Modération** : assouplie mars-avril 2026 (public figures historiques OK, traits raciaux contextuels OK). `moderation="low"` débloque borderline sans toucher safety policies core.
5. **Sora 2 image generation deprecated le 24 sept 2026** → ne pas l'intégrer comme branche image.

### 2.3 Stable Diffusion / FLUX — versions à intégrer

**SD 3.5 (oct 2024)** — non couvert dans doc actuelle :
- Architecture MMDiT, 3 text encoders dont **T5-XXL** acceptant ~256 tokens (vs 77 SDXL).
- Pattern hybride : tags courts CLIP + phrase descriptive longue T5.
- Pondération `(word:1.2)` **non fiable native** — préférer reformulation et ordre.
- Variantes : Large (8B), Large Turbo (4 steps distillé), Medium (2.5B, 12 GB VRAM).
- Params : CFG 3.5-4.5, steps 28-40, sampler `dpmpp_2m + sgm_uniform`.

**FLUX écosystème 2026** — partiellement couvert :
- **FLUX.1 [pro]**, **FLUX.1.1 [pro]**, **FLUX.1.1 [pro] Ultra** (4 MP raw mode) — accès API BFL/Replicate/fal.ai
- **FLUX.1 [dev]** local 12B, **FLUX.1 [schnell]** Apache 2.0 distillé
- **FLUX.1 Krea [dev]** (juillet 2025) — anti "AI look"
- **FLUX Tools** (nov 2024) : Depth, Canny, Fill, Redux — équivalent ControlNet natif
- **FLUX.2** : à confirmer via WebSearch

**Distilled models 2026** (manquent dans doc actuelle) :
- SDXL Turbo, **SDXL Lightning** (ByteDance), **LCM-LoRA**, **Hyper-SD/Hyper-SDXL** (best in class), **TCD-LoRA**, **DMD2**.
- Règle pratique : **Hyper-SD 8 steps > SDXL Lightning > SDXL Turbo**.

**Checkpoints communautaires hot 2026** (manquent) :
- Anime/cartoon : **Pony Diffusion V6 XL**, **Illustrious-XL v0.1/v1.0**, **NoobAI-XL**, Animagine 4
- Photo : Juggernaut XI, **RealVisXL V5**, EpicRealism XL, CyberRealistic XL
- FLUX : PixelWave FLUX, STOIQO Afrodite FLUX, Flux Sigma Vision Alpha

**ControlNet/IP-Adapter à mettre à jour** :
- **ControlNet Union SDXL** (xinsir, 12 modes en 1 modèle) — à intégrer en remplacement
- **PuLID / PuLID-FLUX** > IP-Adapter FaceID pour identité
- **InstantID** (SDXL) — préservation identité visage 1 photo

**Pony Diffusion / Illustrious — règles spéciales** (manquent) :
- Pony : tags qualité obligatoires `score_9, score_8_up, score_7_up, source_anime`
- Illustrious : tags qualité différents `masterpiece, best quality, very aesthetic, absurdres`
- Non interopérable : LoRAs Pony partiellement compatibles Illustrious.

### 2.4 Branche vidéo — à créer (7 modèles recommandés)

**Tour d'horizon** :

| Modèle | Éditeur | Sortie | Force | Faiblesse | Accès |
|---|---|---|---|---|---|
| Runway Gen-4 | Runway | mars 2025 | Cohérence inter-shots, References | Coût | runwayml.com |
| Gen-3 Alpha Turbo | Runway | 2024 | Vitesse, Act One (mocap facial) | Qualité < Gen-4 | runwayml.com |
| Pika 2.1/2.2 | Pika Labs | fin 2025 | Scene Ingredients, Pikaffects | Cohérence longue moyenne | pika.art |
| Kling 2.1/Master | Kuaishou | 2025 | Réalisme physique top, Motion Brush | UI CN, censure | klingai.com |
| Luma Ray2/Flash | Luma Labs | janv. 2025 | Keyframes start+end, Camera Concepts | Détail mou | lumalabs.ai |
| Sora 2 | OpenAI | déc. 2025 | Audio natif, Cameos | Accès gated, watermark | sora.com |
| Veo 3 | Google | mai 2025 | Audio natif 4K, prompt adherence | Coût Vertex | gemini.google.com |
| (option) Hailuo 02 | MiniMax | 2025 | Rapport qualité/prix | Doc EN limitée | hailuoai.video |

**Patterns transversaux à formaliser** :

1. **Vocabulaire caméra unifié** : translation (`dolly`, `truck`, `pedestal`, `crane`), rotation (`pan`, `tilt`, `roll`), composé (`orbit`, `arc`, `tracking`, `push in`, `pull out`), style (`handheld`, `Steadicam`, `static`, `whip pan`, `dutch angle`).
2. **Temporal cues** : `over time`, `gradually`, `transitioning to`, `as ... begins to`. **Éviter** `cut to`, `next scene`, `meanwhile` (modèles font UN shot continu, pas du montage).
3. **Motion intensity** : un verbe d'action fort > 3 verbes mous.
4. **Image-to-video workflow** : générer frame de départ dans MJ/SDXL/Flux, prompter UNIQUEMENT le mouvement dans le modèle vidéo.
5. **Audio-aware prompting** (Veo 3, Sora 2) : ligne `Audio:` dédiée, décomposer dialogue/SFX/ambient/music, expliciter `no music` / `no dialogue`.

**Impact sur 00_core/** :
- `prompt_template_global.md` : nouvelle section "video extension"
- `scoring_grid.md` : ajouter Motion/temporal coherence + Camera fidelity + Audio-prompt alignment (3 critères vidéo, score séparé /15 ou intégré)
- `error_patterns.md` : section vidéo (morphing facial, mains qui se dédoublent, cuts ignorés, audio désynchronisé)
- **12 dimensions canoniques** → décision à prendre : 15 dimensions unifiées OU 12 image + 3 vidéo séparées

---

## 3. Patches recommandés (priorisés)

### Priorité P0 — critique (à appliquer en priorité)

| # | Fichier | Patch | Justification |
|---|---|---|---|
| P0-1 | `midjourney/parameters_reference.md` | Ajouter mention "**`::` multi-prompt et `::-0.5` non supportés en V7**" + retirer ces lignes des exemples valides | Ces syntaxes cassent silencieusement en V7 |
| P0-2 | `midjourney/parameters_reference.md` | Ajouter `--oref <url>` + `--ow 0-1000` dans table Image inputs ; marquer `--cref/--cw` comme "legacy V6, préférer --oref en V7" | Feature V7 majeure non documentée |
| P0-3 | `midjourney/parameters_reference.md` | Ajouter `--exp 0-100` et `--draft` dans table de base | Features V7 lancées fin 2025 |
| P0-4 | `midjourney/prompt_template.md` | Ajouter dans Anti-patterns : (1) "::" V7, (2) biais photoréaliste V7, (3) pixel art régresse V7 | Évite les fails silencieux |
| P0-5 | `dall-e/parameters_reference.md` | Ajouter matrice 4 modèles (DALL·E 3 / gpt-image-1 / 1.5 / 2) avec params divergents | Doc actuelle obsolète depuis 21/04/2026 |
| P0-6 | `dall-e/parameters_reference.md` | Documenter `moderation`, `background`, `output_format`, `partial_images`, `n` étendus, `input_fidelity` | Params API non listés |
| P0-7 | `dall-e/prompt_template.md` | Préciser que "Use this exact prompt without rewriting:" concerne UNIQUEMENT DALL·E 3 via API ou ChatGPT UI ; gpt-image-1+ via API directe = pas de rewriter | Évite la confusion paradigme |
| P0-8 | `dall-e/README.md` | Mettre à jour modèles supportés : ajouter gpt-image-1.5 et gpt-image-2 (sortie 21/04/2026) | Référence à jour |
| P0-9 | `stable-diffusion/parameters_reference.md` | Ajouter ligne SD 3.5 Large / Turbo / Medium (CFG 3.5-4.5, samplers couplés `dpmpp_2m + sgm_uniform`) | Version manquante |
| P0-10 | `stable-diffusion/parameters_reference.md` | Ajouter section FLUX étendue (Pro, Pro Ultra, Krea, Tools : Depth/Canny/Fill/Redux) | Écosystème FLUX incomplet |
| P0-11 | `stable-diffusion/prompt_template.md` | Ajouter sections **Pony V6** et **Illustrious-XL** avec leurs tags qualité spécifiques | Modèles communautaires majeurs 2026 |

### Priorité P1 — important

| # | Fichier | Patch |
|---|---|---|
| P1-1 | `midjourney/prompt_template.md` | Section "Workflow V7 recommandé" : Draft → 4-6 variations → Enhance |
| P1-2 | `midjourney/parameters_reference.md` | Section "Stack créatif V7" : combiner 2 personalization codes + 2 moodboards + 2 srefs |
| P1-3 | `midjourney/prompt_template.md` | Template "texte dans l'image V7" : guillemets + `--s 50` + recommandation Ideogram pour typo prod |
| P1-4 | `midjourney/style_library.md` | Ajouter colonnes "code sref" et "code moodboard" + 12 nouveaux styles (Liminal space, Y2K, Brutalist, Wabi-sabi, Solarpunk, Risograph, Editorial fashion, Cozy storybook, Dark academia, Vaporwave, Cottagecore, Brut tech editorial) |
| P1-5 | `dall-e/prompt_template.md` | Section "Cohérence personnage" : 5 techniques (description single-block, layout keywords, gen IDs, batch n=8 gpt-image-2, multi-input edits avec index) |
| P1-6 | `dall-e/prompt_template.md` | Section "Modération 2026" : substitutions (red liquid, draped figure, prop) + `moderation="low"` |
| P1-7 | `dall-e/parameters_reference.md` | Section streaming `partial_images` (1-3, +100 image tokens par partial) |
| P1-8 | `dall-e/style_library.md` | 7 nouveaux styles (Editorial Photo, Infographic Vector, Manga Panel, Slide Deck Hero, 3D Product Render, Watercolor Botanical, Pixel Art Game) |
| P1-9 | `dall-e/error_patterns.md` *(à créer ou intégrer dans `00_core/error_patterns.md`)* | Anti-pattern `background=transparent` sur edit endpoint gpt-image-1 (non supporté, piège silencieux) |
| P1-10 | `stable-diffusion/parameters_reference.md` | Section samplers couplés FLUX (`euler+beta`, `dpmpp_2m+sgm_uniform`, `ipndm+simple`) |
| P1-11 | `stable-diffusion/parameters_reference.md` | Section distilled models (Hyper-SD, SDXL Lightning, LCM-LoRA, TCD, DMD2) |
| P1-12 | `stable-diffusion/style_library.md` | Ajouter checkpoints (Pony V6, Illustrious-XL, NoobAI, Juggernaut XI, RealVisXL V5, FLUX merges) |
| P1-13 | `stable-diffusion/style_library.md` | Section ControlNet Union SDXL (xinsir, 12 modes en 1) + FLUX Tools |
| P1-14 | `stable-diffusion/style_library.md` | Section IP-Adapter récents (PuLID, PuLID-FLUX, InstantID) |
| P1-15 | `stable-diffusion/negative_prompt_baseline.md` | Sous-sections Pony (`score_6, score_5...`), Illustrious, Animagine ; mention FLUX dev/schnell : negative inutile sauf nodes true-CFG ; SD 3.5 : negative court suffit |
| P1-16 | `stable-diffusion/negative_prompt_baseline.md` | Remplacer EasyNegative SD1.5 par negativeXL_D / unaestheticXL en SDXL |
| P1-17 | `00_core/error_patterns.md` | Section vidéo (morphing facial, mains qui se dédoublent, texte se déforme, cuts ignorés, audio désynchronisé) |

### Priorité P2 — nice-to-have

| # | Fichier | Patch |
|---|---|---|
| P2-1 | `midjourney/README.md` | Section "différences web app vs Discord 2026" — Moodboards/Personalization/Style Creator/Editor = web only |
| P2-2 | `midjourney/iterations_log.md` | Template entrée standardisé (date / brief / prompt complet / params / sref code / score / note) |
| P2-3 | `midjourney/README.md` | Mention V8/V8.1 (text rendering meilleur) et choix volontaire V7 dans ce projet |
| P2-4 | `dall-e/README.md` | Section déprécation Sora-2 (24 sept 2026) pour éviter confusion |
| P2-5 | `dall-e/`(scission) | **Décision à valider** : renommer `dall-e/` en `dall-e_gpt-image/` ou créer sous-dossier `gpt-image/` distinct |
| P2-6 | `stable-diffusion/style_library.md` | Section Pony V6 booru tags `score_9 score_8_up source_anime/cartoon/furry rating_safe` ; Illustrious tags `masterpiece, best quality, very aesthetic, absurdres` |
| P2-7 | `stable-diffusion/parameters_reference.md` | Workflow ComfyUI FLUX dev + Hyper-FLUX 8 steps LoRA (gain x3 vitesse) |
| P2-8 | `stable-diffusion/parameters_reference.md` | Pattern PuLID-FLUX pour identité fidèle |
| P2-9 | `00_core/scoring_grid.md` | Ajouter critères vidéo : Motion/temporal (5pts), Camera fidelity (5pts), Audio-prompt alignment (5pts) — total /65 quand vidéo |
| P2-10 | `00_core/prompt_template_global.md` | Section "video extension" avec dimensions ajoutées (Duration, Camera Movement, Audio) |
| P2-11 | `02_PROJECT_PEDAGOGIQUE.md` + `.pdf` | Régénérer après application patches majeurs |
| P2-12 | `01_PROJECT_TECHNICAL.md` | Mettre à jour §4 conventions par IA + §6 améliorations + §8 extensions futures (vidéo passe de futur à présent) |

---

## 4. Création de la branche vidéo

### Décisions à valider Mickael

**Q1 — Modèles à inclure** (la demande initiale parlait de 5, les agents recommandent 7-8) :

Recommandation : créer **7 dossiers** (les 5 demandés + `veo3` + `hailuo`) car Veo 3 et Hailuo 02 sont des leaders 2026 (audio natif Veo 3, rapport qualité/prix Hailuo). LTXV en option (local sur RTX 3090 de Mickael, intéressant mais qualité < majors).

| Dossier | Inclure ? | Justification |
|---|---|---|
| `runway/` | ✅ | Demandé, Gen-4 leader cohérence inter-shots |
| `pika/` | ✅ | Demandé, leader VFX (Pikaffects) |
| `kling/` | ✅ | Demandé, leader réalisme physique |
| `luma/` | ✅ | Demandé, leader keyframes |
| `sora/` | ✅ | Demandé, leader audio + cameos |
| `veo3/` | 🟡 | Recommandé (audio natif, accessible Gemini) |
| `hailuo/` | 🟡 | Recommandé (rapport qualité/prix) |
| `ltxv/` | ⏳ | Backlog (local RTX 3090) |
| `vidu/` | ❌ | Niché anime/multi-ref, dispensable |

**Q2 — Tronc commun par dossier vidéo** :

Recommandation : 6 fichiers communs + extras spécifiques.

```
<modele>/
├── README.md                     ← identité, forces/faiblesses, accès, pricing
├── prompt_template.md            ← templates par cas d'usage
├── parameters_reference.md       ← durée, ratios, qualité, motion, seed
├── camera_vocabulary.md          ← termes caméra reconnus par CE modèle
├── style_library.md              ← briques EN testées
├── iterations_log.md             ← vide à init
└── (extras spécifiques)
```

**Extras par modèle** :
- `runway/` → `references_guide.md` + `act_one_guide.md`
- `pika/` → `scene_ingredients_guide.md` + `pikaffects_catalog.md`
- `kling/` → `motion_brush_guide.md` + `master_shot_presets.md`
- `luma/` → `keyframes_guide.md` + `camera_concepts_catalog.md`
- `sora/` → `audio_prompting_guide.md` + `cameos_policy.md` + `access_status.md`
- `veo3/` → `audio_prompting_guide.md` + `structured_prompt_format.md`
- `hailuo/` → `pricing_vs_quality.md`

**Q3 — Dossier transversal** :

Recommandation : créer `_video_common/` à la racine du projet pour éviter la duplication :
```
_video_common/
├── camera_vocabulary_global.md   ← vocabulaire unifié (translation/rotation/composé/style)
├── temporal_cues.md              ← guide passage du temps en clip 5-10s
└── image_to_video_workflow.md    ← pattern starting frame + animation only
```

**Q4 — Impact 00_core/ — choix d'architecture** :

| Option | Description | Pour | Contre |
|---|---|---|---|
| A — 12 dimensions image + 3 vidéo séparées | Garder 12 image, créer `dimensions_video.md` parallèle | Lisibilité, séparation claire | Duplication potentielle |
| B — 15 dimensions unifiées | Étendre à 15 dans `prompt_template_global.md` | Élégance, framework unique | Confusion (Audio absent en image) |

Recommandation : **Option A** — 12 dimensions image gardées, 3 dimensions vidéo (Duration, Camera Movement, Audio) ajoutées dans un fichier séparé `00_core/dimensions_video.md`.

---

## 5. Évaluation à blanc avant/après

Voir [EVAL_AVANT_APRES.md](EVAL_AVANT_APRES.md) — 3 prompts test (1 par IA image principale) avant et après application des patches P0+P1, scorés sur :
- Couverture des 12 dimensions canoniques
- Conformité syntaxe IA (V7, langage naturel DALL·E, tags pondérés SD)
- Anti-patterns évités
- Taille/tokens
- Alignement scoring_grid.md

---

## 6. Plan de mise en œuvre proposé

### Phase A — Patches P0 sur fichiers existants (~45 min)

1. `midjourney/parameters_reference.md` — patches P0-1, P0-2, P0-3
2. `midjourney/prompt_template.md` — patch P0-4
3. `dall-e/parameters_reference.md` — patches P0-5, P0-6
4. `dall-e/prompt_template.md` — patch P0-7
5. `dall-e/README.md` — patch P0-8
6. `stable-diffusion/parameters_reference.md` — patches P0-9, P0-10
7. `stable-diffusion/prompt_template.md` — patch P0-11

### Phase B — Création branche vidéo (~1h30)

1. Création des 7 dossiers + `_video_common/`
2. Tronc commun (6 fichiers/dossier × 7 = 42 fichiers)
3. Extras spécifiques (~14 fichiers)
4. `_video_common/` (3 fichiers)
5. `00_core/dimensions_video.md` (1 fichier)

### Phase C — Patches P1 + nouveaux styles (~45 min)

17 patches P1 sur les fichiers existants + intégration des nouveaux styles dans library_styles.

### Phase D — Patches P2 et regen pédagogique (~30 min)

12 patches P2 + régénération éventuelle de `02_PROJECT_PEDAGOGIQUE.md` et son PDF.

**Total** : 3h30-4h, étalable. Phase A seule (45 min) lève les pièges critiques V7 + obsolescence DALL·E.

---

## 7. Décisions ouvertes pour Mickael

Avant tout patch, j'attends ton GO sur :

1. **Q1 — Branche vidéo** : 7 dossiers (Runway/Pika/Kling/Luma/Sora/**Veo3**/**Hailuo**) ou seulement les 5 demandés ?
2. **Q2 — `dall-e/` mixte** : on garde ce nom unique (couvrant DALL·E 3 + gpt-image-1/1.5/2) ou on scinde en `dall-e/` (legacy) + `gpt-image/` (moderne) ?
3. **Q3 — 12 dimensions** : on garde 12 image + 3 vidéo séparées (Option A) ou on unifie en 15 (Option B) ?
4. **Q4 — Validation findings C/D** : on applique les recommandations SD/FLUX et vidéo telles quelles (basées sur knowledge cutoff jan 2026), ou je relance les 2 sous-agents avec instruction explicite WebSearch pour vérifier FLUX.2, Pony V7, Veo 3 audio, Sora 2 access ?
5. **Q5 — Phasage** : on attaque par Phase A (P0) seule pour lever les pièges critiques, ou on lance le chantier complet d'un trait ?
6. **Q6 — Régénération PDF** : on régénère `02_PROJECT_PEDAGOGIQUE.pdf` après les patches majeurs, ou on attend la stabilisation v1.1 complète ?

---

## 8. Annexes

- [FINDINGS_DETAILS.md](FINDINGS_DETAILS.md) — rapports complets des 4 sous-agents (à créer si Mickael souhaite les détails bruts)
- [EVAL_AVANT_APRES.md](EVAL_AVANT_APRES.md) — évaluation textuelle des 3 prompts test

---

*Audit S69 — 27/04/2026 — Jarvis pour Mickael*
*Aucun fichier existant modifié. Tous les changements en attente de validation Mickael.*
