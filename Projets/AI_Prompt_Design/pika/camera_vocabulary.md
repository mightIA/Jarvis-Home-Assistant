# Vocabulaire caméra — Pika 2.x

> Référence transverse : [`_video_common/camera_vocabulary_global.md`](../_video_common/camera_vocabulary_global.md)

## Particularités Pika

- ✅ **Bon** sur `push in`, `pull out`, `pan left/right`, `static shot`
- 🟡 `tilt up/down` **souvent confondu avec `pedestal`** — expliciter
  "camera moves vertically without rotating, framing tilts" si vrai tilt
- 🟡 `orbit` interprété correctement mais arc parfois incomplet sur 5 s
- ❌ `whip pan` peu fiable
- ❌ Combinaison **caméra + Pikaffect** instable (choisir l'un)

## À éviter

- ❌ `tilt` sans précision (ambigu)
- ❌ Mouvement caméra + Pikaffect (le Pikaffect gagne, caméra ignorée)
- ❌ Mouvement complexe en > 5 s (extension perd la cohérence)
