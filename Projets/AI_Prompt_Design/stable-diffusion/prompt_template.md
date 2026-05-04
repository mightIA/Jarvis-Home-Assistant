# Stable Diffusion — template de prompt

## Approche : tags pondérés

SD utilise des **tags séparés par virgules**, avec **pondération
optionnelle** `(tag:1.2)`. C'est l'opposé de DALL·E (langage naturel).

## Structure recommandée

```
[QUALITY tags], [STYLE tag], [SUBJECT], [ACTION], [SETTING],
[TIME/WEATHER], [LIGHTING], [COMPOSITION], [LENS/ANGLE], [COLOR],
[MOOD], [TECHNICAL tags]

Negative prompt: [voir negative_prompt_baseline.md]

CFG: 6-8 | Steps: 25-35 | Sampler: DPM++ 2M Karras | Size: WxH
```

**Ordre crucial** : SD pondère plus les premiers tokens. Mettre devant
ce qui est non négociable. Limite token ~75, segments multiples possibles.

## Pondération

| Syntaxe | Effet | Notes |
|---------|-------|-------|
| `(tag)` | x1.1 | Léger boost |
| `((tag))` | x1.21 | Boost moyen |
| `(tag:1.5)` | x1.5 | Explicite (recommandé) |
| `(tag:0.7)` | x0.7 | Atténue |
| `[tag]` | x0.9 | Léger desboost |
| `[[tag]]` | x0.81 | Desboost moyen |

⚠️ `(tag:1.5)` **sans espace** après `:` sinon casse.

## Template type "photo réaliste" (SDXL / RealisticVision)

```
(masterpiece:1.2), (photorealistic:1.3), (RAW photo:1.2), [SUBJECT]
[ACTION], [SETTING], [time/weather], [lighting] lighting, sharp focus,
8k, highly detailed skin texture, depth of field, [COLOR] palette,
shot on [camera/lens], professional photography

Negative: <cf negative_prompt_baseline.md, photo block>

CFG: 6.5 | Steps: 30 | Sampler: DPM++ 2M Karras | Size: 1024x1024 (SDXL)
ou 512x768 (SD 1.5 portrait) | Hires fix: 2x si SD 1.5
```

**Exemple SDXL** :
```
(masterpiece:1.2), (photorealistic:1.3), (RAW photo:1.2), an old fisherman
mending a blue net on a wooden quay, small Brittany harbor at dawn, soft
overcast lighting, weathered rope-tan and faded blue palette, sharp focus,
8k, highly detailed skin texture, candid documentary style, shot on
Leica 35mm f/2

Negative: cartoon, anime, painting, illustration, lowres, blurry, jpeg
artifacts, watermark, text, logo, deformed hands, extra fingers, oversaturated

CFG: 6 | Steps: 32 | Sampler: DPM++ 2M Karras | Size: 1344x768 (3:2)
```

## Template type "anime / illustration" (SD 1.5 anime models)

```
(masterpiece:1.2), (best quality:1.2), (highly detailed:1.1), [anime style],
1girl/1boy, [character description], [pose], [expression], [outfit],
[setting], [lighting], [color palette], depth of field, [art reference]

Negative: <cf negative_prompt_baseline.md, anime block>

CFG: 7 | Steps: 28 | Sampler: Euler a ou DPM++ 2M Karras | Size: 768x1024
```

## Template type "concept art / fantasy" (DreamShaper XL)

```
(masterpiece:1.2), (concept art:1.2), epic [SUBJECT], [SETTING], [dramatic
lighting], [mood], detailed matte painting, ArtStation trending, by
[artist refs], 8k, ultra-detailed, cinematic composition

Negative: <cf negative_prompt_baseline.md, art block>

CFG: 7.5 | Steps: 30 | Sampler: DPM++ 2M Karras | Size: 1536x640 (21:9)
```

## Template type "portrait" (RealisticVision / epiCRealism)

```
(masterpiece:1.2), (RAW photo:1.3), portrait of a [age, gender, ethnicity]
[character], [expression], [outfit], [background], (Rembrandt lighting:1.1),
85mm f/1.8, shallow DOF, sharp focus on eyes, detailed skin pores, natural
skin tones, professional studio photography

Negative: <cf negative_prompt_baseline.md, portrait block>

CFG: 6 | Steps: 32 | Sampler: DPM++ 2M Karras | Size: 768x1024 (2:3)
Hires fix: 1.5x avec ESRGAN_4x ou 4x-UltraSharp
```

## Template type "FLUX.1" (langage plus naturel)

FLUX comprend mieux le langage naturel que SD 1.5/SDXL :

```
A photorealistic photograph of [subject] [action] in [setting], during
[time]. Lighting is [description]. The composition is [framing]. Mood
is [mood], with [color palette]. Sharp focus, 8k.

CFG: 3.5 | Steps: 20-28 | Sampler: Euler ou Heun | Size: 1024x1024
Pas besoin de negative prompt aussi détaillé qu'avec SDXL.
```

