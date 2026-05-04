# Hailuo 02 — templates de prompt

## Approche

Hailuo = entrée de gamme rapport qualité/prix. Templates simples, EN de
préférence, audio basique optionnel.

## Template type "image-to-video standard"

```
[ACTION] of the subject. Camera [MOVEMENT]. [DURATION: 6s | 10s].
```

**Exemple** :
```
The character walks slowly toward the window. Camera follows from behind.
6s.
```

## Template type "text-to-video"

```
A [STYLE] shot of [SUBJECT] [ACTION] in [SETTING]. [LIGHTING], [MOOD].
Camera [MOVEMENT]. 6s.
```

**Exemple** :
```
A cinematic shot of a small wooden boat drifting on a misty lake at dawn.
Soft cool light, contemplative mood. Camera holds steady from a distance. 6s.
```

## Template type "audio basique" (qualité variable)

```
[ACTION standard]. Camera [MOVEMENT].

Audio: [AMBIENT MUSIC mood]
```

**Exemple** :
```
A drone shot over a golden field at sunset. Camera slowly pans right.

Audio: cinematic strings, peaceful and warm
```

→ Pour qualité audio pro, **désactiver l'audio Hailuo** et l'ajouter
en post (DAW, ElevenLabs, Suno).

## Checklist Jarvis avant de livrer un prompt Hailuo

- [ ] Prompt en EN (le modèle gère mieux qu'auto-traduit) ?
- [ ] Durée 6 s par défaut (10 s OK si motion claire) ?
- [ ] Frame de départ pour i2v ?
- [ ] Sujet sensible reformulé (censure CN) ?
- [ ] Audio désactivé sauf si ambient music acceptable ?
- [ ] Comparatif prix vs Pika sur même brief considéré ?

## Anti-patterns Hailuo

- ❌ Demander dialogue lip-synced (audio basique pas adapté)
- ❌ Sujets politiques/religieux sensibles (censure)
- ❌ Prompt CN auto-traduit (préférer EN direct)
- ❌ Multiple actions complexes superposées (cohérence se dégrade vite)
