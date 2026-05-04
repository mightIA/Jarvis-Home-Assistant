# Guide Keyframes — Luma Ray2

## Principe

**Keyframes start + end** = Luma interpole nativement entre 2 images
fixes. C'est la **feature signature** de Luma, sans équivalent grand
public.

## Workflow

```
1. Préparer la frame de DÉPART (keyframe start) — sujet, décor, mouvement init
2. Préparer la frame de FIN (keyframe end) — même sujet, position/lumière finale
3. Upload les 2 dans l'UI Luma
4. Prompt court décrivant la transition (optionnel, pour aider l'interpolation)
5. Génération 5 s : Luma anime la transition entre les 2 keyframes
```

## Cas d'usage

### 1. Time-lapse compressé

Keyframe 1 : matin, soleil bas, ombres longues
Keyframe 2 : soir, soleil bas inverse, ombres longues vers l'autre côté

Prompt :
```
A day passes over the landscape, sunlight shifting from morning to evening.
```

### 2. Métamorphose contrôlée

Keyframe 1 : bourgeon fermé
Keyframe 2 : fleur épanouie

Prompt :
```
The bud blooms gradually into a full flower.
```

### 3. Mouvement caméra implicite

Keyframe 1 : sujet en plan large
Keyframe 2 : même sujet en gros plan

Prompt :
```
The camera pushes in to the subject.
```

→ Pas besoin de prompt caméra — la différence de cadrage entre les 2
keyframes le crée.

### 4. Évolution narrative

Keyframe 1 : café vide
Keyframe 2 : café plein de clients

Prompt :
```
Time progresses, the café fills with guests.
```

## Bonnes pratiques

- **Sujet identique** dans les 2 keyframes (sinon morphing désagréable)
- **Variation contrôlée** : changer setting / lumière / posture, pas
  identité du sujet
- **Cohérence stylistique** entre les 2 frames (générées dans la même IA
  image, mêmes paramètres)
- **Prompt court** : Luma interpole, pas besoin de tout décrire

## Pièges

- ❌ Sujets trop différents start/end (morphing facial, proportions cassées)
- ❌ 5 s trop court pour une transformation lente (le rendu paraît brusque)
- ❌ Keyframes générées dans 2 IA différentes (style discontinu)
- ❌ Prompt long qui contredit la différence start/end (Luma confus)

## Composition 10 s

Pour faire un clip 10 s : **2 clips Luma de 5 s en série** avec keyframe
end du clip 1 = keyframe start du clip 2.

```
Clip 1 : keyframe A → keyframe B (5 s)
Clip 2 : keyframe B → keyframe C (5 s)
Montage : concat A→B→C en post (DaVinci, Premiere) = 10 s cohérents
```

## Sources

- Doc Luma : `https://lumalabs.ai`
