# Vocabulaire caméra — Sora 2

> Référence transverse : [`_video_common/camera_vocabulary_global.md`](../_video_common/camera_vocabulary_global.md)

> 🔴 API discontinuée le **24/09/2026**.

## Particularités Sora 2

- ✅ **Très large vocabulaire** caméra reconnu (Sora 2 a été entraîné sur
  un large corpus cinéma)
- ✅ Termes cinéma avancés OK (`whip pan`, `dolly zoom`, `Steadicam follow`)
- ✅ Combinaison plusieurs mouvements caméra dans un clip long (jusqu'à 60 s)
- 🟡 Cohérence physique baisse en clips > 20 s
- 🟡 Watermark visible (gratuit), optionnel sur Pro

## À éviter

- ❌ Investir du temps dans des prompts caméra avancés Sora 2 alors que
  l'API ferme le 24/09/2026
- ❌ Mélanger `cut to` (modèle ignore, fait UN shot continu)
