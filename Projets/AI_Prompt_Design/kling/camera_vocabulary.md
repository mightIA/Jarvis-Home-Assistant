# Vocabulaire caméra — Kling 2.1 / Master

> Référence transverse : [`_video_common/camera_vocabulary_global.md`](../_video_common/camera_vocabulary_global.md)

## Particularités Kling

- ✅ **Excellent** sur `dolly`, `crane`, `tracking shot`, `orbit`
- ✅ **Master shot presets** (UI) = mouvements cinématiques pré-codés,
  plus fiables qu'un prompt texte
- ✅ Interaction caméra + physique réaliste très propre
  (ex : caméra qui suit un objet en chute)
- 🟡 `dutch angle` reconnu mais peu prononcé
- ❌ Termes EN obscurs (`Vertigo effect`, `Hitchcock zoom`) → reformuler
  en termes basiques

## Termes spécifiques Kling

| Terme Kling UI | Effet |
|---|---|
| Master shot: Establishing | Crane up + reveal large |
| Master shot: Push in dramatic | Dolly in soutenu |
| Master shot: Orbit cinematic | Orbit lent autour du sujet |
| Motion Brush: <zone> | Zone animée painter en UI |

## À éviter

- ❌ Master shot preset + Motion Brush (instable)
- ❌ Master shot preset + prompt caméra texte (conflit, le preset gagne)
