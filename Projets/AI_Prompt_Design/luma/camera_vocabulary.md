# Vocabulaire caméra — Luma Ray2 / Ray2 Flash

> Référence transverse : [`_video_common/camera_vocabulary_global.md`](../_video_common/camera_vocabulary_global.md)

## Particularités Luma

- ✅ **Camera Concepts** (UI) = presets ergonomiques, plus fiables qu'un
  prompt texte (orbit, push in, crane up, etc.)
- ✅ **Keyframes start + end** permettent un mouvement caméra implicite
  via la différence de cadrage entre les 2 frames
- 🟡 Mouvement caméra texte libre OK mais moins précis que Camera Concept
- 🟡 `tracking shot` interprété correctement si sujet en mouvement clair
- ❌ Combinaison Camera Concept + prompt caméra texte → conflit

## Termes spécifiques Luma

| Terme Luma UI | Effet |
|---|---|
| Camera Concept: Orbit | Tour complet ou partiel autour du sujet |
| Camera Concept: Push In | Dolly in vers le sujet |
| Camera Concept: Pull Out | Dolly out depuis le sujet |
| Camera Concept: Crane Up | Élévation |
| Camera Concept: Aerial | Vue drone |
| Camera Concept: Pan Right/Left | Pan horizontal |

## À éviter

- ❌ Camera Concept + prompt caméra texte (conflit)
- ❌ Demander un mouvement complexe sans Camera Concept (préférer le preset)
