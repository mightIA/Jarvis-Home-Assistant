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
| `--p` ou `--personalize` | flag ou code | off | Active ta personnalisation entraînée (**V7 = Personalization V2 par défaut**, blend possible de 2 profils) |
| `--exp` | 0 - 100 | 0 | **V7 only** — deuxième dimension de stylize (sweet spots **5, 10, 25, 50**). Ne pas dépasser 50 si combiné avec `--s` ou `--p` |
| `--draft` | flag | off | **V7 only** — Draft Mode 10× plus rapide, basse qualité, bouton **Enhance** pour repasser en haute qualité |

## Image inputs

| Param | Effet | V applicable |
|-------|-------|--------------|
| URL en début de prompt | Image-to-image classique (mood/référence) | toutes |
| `--oref <url>` | **Omni-Reference** — référence universelle (objet, personnage, style) | **V7 only** |
| `--ow 0-1000` | Omni-Reference weight (sweet spot **600-1000** pour fidélité forte) | **V7 only** |
| `--cref <url>` | Character reference (cohérence personnage) — **legacy V6, préférer `--oref` en V7** | V6, V7 toléré |
| `--cw 0-100` | Character weight (0 = visage seul, 100 = tout) — **legacy V6** | V6, V7 toléré |
| `--sref <url>` | Style reference (clone le style) | V6, V7 |
| `--sref random` | Style aléatoire reproductible | V6, V7 |
| `--sw 0-1000` | Style weight pour --sref | V6, V7 |
| `--iw 0-2` | Image weight global (pondération de l'image vs texte) | toutes |

## Permutations et pondérations

> 🔴 **Piège V7 (avril 2026)** : la syntaxe **multi-prompt `::`**
> (séparateurs et poids explicites) **ne fonctionne plus en V7**. Elle
> reste fonctionnelle en V6 et antérieures. Source : aitooldiscovery.com,
> thecodersblog.com 2026.

| Syntaxe | Effet | V applicable |
|---------|-------|--------------|
| `{a, b, c}` | Génère 3 prompts différents | toutes |
| `{1..5}` | Range 1, 2, 3, 4, 5 | toutes |
| `concept A :: concept B` | Sépare en deux prompts pondérés (égaux) | **V6 et < seulement** |
| `concept A ::2 concept B ::1` | Pondération explicite | **V6 et < seulement** |
| `concept ::-0.5` | Negative weight (similaire à `--no`) | **V6 et < seulement** |

**Workaround V7** : utiliser `--no` pour les négatifs et reformuler la
phrase pour le multi-prompt (ou rester sur `--v 6`).

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

## Stack créatif V7 (combinaison features depuis avril 2026)

Recette pour exploiter pleinement V7 — combiner jusqu'à **6 références
visuelles** dans un seul prompt :

```
2 personalization codes (--p code1 --p code2) blendés
+ 2 moodboards (--p moodboard_code1 --p moodboard_code2)
+ 2 style references (--sref url1 --sref url2 --sw 400)
+ optionnellement 1 omni-reference (--oref url --ow 800) pour cohérence sujet
+ prompt texte court (15-25 mots)
+ --ar W:H --s 75 --c 10 --v 7
```

### Sweet spots actualisés V7

| Param | Prod | Exploration | Notes |
|---|---|---|---|
| `--s` (stylize) | **55-100** | 100-250 | 75 = inclination communauté |
| `--c` (chaos) | **0-25** | 30-50, jusqu'à 60-80 pour moodboards | — |
| `--exp` | 0-50 | jusqu'à 50 | **Ne pas dépasser 50** si combiné `--s` ou `--p` |
| `--ow` (omni-ref) | **600-1000** | 200-500 | 1000 = fidélité max au visage/objet |

### Exemple stack complet

```
A young woman walking through a misty forest at dawn, contemplative mood
--p personalCodeA --p personalCodeB
--p moodboardForestVibe
--sref https://i.imgur.com/refStyle1.jpg --sw 400
--oref https://i.imgur.com/charRef.jpg --ow 800
--ar 2:3 --s 75 --c 15 --v 7
```

### Pièges Stack créatif

- ❌ Plus de **6 références totales** = MJ confus, résultat dilué
- ❌ Codes `--p` non issus du même compte (ne fonctionne pas)
- ❌ Moodboard et personalization avec esthétiques opposées (annule)
- ❌ `--exp 80` combiné `--s 250` (sur-stylisation cassée)

## Différences Web App vs Discord (état 2026)

| Feature | Web App `alpha.midjourney.com` | Discord bot |
|---|---|---|
| Génération de base | ✅ | ✅ |
| Upscale 4K | ✅ | 🟡 (via /upscale) |
| Vary Region (inpainting) | ✅ | ✅ |
| Pan / Zoom out | ✅ | ✅ |
| **Moodboards** | ✅ | ❌ |
| **Personalization V2** | ✅ | 🟡 (lecture seule) |
| **Style Creator** | ✅ | ❌ |
| **Editor (canvas multi-image)** | ✅ | ❌ |
| **Profiles (multi-personas)** | ✅ | ❌ |
| Conversational Mode | ✅ | ❌ |

→ **Recommandation Mickael** : tout faire en web app sauf workflow legacy.

## V8 / V8.1 (à venir 2026 — mention)

Selon la roadmap MJ, V8 (puis V8.1) doivent améliorer :
- **Texte rendu fiable** (rattrapage Ideogram)
- Cohérence personnages multi-poses encore meilleure
- Vidéo native MJ (en concurrence avec Veo / Runway)

→ **Choix de ce projet (S91)** : rester sur **V7** par défaut tant que V8
n'est pas stabilisé. V8 sera intégré quand sortie + 2-3 mois retours
communauté.

## Sources

- Doc officielle : `https://docs.midjourney.com`
- `/settings` dans Discord pour ajuster les defaults compte
- Web app `https://alpha.midjourney.com` plus complète
