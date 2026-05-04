# Master Shot Presets — Kling 2.1 / Master

## Principe

**Master shots** = mouvements caméra cinématographiques pré-codés dans
l'UI Kling. Plus fiables qu'un prompt caméra texte libre, surtout sur
les mouvements complexes.

> ⚠️ **Pas combiner avec Motion Brush** (instable).

## Catalogue (état mai 2026)

### Etablissement de scène

| Preset | Effet | Cas d'usage |
|---|---|---|
| `Establishing Wide` | Vue large statique sur la scène | Ouverture de scène |
| `Crane Up Reveal` | Caméra monte et révèle le décor large | Drame, paysage |
| `Helicopter Aerial` | Vue aérienne en mouvement | Drone, exploration |

### Mouvements vers le sujet

| Preset | Effet | Cas d'usage |
|---|---|---|
| `Push In Dramatic` | Dolly in soutenu vers le sujet | Tension, révélation |
| `Push In Slow` | Dolly in lent | Intimité, contemplation |
| `Pull Out Reveal` | Dolly out qui révèle le contexte | Final de scène |
| `Zoom In Subtle` | Zoom optique lent | Vintage, TV style |

### Rotations / orbites

| Preset | Effet | Cas d'usage |
|---|---|---|
| `Orbit Cinematic` | Tour complet ou partiel autour du sujet | Hero shot |
| `Arc Slow` | Demi-cercle autour du sujet | Réveal lent |
| `Spin Around` | Rotation rapide autour du sujet | Action, dynamique |

### Suivi

| Preset | Effet | Cas d'usage |
|---|---|---|
| `Tracking Forward` | Suit le sujet en avant | Marche, course |
| `Tracking Lateral` | Suit le sujet sur le côté | Conversation en marche |
| `Steadicam Follow` | Suivi fluide style Steadicam | Cinéma classique |

### Spéciaux

| Preset | Effet | Cas d'usage |
|---|---|---|
| `Dutch Angle Hold` | Caméra inclinée statique | Tension, malaise |
| `Whip Pan Transition` | Pan rapide avec flou | Transition entre 2 sujets |
| `Vertigo Effect` | Dolly + zoom inverse (Hitchcock zoom) | Vertige, désorientation |

## Templates

### Master shot + sujet contextuel

```
[Master shot preset]: [SUBJECT/SETTING context].
```

**Exemples** :
```
Establishing Wide: a vast medieval castle on a cliff at sunset. Camera reveals the surrounding landscape.
```

```
Push In Dramatic: the detective's face as he realizes the truth. 5s.
```

```
Orbit Cinematic: the new product on a marble pedestal, glossy reflections.
```

```
Vertigo Effect: the protagonist discovers the empty room, reality warps.
```

## Pièges

- ❌ Combiner Master shot preset + Motion Brush (instable)
- ❌ Combiner Master shot preset + prompt caméra texte (preset gagne)
- ❌ Vertigo Effect en < 5 s (l'effet n'a pas le temps de se développer)

## Sources

- Doc Kling : `https://klingai.com` (section Master Shot)
