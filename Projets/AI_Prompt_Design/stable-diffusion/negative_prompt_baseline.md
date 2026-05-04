# Stable Diffusion — negative prompt baseline

Negative prompts prêts à coller, par cas d'usage. À enrichir avec
l'expérience.

> **Règle** : un negative trop long (>75 tokens) est contre-productif.
> Choisir la baseline qui correspond, ajouter 2-5 mots spécifiques au
> brief, **stop**.

---

## Universal baseline (toujours utile, court)

```
lowres, blurry, jpeg artifacts, watermark, signature, text, logo,
deformed, mutated, bad anatomy, bad proportions, extra limbs, extra
fingers, fused fingers
```

Limite ~25 tokens. Ajouter selon contexte.

---

## Photo réaliste (SDXL / SD 1.5)

```
cartoon, anime, painting, illustration, sketch, 3d render, cgi, lowres,
blurry, jpeg artifacts, watermark, signature, text, logo, deformed
hands, extra fingers, fused fingers, bad anatomy, oversaturated, plastic
skin, doll-like, airbrushed, smooth skin, AI plastic
```

⚠️ "AI plastic", "plastic skin", "smooth skin" très utiles pour casser
le "AI generated" look.

---

## Anime (SD 1.5 anime checkpoints)

```
realistic, photorealistic, 3d, photo, lowres, blurry, jpeg artifacts,
watermark, signature, text, deformed, bad anatomy, bad hands, extra
fingers, fused fingers, missing fingers, extra limbs, missing limbs,
ugly, disgusting, bad proportions, mutated
```

Avec embedding `EasyNegative` ou `bad-hands-5` :
```
EasyNegative, bad-hands-5, realistic, photorealistic, 3d, photo, lowres,
watermark, text, bad anatomy
```

---

## Portrait (focus visage)

```
deformed face, bad eyes, crossed eyes, asymmetric eyes, deformed pupils,
extra eyes, missing eyes, deformed mouth, missing teeth, deformed teeth,
deformed nose, deformed ears, mutated face, plastic skin, smooth skin,
airbrushed, doll-like, lowres, blurry, jpeg artifacts, watermark, text,
oversaturated
```

---

## Mains (très problématique en SD)

À ajouter à la baseline si mains visibles dans le brief :

```
deformed hands, extra fingers, missing fingers, fused fingers, mutated
hands, malformed hands, six fingers, four fingers, bad hands, ugly hands,
extra arms, missing arms
```

Pour qualité supérieure, embeddings dédiés :
```
bad-hands-5, badhandv4, BadHands
```

---

## Concept art / fantasy

```
photo, photorealistic, lowres, blurry, jpeg artifacts, watermark,
signature, text, deformed, bad anatomy, generic, boring composition,
flat lighting, washed out colors
```

---

## Architecture / produit

```
people, person, human, deformed, bad geometry, crooked lines, lowres,
blurry, jpeg artifacts, watermark, signature, text, oversaturated,
cluttered background
```

---

## Paysage

```
people, deformed terrain, lowres, blurry, jpeg artifacts, watermark,
signature, text, oversaturated, washed out, flat lighting, fog without
reason, painting, illustration
```

---

## FLUX.1 / FLUX.2 — negative minimaliste ou inutile

FLUX.1 a moins besoin de negative prompts détaillés.

```
lowres, blurry, watermark, text
```

Souvent suffisant. Ajouter 2-3 anti-éléments spécifiques au brief.

**FLUX.1 dev / schnell** : negative **inutile** sauf si nodes ComfyUI
true-CFG activés. Le modèle est entraîné sans negative classifier.

**FLUX.2 [dev]** (nov 2025) : negative court suffit (`lowres, blurry,
watermark`). L'amélioration multi-reference conditioning rend les
anti-éléments souvent superflus.

## SD 3.5 — negative court

SD 3.5 (MMDiT, 3 text encoders dont T5-XXL) gère mieux le prompt positif.
Negative court suffit :

