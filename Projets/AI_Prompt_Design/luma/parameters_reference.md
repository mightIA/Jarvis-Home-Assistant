# Luma Ray2 / Ray2 Flash — référence paramètres

## Paramètres Ray2

| Param | Valeurs | Effet |
|---|---|---|
| Duration | 5 s | Native 5 s, étendre via composition |
| Resolution | 720p, 1080p | — |
| Aspect ratio | 16:9, 9:16, 1:1, 4:3, 3:4 | — |
| Image input | upload (keyframe start) | Image-to-video |
| Keyframe end | upload optionnel | Interpolation start→end |
| Camera Concept | preset menu | Voir camera_concepts_catalog.md |
| Loop | on / off | Génère un clip qui boucle proprement |

## Paramètres Ray2 Flash

Variante "Flash" :
- Génération ~3× plus rapide
- Coût ~50% moins cher
- Qualité inférieure sur textures fines
- **Recommandé** pour itérations rapides

## Combinaisons typiques Mickael

### Itération rapide
```
Luma Ray2 Flash, 5s, 1080p, 16:9
```

### Interpolation start + end
```
Luma Ray2, 5s, 1080p, keyframe start + keyframe end
```

### Camera Concept (orbit, push in, etc.)
```
Luma Ray2, 5s, 1080p, camera concept: <choisi>
```

### Loop infini
```
Luma Ray2, 5s, 1080p, loop: on
```

## Sources

- Doc officielle : `https://lumalabs.ai`
