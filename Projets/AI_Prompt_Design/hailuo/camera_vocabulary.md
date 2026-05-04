# Vocabulaire caméra — Hailuo 02

> Référence transverse : [`_video_common/camera_vocabulary_global.md`](../_video_common/camera_vocabulary_global.md)

## Particularités Hailuo

- ✅ **Bon** sur `static shot`, `pan left/right`, `push in`, `pull out`
- 🟡 `tilt` confondu avec `pedestal` (comme Pika) — expliciter si vrai tilt
- 🟡 `orbit` interprété mais arc souvent incomplet
- ❌ `whip pan`, `dutch angle` peu fiables
- ❌ Termes cinéma avancés non reconnus (limites du fine-tuning EN)

## À éviter

- ❌ Vocabulaire avancé (`Steadicam`, `Hitchcock zoom`) → fallback sur
  basic terms
- ❌ Mouvement complexe en > 6 s (cohérence dégrade vite)
