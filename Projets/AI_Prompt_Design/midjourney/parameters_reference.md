# Midjourney V7 — référence paramètres complète

## Paramètres de base

| Param | Plage | Défaut | Effet |
|-------|-------|--------|-------|
| `--ar W:H` | tout ratio | 1:1 | Aspect ratio (16:9, 9:16, 3:2, 2:3, 21:9, 4:5, 5:4...) |
| `--v` | 4, 5, 5.1, 5.2, 6, 6.1, **7** | 7 | Version du modèle |
| `--niji` | 4, 5, 6, **7** | (off) | Mode anime / manga (exclusif avec --v) |
| `--s` ou `--stylize` | 0 - 1000 | 100 | Niveau d'auto-stylisation MJ |
| `--c` ou `--chaos` | 0 - 100 | 0 | Variation entre les 4 images du grid |
| `--w` ou `--weird` | 0 - 3000 | 0 | Bizarreries non-conventionnelles |
| `--q` ou `--quality` | 0.25, 0.5, 1, 2 | 1 | Temps GPU dépensé (qualité) |
| `--seed` | 0 - 4294967295 | aléatoire | Reproductibilité (memo : `--sameseed`) |
| `--style` | `raw`, `4a`, `4b`, `4c`, `cute`, `expressive`, `original`, `scenic` | (off) | Mode de stylisation |
| `--no` | mots séparés par virgule | (off) | Negative (light) |
| `--tile` | flag | off | Image tilable / pattern répétable |
| `--p` ou `--personalize` | flag ou code | off | Active ta personnalisation entraînée |

## Image inputs

| Param | Effet |
|-------|-------|
| URL en début de prompt | Image-to-image classique (mood/référence) |
| `--cref <url>` | Character reference (cohérence personnage) |
| `--cw 0-100` | Character weight (0 = visage seul, 100 = tout) |
| `--sref <url>` | Style reference (clone le style) |
| `--sref random` | Style aléatoire reproductible |
| `--sw 0-1000` | Style weight pour --sref |
| `--iw 0-2` | Image weight global (pondération de l'image vs texte) |

## Permutations et pondérations

| Syntaxe | Effet |
|---------|-------|
| `{a, b, c}` | Génère 3 prompts différents |
| `{1..5}` | Range 1, 2, 3, 4, 5 |
| `concept A :: concept B` | Sépare en deux prompts pondérés (égaux) |
| `concept A ::2 concept B ::1` | Pondération explicite |
| `concept ::-0.5` | Negative weight (similaire à `--no`) |

## Aspect ratios standard

| Ratio | Usage typique | Pixel shape (V7) |
|-------|---------------|------------------|
| `1:1` | Instagram post, avatar | 1024×1024 |
| `4:5` | Insta portrait | 916×1144 |
| `9:16` | Story / Reels / Mobile | 768×1366 |
| `2:3` | Portrait (poster, livre) | 832×1248 |
| `3:2` | Photo classique 35mm | 1248×832 |
| `16:9` | Vidéo / wallpaper desktop | 1456×816 |
| `21:9` | Cinéma anamorphique | 1680×720 |

## Stylize (`--s`) — guide pratique

| Valeur | Effet | Usage |
|--------|-------|-------|
| 0 | Aucune stylisation MJ | Maximum fidélité prompt |
| 50 | Très peu | Photo réaliste stricte |
| 100 (default) | Équilibre | La plupart des cas |
| 250 | Stylisation marquée | Concept art, dramatique |
| 500 | Très stylisé | Fantasy, surréaliste |
| 750-1000 | Délire visuel | Exploration artistique |

## Chaos (`--c`) — guide pratique

| Valeur | Effet |
|--------|-------|
| 0 | Les 4 images du grid très similaires (reproductibilité) |
| 10-25 | Variation modérée (recommandé exploration) |
| 50 | Variation importante |
| 100 | Variation maximale (les 4 images peuvent être très différentes) |

## Weird (`--w`) — guide pratique

| Valeur | Effet |
|--------|-------|
| 0 | Conventionnel |
| 250-500 | Touche d'originalité |
| 1000+ | Bizarreries franches, peut casser le sujet |
| 3000 | Délire absolu |

## Style modes (`--style`)

| Style | Effet | V applicable |
|-------|-------|--------------|
| `raw` | Moins d'auto-stylisation, plus fidèle prompt | V5.1+, V6, V7 |
| `4a, 4b, 4c` | Variantes V4 (legacy) | V4 |
| `cute` | Mignon (mode --niji) | --niji 5/6/7 |
| `expressive` | Style anime expressif | --niji 5/6 |
| `original` | --niji original | --niji 5/6 |
| `scenic` | Décors --niji | --niji 5/6 |

## Commandes web app utiles

| Action | Comment |
|--------|---------|
| Variations | Boutons V1-V4 sous le grid |
| Upscale | Boutons U1-U4 |
| Subtle / Strong variations | Sous le grid après upscale |
| Inpainting (Vary Region) | "Vary Region" sur image upscaled |
| Pan | Pan ⬅ ➡ ⬆ ⬇ pour étendre l'image |
| Zoom out | Zoom Out 1.5x ou 2x ou Custom |
| Remix mode | `/settings` → Remix ON |

## Combinaisons utiles

```bash
# Photo réaliste stricte
--style raw --s 50 --c 5 --v 7

# Concept art épique
--s 250 --c 15 --v 7

# Reproductibilité (mêmes 4 images si même prompt)
--seed 12345 --c 0 --s 100 --v 7

# Exploration créative
--c 50 --w 500 --s 250 --v 7

# Anime moderne
--niji 7 --style cute --s 150
```

## Sources

- Doc officielle : `https://docs.midjourney.com`
- `/settings` dans Discord pour ajuster les defaults compte
- Web app `https://alpha.midjourney.com` plus complète
