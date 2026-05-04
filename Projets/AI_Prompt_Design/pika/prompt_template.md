# Pika 2.x — templates de prompt

## Approche

Pika = prompt vidéo court + features signature **Scene Ingredients** ou
**Pikaffects**. Ne pas combiner les deux dans un même clip.

## Template type "image-to-video simple"

```
[ACTION] of the subject. Camera [MOVEMENT].
```

**Exemple** :
```
The cat slowly stretches and yawns. Camera holds steady, slight push in
on the face.
```

## Template type "Scene Ingredients" (multi-references)

Upload plusieurs images de référence (sujets, props, décors) puis :

```
Combine: [INGREDIENT 1] + [INGREDIENT 2] + [INGREDIENT 3]
in [SCENE description]. [ACTION]. Camera [MOVEMENT].
```

**Exemple** (avec 3 images uploadées : un chat, un fauteuil, un salon) :
```
Combine: the orange cat (image 1) + the leather armchair (image 2) +
the warm lit living room (image 3) into a cozy evening scene. The cat
jumps onto the armchair and curls up. Camera dollies in slowly.
```

## Template type "Pikaffect" (transformation paramétrique)

Sélection d'un Pikaffect dans l'UI Pika (catalogue dans
`pikaffects_catalog.md`) puis prompt :

```
[Pikaffect name]: [TARGET in the scene].
```

**Exemples** :
```
Melt: the building.
```

```
Inflate: the cat (gentle).
```

```
Crush: the can on the table.
```

```
Explode: the fireworks at the top of the frame.
```

→ Pour Pikaffects, **pas de mouvement caméra** dans le même prompt
(la caméra est gérée par le Pikaffect).

## Template type "text-to-video pur"

```
A [STYLE] shot of [SUBJECT] [ACTION] in [SETTING]. [LIGHTING], [MOOD].
Camera [MOVEMENT]. 5s.
```

## Checklist Jarvis avant de livrer un prompt Pika

- [ ] Choix entre Scene Ingredients / Pikaffect / standard fait ?
- [ ] Frame de départ ou ingredients prêts si non text-to-video ?
- [ ] Action simple (1 verbe principal) ?
- [ ] Mouvement caméra explicite (pas "moves around") ?
- [ ] Si `tilt` voulu : préciser pour éviter confusion avec `pedestal` ?
- [ ] Pikaffect : pas combiné avec Scene Ingredients ?

## Anti-patterns Pika

- ❌ Combiner Pikaffect + camera movement (instable)
- ❌ Combiner Scene Ingredients + Pikaffect (très instable)
- ❌ Demander 10 s sur un Pikaffect (extension perd la qualité)
- ❌ Utiliser `tilt` sans préciser (souvent confondu avec `pedestal`)
