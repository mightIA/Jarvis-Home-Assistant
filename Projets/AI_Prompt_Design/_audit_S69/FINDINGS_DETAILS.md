# Findings détaillés — rapports bruts des 4 sous-agents

> Rapports complets retournés par les 4 sous-agents lancés en parallèle pour
> l'audit S69. Ce fichier sert de traçabilité pour les patches recommandés
> dans `RAPPORT.md`. Citer ce fichier en cas de doute sur une recommandation.

---

## Agent A — Midjourney V7 (14 tool uses, recherche web réelle)

**Sources consultées** :
- docs.midjourney.com (Version, Draft & Conversational, Omni Reference, Personalization, Moodboards, Style Reference, Text Generation)
- updates.midjourney.com (V7 update, --exp, Profiles & Moodboards)
- discuss.huggingface.co (V7 vs V6 Builder review 2026)
- dev.to (Midjourney V7 in 2026 What Changed for Builders)
- thecodersblog.com (V7 Prompt Bugs)
- aitooldiscovery.com (2026 prompts guide)
- srefcodes.com, midlibrary.io, srefs.co (libs sref publiques 4800+ codes)

### 1. Nouveautés V7 (vs V6)

- **Draft Mode** (`--draft` + bouton Imagine bar) : 10× plus rapide, ~½ GPU. Workflow : drafter avec différents `--ar`/styles, puis bouton **Enhance** pour upscale en qualité standard.
- **Conversational Mode** : bouton dans Imagine bar, multi-langues (dont FR), MJ écrit le prompt à partir d'une description.
- **Omni-Reference (`--oref <url>` + `--ow 0..1000`)** : remplace `--cref` en V7. Default `--ow 100`, sweet spot consistance forte = **600-1000**. Marche avec images hors-MJ (selfies).
- **Personalization V2** activée **par défaut en V7** (preference 85% des users). Plusieurs profils, **2 sélectionnables simultanés** → blend automatique. `--p` flag basique ou `--p <code>`.
- **Moodboards** (web app uniquement) : board d'images uploadées → code utilisable comme `--p <moodboard_code>`. Combinable jusqu'à 2 moodboards + 2 srefs + 2 personalization codes simultanément.
- **`--exp 0..100`** (expérimental, fin 2025) : "deuxième dimension" du stylize, pousse détail+créativité au prix de fidélité prompt. Sweet spots officiels MJ = **5/10/25/50**.
- **Style Creator** (web) : génère un sref code à partir d'une consigne textuelle.

### 2. Sweet spots paramètres actualisés

- `--s` : sweet spot communautaire 2026 = **55-100** (inclination 75) pour la prod, pas 100 par défaut.
- `--c` : prod = **0-25** ; exploration 30-50 ; moodboards 60-80.
- `--ow` : 0..1000, default 100. Cohérence personnage forte = **600-1000**.
- `--exp` : default 0, recommandés 5/10/25/50, **éviter > 50** si combiné `--s` ou `--p`.

### 3. Patterns communautaires émergents

- **Natural language > keyword stacking en V7** : régression vs V6. V7 préfère un brief de photographe/AD ("a tired baker kneading dough at 5am, single bare bulb overhead") à des listes de mots-clés.
- **"Quoted text"** pour le texte : V7 reste faible (pas au niveau Ideogram/V8.1), mais guillemets + `--s` < 100 améliore lisibilité.
- **`--sref random`** : applique un code random et le fige (visible dans les params), conserve via reroll/variations → moyen rapide de découvrir des styles à archiver.
- **Stack profil + sref + moodboard** : la "creative system" V7 = 1 personalization global + 1 moodboard projet + 1 sref campagne.
- **Draft → Enhance loop** : ne plus générer en standard pour explorer ; toujours drafter d'abord (10× cheaper), puis Enhance le retenu.

### 4. Anti-patterns 2026

- **`::` multi-prompts et pondérations `::2 / ::-0.5` cassés en V7** : non supportés sur le modèle V7. Rester V6 si on en dépend, sinon utiliser sref/oref/personalization. **`parameters_reference.md` lignes 38-40 obsolète pour V7.**
- **Negative weight `concept ::-0.5`** : idem, plus fiable. Préférer `--no` ou exclusions explicites.
- **V7 a un biais photoréaliste fort** : si on veut illustration/peinture, expliciter le médium.
- **Pixel art régresse en V7** : passer en V6 pour ce style.
- **"highly detailed, 8K, masterpiece" stack** : confirmé inutile/contre-productif en V7.
- **`--cref` en V7** : encore supporté mais inférieur à `--oref` ; recommander la migration.

