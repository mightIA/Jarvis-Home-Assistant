# Format prompt structuré — Veo 3.1

## Principe

Google recommande pour Veo 3.1 un **prompt structuré** avec des labels
explicites pour chaque dimension. Plus fiable que du prose libre.

## Template de référence

```
Subject: [Description précise du sujet principal]
Action: [Verbe + objet, action simple sur 8 s]
Setting: [Décor, lieu, time of day]
Camera: [Mouvement caméra, angle, focale]
Style: [photographic / animated / cinematic / documentary / etc.]
Lighting: [Setup lumière]
Mood: [Atmosphere générale]
Color palette: [Optional]

Audio:
- Dialogue: <si applicable>
- SFX: <si applicable>
- Ambient noise: <one-clause>
- Music: <mood/texture ou "none">
```

## Exemples complets

### Cinéma photo réaliste

```
Subject: An old fisherman with weathered face and white beard
Action: He mends a torn blue fishing net with a needle
Setting: A small Brittany harbor at dawn, fog hovering over the water
Camera: Medium close-up, slowly dollying in to his hands
Style: Documentary photography, cinematic
Lighting: Soft overcast morning light, slightly cool
Mood: Contemplative, respectful, melancholic
Color palette: Weathered greys, faded blues, rope-tan

Audio:
- SFX: pen of needle pulling through net fibers, soft seagull calls
- Ambient noise: gentle waves lapping the dock, distant boat creaks
- Music: minimal cello drone, melancholic
```

### Animation 2D / illustration

```
Subject: A young girl with red hair and a yellow dress
Action: She runs through a field, arms wide, laughing
Setting: A wide field of golden wheat at golden hour
Camera: Tracking shot from the side, following her movement
Style: Studio Ghibli inspired animation, hand-painted
Lighting: Warm golden hour, soft backlit
Mood: Joyful, free, nostalgic

Audio:
- SFX: footsteps in dry wheat, light fabric flapping
- Ambient noise: gentle wind, distant birdsong
- Music: warm orchestral piano, uplifting
```

### Scène urbaine moderne

```
Subject: A young chef in a white uniform
Action: She plates a delicate dish, finishing with a sprinkle of herbs
Setting: A modern restaurant kitchen, late evening, ambient warm light
Camera: Close-up on her hands, slow push in
Style: Cinematic photographic, shallow depth of field
Lighting: Warm overhead spotlight on the plate, ambient kitchen light
Mood: Focused, precise, elegant

Audio:
- SFX: ceramic plate placed gently, herb sprinkle, light knife sound
- Ambient noise: distant kitchen activity, soft murmur of guests
- Music: minimalist piano, jazzy and intimate
```

## Variantes du format

### Format minimal (8 lignes)

Pour briefs simples, version condensée :

```
Subject: <...>
Action: <...>
Setting: <...>
Camera: <...>
Style: <...>
Lighting: <...>
Mood: <...>

Audio: <single-clause naturel>
```

### Format avec multi-shots interdit

Veo 3.1 fait **un seul shot continu**. Ne pas écrire :

```
Shot 1: ...
Shot 2: ...
```

→ Le modèle ignore. Pour multi-shots, faire 2 prompts séparés et concat
en post.

## Pièges

- ❌ Mélanger format structuré et prose libre dans le même prompt (confusion)
- ❌ Multiples valeurs pour `Camera:` (ex : "Push in then orbit then crane up")
  → Veo 3.1 prend la première et ignore les autres en 8 s
- ❌ `Audio:` placé dans la description visuelle (toujours en bloc séparé)

## Sources

- Google Cloud blog : `https://cloud.google.com/blog/products/ai-machine-learning/ultimate-prompting-guide-for-veo-3-1`
- LTX Studio guide : `https://ltx.studio/blog/veo-prompt-guide`
