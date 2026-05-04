# Vocabulaire caméra — Veo 3.1

> Référence transverse : [`_video_common/camera_vocabulary_global.md`](../_video_common/camera_vocabulary_global.md)

## Particularités Veo 3.1

- ✅ **Très bonne prompt adherence** — suit le mouvement caméra prompté
  avec précision
- ✅ Recommandation Google : **bloc `Camera:` séparé** dans le prompt
  structuré (voir `structured_prompt_format.md`)
- ✅ Vocabulaire cinéma standard reconnu (dolly, crane, orbit, tracking,
  Steadicam, handheld, etc.)
- 🟡 `dolly zoom` (Hitchcock zoom) reconnu mais effet souvent atténué
- ❌ `cut to` ignoré (un seul shot)

## Format recommandé (extrait structured_prompt_format.md)

```
Camera: Dolly in slowly toward the subject's face, holding for 2 seconds,
then a gentle pull out.
```

→ Veo 3.1 accepte des descriptions multi-étapes dans le bloc `Camera:`,
**dans la limite des 8 s par défaut**.

## À éviter

- ❌ Mentionner mouvement caméra dans plusieurs blocs (mettre tout dans `Camera:`)
- ❌ Multi-mouvements > 2 dans un clip 8 s (cohérence dégradée)
