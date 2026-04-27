# Stable Diffusion — référence paramètres complète

## Paramètres de génération

### CFG Scale (Classifier-Free Guidance)

Force avec laquelle le modèle suit le prompt vs. créativité libre.

| CFG | Effet |
|-----|-------|
| 1-3 | Très libre, peu fidèle au prompt |
| 4-6 | Doux, naturel, recommandé pour photo (FLUX = 3.5) |
| 6-8 | **Sweet spot** pour SD 1.5 / SDXL la plupart des cas |
| 9-11 | Très fidèle mais commence à "cuire" |
| 12+ | Image sur-cuite, contrastes durs, "AI plastic" |

**Règle Jarvis** :
- Photo réaliste SDXL → CFG 5-7
- Anime SD 1.5 → CFG 7-8
- Concept art SDXL → CFG 7-8
- FLUX.1 → guidance 3.5 (paramètre équivalent)

### Steps

Nombre d'itérations de denoising. Plus = plus précis (jusqu'à un point).

| Steps | Effet |
|-------|-------|
| 10-15 | Trop peu, image floue / brute |
| 20-25 | Acceptable rapide |
| 25-35 | **Sweet spot** la plupart des cas |
| 40-50 | Diminishing returns, perte de temps |
| 60+ | Aucun gain notable, gaspillage GPU |

**Règle Jarvis** :
- DPM++ 2M Karras → 28-32 steps optimal
- Euler a → 25-30 steps
- LCM / Turbo / Lightning → 4-8 steps (modèles spéciaux)
- FLUX schnell → 4 steps

### Samplers (méthodes de denoising)

| Sampler | Caractère | Vitesse | Recommandé pour |
|---------|-----------|---------|-----------------|
| **DPM++ 2M Karras** | Net, détaillé | Moyen | Photo, défaut sécurisé |
| **DPM++ SDE Karras** | Variable, créatif | Lent | Concept art, exploration |
| **Euler** | Doux, prédictible | Rapide | FLUX, tests rapides |
| **Euler a** (ancestral) | Variable, créatif | Rapide | Anime, exploration |
| **Heun** | Précis | Lent | FLUX, qualité max |
| **DDIM** | Reproductible | Rapide | Img2img |
| **UniPC** | Net | Rapide | Alternative à DPM++ |
| **LMS** | Vintage SD 1.5 | Rapide | Legacy, peu utile aujourd'hui |
| **PLMS** | Legacy | Rapide | Legacy |
| **Restart** | Très bon récent | Moyen | Photo détaillée |
| **DPM++ 3M SDE Karras** | Très net | Lent | Portrait haute qualité |

### Dimensions

| Version | Native | Multiples corrects |
|---------|--------|-------------------|
| SD 1.5 | 512×512 | 512×768, 768×512 (limites au-delà) |
| SDXL | 1024×1024 | 1024×1024, 1152×896, 896×1152, 1216×832, 832×1216, 1344×768, 768×1344, 1536×640, 640×1536 |
| SD3 | 1024×1024 | similaire SDXL, plus flexible |
| FLUX | 1024×1024 | flexible 768-1536 par axe |

⚠️ Multiples de **8** strictement (SDXL) ou de **64** recommandé pour
performances.

### Seed

Reproductibilité. `-1` = aléatoire à chaque génération.

```
Seed: 1234567890   → mêmes paramètres = même image (à de rares
                     variations près selon GPU/sampler)
```

Variation autour d'un seed : "Variation seed" + "Variation strength" en
A1111.

---

## Hires fix (Auto1111 / Forge)

Pour SD 1.5 surtout. Génère petit puis upscale + refine.

| Param | Valeur typique |
|-------|----------------|
| Upscaler | `ESRGAN_4x`, `4x-UltraSharp`, `R-ESRGAN 4x+`, `Latent (nearest)` |
| Hires steps | 15-20 |
| Denoising strength | 0.4-0.55 (au-delà → modifie trop) |
| Upscale by | 1.5 ou 2.0 |

---

## Img2img

Reprise d'une image existante.

| Param | Effet |
|-------|-------|
| Denoising strength | 0.0 = identique, 1.0 = total redraw, 0.4-0.6 = sweet spot |

---

## Inpainting / Outpainting

Modification d'une zone (mask) ou extension hors cadre.

- A1111 : onglet img2img → Inpaint
- ComfyUI : nodes inpaint
- InvokeAI : canvas natif (excellent)

