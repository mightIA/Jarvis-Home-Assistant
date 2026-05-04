# Runway Gen-4 / Aleph — templates de prompt

## Approche

Runway prompts vidéo = **2 lignes max** :
1. Action / motion du sujet
2. Mouvement caméra

**Ne jamais redécrire le sujet** quand on part d'une image (i2v). Voir
`_video_common/image_to_video_workflow.md`.

## Template type "image-to-video — action simple"

```
[ACTION] of the subject. Camera [MOVEMENT].
```

**Exemple** :
```
The fisherman slowly raises his head and looks toward the horizon.
Camera dollies in gently.
```

## Template type "text-to-video pur" (sans frame source)

```
A [STYLE] [SUBJECT] [ACTION] in [SETTING], [LIGHTING], [MOOD].
Camera [MOVEMENT]. Duration: [5s | 10s].
```

**Exemple** :
```
A cinematic shot of a small fishing boat drifting on a calm sea at dawn,
soft golden light, contemplative mood. Camera slowly orbits clockwise.
Duration: 10s.
```

## Template type "Aleph video-to-video — édition"

Aleph prend une vidéo existante en input et applique un prompt d'édition.

```
[EDIT INSTRUCTION] in the video. Keep [WHAT TO PRESERVE] consistent.
```

**Exemples** :
```
Remove the red car from the background. Keep the lighting and shadows
consistent.
```

```
Relight the scene as if shot at golden hour. Keep the composition and
character poses unchanged.
```

```
Generate a new camera angle from above (top-down view). Keep the
character and setting consistent.
```

## Template type "shot continuation Aleph"

```
Continue this shot. Next: [NEXT BEAT].
```

**Exemple** :
```
Continue this shot. Next: the chef finishes plating, looks up to the
camera with a satisfied smile.
```

## Template type "Act-Two motion capture facial"

Workflow : enregistrer une vidéo de l'acteur (toi avec ton iPhone) puis
appliquer Act-Two sur un personnage cible.

```
Apply this performance to [TARGET CHARACTER REFERENCE].
```

→ Le prompt Act-Two est minimal, le travail est dans la vidéo source +
l'image de référence du personnage.

## Checklist Jarvis avant de livrer un prompt Runway

- [ ] Frame de départ générée et validée ?
- [ ] Action en 1 verbe principal (pas 3 superposés) ?
- [ ] Mouvement caméra en 1 terme du vocabulaire `_video_common/camera_vocabulary_global.md` ?
- [ ] Pas de redescription du sujet quand i2v ?
- [ ] Durée choisie (5 ou 10 s) cohérente avec l'action ?
- [ ] Si Aleph : "Keep [...] consistent" pour préserver l'inchangé ?

## Anti-patterns Runway

- ❌ Phrases narratives longues à la DALL·E
- ❌ Mélanger plusieurs actions dans le même prompt
- ❌ Utiliser `cut to`, `next scene` (modèle ignore)
- ❌ Demander de l'audio (Runway n'en a pas natif)
