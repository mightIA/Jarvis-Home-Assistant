# Template global de prompt image

Structure universelle, indépendante de l'IA. Sert de **squelette mental**
à Jarvis pour composer un prompt avant adaptation à la syntaxe cible.

---

## Les 12 dimensions

```
1.  SUBJECT       — Qui / quoi est représenté
2.  ACTION        — Ce que fait/subit le sujet
3.  SETTING       — Lieu, environnement, contexte
4.  TIME/WEATHER  — Moment, saison, météo
5.  STYLE         — Photo, peinture, anime, 3D, illustration...
6.  MOOD          — Émotion / ambiance dégagée
7.  COMPOSITION   — Cadrage, plan large/serré, règle des tiers
8.  ANGLE         — Vue de face, plongée, contre-plongée, low angle
9.  LENS / DOF    — Focale, ouverture, bokeh, profondeur de champ
10. LIGHTING      — Source, direction, qualité, intensité
11. COLOR         — Palette dominante, contraste, saturation
12. TECHNICAL     — Qualité, résolution, post-prod, anti-éléments
```

---

## Squelette canonique (ordre de pondération décroissante)

```
[STYLE] [SUBJECT] [ACTION], [SETTING], [TIME/WEATHER],
[COMPOSITION] [ANGLE] [LENS/DOF],
[LIGHTING], [COLOR],
[MOOD], [TECHNICAL],
[NEGATIVE / NO-LIST]
```

L'ordre compte : la plupart des modèles pondèrent davantage les premiers
mots/concepts. Mettre devant ce qui est non négociable.

---

## Mapping vers les 3 IA

### Midjourney V7

```
<STYLE keyword>, <SUBJECT> <ACTION>, <SETTING>, <TIME/WEATHER>,
<LIGHTING>, <COLOR>, <MOOD>, <LENS> --ar W:H --s 100 --c 10 --no <neg>
```

Tons : phrases descriptives plutôt que tags purs. Les paramètres
viennent à la fin.

### DALL·E 3 / gpt-image-1

```
A <STYLE> of <SUBJECT> <ACTION> in <SETTING>, during <TIME>.
The composition is <COMPOSITION> with <LIGHTING>.
The mood is <MOOD>, dominated by <COLOR>.
<TECHNICAL>.
```

Tons : narration en phrases complètes EN (ou FR). Pas de tags virgulés
en chaîne, pas de paramètres `--`.

### Stable Diffusion

```
(<STYLE>:1.2), <SUBJECT>, <ACTION>, <SETTING>, <TIME>,
(<LIGHTING>:1.1), <COMPOSITION>, <ANGLE>, <LENS>, <COLOR>,
<MOOD>, masterpiece, best quality, 8k, sharp focus

Negative: <baseline negative + ce qu'on évite>
CFG: 7  |  Steps: 30  |  Sampler: DPM++ 2M Karras  |  Size: 1024x1024
```

Tons : tags pondérés virgulés. Negative prompt obligatoire.

---

## Defaults Mickael (à enrichir dans `style_preferences.md`)

Quand une dimension est absente, appliquer ces defaults par défaut **sauf
indication contraire** dans `style_preferences.md` :

| Dimension | Default v1 |
|-----------|-----------|
| Style | photo réaliste, sauf mention contraire |
| Mood | neutre / contemplatif |
| Composition | cadrage moyen, règle des tiers |
| Lighting | naturelle, golden hour si extérieur |
| Color | palette équilibrée, légèrement désaturée |
| Technical | 8K, sharp focus, high detail |

Ces defaults seront **écrasés** par les vrais goûts Mickael au fur et à
mesure des itérations.

---

## Exemple complet (les 3 IA pour le même brief)

**Brief Mickael** : *"un vieux phare breton sous orage la nuit"*

### Midjourney V7
```
cinematic photography, an old Breton lighthouse standing on jagged cliffs,
violent storm at night, lightning striking the sea, towering waves crashing,
dramatic chiaroscuro lighting, deep blues and greys, ominous and powerful
mood, wide-angle 24mm shot, ultra-detailed --ar 16:9 --s 250 --c 5 --v 7
```

### DALL·E 3
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

### Stable Diffusion (SDXL)
```
(cinematic photo:1.2), old Breton lighthouse on jagged cliffs, violent
thunderstorm, night, lightning strike over the sea, massive crashing waves,
(dramatic chiaroscuro:1.1), deep blue and grey palette, ominous mood,
wide-angle 24mm, ultra-detailed, 8k, sharp focus, masterpiece, best quality

Negative: blurry, lowres, cartoon, anime, deformed, watermark, text,
bad anatomy, oversaturated, pastel, daylight, calm sea

CFG: 7.5 | Steps: 32 | Sampler: DPM++ 2M Karras | Size: 1344x768 (16:9)
```

---

*Version 1.0 — 2026-04-26*
