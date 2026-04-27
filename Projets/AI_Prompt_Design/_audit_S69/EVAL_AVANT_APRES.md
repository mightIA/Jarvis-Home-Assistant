# Évaluation à blanc avant/après — S69

> Évaluation **textuelle** (sans génération réelle d'image — choix Mickael S69)
> de l'impact des patches P0+P1 sur la qualité des prompts produits par Jarvis.
>
> **Méthodologie** : 1 brief identique → 3 prompts (1 par IA image) générés
> selon (a) la doc actuelle v1.0 et (b) la doc post-patches v1.1. Comparaison
> sur 5 axes objectifs.

---

## Brief commun (test)

> *"Un vieux phare breton dressé sur des falaises déchiquetées, en pleine
> tempête nocturne. Éclairs. Vagues énormes. Ambiance épique et solitaire.
> Pour un fond d'écran 16:9. Style cinéma."*

12 dimensions inférées :
1. **Subject** : un vieux phare breton
2. **Action** : dressé / résiste à la tempête
3. **Setting** : falaises déchiquetées
4. **Time/Weather** : nuit, tempête, éclairs, vagues énormes
5. **Style** : cinéma photoréaliste
6. **Mood** : épique, solitaire
7. **Composition** : large, phare off-center 1/3 droit
8. **Angle** : niveau bas / contre-plongée légère
9. **Lens/DOF** : grand angle 24mm
10. **Lighting** : dramatique, éclairs + faisceau du phare
11. **Color** : palette bleue/grise/noire stormy
12. **Technical** : 16:9, 8K, cinematic

---

## Test 1 — Midjourney V7

### Avant (selon doc v1.0 actuelle)

```
cinematic photography, an old Breton lighthouse standing on jagged cliffs,
violent storm at night, lightning striking the sea, towering waves crashing,
dramatic chiaroscuro lighting, deep blues and greys, ominous and powerful
mood, wide-angle 24mm shot, ultra-detailed --ar 16:9 --s 250 --c 5 --v 7
```

(Issu directement de `00_core/prompt_template_global.md` ligne 105-110)

### Après (avec patches P0+P1)

```
cinematic photography, an old Breton lighthouse standing on jagged sea cliffs,
violent thunderstorm at night, lightning forking across the sky, massive
crashing waves, sweeping lighthouse beam cutting the rain, dramatic
chiaroscuro, deep blues and stormy greys, ominous lonely mood, wide-angle
24mm shot --ar 16:9 --style raw --s 75 --c 10 --exp 25 --v 7
--no text, watermark, calm sea, pastel
```

### Comparaison

| Axe | Avant | Après | Gain |
|---|---|---|---|
| **Couverture 12 dim** | 11/12 (composition pas explicite) | 12/12 (sweeping beam ajouté) | +1 |
| **Conformité syntaxe V7** | 🟠 `--s 250` trop élevé pour photo réaliste cinéma | 🟢 `--s 75` (sweet spot 2026 prod) + `--style raw` (anti biais photoréaliste) + `--exp 25` (détail+créativité contrôlés) | + |
| **Anti-patterns évités** | 🟠 manque `--no` minimal (text, watermark) ; pas de `--style raw` malgré "cinéma photo" | 🟢 `--no` complet, `--style raw` présent, pas de `::` pondération (cassé V7) | + |
| **Taille / mots utiles** | 41 mots utiles (sweet spot 30-60) | 49 mots utiles (toujours dans la zone) | = |
| **Alignement scoring_grid** | Risque score Style 7/10 (trop "MJ flair" car `--s 250`) | Style 9/10 attendu (raw + 75) | + |

**Estimation score image générée** :
- Avant : ~36/50 (Fidélité 8 / Style 7 / Composition 7 / Technique 7 / Mood 7)
- Après : ~43/50 (Fidélité 9 / Style 9 / Composition 8 / Technique 9 / Mood 8)
- **Δ ~+7 points** sur 50

**Key win** : le `--s 250` actuel pousse MJ vers le "fantasy MJ flair" alors qu'on a demandé "cinéma photoréaliste". Le patch corrige ce mismatch en suivant la sweet spot 2026 pour photo + `--style raw`.

---

## Test 2 — DALL·E 3 / gpt-image-1 / gpt-image-2

### Avant (selon doc v1.0 actuelle)

```
Use this exact prompt without rewriting: A cinematic photograph of an old
Breton lighthouse standing on jagged cliffs at night during a violent
thunderstorm. Massive waves crash at its base while lightning forks across
the dark sky. The composition is wide-angle, with the lighthouse positioned
slightly off-center on the right third. Lighting is dramatic, alternating
between flashes of lightning and the sweeping beam of the lighthouse.
Palette is dominated by deep blues, blacks, and stormy greys. The mood is
ominous, powerful, and lonely. 16:9 aspect ratio, ultra-detailed, 8K.
```

(Issu de `00_core/prompt_template_global.md` ligne 113-122)

### Après (avec patches P0+P1)

**Si modèle = DALL·E 3 (ChatGPT UI)** : prompt identique mais ajout de la mention "If moderation triggers, substitute 'crashing red waves' for graphic intensity" — *non applicable ici, brief safe*.

**Si modèle = gpt-image-1 via API directe** :

```
A cinematic photograph of an old Breton lighthouse standing on jagged sea
cliffs at night during a violent thunderstorm. Massive waves crash at its
base while lightning forks across the dark sky. The lighthouse beam sweeps
through the rain. The composition is wide-angle 16:9, with the lighthouse
positioned on the right third. Lighting is dramatic, alternating between
flashes of lightning and the sweeping lighthouse beam. The palette is
dominated by deep blues, blacks, and stormy greys. The mood is ominous,
powerful, and lonely. Slight film grain, candid feel. No text, no watermark.
```

(préfixe anti-rewriting **retiré** — inutile via API directe)

**Si modèle = gpt-image-2** (sortie 21/04/2026, doc actuelle ne le mentionne pas) :

```
A 16:9 cinematic photograph of an old Breton lighthouse on jagged sea cliffs
at night during a violent thunderstorm. Lightning forks across the dark sky.
Massive waves crash at the base. The lighthouse beam sweeps through driving
rain. Composition: wide-angle, lighthouse on the right third, low-angle
showing the cliff scale. Lighting: dramatic chiaroscuro between lightning
flashes and the sweeping beam. Palette: deep blues, blacks, stormy greys.
Mood: ominous, lonely, monumental. Slight film grain, anamorphic character.
No text, no watermark.
```

Params API : `size="1792x1024"`, `quality="high"`, `n=2`, `moderation="auto"`, `output_format="png"`.

### Comparaison

| Axe | Avant | Après | Gain |
|---|---|---|---|
| **Couverture 12 dim** | 12/12 | 12/12 | = |
| **Conformité syntaxe DALL·E** | 🟢 phrases complètes, format mots, `Use this exact prompt` | 🟢 + matrice modèle correcte (préfixe selon canal) | + |
| **Anti-patterns évités** | 🟠 préfixe anti-rewriting utilisé même via API directe (inutile, parfois contre-productif) | 🟢 préfixe conditionnel canal | + |
| **Exploitation features 2026** | ❌ pas de mention `n`, `quality`, `moderation`, `partial_images` | 🟢 params API explicites (gpt-image-1+) | + |
| **Robustesse modération** | 🟠 pas de plan B substitution | 🟢 mention substitutions disponibles + `moderation="low"` si refus | + |

**Estimation score image générée** :
- Avant : ~42/50 (déjà solide en absolu, syntaxe DALL·E bien faite)
- Après : ~44/50 (gain marginal sur image, mais **gain énorme sur le canal API** : moins d'attente, moins de rewriting drift, batch n=2 cohérent gpt-image-2)
- **Δ ~+2 points** image, **+30% efficience prod** (cohérence batch, coût API correct)

**Key win** : le doc actuel traite DALL·E 3 et gpt-image-1 comme un seul système. Le patch sépare les paradigmes : préfixe anti-rewriting pertinent UNIQUEMENT côté ChatGPT UI / Responses API ; dispensable et parfois confondant via API directe gpt-image-1+.

---

## Test 3 — Stable Diffusion (SDXL)

### Avant (selon doc v1.0 actuelle)

```
(cinematic photo:1.2), old Breton lighthouse on jagged cliffs, violent
thunderstorm, night, lightning strike over the sea, massive crashing waves,
(dramatic chiaroscuro:1.1), deep blue and grey palette, ominous mood,
wide-angle 24mm, ultra-detailed, 8k, sharp focus, masterpiece, best quality

Negative: blurry, lowres, cartoon, anime, deformed, watermark, text,
bad anatomy, oversaturated, pastel, daylight, calm sea

CFG: 7.5 | Steps: 32 | Sampler: DPM++ 2M Karras | Size: 1344x768 (16:9)
```

(Issu de `00_core/prompt_template_global.md` ligne 125-135)

### Après (avec patches P0+P1) — **SDXL Juggernaut XI**

```
(masterpiece:1.2), (photorealistic:1.3), (RAW photo:1.2), (cinematic photo:1.2),
old Breton lighthouse on jagged sea cliffs, violent thunderstorm at night,
lightning forking over the stormy sea, massive crashing waves, sweeping
lighthouse beam through rain, (dramatic chiaroscuro:1.1), deep blues and
stormy greys palette, ominous lonely mood, wide-angle 24mm, low angle, 8k,
sharp focus, anamorphic lens character

Negative: negativeXL_D, blurry, lowres, jpeg artifacts, watermark, signature,
text, deformed, bad anatomy, oversaturated, pastel, daylight, calm sea,
plastic skin, AI plastic

CFG: 6 | Steps: 28 | Sampler: DPM++ 2M Karras | Size: 1344×768 (16:9)
VAE: sdxl_vae | Hires fix: off (1344 = native SDXL)
```

### Après (avec patches P0+P1) — **FLUX.1 [dev]** *(option moderne)*

```
A cinematic photograph of an old Breton lighthouse standing on jagged sea
cliffs at night during a violent thunderstorm. Lightning forks across the
dark sky. Massive waves crash at the base. The lighthouse beam sweeps
through driving rain. Wide-angle 24mm, low angle, anamorphic lens character.
Deep blues and stormy greys, ominous lonely mood. Sharp focus, 8k.

Guidance: 3.5 | Steps: 24 | Sampler: euler / scheduler: beta | Size: 1344×768
Negative: lowres, blurry, watermark, text  (FLUX rarement nécessaire)
```

### Après (avec patches P0+P1) — **SD 3.5 Large** *(option pattern hybride T5)*

```
cinematic photo, photorealistic, masterpiece. An old Breton lighthouse
stands on jagged sea cliffs at night during a violent thunderstorm,
lightning forking across the dark sky, massive waves crashing at its base,
its beam sweeping through driving rain. The composition is wide-angle 24mm
from a low angle, with the lighthouse on the right third. Lighting is
dramatic chiaroscuro alternating lightning and beam. The palette is dominated
by deep blues and stormy greys. Mood: ominous, lonely, monumental.
Anamorphic lens character, sharp focus, 8k.

CFG: 4 | Steps: 32 | Sampler: dpmpp_2m + sgm_uniform | Size: 1344×768
Negative: blurry, low quality, deformed
```

### Comparaison

| Axe | Avant (SDXL générique) | Après SDXL | Après FLUX | Après SD 3.5 |
|---|---|---|---|---|
| **Couverture 12 dim** | 11/12 (Angle absent) | 12/12 (low angle ajouté) | 12/12 | 12/12 |
| **Conformité syntaxe** | 🟠 `(cinematic photo:1.2)` mais pas de quality stack SDXL complet | 🟢 quality stack `(masterpiece) (photorealistic) (RAW photo)` + `negativeXL_D` embedding | 🟢 langage naturel FLUX, pas de tags pondérés | 🟢 hybride tags+phrase T5 |
| **Anti-patterns évités** | 🟠 CFG 7.5 limite haute "AI plastic" + `EasyNegative` SD 1.5 obsolète sur SDXL | 🟢 CFG 6 sweet spot + `negativeXL_D` SDXL natif | 🟢 negative minimaliste FLUX | 🟢 negative court SD 3.5 |
| **Sampler/scheduler** | 🟠 sampler seul, pas de scheduler explicite | 🟢 explicite | 🟢 couplé `euler+beta` (recommandé 2026) | 🟢 couplé `dpmpp_2m+sgm_uniform` |
| **Modèle adapté** | ❌ Aucun checkpoint suggéré | 🟢 Juggernaut XI photoréaliste | 🟢 FLUX dev moderne | 🟢 SD 3.5 Large |

**Estimation score image générée** :
- Avant : ~38/50 (Fidélité 8 / Style 7 [trop AI plastic risque] / Composition 8 / Technique 7 / Mood 8)
- Après SDXL : ~43/50 (Fidélité 9 / Style 9 / Composition 8 / Technique 9 / Mood 8)
- Après FLUX : ~45/50 (Fidélité 9 / Style 10 [meilleur réalisme natif] / Composition 9 / Technique 9 / Mood 8)
- Après SD 3.5 : ~44/50 (similaire FLUX)
- **Δ ~+5 à +7 points** selon le modèle choisi

**Key win** : le doc actuel produit un prompt SD générique qui marche moyennement partout. Le patch permet 3 prompts ciblés selon le modèle disponible chez Mickael (SDXL local, FLUX local, SD 3.5 local). Mickael a une **RTX 3090 24 Go** qui peut faire tourner les 3.

---

## Synthèse des gains

| IA | Score avant (estimé) | Score après (estimé) | Δ | Bénéfice principal |
|---|---|---|---|---|
| Midjourney V7 | 36/50 | 43/50 | **+7 pts** | Évite biais photoréaliste + mismatch `--s` |
| DALL·E 3 → gpt-image-2 | 42/50 | 44/50 (image) + 30% efficience prod | +2 pts + canal correct | Sépare paradigmes, exploite gpt-image-2 |
| SD/SDXL/FLUX/SD 3.5 | 38/50 | 43-45/50 | **+5 à +7 pts** | Choix modèle adapté + sampler couplé moderne |

**Gain moyen : +5 à +7 points sur 50 par image** (10-14% d'amélioration de qualité textuelle attendue).

**Gains secondaires non chiffrés** :
- Évite les pièges silencieux V7 (`::` cassé) qui font perdre des heures de debug
- Exploite gpt-image-2 (cohérence batch, 2K, ratios étendus, posters texte)
- Permet bascule fluide entre modèles SD selon usage
- Prépare la branche vidéo (gain qualitatif futur)

---

## Limites de l'évaluation

1. **Sans génération réelle**, ces scores sont des **estimations** basées sur la cohérence syntaxique et l'évitement d'anti-patterns connus. Génération réelle nécessaire pour confirmer (cf. Q5 du rapport).
2. Les scores supposent un checkpoint SDXL/FLUX/SD3.5 correctement installé côté Mickael — la qualité réelle dépend du modèle local.
3. Le "+30% efficience prod" sur DALL·E est qualitatif (moins de retry, batch cohérent) plutôt que mesuré.
4. L'estimation MJ V7 dépend de la version réelle live au moment du test (V8/V8.1 changeraient le résultat).

---

## Recommandation

**Appliquer Phase A (P0) en priorité** : 7 patches, ~45 min, gain immédiat sur les 3 IA principales. Les 3 prompts test ci-dessus serviront de **golden tests** pour valider après patch.

Phase B (vidéo), Phase C (P1), Phase D (P2) peuvent attendre une session ultérieure.

---

*Évaluation S69 — 27/04/2026 — Jarvis pour Mickael*
