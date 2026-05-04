# Sora 2 — templates de prompt

> 🔴 Rappel : Sora 2 API discontinuée le **24/09/2026**. N'utiliser pour
> tests ponctuels uniquement. Voir [README.md](README.md).

## Approche

Sora 2 = audio natif + clips longs (jusqu'à 60 s sur Pro). Templates
proches de Veo 3.1 mais syntaxe audio différente (moins formalisée).

## Template type "image-to-video avec audio"

```
[VISUAL: ACTION + camera movement]

Audio: [DIALOGUE / SFX / AMBIENT / MUSIC en langage naturel]
```

**Exemple** :
```
The chef begins plating with focused precision. Camera pushes in slowly
to her hands.

Audio: gentle kitchen ambient with soft murmur of guests in the background,
ceramic plate clinks as she works, no music.
```

## Template type "text-to-video clip long"

```
A [STYLE] [LENGTH-second] shot of [SUBJECT] [ACTION] in [SETTING].
[LIGHTING], [MOOD]. Camera [MOVEMENT].

Audio: [SOUNDSCAPE]
```

## Template type "Cameos" (référence sociale Sora)

Workflow Sora 2 propriétaire — upload d'une vidéo de référence personne,
puis :

```
[CAMEO REFERENCE] doing [ACTION] in [SETTING].
```

→ Cameos restent une feature unique sans équivalent ailleurs, mais
inutilisable post-déprécation.

## Checklist Jarvis avant de livrer un prompt Sora 2

- [ ] Confirmation Mickael que test ponctuel justifié (déprécation 09/2026) ?
- [ ] Audio formulé en langage naturel (pas de syntaxe formelle Veo) ?
- [ ] Durée ≤ 20 s (au-delà, cohérence se dégrade fortement) ?
- [ ] Watermark mentionné dans le brief si exporté ?
- [ ] Prompt archivé dans `iterations_log.md` pour réutilisation Veo 3.1 ?

## Anti-patterns Sora 2

- ❌ Investir dans des workflows long terme (déprécation 24/09/2026)
- ❌ Clips > 20 s (cohérence physique se dégrade)
- ❌ Confondre syntaxe audio Sora (langage naturel) et Veo 3.1 (formelle)
