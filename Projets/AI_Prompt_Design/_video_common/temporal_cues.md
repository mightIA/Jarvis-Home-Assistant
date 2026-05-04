# Temporal cues — passage du temps en clip 5-10s

Les modèles vidéo génèrent **un seul shot continu** (pas de montage).
Pour suggérer une évolution temporelle dans le clip, utiliser des cues
temporels EN précis.

## Cues qui marchent (cross-modèles)

| Cue EN | Effet | Modèles testés |
|---|---|---|
| `over time` | Évolution graduelle | Tous |
| `gradually` | Transition douce | Tous |
| `transitioning to` | Transformation visible | Runway, Veo, Sora |
| `as ... begins to` | Action qui démarre | Tous |
| `slowly turning into` | Métamorphose | Runway, Kling |
| `the camera follows the action` | Caméra qui suit | Tous |
| `from morning light to dusk` | Light shift cinématique | Veo 3.1, Runway Gen-4 |
| `shifting from calm to urgent` | Mood arc | Sora 2, Veo 3.1 |

## Cues à éviter

| Cue EN | Pourquoi |
|---|---|
| `cut to` | Ignoré (pas de montage) |
| `next scene` | Idem |
| `meanwhile` | Ambigu, casse le shot |
| `flashback` | Non supporté |
| `then suddenly` | Cassure brutale, donne souvent du morphing chelou |
| Time labels (`2 hours later`) | Ignorés ou interprétés visuellement de façon bizarre |

## Patterns recommandés

### Évolution naturelle
```
A still lake at dawn, mist hovering on the surface. Over time, the mist
gradually lifts as soft golden light spreads across the water.
```

### Action qui se déploie
```
A young chef plates a dish carefully. As she begins to garnish, the
camera slowly pushes in to her hands.
```

### Light shift cinématique
```
The interior of an old library, shifting from morning sunlight streaming
through tall windows to the warm amber glow of table lamps as evening falls.
```

## Durée pratique

| Modèle | Durée par clip | Best practice |
|---|---|---|
| Runway Gen-4 | 5 ou 10 s | Préférer 5 s, enchaîner via Aleph shot continuation |
| Pika 2.2 | 5 s (10 s extend) | 5 s puis Pikaffects pour étendre |
| Kling 2.1 | 5 ou 10 s | 10 s OK si motion claire |
| Luma Ray2 | 5 s | Keyframes start+end pour 10s composé |
| Sora 2 | 5-20 s (jusqu'à 60 sur Pro) | Plus le clip est long, plus la cohérence se dégrade |
| Veo 3.1 | 8 s par défaut | Audio synchronisé sur toute la durée |
| Hailuo 02 | 6-10 s | 6 s plus stable |

> ⚠️ **Règle générale** : un clip 5 s avec **un seul beat narratif fort**
> > qu'un clip 10 s avec 3 actions superposées.