## Template type "Pony Diffusion V6 XL" (anime/cartoon/furry SDXL fine-tune)

> ⚠️ Pony exige des **tags qualité spécifiques** sans lesquels la qualité
> s'effondre. Non interopérable avec Illustrious sur les LoRAs.

```
score_9, score_8_up, score_7_up, source_anime, rating_safe,
[anime style: shojo / shonen / studio ghibli], 1girl/1boy,
[character description], [pose], [expression], [outfit],
[setting], [lighting], [color palette], depth of field

Negative: score_6, score_5, score_4, source_pony, source_furry (si non voulu),
worst quality, bad anatomy, blurry, jpeg artifacts

CFG: 6-7 | Steps: 28-32 | Sampler: DPM++ 2M Karras | Size: 1024x1024 (SDXL)
```

**Règles Pony** :
- Tags qualité **obligatoires** : `score_9, score_8_up, score_7_up` (les 3 cumulés)
- Tags source : `source_anime`, `source_cartoon`, `source_furry`
- Tags rating : `rating_safe`, `rating_questionable`, `rating_explicit`

## Template type "Illustrious-XL" (anime SDXL fine-tune, alternative à Pony)

> ⚠️ Illustrious utilise des **tags qualité différents** de Pony. Ne pas
> mélanger les deux conventions dans un même prompt.

```
masterpiece, best quality, very aesthetic, absurdres, [anime style],
1girl/1boy, [character description], [pose], [expression], [outfit],
[setting], [lighting], [color palette]

Negative: worst quality, low quality, bad anatomy, blurry, jpeg artifacts,
text, watermark, signature

CFG: 5-7 | Steps: 28-32 | Sampler: Euler a ou DPM++ 2M Karras | Size: 1024x1024
```

**Règles Illustrious** : tags qualité `masterpiece, best quality, very
aesthetic, absurdres` cumulés en début de prompt.

## LoRA

Syntaxe Auto1111/Forge : `<lora:name:weight>` à coller dans le prompt.

```
<lora:detail_tweaker_xl:0.6>, <lora:better_eyes_xl:0.4>, [reste du prompt]
```

| Type LoRA | Effet | Weight typique |
|-----------|-------|----------------|
| Detail tweaker | Plus de détails fins | 0.4 - 0.7 |
| Style LoRA | Imite un style/artiste | 0.6 - 1.0 |
| Character LoRA | Reproduit un personnage | 0.7 - 1.0 |
| Concept LoRA | Ajoute un concept (pose, objet) | 0.5 - 1.0 |
| Correctif (hands, eyes) | Corrige défauts | 0.3 - 0.5 |

## Paramètres techniques par version

| Version | CFG | Steps | Sampler | Size base |
|---------|-----|-------|---------|-----------|
| SD 1.5 | 6-8 | 25-35 | DPM++ 2M Karras / Euler a | 512x512 ou 512x768 |
| SDXL | 5-8 | 25-35 | DPM++ 2M Karras / DPM++ SDE Karras | 1024x1024 |
| SD3 | 4-6 | 28-40 | DPM++ 2M | 1024x1024 |
| FLUX.1 dev | 3.5 (guidance) | 20-28 | Euler / Heun | 1024x1024 |
| FLUX.1 schnell | 3.5 (guidance) | 4-8 | Euler | 1024x1024 (rapide) |

## Hires fix (SD 1.5 surtout)

Pour passer de 512x768 à 1024x1536 sans défauts :

```
Hires fix: ON
Upscaler: ESRGAN_4x ou 4x-UltraSharp ou Latent (nearest-exact)
Hires steps: 15-20
Denoising strength: 0.4-0.55
Upscale by: 2.0
```

## Checklist Jarvis avant de livrer un prompt SD

- [ ] Quality tags présents (`masterpiece, best quality, ...`) ?
- [ ] Sujet dans les premiers tokens ?
- [ ] Style explicite ?
- [ ] Lighting + Composition + Color présents ?
- [ ] Negative prompt fourni (baseline + spécifique) ?
- [ ] Paramètres CFG/steps/sampler/size adaptés à la version ?
- [ ] Pondération syntaxe correcte (`(word:1.2)` sans espace) ?
- [ ] Limite ~75 tokens respectée (ou bien segmentée) ?
- [ ] LoRA cohérents avec le checkpoint cible ?

## Anti-patterns SD

- ❌ Prompt sans negative → défauts récurrents (anatomie, watermarks)
- ❌ Pondération `(word: 1.2)` avec espace → cassée
- ❌ "8K, masterpiece, hyper realistic, ultra detailed, intricate" en
  chaîne sans variation → noise sémantique
- ❌ CFG 12+ → image cuite
- ❌ Mélanger LoRA incompatibles (ex : 2 character LoRA en parallèle
  sans dilution)
- ❌ Utiliser une syntaxe SDXL-style sur un checkpoint SD 1.5 booru-tags
  fine-tuné (résultats médiocres)

---

*Version 1.0 — 2026-04-26*
