# Veo 3.1 — fiche IA vidéo

> ✅ **Modèle recommandé pour vidéo + audio en mai 2026** (vs Sora 2 en
> fin de vie). Couvre le même périmètre (image-to-video + audio synchronisé)
> sans risque de dépréciation imminente.

## Identité (mai 2026)

- **Éditeur** : Google
- **Modèle** : **Veo 3.1** (le nom "Veo 3" simple est obsolète)
- **Accès** :
  - `gemini.google.com` (Gemini Advanced)
  - Vertex AI (entreprises)
  - Gemini API (`ai.google.dev/gemini-api/docs/video`)
- **Sortie** : mai 2025, mise à jour majeure 3.1 fin 2025
- **Durée par défaut** : 8 s

## Forces

- **Audio natif** : dialogue lip-synced, SFX, ambient, music — qualité
  excellente
- **Prompt adherence** très bon (suit les instructions précisément)
- **Sortie 4K** disponible
- **Image-to-video** propre

## Faiblesses

- **Coût Vertex** sur les usages pro
- Censure modérée (sujets sensibles)
- 8 s par défaut, plus difficile d'étendre que Runway Aleph

## Workflow standard Mickael

1. Brief Mickael (incluant intention audio)
2. Frame de départ générée dans `midjourney/` etc.
3. Prompt Veo = motion + caméra + bloc `Audio:` (voir `audio_prompting_guide.md`)
4. Génération 8 s avec audio
5. Si dialogue : lip-sync vérifié, ajustement si besoin

## Syntaxe audio (résumé)

Voir `audio_prompting_guide.md` pour le détail. Format :

```
Audio:
- Dialogue: A woman says, "We have to leave now."   (4-10 mots, double quotes)
- SFX: ceramic cup clinks as it lands               (tied to action visible)
- Ambient noise: quiet hum of a starship bridge     (one clause)
- Music: minimal piano underscore, somber           (mood/texture, pas tempo)
```

## Pièges connus

- ⚠️ **Dialogue trop long** : > 10 mots = lip-sync casse, intelligibilité
  baisse. Raccourcir
- ⚠️ **Plusieurs SFX par beat** : 1 SFX par beat max, sinon désynchro
- ⚠️ **Music précise (BPM, instruments)** : le modèle ne respecte pas
  les contraintes techniques. Décrire en mood seul
- ⚠️ **Pas mélanger Audio: et inline mentions audio** dans la partie
  visuelle. Tout l'audio dans le bloc `Audio:`

## Liens projet

- Templates prompts : [prompt_template.md](prompt_template.md)
- Paramètres : [parameters_reference.md](parameters_reference.md)
- Vocabulaire caméra Veo : [camera_vocabulary.md](camera_vocabulary.md)
- Bibliothèque styles : [style_library.md](style_library.md)
- Log itérations : [iterations_log.md](iterations_log.md)
- Guide audio prompting (détaillé) : [audio_prompting_guide.md](audio_prompting_guide.md)
- Format prompt structuré : [structured_prompt_format.md](structured_prompt_format.md)

## Sources

- Doc officielle : `https://cloud.google.com/blog/products/ai-machine-learning/ultimate-prompting-guide-for-veo-3-1`
- Gemini API : `https://ai.google.dev/gemini-api/docs/video`
