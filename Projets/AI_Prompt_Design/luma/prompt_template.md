# Luma Ray2 / Ray2 Flash — templates de prompt

## Approche

Luma signature = **keyframes start + end** (interpolation native) et
**Camera Concepts** (presets ergonomiques).

## Template type "keyframe start uniquement (i2v classique)"

Upload une image en keyframe start, puis :

```
[ACTION]. Camera [MOVEMENT].
```

**Exemple** :
```
The character begins to walk toward the door. Camera follows from behind
in a tracking shot.
```

## Template type "keyframe start + end" (signature Luma)

Upload 2 images : une start, une end. Luma interpole l'animation entre
les deux. Sujet identique recommandé, varier setting / posture / lumière.

```
[Optional brief description of the transition]
```

**Exemple** :
- Keyframe 1 : portrait du chef en cuisine vide, lumière froide matin
- Keyframe 2 : portrait du chef en cuisine animée, lumière chaude soir
- Prompt : `A day in the life of the chef. Time progresses from morning to evening.`

→ Luma génère la transition naturelle entre les 2 frames.

## Template type "Camera Concept"

Sélection d'un Camera Concept dans l'UI (catalogue dans
`camera_concepts_catalog.md`) puis prompt :

```
[Camera Concept selected]: [SUBJECT/SCENE].
```

**Exemples** :
```
Orbit: the sculpture in the center of the gallery.
```

```
Push in: the chef's hands plating the dish.
```

```
Crane up: the wide field of sunflowers.
```

## Template type "text-to-video Ray2"

```
A [STYLE] shot of [SUBJECT] [ACTION] in [SETTING]. [LIGHTING], [MOOD].
Camera [MOVEMENT]. 5s.
```

## Checklist Jarvis avant de livrer un prompt Luma

- [ ] Keyframe start préparée ?
- [ ] Si keyframe end : sujet identique start/end (sinon morphing) ?
- [ ] Camera Concept choisi OU prompt caméra texte (pas les deux) ?
- [ ] Action simple ?
- [ ] Mode Flash si essais rapides, Ray2 standard si livrable ?

## Anti-patterns Luma

- ❌ Keyframes start/end avec sujets très différents (morphing désagréable)
- ❌ Camera Concept + prompt caméra texte (conflit, l'un gagne)
- ❌ Demander 10 s sur un seul clip Luma (limite 5 s native, composer)
- ❌ Demander de l'audio (Luma n'en a pas natif)
