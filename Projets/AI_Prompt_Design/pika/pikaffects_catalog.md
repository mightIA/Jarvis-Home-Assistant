# Catalogue Pikaffects — Pika 2.x

## Principe

**Pikaffects** = effets VFX paramétriques pré-codés (transformation,
destruction, déformation). Chaque Pikaffect prend un sujet/objet et lui
applique l'effet automatiquement.

> ⚠️ **Pas combiner avec mouvement caméra** ni avec **Scene Ingredients**.

## Catalogue (état mai 2026, ~20 effets)

### Transformations

| Pikaffect | Effet | Cas d'usage |
|---|---|---|
| `Melt` | Le sujet fond progressivement | Bâtiments, glace, objets |
| `Inflate` | Le sujet gonfle comme un ballon | Animaux, objets ronds, personnes (humour) |
| `Squish` | Compression molle | Fruits, gel, cartoon |
| `Crush` | Écrasement net | Cans, voiture, objets fragiles |
| `Crumble` | Désintégration en miettes | Bâtiments, ruines, sable |
| `Dissolve` | Fond en particules | Personnages mystères, fantômes |
| `Levitate` | Lévitation | Objets, personnages |

### Destruction

| Pikaffect | Effet | Cas d'usage |
|---|---|---|
| `Explode` | Explosion locale | VFX, feu d'artifice, action |
| `Shatter` | Éclate en morceaux | Verre, glace, miroir |
| `Burn` | Combustion | Papier, bois, films d'horreur |
| `Tear apart` | Déchirure | Tissu, papier |

### Déformations / animations

| Pikaffect | Effet | Cas d'usage |
|---|---|---|
| `Cake-ify` | Le sujet se transforme en gâteau | Humour, mèmes |
| `Toy-ify` | Le sujet devient figurine plastique | Stop-motion vibe |
| `Cartoonify` | Style cartoon overlay | Conversion style |
| `Pixelate` | Pixelisation 8-bit | Glitch art, retro gaming |
| `Glitch` | Effet glitch numérique | Cyberpunk, effet TV cassée |

### Atmosphériques

| Pikaffect | Effet | Cas d'usage |
|---|---|---|
| `Snowfall` | Neige tombe sur la scène | Hiver, ambiance |
| `Rain` | Pluie | Drame, mood |
| `Fog` | Brouillard | Mystère, horreur |
| `Sunbeam` | Rayons de soleil | Religion, divin, atmosphère |

## Templates

### Pikaffect simple

```
[Pikaffect name]: [TARGET in the scene].
```

**Exemples** :
```
Melt: the building.
Inflate: the cat (gentle, slow).
Crush: the soda can on the table.
Explode: the fireworks at the top of the frame.
Shatter: the mirror behind the character.
```

### Avec intensité

```
[Pikaffect name] (intensity: low/medium/high): [TARGET].
```

**Exemple** :
```
Crumble (intensity: high): the ancient stone tower in the background.
```

## Pièges

- ❌ Combiner Pikaffect + camera movement (le Pikaffect gagne)
- ❌ Combiner Pikaffect + Scene Ingredients (très instable)
- ❌ Multi-targets (`Melt: building AND car`) → choisir un seul
- ❌ Pikaffect sur un sujet partiellement hors cadre (cropping bizarre)

## Sources

- Doc Pika : `https://pika.art` (section Pikaffects)