### 5. 12 styles à ajouter

| Nom court | Brique EN |
|---|---|
| Liminal space | `liminal space photography, empty interior, fluorescent overhead, eerie stillness, 4:3` |
| Y2K aesthetic | `Y2K aesthetic, frosted plastic, chrome gradients, early 2000s tech, lens flare` |
| Brutalist arch | `brutalist concrete architecture, raw textured surfaces, harsh shadows, monumental` |
| Wabi-sabi | `wabi-sabi aesthetic, imperfect natural textures, muted earth tones, quiet beauty` |
| Solarpunk | `solarpunk illustration, lush greenery integrated with architecture, optimistic future, soft sunlight` |
| Risograph | `risograph print, limited 2-3 spot colors, slight misregistration, paper grain` |
| Editorial fashion | `editorial fashion photography, Vogue style, dramatic pose, high-key lighting, --style raw` |
| Cozy storybook | `cozy storybook illustration, soft gouache, warm palette, hand-painted texture` |
| Dark academia | `dark academia mood, oak library, candlelight, leather-bound books, autumn palette` |
| Vaporwave | `vaporwave aesthetic, pastel pink and cyan, retro grids, glitched VHS, 80s nostalgia` |
| Cottagecore | `cottagecore aesthetic, wildflower meadow, linen dress, soft golden hour, painterly` |
| Brut tech editorial | `Apple keynote photography, glass and aluminum, studio lighting on black, 1:1` |

---

## Agent B — DALL·E / gpt-image (19 tool uses, recherche web réelle)

**Sources consultées** :
- cookbook.openai.com (gpt-image-1.5 prompting guide, gpt-image-1 high input fidelity, generate_images_with_gpt_image)
- developers.openai.com (Sora 2 deprecation 24/09/2026)
- community.openai.com (5 threads : input fidelity, transparent backgrounds, pop culture moderation, prompt rewriting bypass, dalle3+gpt-image-1 tips)
- VentureBeat (ChatGPT Images 2.0 multilingual)
- PixVerse (gpt-image-2 review 2026)
- TechCrunch (OpenAI safeguards peeled back)
- DataCamp (GPT-Image-1 API guide)

### 0. Élément majeur

**OpenAI a sorti gpt-image-1.5 puis gpt-image-2** (lancé 21 avril 2026, "ChatGPT Images 2.0"). Le doc v1.0 du 26/04/2026 ne les mentionne pas et liste seulement DALL·E 3 + gpt-image-1.

### 1. gpt-image-1+ features confirmées 2026

- **`input_fidelity`** : `"high"` ou `"low"`, **uniquement endpoint `edits`**. Crucial pour faces/logos. Ignoré sur 1.5/2.
- **`background`** : `"transparent"` / `"opaque"` / `"auto"`. Transparent **uniquement sur `generate`, pas sur `edit`** (piège silencieux). Requiert `output_format=png` ou `webp`.
- **`output_format`** : `png` (défaut), `jpeg`, `webp`.
- **`output_compression`** : 0-100 % (jpeg/webp).
- **`moderation`** : `"auto"` (défaut, strict) ou `"low"` (moins restrictif, garde safety policies core).
- **`n`** : 1-10 sur gpt-image-1 ; 1-8 sur gpt-image-2 avec **continuité personnages/objets** maintenue dans le batch.
- **Multi-image input (edit)** : pas de limite documentée explicite, exemple OpenAI = 4 images. Le mask s'applique à la **première image**.
- **Streaming via Responses API** : `partial_images: 1-3`. Coût +100 image tokens par partial.
- **Aspect ratios gpt-image-2** : 3:1 à 1:3, résolution 2K supportée.

### 2. Prompt rewriting actualisé