Modèles inpaint dédiés disponibles (`*-inpainting.safetensors`) pour
qualité supérieure.

---

## ControlNet (modèle de contrôle)

Pour imposer une structure (pose, contour, depth, segmentation...).

| Type | Usage |
|------|-------|
| **Canny** | Contours edge → respecter la silhouette |
| **OpenPose** | Squelette humain → reproduire la pose |
| **Depth** | Carte profondeur → respecter la perspective |
| **MLSD** | Lignes droites → architecture |
| **Scribble** | Croquis → guide brut |
| **Lineart** | Lineart cleaner → BD/illu |
| **Normal** | Normal map → 3D |
| **Reference** | Image référence (style/composition) |
| **Tile** | Tiling cohérent (upscale) |

Strength typique : 0.6 - 1.0. Se combine avec un prompt classique.

---

## IP-Adapter

Référence d'image de **style** ou **personnage** sans entraîner de LoRA.
Fonctionne en SD 1.5, SDXL, FLUX.

| Mode | Effet |
|------|-------|
| `IP-Adapter Plus` | Cohérence style générale |
| `IP-Adapter Face / FaceID` | Cohérence visage (référence portrait) |
| `IP-Adapter Plus Face` | Visage plus proche encore |

Strength typique : 0.5-0.8.

---

## LoRA (Low-Rank Adaptation)

Adaptateurs à charger en plus du checkpoint.

```
<lora:name:weight>     # syntaxe A1111/Forge
```

| Champ | Détails |
|-------|---------|
| `name` | nom du fichier `.safetensors` (sans extension) |
| `weight` | 0.0 à ~1.5, typique 0.4-1.0 |

Plusieurs LoRA possibles dans un prompt (max ~3-4 sinon dilution).

---

## Embeddings (Textual Inversion)

Petits fichiers `.pt` qui ajoutent un concept par token.

```
embedding_name, [reste du prompt]
```

Pour negative prompts : embeddings comme `EasyNegative`, `BadDream`,
`UnrealisticDream` à inclure direct dans le negative.

---

## Checkpoints / modèles de base

Fichier `.safetensors` 2-7 GB. Le modèle racine.

| Source | Notes |
|--------|-------|
| HuggingFace | modèles officiels (Stability, BFL) |
| CivitAI | écosystème communautaire (~100k modèles) |
| Tensor.Art | autre hub communautaire |

⚠️ Mélanger LoRA **du même format** que checkpoint (LoRA SD 1.5 ne marche
pas sur SDXL et vice-versa).

---

## VAE (Variational Autoencoder)

Composant qui encode/décode les images. Certains modèles incluent un VAE
custom (sinon utiliser `vae-ft-mse-840000` pour SD 1.5).

⚠️ VAE absent ou mauvais → couleurs ternes / image grise.

---

## Combinaisons courantes Mickael (à enrichir)

### Photo réaliste rapide (SDXL Juggernaut)
```
CFG: 6 | Steps: 28 | Sampler: DPM++ 2M Karras | Size: 1024x1024 |
VAE: sdxl_vae | Hires: off
```

### Portrait pro (SD 1.5 RealisticVision + Hires fix)
```
CFG: 6.5 | Steps: 32 | Sampler: DPM++ 2M Karras | Size: 512x768 |
VAE: vae-ft-mse | Hires: 2x ESRGAN, denoise 0.4, hires steps 18
```

### Anime (SD 1.5 MeinaMix)
```
CFG: 7 | Steps: 28 | Sampler: Euler a | Size: 512x768 |
VAE: kl-f8-anime2 | Hires: 2x Latent, denoise 0.45
```

### Concept art épique (SDXL DreamShaper)
```
CFG: 7.5 | Steps: 30 | Sampler: DPM++ SDE Karras | Size: 1536x640 (21:9)
```

### Speed run FLUX schnell
```
Guidance: 0 (schnell) | Steps: 4 | Sampler: Euler | Size: 1024x1024
```

---

## Sources

- A1111 wiki : `https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki`
- ComfyUI examples : `https://comfyanonymous.github.io/ComfyUI_examples/`
- CivitAI guides : `https://civitai.com/articles`
- BFL FLUX docs : `https://blackforestlabs.ai`
- Stability docs : `https://stability.ai/news`

---

*Version 1.0 — 2026-04-26*
