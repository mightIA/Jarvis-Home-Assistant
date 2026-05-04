# Catalogue Camera Concepts — Luma Ray2

## Principe

**Camera Concepts** = presets caméra disponibles dans l'UI Luma. Plus
fiables qu'un prompt caméra texte libre.

> ⚠️ **Pas combiner avec prompt caméra texte** (conflit, le preset gagne).

## Catalogue (état mai 2026)

### Mouvements basiques

| Concept | Effet |
|---|---|
| `Static` | Caméra fixe |
| `Push In` | Dolly in vers le sujet |
| `Pull Out` | Dolly out depuis le sujet |
| `Zoom In` | Zoom optique avant |
| `Zoom Out` | Zoom optique arrière |
| `Pan Left` | Pan horizontal vers la gauche |
| `Pan Right` | Pan horizontal vers la droite |
| `Tilt Up` | Tilt vertical vers le haut |
| `Tilt Down` | Tilt vertical vers le bas |

### Mouvements composés

| Concept | Effet |
|---|---|
| `Orbit Left` | Tour partiel autour du sujet, sens horaire |
| `Orbit Right` | Idem sens anti-horaire |
| `Crane Up` | Élévation verticale large |
| `Crane Down` | Descente verticale large |
| `Aerial` | Vue drone, mouvement libre |
| `Tracking Left` | Suit le sujet vers la gauche |
| `Tracking Right` | Suit le sujet vers la droite |

### Spéciaux

| Concept | Effet |
|---|---|
| `Handheld` | Tremblements légers, style documentaire |
| `Steadicam` | Mouvement fluide style cinéma |
| `Drone Reveal` | Vue drone qui s'élève et révèle |
| `Roll` | Rotation autour de l'axe optique |

## Templates

### Camera Concept seul

```
[Camera Concept]: [SUBJECT/SCENE].
```

**Exemples** :
```
Push In: the chef's hands plating the dish.
```

```
Orbit Left: the new product on a glossy pedestal.
```

```
Crane Up: the wide field of sunflowers at sunset.
```

```
Aerial: a winding road through forest hills.
```

### Camera Concept + intensité (si disponible)

Certains concepts acceptent un slider d'intensité dans l'UI. Notamment :
- `Push In` (subtle / moderate / dramatic)
- `Orbit` (partial / full)
- `Aerial` (low / mid / high altitude)

## Pièges

- ❌ Camera Concept + prompt caméra texte (conflit)
- ❌ Camera Concept ambigu sur sujet flou (le concept n'a pas de cible claire)
- ❌ Aerial sur scène d'intérieur (résultat bizarre)

## Sources

- Doc Luma : `https://lumalabs.ai` (section Camera Concepts)