- "Use this exact prompt without rewriting:" reste **non garanti** côté API DALL·E 3 (rewrite atténué, pas neutralisé). Lire `revised_prompt` de la response.
- Pattern qui marche mieux : **prompts ultra-détaillés et longs (200+ mots)** — moins d'ambiguïté à enrichir.
- **gpt-image-1/1.5/2 via API directe : pas de rewriter automatique**. Le rewrite n'existe que via ChatGPT UI ou tool `image_generation` du Responses API.
- **Patch concret** : préciser dans `prompt_template.md` que la consigne anti-rewriting concerne UNIQUEMENT DALL·E 3 via API ou ChatGPT.

### 3. Posters texte

- gpt-image-1 : faible, ~1-3 mots fiables.
- gpt-image-1.5 / gpt-image-2 : "step change" — multi-line headlines, poster titles, UI labels rendus correctement. Multilingue confirmé (FR, JP manga).
- Limite résiduelle : très petit texte basse résolution génère encore erreurs.
- Ideogram reste plus propre pour typo prod fine.
- Best practice : texte **entre guillemets** + police descriptive + position ("top-right corner", "centered headline").

### 4. Cohérence multi-image / personnage

5 techniques consensus :
1. **Description exhaustive single-block** par personnage : "a 30yo woman with shoulder-length auburn hair parted left, hazel eyes, freckles across nose bridge, wearing navy linen shirt and silver pendant" — sans virgules internes.
2. **Layout keywords** : `montage, grid, storyboard, comic strip, quad-diptych, film strip, split-screen`.
3. **Gen ID** (DALL·E 3 / ChatGPT) : récupérer ID, réutiliser : "using the same character as gen_id XXX, now show her at the beach". Sweet spot ~4 images, max ~6.
4. **gpt-image-2** : cohérence native dans un même batch `n=1..8`.
5. **gpt-image-1 edits multi-input** : référencer par index — "Image 1: product photo. Image 2: style reference. Apply Image 2's style to Image 1."

### 5. Modération 2026

- **Assouplissement majeur (mars-avril 2026)** : public figures, traits raciaux explicites, symboles haineux en contexte éducatif/neutre — désormais autorisés.
- **Restriction maintenue** : enfants (sexualisation, édition photo réaliste → refus dur), artistes vivants nommés.
- **Régression** : gpt-image-1 bloque parfois pop-culture qui passait sous DALL·E 3.
- **Substitutions courantes** : "blood" → "red liquid" / "crimson splatter", "nude" → "draped figure" / "classical sculpture", "weapon" → "tool" / "prop", artiste vivant → "in the style of [genre/era] illustration".
- **Levier API** : `moderation="low"` débloque borderline.

### 6. Anti-patterns 2026

- Tags virgulés à la MJ : sous-optimal sur DALL·E 3, gpt-image-1+ tolère mieux mais ne surperforme pas.
- Prompts < 30 mots : sous-spécifiés, le rewriter DALL·E 3 invente.
- Demander texte long DALL·E 3 : faux espoir, basculer gpt-image-1.5+.
- `background=transparent` sur edit endpoint gpt-image-1 : non supporté, piège silencieux.
- `input_fidelity` sur gpt-image-1.5/2 : ignoré, ne pas le mettre.
- Compter sur prompt rewriting "OFF" sur DALL·E 3 : illusoire, basculer gpt-image-1+ via API directe.

### 7. 7 styles à ajouter

| Nom | Phrase EN |
|---|---|
| Editorial Photo Magazine | "editorial fashion photography, soft window light, shallow depth of field, fine grain Kodak Portra 400 emulation" |
| Infographic Vector | "clean flat infographic, 2-color palette, isometric perspective, thin stroke icons, generous negative space" |
| Manga Panel | "black-and-white manga panel, screentone shading, dynamic speed lines, expressive line weight, vertical reading order" |
| Slide Deck Hero | "minimalist presentation hero slide, large bold sans-serif headline, single accent color, abundant whitespace" |
| 3D Product Render | "studio product render, soft three-point lighting, matte cyclorama backdrop, subtle ground reflection, octane-style materials" |
| Watercolor Botanical | "loose watercolor botanical illustration, wet-on-wet bleeds, visible paper texture, muted earth palette, hand-painted" |
| Pixel Art Game | "16-bit pixel art game asset, dithered shading, limited 32-color palette, sprite-sheet ready, transparent background" |

---

## Agent C — Stable Diffusion / FLUX (0 tool uses, knowledge cutoff janvier 2026)

