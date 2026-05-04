# Guide Motion Brush — Kling 2.1 / Master

## Principe

**Motion Brush** = peindre directement sur l'image source les zones qui
doivent être animées. Les zones non peintes restent stables.

## Workflow web app

```
1. Upload frame de départ dans l'UI Kling
2. Activer le Motion Brush
3. Choisir un brush (Auto, Manual, Static)
4. Peindre les zones sur l'image
5. Préciser dans le prompt l'action attendue dans ces zones
6. Génération 5 ou 10 s
```

## Types de brushes

| Brush | Effet |
|---|---|
| `Auto Brush` | Kling devine les zones animables (sujet principal) |
| `Manual Brush` | Tu peins toi-même les zones (contrôle max) |
| `Static Brush` | Tu peins les zones à **figer** (anti-mouvement) |

## Bonnes pratiques

- **Manual Brush** pour précision (cheveux, vêtements, fluide)
- **Static Brush** pour figer le décor pendant que le sujet bouge
- **Combiner Auto + Static** : Kling anime le sujet, tu figes le décor
- **Une zone = un mouvement** : si tu peins 3 zones, prompt explicite
  l'action de chacune

## Templates

### Cheveux dans le vent (Manual Brush)

Zones peintes : cheveux uniquement.

```
The hair flows naturally in the wind, strands moving to the right.
The face and body remain still. Camera holds steady.
```

### Personnage animé / décor figé (Manual + Static)

Zones Manual : sujet entier. Zones Static : décor en arrière-plan.

```
The character walks slowly toward the camera. The background trees and
buildings remain perfectly still. Camera holds steady.
```

### Liquide en chute (Manual Brush)

Zones peintes : tasse + zone de chute du liquide.

```
The tea pours from the teapot into the cup, realistic fluid physics.
Steam rises gently from the cup. Camera holds steady.
```

## Pièges

- ❌ Peindre toute l'image (équivalent à pas de Motion Brush — perd l'avantage)
- ❌ Zones brushées contradictoires (sujet bouge à droite + sujet bouge à gauche)
- ❌ Combiner Motion Brush + Master shot preset (instable)
- ❌ Prompt sans préciser l'action dans les zones brushées (Kling improvise)

## Sources

- Doc Kling : `https://klingai.com` (section Motion Brush)
