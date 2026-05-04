# Runway Gen-4 / Aleph — référence paramètres

## Paramètres Gen-4 (text-to-video / image-to-video)

| Param | Valeurs | Effet |
|---|---|---|
| Duration | 5 s, 10 s | 5 s recommandé pour cohérence max |
| Resolution | 720p, 1080p, 4K | 4K = beaucoup de crédits |
| Aspect ratio | 16:9, 9:16, 1:1, 4:3, 3:4, 21:9 | Choisir selon usage final |
| Seed | int aléatoire ou fixé | Reproductibilité |
| Image input | upload PNG/JPG | Image-to-video, sujet figé dès le frame 1 |
| Motion intensity | low / medium / high | Influence amplitude des mouvements |

## Paramètres Gen-4 Turbo

Identique à Gen-4 mais :
- Vitesse génération ~3× plus rapide
- Coût en crédits ~50% moins cher
- Qualité légèrement inférieure (textures, détails fins)
- **Recommandé** pour itérations / explorations
- **Gen-4 standard** réservé au livrable final

## Paramètres Aleph (video-to-video)

| Param | Valeurs | Effet |
|---|---|---|
| Source video | upload | Vidéo à éditer |
| Reference image | optionnel | Style ou sujet de référence |
| Text prompt | EN | Instruction d'édition |
| Mode | edit / continue / new view | Voir aleph_guide.md |

## Paramètres Act-Two (motion capture facial)

| Param | Valeurs | Effet |
|---|---|---|
| Driver video | upload (acteur) | Performance source |
| Target character | image ou vidéo | Personnage cible |

## Combinaisons typiques Mickael

### Itération rapide
```
Gen-4 Turbo, 5s, 1080p, motion intensity: medium
```

### Livrable final
```
Gen-4, 10s, 4K, motion intensity: medium
```

### Édition vidéo existante
```
Aleph, mode: edit, prompt: "remove [object], keep lighting consistent"
```

### Shot continuation
```
Aleph, mode: continue, prompt: "next: [next beat]"
```

## Sources

- Doc officielle : `https://help.runwayml.com`
- Pricing crédits : `https://runwayml.com/pricing`