> ⚠️ Ce sous-agent n'a pas effectué de WebSearch/WebFetch. Findings basés sur
> connaissances internes. À valider via WebSearch avant patch effectif pour :
> (a) sortie éventuelle FLUX.2, (b) Pony Diffusion V7, (c) Illustrious v2,
> (d) FLUX Krea licence/perfs, (e) ControlNet Union ProMax compat.

### 1. SD 3.5 (oct 2024)

- 3 variantes : Large (8B), Large Turbo (4 steps distillé), Medium (2.5B, 12 GB VRAM).
- Architecture **MMDiT** + 3 text encoders : CLIP-L + CLIP-G + **T5-XXL** (~256 tokens utiles vs 77 SDXL).
- Pattern hybride recommandé : tags courts CLIP en début + phrase descriptive longue T5.
- Pondération `(word:1.2)` **non fiable native** — préférer reformulation et ordre.
- Negative court suffit (`blurry, low quality, deformed`).
- Params Large : **CFG 3.5–4.5**, **steps 28–40**, sampler **dpmpp_2m + sgm_uniform** (ComfyUI) ou Euler.
- Turbo : **CFG 1–1.5, 4 steps, sampler euler**.
- Licence Stability AI Community (gratuit <1M $/an CA).

### 2. FLUX écosystème 2026

| Modèle | Accès | Licence | Cas d'usage |
|---|---|---|---|
| FLUX.1 [pro] | API BFL, fal.ai, Replicate | Commercial API | Qualité max, pas de poids |
| FLUX.1.1 [pro] | API BFL | Commercial API | +vitesse +adherence |
| FLUX.1.1 [pro] Ultra | API BFL | Commercial | 4 MP natif, mode "raw" photoréaliste |
| FLUX.1 [dev] | HF, ComfyUI, local | Non-commercial | Standard local 12B params |
| FLUX.1 [schnell] | HF, local | Apache 2.0 | 1-4 steps, distillé |
| FLUX.1 Krea [dev] | HF (juillet 2025) | Non-commercial | Anti "AI look", esthétique réaliste |

**FLUX.2 :** non publié au cutoff jan 2026 — vérifier WebSearch.

Prompting FLUX :
- Langage naturel long, pas de tags. Phrases complètes ordonnées (sujet → action → vêtement → décor → lumière → caméra → ambiance).
- Excellent rendu **texte dans l'image**.
- Pas de negative en mode standard (CFG=1 dev/schnell, distillation guidance ignore negative).
- True CFG 1.5-3.5 + negative seulement avec node `FluxGuidance` ou `DynamicThresholdingFull`.
- Params dev : **guidance 3.5**, **steps 20-28**, sampler **euler + simple/beta/sgm_uniform**.
- Params schnell : **guidance 0**, **steps 4**, sampler **euler + simple**.

### 3. Samplers récents

| Sampler | Forces | Cible |
|---|---|---|
| DPM++ 2M Karras | Référence SDXL | SDXL, SD 1.5 |
| **DPM++ 3M SDE Karras / Exponential** | Détails fins, +cher | SDXL |
| **Restart** | Convergence sup. few-steps | SDXL, SD 3.5 |
| **UniPC** | Rapide, stable | SDXL |
| **IPNDM / IPNDM_V** | FLUX/SD3 récents | FLUX, SD 3.5 |
| **RES_Multistep** | Qualité FLUX peu de steps | FLUX |
| **deis** | Stable, alt à dpmpp | SDXL, FLUX |
| **euler + beta** | FLUX optimal récent | FLUX dev |
| **sgm_uniform** | Scheduler SD 3.5 + FLUX | SD 3.5, FLUX |

Pattern 2026 : sur FLUX, choisir le **couple (sampler, scheduler)** — `euler/beta` ou `dpmpp_2m/sgm_uniform`.

### 4. Distilled / fast models