```
lowres, blurry, watermark, text, deformed, extra limbs
```

Pondération `(word:1.2)` **non fiable native** sur SD 3.5 — préférer
reformulation / ordre.

## Pony Diffusion V6 XL — tags qualité dans negative

Pony exige des **tags qualité spécifiques** dans le negative pour bloquer
les low-quality :

```
score_6, score_5, score_4, source_pony, source_furry (si non voulu),
worst quality, low quality, bad anatomy, blurry, jpeg artifacts,
watermark, text, signature
```

Combiné aux tags positifs `score_9, score_8_up, score_7_up` → qualité
nette.

## Pony Diffusion V7 (oct 2025, AuraFlow) — convention différente

Pony V7 utilise **AuraFlow** (pas SDXL). Negative recommandé par Civitai
docs (à confirmer en itération) :

```
worst quality, low quality, bad anatomy, blurry, jpeg artifacts,
watermark, text, signature, deformed
```

→ **Ne PAS reprendre les `score_X` de Pony V6** sur V7 (différent système).

## Illustrious-XL — negative spécifique

Tags qualité différents de Pony, ne pas mélanger :

```
worst quality, low quality, bad anatomy, blurry, jpeg artifacts,
text, watermark, signature, deformed, extra limbs
```

## Animagine 4 — negative

```
lowres, bad anatomy, bad hands, text, error, missing fingers, extra digit,
fewer digits, cropped, worst quality, low quality, normal quality,
jpeg artifacts, signature, watermark
```

---

## Embeddings populaires (à installer)

| Embedding | Usage | Plateforme |
|-----------|-------|------------|
| `EasyNegative` | Universal SD 1.5 (legacy) | CivitAI |
| `bad-hands-5` | Mains SD 1.5 | CivitAI |
| `badhandv4` | Mains SD 1.5 | CivitAI |
| `BadDream` | Universal SD 1.5 | CivitAI |
| `UnrealisticDream` | Photo réaliste SD 1.5 | CivitAI |
| `negative_hand-neg` | Mains alternative SD 1.5 | CivitAI |
| **`negativeXL_D`** | **SDXL universal — remplace EasyNegative en SDXL 2026** | **CivitAI** |
| **`unaestheticXL`** | **SDXL anti AI-look (slop)** | **CivitAI** |
| `NEGATIVE_PROMPT_FOR_SDXL` (legacy) | SDXL universal (ancien) | CivitAI |

> 🔄 **Migration 2026** : pour les nouveaux prompts SDXL, préférer
> `negativeXL_D` + `unaestheticXL` au lieu de `EasyNegative`. EasyNegative
> reste utile uniquement sur SD 1.5.

Usage : nom de l'embedding **dans le negative prompt**, comme un tag
classique.

```
EasyNegative, bad-hands-5, [autres tags negative]
```

---

## Anti-patterns negative

- ❌ Negative > 100 tokens → contre-productif, dilue
- ❌ Mettre dans le negative ce qu'on veut explicitement (ex : "happy"
  alors qu'on veut "joyful" → confusion)
- ❌ Pondération extrême `(word:2.0)` dans negative → casse le rendu
- ❌ Mettre "Bad" / "Worst" / "Ugly" sans contexte → effet aléatoire
- ❌ Recopier de longues listes vues sur Reddit sans comprendre

---

## Workflow Jarvis pour composer un negative

1. **Baseline** universal (toujours).
2. **Domaine** : ajouter le block correspondant (photo/anime/portrait/
   architecture/paysage).
3. **Spécifique brief** : ajouter 2-5 anti-éléments tirés du brief
   (ex : Mickael dit "pas de personnages" → ajouter `people, person,
   human`).
4. **Embeddings** si dispo et installé Mickael.
5. **Limite** : ~50-70 tokens total max.

---

*Version 1.0 — 2026-04-26*
