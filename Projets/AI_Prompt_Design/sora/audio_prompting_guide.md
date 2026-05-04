# Guide audio prompting — Sora 2

> 🔴 API discontinuée le **24/09/2026**. Voir [README.md](README.md).

## Approche

Sora 2 audio = **langage naturel intégré au prompt visuel** (pas de bloc
formel comme Veo 3.1). Le modèle interprète librement.

## Format général

```
[VISUAL: ACTION + camera movement]

Audio: [DESCRIPTION naturelle du soundscape complet en 1-3 phrases]
```

**Exemple** :
```
The chef begins plating with focused precision. Camera pushes in slowly
to her hands.

Audio: gentle kitchen ambient with soft murmur of guests in the background,
ceramic plate clinks as she works, no music playing.
```

## Patterns naturels (vs Veo 3.1 formel)

| Veo 3.1 formel | Sora 2 naturel |
|---|---|
| `Dialogue: A woman says, "..."` | `She speaks softly: "..."` |
| `SFX: thunder cracks` | `Distant thunder rumbles` |
| `Ambient noise: rain on metal` | `Light rain pattering on metal awning` |
| `Music: minimal piano somber` | `A minimal piano plays in the background, somber` |

→ Sora préfère du **prose continue** plutôt que des sous-éléments listés.

## Multi-locuteurs

```
[VISUAL]

Audio: [SPEAKER 1] says, "...". [SPEAKER 2] replies, "...". Background
ambient: [...].
```

## Music

Sora 2 reproduit du music **généré**, contrairement à Veo qui peut le
modeler par mood. Sora accepte :
- Genre (`upbeat indie`, `cinematic strings`, `minimalist piano`)
- Mood (`somber`, `triumphant`, `tense`)
- Tempo descriptif (`slow`, `driving`, `gentle`)

```
Audio: cinematic strings rising slowly to a triumphant peak as the hero
approaches the summit, no dialogue.
```

## Pièges

- ❌ Utiliser le format Veo 3.1 (`Dialogue:`, `SFX:`) — Sora 2 n'a pas
  cette structure
- ❌ Trop de SFX / dialogues simultanés (Sora compresse)
- ❌ Investir dans des templates audio Sora 2 (déprécation 09/2026)

## Migration vers Veo 3.1

Pour archiver les prompts audio Sora 2 réussis et les porter vers Veo 3.1 :

1. Identifier les éléments : Dialogue / SFX / Ambient / Music
2. Reformater en bloc structuré Veo 3.1 (voir `veo3/audio_prompting_guide.md`)
3. Tester sur Veo 3.1, scoring /65
4. Si conservation qualité ≥ 80% Sora 2 → conserver template Veo 3.1
   pour la suite

## Sources

- Doc historique Sora 2 : `https://openai.com/index/sora-2/`