| Modèle | Steps | CFG | Note |
|---|---|---|---|
| SDXL Turbo | 1-4 | 1.0 | Qualité moyenne, ultra rapide |
| **SDXL Lightning** (ByteDance) | 2/4/8 | 1-2 | Meilleur compromis vs Turbo |
| LCM-LoRA | 4-8 | 1-2 | LoRA additionnel, marche sur SDXL custom |
| **Hyper-SD / Hyper-SDXL** | 1/2/4/8 | 1-2 | Best in class 2024+ |
| TCD-LoRA | 4-8 | 1 | Alternative Hyper, contrôle plus fin |
| DMD2 | 4 | 1 | Distillation NVIDIA récente |
| FLUX schnell | 1-4 | 0 | Distillé natif Apache 2.0 |
| Hyper-FLUX 8/16 steps | 8/16 | 3.5 | LoRA Hyper sur FLUX |

Règle : **Hyper-SD 8 steps > SDXL Lightning > SDXL Turbo**.

### 5. Checkpoints communautaires hot 2026

| Nom | Type | Domaine |
|---|---|---|
| **Pony Diffusion V6 XL** | SDXL fine-tune | NSFW + SFW anime/cartoon, booru tags |
| **Illustrious-XL v0.1 / v1.0** | SDXL | Anime danbooru, sup. à Pony pour SFW |
| **NoobAI-XL** | SDXL (Illustrious-based) | Anime, training étendu |
| **Animagine XL 3.1 / 4.0** | SDXL | Anime propre, prompting tagué |
| **Juggernaut XL X / XI** | SDXL | Photoréaliste polyvalent |
| **RealVisXL V5.0** | SDXL | Portrait photo |
| **EpicRealism XL / Natural Sin** | SDXL | Photo polyvalent |
| **CyberRealistic XL / Pony** | SDXL | Photo + Pony variant |
| **WAI-NSFW-illustrious-SDXL** | SDXL | Illustrious fine-tune |
| **PixelWave FLUX, STOIQO Afrodite FLUX, Flux Sigma Vision** | FLUX dev | Photo/anime FLUX-based |

### 6. ControlNet / IP-Adapter / FLUX Tools

**ControlNet SDXL :**
- **ControlNet Union SDXL** (xinsir) — un seul modèle, 12 modes (Canny, Depth, OpenPose, Scribble, Lineart, Anime Lineart, MLSD, Normal, Segment, Tile, Inpaint, Soft Edge). Remplace 12 séparés.
- **ControlNet Union ProMax** — version sup. avec inpaint/outpaint/tile renforcés.

