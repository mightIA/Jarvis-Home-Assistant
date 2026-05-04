# Kling 2.1 / Master — templates de prompt

## Approche

Kling brille sur **physique réaliste** et **détail textures**. Templates
optimisés pour ces forces. Motion Brush = controle fin des zones animées.

## Template type "image-to-video — physique réaliste"

```
[ACTION] of the subject. Realistic physics: [SPECIFIC PHYSICS DETAIL].
Camera [MOVEMENT].
```

**Exemple** (chute d'un verre) :
```
The glass tips over and falls off the table. Realistic physics: shattering
on impact, water splashing outward, droplets bouncing.
Camera holds steady on the table.
```

## Template type "Motion Brush"

Workflow web app Kling :
1. Upload frame de départ
2. Painter les zones de mouvement avec le Motion Brush (UI)
3. Texte du prompt = motion + caméra

```
[ACTION animée dans les zones brushées]. Camera [MOVEMENT].
```

**Exemple** (vent dans les cheveux) :
```
The hair flows in the wind, strands moving naturally to the right.
The eyes blink twice slowly. Camera holds steady.
```

→ Les zones non brushées restent stables — c'est la force de Motion Brush.

## Template type "Master shot preset"

Sélection d'un Master shot preset dans l'UI (catalogue dans
`master_shot_presets.md`) puis prompt minimal :

```
[Master shot preset selected]: [SUBJECT/SETTING context].
```

**Exemple** :
```
Establishing crane shot: a vast medieval castle on a cliff at sunset.
The camera rises and reveals the surrounding landscape.
```

## Template type "text-to-video"

```
A [STYLE] shot of [SUBJECT] [ACTION] in [SETTING]. Realistic physics.
[LIGHTING], [MOOD]. Camera [MOVEMENT]. 10s.
```

## Checklist Jarvis avant de livrer un prompt Kling

- [ ] Si physique : détail physique explicité (gravité, fluide, tissu) ?
- [ ] Frame de départ pour i2v ?
- [ ] Si Motion Brush : zones précisées dans la consigne ?
- [ ] Pas de Master shot + Motion Brush combinés ?
- [ ] Prompt en EN (Kling gère mal le FR direct) ?
- [ ] Sujet sensible reformulé (censure CN) ?

## Anti-patterns Kling

- ❌ Combiner Master shot preset + Motion Brush (instable)
- ❌ Demander des sujets politiques / religieux sensibles (refus)
- ❌ Prompt FR direct (passer en EN, le modèle interprète mieux)
- ❌ Demander de l'audio (Kling n'en a pas natif)
