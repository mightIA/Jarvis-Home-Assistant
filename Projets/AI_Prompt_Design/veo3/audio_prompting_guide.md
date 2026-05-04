# Guide audio prompting — Veo 3.1 (détaillé)

## Principe

Veo 3.1 = audio natif synchronisé avec l'image. Format **structuré** dans
un bloc `Audio:` séparé, avec sous-éléments précis. C'est la **différence
clé vs Sora 2** (qui utilise du langage naturel libre).

## Format de référence

```
Audio:
- Dialogue: <Speaker description>, "<phrase 4-10 mots>"
- SFX: <son spécifique tied to action visible>
- Ambient noise: <one-clause soundscape>
- Music: <mood / texture, pas tempo précis>
```

## Dialogue

### Règles strictes

- **Guillemets doubles** `"..."` autour de la phrase
- **4 à 10 mots** par ligne dialogue (au-delà = lip-sync casse)
- **Speaker description** en amont : `A woman says, "..."` / `A man whispers, "..."`
- **Tone descriptor** optionnel : `furiously`, `softly`, `nervously`, `with a smile`

### Exemples valides

```
Audio:
- Dialogue: A woman says nervously, "We have to leave now."
```

```
Audio:
- Dialogue 1: An old man asks, "Have you seen my hat?"
- Dialogue 2: A young woman replies softly, "It's on the table."
```

### Pièges dialogue

- ❌ `Dialogue: "I went to the store yesterday and bought twelve apples"` — trop long, lip-sync casse
- ❌ `Dialogue: A man says...` sans guillemets — le modèle improvise le texte
- ❌ Mélanger plusieurs personnes dans une seule ligne `Dialogue:`

## SFX (Sound Effects)

### Règles

- **Préfixe `SFX:`** obligatoire
- **Tied to a specific on-screen action or timing** (le son doit
  correspondre à un événement visible)
- **1 SFX par beat** (pas plusieurs sons simultanés sur la même action)

### Exemples valides

```
Audio:
- SFX: ceramic cup clinks as it lands on the table
- SFX: distant rolling thunder during the lightning flash
- SFX: door creaks open slowly
- SFX: footsteps echo in the marble hallway
```

### Pièges SFX

- ❌ `SFX: kitchen sounds` (trop vague — préciser quel son, quel objet)
- ❌ Empiler 4-5 SFX sur la même action (désynchro)
- ❌ SFX sans correspondance visuelle (le modèle peut l'ignorer)

## Ambient noise

### Règles

- **Préfixe `Ambient noise:`** obligatoire
- **One clause** (pas une description longue)
- Décrit le **soundscape de fond** stable pendant tout le clip

### Exemples valides

```
Audio:
- Ambient noise: quiet hum of a starship bridge
- Ambient noise: wind through bare trees, light rain on metal awning
- Ambient noise: distant murmur of restaurant guests, low HVAC hum
- Ambient noise: gentle waves lapping the hull, distant seagull calls
- Ambient noise: bustling Tokyo intersection with car horns and chatter
```

### Pièges ambient

- ❌ `Ambient noise: lots of different sounds` (vague)
- ❌ Ambient qui contredit le SFX (ex : SFX silence + ambient bruyant)

## Music

### Règles

- **Préfixe `Music:`** obligatoire (ou `Music: none` pour silence)
- **Mood / texture** (pas BPM, pas instruments précis trop techniques)
- **Une indication par clip** (pas de changement de musique en milieu de 8 s)

### Exemples valides

```
Audio:
- Music: minimal piano underscore, somber
- Music: upbeat indie guitar, light
- Music: cinematic strings rising, triumphant
- Music: minimal cello drone, melancholic
- Music: none
```

### Pièges music

- ❌ `Music: 120 BPM jazz with saxophone, drums, and bass` (trop technique, modèle ignore)
- ❌ `Music: starts soft then becomes loud at 4 seconds` (pas de scénarisation temporelle)
- ❌ Oublier `Music: none` quand on veut du silence (le modèle ajoute de la musique par défaut)

## Templates complets

### Scène intime sans dialogue

```
A woman writes a letter by candlelight in an old wooden room. Camera
slowly pushes in to her hand and the paper.

Audio:
- SFX: pen scratching on parchment, candle flame flickering
- Ambient noise: quiet creak of wooden floor, distant owl hooting
- Music: minimal piano underscore, melancholic
```

### Action avec dialogue

```
The detective bursts through the door of the office. A man sits behind
the desk, looking up surprised.

Audio:
- Dialogue 1: The detective shouts, "Hands up, now!"
- Dialogue 2: The man stammers, "Wait, I can explain!"
- SFX: door slammed open, papers fluttering
- Ambient noise: ceiling fan whirring, distant city traffic
- Music: tense cinematic strings, urgent
```

### Documentaire nature

```
A drone shot rises slowly over a wide field of sunflowers at sunset.
Camera continues upward, revealing distant mountains.

Audio:
- SFX: gentle wind rustling through the petals
- Ambient noise: distant birdsong, light breeze
- Music: warm orchestral strings, peaceful and contemplative
```

## Sources

- Google Cloud blog : `https://cloud.google.com/blog/products/ai-machine-learning/ultimate-prompting-guide-for-veo-3-1`
- Atlabs guide : `https://www.atlabs.ai/blog/the-ultimate-prompting-guide-for-veo-3-1`
- Skywork audio guide : `https://skywork.ai/blog/how-to-audio-aware-prompting-veo-3-1-guide/`
- Lip-sync guide : `https://www.glbgpt.com/hub/how-to-make-characters-speak-in-veo-3-1-the-ultimate-guide-to-dialogue-audio-lip-sync/`
