# Pika 2.x — référence paramètres

## Paramètres standard

| Param | Valeurs | Effet |
|---|---|---|
| Duration | 5 s (10 s extend) | 5 s recommandé pour cohérence |
| Resolution | 720p, 1080p | 1080p par défaut sur Pika 2.2 |
| Aspect ratio | 16:9, 9:16, 1:1 | Choisir selon usage |
| Seed | int aléatoire ou fixé | Reproductibilité |
| Image input | upload | Image-to-video |
| Motion strength | 1-4 | 1=stable, 4=très animé |
| Negative prompt | mots-clés | Anti-éléments |

## Scene Ingredients

- Upload jusqu'à **5 images** de référence (sujets, props, décors)
- Le modèle compose automatiquement
- Voir `scene_ingredients_guide.md` pour patterns

## Pikaffects

- Sélection dans menu UI (~20 effets paramétriques)
- Pas combiner avec mouvement caméra
- Voir `pikaffects_catalog.md` pour la liste complète

## Combinaisons typiques Mickael

### Génération standard
```
Pika 2.2, 5s, 1080p, 16:9, motion strength: 2
```

### Avec Pikaffect (transformation)
```
Pika 2.2, 5s, 1080p, Pikaffect: <choisi>, motion strength: auto
```

### Avec Scene Ingredients
```
Pika 2.2, 5s, 1080p, ingredients: 3 images, motion strength: 2
```

## Sources

- Doc officielle : `https://pika.art`
