# Kling 2.1 / Master — référence paramètres

## Paramètres Kling 2.1

| Param | Valeurs | Effet |
|---|---|---|
| Duration | 5 s, 10 s | 10 s OK si motion claire |
| Resolution | 720p, 1080p | 1080p standard |
| Aspect ratio | 16:9, 9:16, 1:1 | — |
| Mode | Standard, Pro | Pro = +qualité +crédits |
| Image input | upload | Image-to-video |
| Motion Brush | UI tool | Painter zones animées |
| Master shot | preset | Voir master_shot_presets.md |
| Negative prompt | mots-clés | Anti-éléments |

## Paramètres Kling Master

Variante "Master" = qualité supérieure :
- Détail textures amélioré
- Physique encore plus réaliste
- Crédits ~2× supérieurs à Kling 2.1 Pro
- **Recommandé** pour livrables finaux nécessitant détail max

## Combinaisons typiques Mickael

### Itération rapide
```
Kling 2.1 Standard, 5s, 1080p, 16:9
```

### Physique réaliste (chute, fluide, tissu)
```
Kling 2.1 Pro, 10s, 1080p, prompt: "realistic physics: <détail>"
```

### Avec Motion Brush
```
Kling 2.1 Pro, 5s, 1080p, motion brush: <zones brushées>
```

### Livrable cinématique
```
Kling Master, 10s, 1080p, master shot preset: <choisi>
```

## Sources

- Doc officielle : `https://klingai.com`