**FLUX Tools (BFL, nov 2024) :**
- **FLUX.1 Depth [dev]** — équivalent ControlNet Depth.
- **FLUX.1 Canny [dev]** — équivalent ControlNet Canny.
- **FLUX.1 Fill [dev]** — inpainting/outpainting natif (état de l'art).
- **FLUX.1 Redux [dev]** — variation/style transfer (≈ IP-Adapter image-to-image).

**IP-Adapter récents :**
- **IP-Adapter SDXL Plus / Plus Face / FaceID Plus V2 / FaceID Portrait** — référence.
- **InstantID** (SDXL) — préservation identité visage 1 photo, supérieur à FaceID.
- **PuLID** (SDXL + FLUX) — identité fidèle sans déformation style, recommandé 2026.
- **PuLID-FLUX v0.9.x** — port FLUX, qualité ID nettement >IP-Adapter.

### 7. Pony Diffusion / Illustrious

**Pony V6 XL** :
- Booru tags **+ tags qualité obligatoires** : `score_9, score_8_up, score_7_up, source_anime` (ou `source_furry`, `source_cartoon`, `source_pony`).
- `rating_safe / rating_questionable / rating_explicit` pour contrôler NSFW.
- CFG 6-8, steps 25-30, DPM++ 2M Karras.
- Negative : `score_6, score_5, score_4, source_pony, source_furry, worst quality, low quality`.

**Illustrious-XL** :
- Booru tags **sans `score_*`** (n'a pas été entraîné dessus).
- Tags qualité : `masterpiece, best quality, very aesthetic, absurdres`.
- Negative : `lowres, bad anatomy, bad hands, text, error, missing fingers, jpeg artifacts, signature, watermark, ugly`.
- CFG 5-7, steps 28, Euler a / DPM++ 2M Karras.
- Compat. partielle avec LoRAs Pony.

**Animagine 3.1+** : tags qualité `masterpiece, best quality, newest, absurdres, highres, very aesthetic` + années (`year 2024`) pour style.

---

## Agent D — Modèles vidéo (0 tool uses, knowledge cutoff janvier 2026)

> ⚠️ Idem agent C : findings basés sur connaissances internes. Validation web
> nécessaire pour : (a) Sora 2 access status à la date courante, (b) Veo 3
> pricing Vertex AI, (c) Kling 2.1 Master dispo hors Chine, (d) Hailuo 02 doc EN.

### 1. Tour d'horizon

| Modèle | Éditeur | Sortie | Force | Faiblesse | Accès |
|---|---|---|---|---|---|
| Runway Gen-4 | Runway | mars 2025 | Cohérence inter-shots, References | Coût, durée 5/10s | runwayml.com |
| Gen-3 Alpha Turbo | Runway | 2024 | Vitesse, Act One (mocap facial) | Qualité < Gen-4 | runwayml.com |
| Pika 2.1 / 2.2 | Pika Labs | fin 2025 | Scene Ingredients, Pikaffects | Cohérence longue moyenne | pika.art |
| Kling 2.1 / Master | Kuaishou | 2025 | Réalisme physique, Motion Brush | UI CN, censure | klingai.com |
| Luma Ray2 / Flash | Luma Labs | janv. 2025 | Keyframes, Camera Concepts | Détail mou | lumalabs.ai |
| Sora 2 | OpenAI | déc. 2025 | Audio natif, Cameos | Accès gated, watermark | sora.com |
| Veo 3 | Google | mai 2025 | Audio natif 4K | Coût Vertex | gemini.google.com |
| Hailuo 02 | MiniMax | 2025 | Rapport qualité/prix | Doc EN limitée | hailuoai.video |

### 2. Runway Gen-4

- Specs : durée 5s ou 10s, ratios 16:9, 9:16, 1:1, 4:3, 3:4, 21:9.
- Modes : Text-to-Video, Image-to-Video, Video-to-Video.
- **References** (jusqu'à 3 images) pour cohérence character/scene.
- Gen-3 Turbo : Act One (drive un personnage avec une vidéo de visage source).
- **Structure prompt** : `[Camera movement] [Subject] [Action] [Setting] [Style/lighting]`
- Vocabulaire caméra : `dolly in/out`, `truck left/right`, `pan left/right`, `tilt up/down`, `pedestal up/down`, `orbit clockwise`, `crane shot`, `handheld`, `static`, `whip pan`, `zoom in/out`. Préférer **un seul** mouvement par clip 5s.
- Anti-patterns : combiner 3+ mouvements caméra ; demander des cuts (Gen-4 fait UN shot continu) ; texte lisible (mauvais).

### 3. Pika 2.x

- 1080p, durée 5s extensible, ratios 16:9, 9:16, 1:1.
- **Scene Ingredients** : upload jusqu'à ~6 images (personnage + objet + décor) → Pika compose.
- **Pikaffects** : VFX préréglés (Inflate, Melt, Explode, Crush, Squish, Cake-ify, Dissolve, Levitate).
- **Pikadditions** : ajouter objet à vidéo existante. **Pikaswaps** : remplacer élément. **Pikaframes** : transition entre 2 keyframes.
- Prompting : phrases courtes, un sujet, un mouvement clair.
- Pikaffects se déclenchent par UI, pas par texte.

### 4. Kling 2.x

- Durée 5s/10s, 1080p, ratios standards. Modes Standard/Pro/Master.
- **Motion Brush** : peindre des zones et leur assigner un vecteur de mouvement.
- **Camera Control** : presets `zoom`, `pan`, `tilt`, `roll`, `master shot`.
- Prompting : Kling absorbe les prompts longs et détaillés. Structure : `[Sujet détaillé] + [Action verbe fort] + [Décor/lumière] + [Caméra]`.
- Gère bien EN+CN, réalisme physique, multi-personnages.

### 5. Luma Ray2

- Ray2 / Ray2 Flash, durée 5s/10s, 720p/1080p. Flash = ~5x plus rapide.
- **Keyframes** : upload image début + fin, Luma interpole.
- **Camera Concepts** : presets nommés (Static, Move In/Out, Pan Left/Right, Orbit Left/Right, Crane Up/Down, Pull Out, Push In, Zoom In/Out).
- **Modify with text** : reprend une vidéo Luma avec nouveau prompt.
- **Extend** : prolonge un clip de 5s à 10/15/20s.

### 6. Sora 2 (déc. 2025)

- Durée jusqu'à ~20s (Pro), 1080p, ratios 16:9 / 9:16 / 1:1.
- **Audio natif synchronisé** (dialogues + SFX + ambiance).
- **Cameos** : insérer une personne consentante (vérification vidéo).
- Accès : application Sora (iOS US/CA), ChatGPT Pro, invite-only. Watermark obligatoire tier gratuit.
- Prompting : long, narratif, scénaristique. Structure : `[Shot type] of [Subject] [Action], [Setting], [Lighting]. [Camera movement]. Audio: ...`
- Audio explicite : `Audio: faint waves crashing, seagull cries in distance, no music.`

### 7. Veo 3 (mai 2025)

- 4K possible (Vertex), durée 8s par défaut (extensible), audio natif (dialogue+SFX+musique), excellent prompt adherence.
- Veo 3 Fast = variante rapide moins chère.
- Prompting : structure JSON-like ou paragraphe dense. Champs explicites :
  ```
  Subject: ...
  Action: ...
  Scene: ...
  Camera: ...
  Composition: ...
  Ambiance: ...
  Audio: ...
  ```

### 8. Patterns transversaux

**Vocabulaire caméra unifié** :
- Translation : `dolly in/out`, `truck left/right`, `pedestal up/down`, `crane`
- Rotation : `pan left/right`, `tilt up/down`, `roll`
- Composé : `orbit`, `arc`, `tracking shot`, `push in`, `pull out`
- Style : `handheld`, `Steadicam`, `static`, `whip pan`, `dutch angle`

**Temporal cues** :
- ✅ `over time`, `gradually`, `transitioning to`, `as ... begins to`
- ❌ `cut to`, `next scene`, `meanwhile` (modèles font UN shot)

**Image-to-video** :
1. Générer la **starting frame** dans MJ/SDXL/Flux
2. Décrire UNIQUEMENT le mouvement dans le prompt vidéo
3. Modèles compatibles : tous. Luma Keyframes = version premium (start + end frame).

**Audio-aware (Veo 3, Sora 2)** :
- Toujours ligne `Audio:` dédiée
- Décomposer : dialogue / SFX / ambient / music
- Spécifier `no music` ou `no dialogue` quand on ne veut pas

### 9. Structure recommandée par dossier vidéo

**Tronc commun (7 dossiers)** :
- `README.md`, `prompt_template.md`, `parameters_reference.md`, `camera_vocabulary.md`, `style_library.md`, `iterations_log.md`

**Extras** :
- `runway/` → `references_guide.md` + `act_one_guide.md`
- `pika/` → `scene_ingredients_guide.md` + `pikaffects_catalog.md`
- `kling/` → `motion_brush_guide.md` + `master_shot_presets.md`
- `luma/` → `keyframes_guide.md` + `camera_concepts_catalog.md`
- `sora/` → `audio_prompting_guide.md` + `cameos_policy.md` + `access_status.md`
- `veo3/` → `audio_prompting_guide.md` + `structured_prompt_format.md`
- `hailuo/` → `pricing_vs_quality.md`

**Dossier transversal** : `_video_common/` à la racine avec `camera_vocabulary_global.md`, `temporal_cues.md`, `image_to_video_workflow.md`.

### 10. Impact 00_core/

**`prompt_template_global.md`** : section "video extension" avec différences clés (sortie temporelle, caméra first-class, audio, un seul shot continu).

**`scoring_grid.md`** : 3 critères vidéo-spécifiques :
- Motion / temporal coherence (5 pts)
- Camera fidelity (5 pts)
- Audio-prompt alignment (5 pts) — Sora 2 / Veo 3 uniquement

**`error_patterns.md`** : section vidéo (morphing facial, mains qui se dédoublent, texte qui se déforme, cuts/changements de scène demandés ignorés ou cassés, caméras impossibles, audio désync, watermark Sora 2).

**12 dimensions** : passer à 15 avec `Duration` + `Camera Movement` + `Audio` OU garder 12 image + 3 vidéo séparées (option recommandée pour la séparation claire).

---

*Findings détaillés S69 — 27/04/2026 — sources des recommandations dans RAPPORT.md*
