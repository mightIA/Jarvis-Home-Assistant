# Guide Aleph — video-to-video Runway

> Aleph est l'**éditeur vidéo IA** de Runway. Il prend une vidéo source
> et applique des transformations via prompt. C'est l'équivalent vidéo
> de gpt-image-1 edit (image-to-image avec masque).

## Modes Aleph

### 1. Edit (transformation locale)

Modifier un élément de la vidéo source.

```
Remove the [object] from the scene. Keep [WHAT TO PRESERVE] consistent.
```

**Exemples** :
```
Remove the red car from the background. Keep lighting and shadows consistent.
```

```
Add a flock of birds in the sky. Keep the foreground and lighting unchanged.
```

```
Replace the wooden table with a marble one. Keep objects on the table identical.
```

### 2. Relighting

Changer la lumière sans toucher au reste.

```
Relight the scene as [TARGET LIGHTING]. Keep composition and character poses unchanged.
```

**Exemples** :
```
Relight as golden hour, warm orange tones from the left.
```

```
Relight as overcast cool morning, soft diffused light from above.
```

```
Relight as dramatic film noir, single hard light from the right, deep shadows.
```

### 3. Novel View Generation (angles caméra inédits)

Générer un nouveau point de vue de la même scène.

```
Generate a [NEW ANGLE] view of this scene. Keep characters and setting consistent.
```

**Angles supportés** :
- `top-down view` / `aerial view`
- `side view (left/right)`
- `over-the-shoulder view`
- `low angle (from below)`
- `high angle (from above)`
- `reverse angle` (l'opposé du shot original)

### 4. Shot Continuation

Générer le shot suivant de manière cohérente.

```
Continue this shot. Next: [NEXT BEAT].
```

**Exemples** :
```
Continue this shot. Next: the chef finishes plating, looks up to camera with a satisfied smile.
```

```
Continue this shot. Next: the door opens, a second character enters.
```

### 5. Object Addition

Insérer un nouvel élément avec le bon lighting / perspective.

```
Add [OBJECT] in [LOCATION]. Match lighting and perspective.
```

**Exemple** :
```
Add a glass of red wine on the right side of the table. Match lighting,
shadows, and reflections with the existing scene.
```

## Bonnes pratiques

- **Préciser ce qu'on veut préserver** : Aleph dérive moins si on dit
  explicitement "Keep X, Y, Z consistent"
- **Une transformation par appel** : pas combiner remove + relight + add
  dans le même prompt, faire 3 passes
- **Référence image optionnelle** pour style transfer ou character preservation
- **Coût** : Aleph ~équivalent Gen-4 standard, plus cher que Gen-4 Turbo

## Pièges

- ❌ Demander 3 transformations dans le même prompt (résultat instable)
- ❌ Ne pas préciser "Keep [...] consistent" (Aleph peut réécrire la
  scène entière)
- ❌ Edit sur vidéo basse résolution puis upscale (artefacts)

## Sources

- Doc Aleph : `https://help.runwayml.com/hc/en-us/articles/43176400374419-Creating-with-Aleph`
- Aleph blog : `https://wavespeed.ai/blog/posts/introducing-runway-gen4-aleph-on-wavespeedai/`
