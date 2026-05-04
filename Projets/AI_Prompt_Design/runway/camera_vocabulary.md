# Vocabulaire caméra — Runway Gen-4 / Aleph

> Référence transverse : [`_video_common/camera_vocabulary_global.md`](../_video_common/camera_vocabulary_global.md)

## Particularités Runway

- ✅ **Excellent** sur `dolly in/out`, `orbit`, `tracking shot`, `crane up/down`
- ✅ **Aleph "novel view generation"** = synthèse d'angles caméra inédits
  depuis une vidéo source (top-down, side, OTS) — feature unique
- ✅ **Shot continuation** Aleph permet d'enchaîner cohéremment des
  mouvements caméra différents sur 2 clips successifs
- 🟡 `whip pan` reconnu mais souvent atténué (motion blur léger)
- 🟡 `dutch angle` correctement exécuté en image-to-video, plus difficile en text-to-video

## Termes spécifiques Runway

| Terme Runway | Effet |
|---|---|
| `Aleph: novel view from above` | Top-down de la scène source |
| `Aleph: novel view from side` | Vue latérale |
| `Aleph: novel view OTS` | Over-the-shoulder synthétique |
| `Continue this shot` | Shot continuation Aleph |

## À éviter

- ❌ Empiler 2 mouvements caméra dans le même prompt (préférer Aleph
  shot continuation pour enchaîner 2 plans)
