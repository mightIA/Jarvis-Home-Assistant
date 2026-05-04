# Image-to-video workflow — pattern frame de départ + animation only

## Principe

**Ne pas demander** au modèle vidéo de générer **simultanément** le sujet,
le décor, le style et le mouvement. C'est le piège #1 qui produit du
morphing facial, des proportions cassées et des incohérences.

**À la place** : générer une **frame de départ** dans une IA image
(Midjourney, SDXL, FLUX) puis prompter **uniquement le mouvement** dans
le modèle vidéo.

## Workflow standard

```
┌─────────────────────┐      ┌─────────────────────┐      ┌─────────────────────┐
│ 1. Frame de départ  │ ───> │ 2. Modèle vidéo     │ ───> │ 3. Clip 5-10s       │
│   (MJ / SDXL / FLUX)│      │   (Runway Gen-4...) │      │   sujet stable      │
│   = sujet + décor   │      │   prompt = motion   │      │   + animation       │
│   + style figés     │      │     + caméra        │      │     contrôlée       │
└─────────────────────┘      └─────────────────────┘      └─────────────────────┘
```

## Étape 1 : générer la frame de départ

Utiliser **les templates des dossiers IA images** (midjourney, dall-e,
stable-diffusion). Soigner particulièrement :

- **Sujet net, lighting clair** (pas de brouillard épais qui complique le motion)
- **Cadrage qui laisse de la place** au mouvement prévu (espace devant si push in, latéral si truck)
- **Pose du sujet en début d'action** (pas en milieu — le modèle vidéo
  doit comprendre où elle va)

## Étape 2 : prompter uniquement le mouvement

Dans le prompt vidéo, **NE PAS redécrire** le sujet (le modèle l'a déjà via
l'image). Décrire UNIQUEMENT :

1. **Action / motion** du sujet (verbes simples, 1 action principale)
2. **Mouvement caméra** (vocabulaire `_video_common/camera_vocabulary_global.md`)
3. **Évolution temporelle** (`_video_common/temporal_cues.md`)
4. **Audio** si modèle compatible (Veo 3.1, Sora 2)

### Exemple Runway Gen-4 (image-to-video)

Frame Midjourney V7 (sujet figé) →

Prompt Runway :
```
The fisherman slowly raises his head and looks toward the horizon.
Camera dollies in gently. Soft wind moves the loose threads of the net.
```

(Pas de redescription "old fisherman, blue net, Brittany harbor" — déjà dans l'image.)

### Exemple Veo 3.1 avec audio

```
The chef begins plating with focused precision. Camera pushes in to her hands.

Audio:
- SFX: ceramic plate clink, light kitchen ambient hum
- Ambient noise: distant murmur of restaurant guests
```

## Étape 3 : itérer

Si le clip rate :

| Symptôme | Action |
|---|---|
| Morphing facial | Réduire la durée, simplifier l'action, ou utiliser Aleph (Runway) pour relighting |
| Mouvement caméra ignoré | Reformuler avec un seul terme caméra clair |
| Sujet qui dérive | Frame de départ trop ambiguë, regénérer |
| Audio désynchronisé (Veo) | Raccourcir le dialogue, expliciter `Audio: ...` |

## Modèles supportant l'image-to-video natif

| Modèle | I2V natif | Méthode |
|---|---|---|
| Runway Gen-4 | ✅ | Upload image + text prompt |
| Pika 2.x | ✅ | Image + text |
| Kling 2.1 | ✅ | Image + text + motion brush |
| Luma Ray2 | ✅ | Keyframe start (+ end optionnel) |
| Sora 2 | ✅ | Image input |
| Veo 3.1 | ✅ | Image-to-video + audio |
| Hailuo 02 | ✅ | Image + text |

→ **L'image-to-video est universel en 2026**. Le text-to-video pur reste
utile pour les concepts abstraits ou quand on n'a pas de frame source.
