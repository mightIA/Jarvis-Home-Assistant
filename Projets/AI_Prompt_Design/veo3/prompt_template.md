# Veo 3.1 — templates de prompt

## Approche

Veo 3.1 = format prompt **structuré** (recommandation Google) avec bloc
`Audio:` séparé. Voir aussi `audio_prompting_guide.md` et
`structured_prompt_format.md`.

## Format structuré recommandé

```
Subject: [DESCRIPTION du sujet]
Action: [ACTION simple]
Setting: [DÉCOR + time of day]
Camera: [MOVEMENT explicite]
Style: [photographic / animated / cinematic / etc.]
Lighting: [setup]
Mood: [atmosphere]

Audio:
- Dialogue: [si applicable, "..." 4-10 mots]
- SFX: [son spécifique tied to action]
- Ambient noise: [one-clause soundscape]
- Music: [mood/texture, pas tempo]
```

## Template type "image-to-video avec dialogue lip-synced"

```
The character looks toward the camera and speaks. Camera holds in close-up.

Audio:
- Dialogue: A man says, "We have to leave now."
- SFX: distant rolling thunder
- Ambient noise: wind through bare trees, light rain on metal awning
- Music: minimal piano underscore, somber
```

## Template type "image-to-video sans dialogue (SFX + ambient)"

```
The chef plates the dish with focused precision. Camera pushes in slowly
to her hands.

Audio:
- SFX: ceramic plate clink, soft kitchen utensil sounds
- Ambient noise: distant murmur of restaurant guests, low HVAC hum
- Music: none
```

## Template type "text-to-video pur"

```
A cinematic shot of a small fishing boat drifting on a calm sea at dawn.
Soft golden light, contemplative mood. Camera slowly orbits the boat
clockwise. 8 seconds.

Audio:
- SFX: gentle waves lapping the hull, distant seagull calls
- Ambient noise: open sea, light breeze
- Music: minimal cello drone, melancholic
```

## Template type "scène avec multiple speakers"

```
Two characters sit across each other at a café table. Camera alternates
between medium shots of each speaker.

Audio:
- Dialogue 1: A woman says, "I think we should tell him."
- Dialogue 2: A man replies, "Not yet. Give it time."
- SFX: coffee cup placed gently, soft café murmur
- Ambient noise: light music in the background
```

→ Pour multiple dialogues, séparer en `Dialogue 1`, `Dialogue 2`. Limiter
à 2 speakers max sur 8 s sinon lip-sync casse.

## Checklist Jarvis avant de livrer un prompt Veo 3.1

- [ ] Format structuré (Subject / Action / Setting / Camera / Style / etc.) ?
- [ ] Bloc `Audio:` SÉPARÉ avec sous-items Dialogue / SFX / Ambient / Music ?
- [ ] Dialogue ≤ 10 mots par ligne ?
- [ ] SFX tied to action visible ?
- [ ] Music en mood/texture (pas BPM, pas instruments précis) ?
- [ ] Durée 8 s par défaut (préciser si autre) ?

## Anti-patterns Veo 3.1

- ❌ Mentionner audio inline dans la partie visuelle (mettre dans `Audio:` bloc)
- ❌ Dialogue > 10 mots (lip-sync casse)
- ❌ Music avec BPM ou instruments précis (modèle ignore les contraintes techniques)
- ❌ Multiple SFX par beat (1 SFX = 1 action, sinon désynchro)
- ❌ Utiliser `cut to` (modèle fait UN shot continu)
