# Stable Diffusion — bibliothèque de styles testés

Briques EN en **tags pondérés** qui marchent sur SDXL / SD 1.5 / FLUX.

> ✅ après validation Mickael en cours d'itération.
> Préciser quel checkpoint a été utilisé, ça change tout.

---

## Quality stack (à mettre devant la plupart des prompts)

| Stack | Tags |
|-------|------|
| Photo (SDXL) | `(masterpiece:1.2), (photorealistic:1.3), (RAW photo:1.2), 8k, sharp focus, highly detailed` |
| Photo (SD 1.5) | `(masterpiece:1.2), (best quality:1.3), (RAW photo:1.2), 8k, ultra-detailed, sharp focus` |
| Anime (SD 1.5) | `(masterpiece:1.2), (best quality:1.2), (highly detailed:1.1), beautiful anime art` |
| Concept art (SDXL) | `(masterpiece:1.2), concept art, matte painting, 8k, ultra-detailed, ArtStation trending` |
| FLUX | (rien, FLUX gère bien sans tag stack) |

---

## Photo / réalisme

| Style | Brique EN | Validé | Checkpoint conseillé |
|-------|-----------|--------|----------------------|
| Cinematic 35mm | `cinematic photo, anamorphic lens, 35mm, shallow depth of field, color graded` | ⏳ | Juggernaut XL, RealisticVision |
| Documentary | `documentary photography, candid moment, natural lighting, slight grain, photojournalism` | ⏳ | RealisticVision, epiCRealism |
| Studio portrait | `studio portrait, softbox lighting, neutral grey backdrop, 85mm f/1.8, shallow DOF` | ⏳ | RealisticVision, AbsoluteReality |
| Polaroid | `vintage polaroid, faded colors, instant film, 1970s aesthetic` | ⏳ | RealisticVision |
| National Geographic | `National Geographic photo, photojournalism, dramatic moment, professional` | ⏳ | Juggernaut XL |
| Architectural | `architectural photography, wide-angle 24mm, leading lines, golden hour` | ⏳ | Juggernaut XL |
| Macro nature | `macro photography, extreme close-up, hyper-detailed texture, shallow DOF` | ⏳ | RealisticVision |

## Illustration

| Style | Brique EN | Validé | Checkpoint conseillé |
|-------|-----------|--------|----------------------|
| Aquarelle | `traditional watercolor painting, soft washes, paper texture, hand-painted` | ⏳ | DreamShaper, MeinaMix |
| Encre | `Japanese sumi-e ink wash, minimalist brushstrokes, white space` | ⏳ | DreamShaper |
| Crayon | `pencil sketch, hand-drawn, expressive linework, paper grain` | ⏳ | DreamShaper |
| Flat vector | `flat vector illustration, geometric shapes, limited palette, minimalist` | ⏳ | DreamShaper XL |
| Isometric 3D | `isometric 3D illustration, clean lines, soft shadows, pastel palette` | ⏳ | DreamShaper XL |
| Comic book | `comic book art, bold inked outlines, halftone shading, vibrant primary colors` | ⏳ | DreamShaper |
| Concept art | `professional concept art, matte painting, ArtStation trending, hyper-detailed` | ⏳ | DreamShaper XL |

## Anime (SD 1.5 anime models)

| Style | Brique EN | Validé | Checkpoint conseillé |
|-------|-----------|--------|----------------------|
| Ghibli | `Studio Ghibli style, hand-drawn animation, lush pastoral, Miyazaki aesthetic` | ⏳ | MeinaMix, AnythingV5 |
| Shōnen | `shounen anime, dynamic pose, motion lines, dramatic angle` | ⏳ | AnythingV5, MeinaMix |
| Shōjo | `shoujo manga, soft pastel tones, delicate linework, dreamy` | ⏳ | MeinaMix |
| Cyberpunk | `cyberpunk anime, neon city, glowing signs, rain reflections, Akira influence` | ⏳ | AnythingV5 |
| Slice of life | `slice of life anime, cosy interior, warm sunlight, peaceful` | ⏳ | MeinaMix |

## Cinéma / réalisateurs

| Réf | Brique EN | Validé |
|-----|-----------|--------|
| Wes Anderson | `Wes Anderson style, symmetric composition, pastel palette, deadpan, centered framing` | ⏳ |
| Christopher Nolan | `Christopher Nolan cinematography, IMAX scale, cool desaturated tones, dramatic shadows` | ⏳ |
| Studio Ghibli | `Studio Ghibli, hand-drawn animation, lush pastoral landscape, Miyazaki style` | ⏳ |
| Blade Runner 2049 | `Blade Runner 2049 aesthetic, neon haze, orange and teal, Roger Deakins lighting` | ⏳ |
| Denis Villeneuve | `Denis Villeneuve atmosphere, vast scale, muted palette, sci-fi minimalism` | ⏳ |

## Lighting briques

| Light | Brique EN |
|-------|-----------|
| Golden hour | `golden hour lighting, warm low sun, long shadows, soft glow` |
| Blue hour | `blue hour, twilight, cool ambient, moody` |
| Rim light | `(rim light:1.1), strong backlight, edge glow, silhouetted` |
| Rembrandt | `Rembrandt lighting, triangular cheek light, single dramatic source` |
| Softbox | `soft diffused softbox, even illumination, no harsh shadows` |
| Neon | `neon lighting, magenta and cyan glow, urban night` |
| Volumetric | `(volumetric lighting:1.2), god rays, light beams, dust particles` |
| Candlelight | `warm candlelight, intimate, flickering glow, low key` |

## Mood briques

| Mood | Brique EN |
|------|-----------|
| Mélancolique | `melancholic mood, muted tones, soft fog, contemplative` |
| Épique | `(epic atmosphere:1.2), vast scale, dramatic sky, monumental composition` |
| Cosy | `cosy atmosphere, warm interior, soft fabrics, hygge` |
| Inquiétant | `(unsettling atmosphere:1.1), dim light, eerie stillness, off-kilter` |
| Onirique | `dreamlike, ethereal, soft focus, surreal lighting` |
| Joyeux | `bright cheerful mood, vibrant colors, sunny, uplifting` |

## Checkpoints communautaires hot 2026 (ajout S90 — patches P1-12, P2-6)

### Anime / Cartoon / Illustration

| Checkpoint | Architecture | Tags qualité spécifiques | Cas d'usage |
|---|---|---|---|
| **Pony Diffusion V6 XL** | SDXL fine-tune | `score_9, score_8_up, score_7_up, source_anime, rating_safe` | Anime, NSFW, fandom |
| **Pony Diffusion V7** | **AuraFlow** (sortie oct 2025) | base différente — voir CivitAI doc | Anime nouvelle gen |
| **Illustrious-XL v0.1 / v1.0** | SDXL fine-tune | `masterpiece, best quality, very aesthetic, absurdres` | Anime, alternative à Pony |
| **NoobAI-XL** | SDXL fine-tune | tags Illu