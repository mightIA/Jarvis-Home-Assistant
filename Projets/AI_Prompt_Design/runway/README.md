# Runway — fiche IA vidéo

## Identité (mai 2026)

- **Éditeur** : Runway AI
- **Modèles couverts** :
  - **Gen-4** (text-to-video + image-to-video, 4K, 5 ou 10 s)
  - **Gen-4 Turbo** (Gen-4 plus rapide / moins cher)
  - **Aleph** (video-to-video : édition, transformation, novel view, shot
    continuation, object add/remove, relighting)
  - **Act-Two** (motion capture facial — remplace Act-One)
- **Workflows** custom pipelines (chaîner Gen-4 + Aleph + Act-Two)
- **Accès** : `runwayml.com` (à partir de **$12/mois**) + API Replicate / WaveSpeedAI

## Forces

- **Cohérence inter-shots** : Aleph permet de chaîner des plans cohérents
  (shot continuation) avec sujet stable
- **Édition vidéo** : Aleph fait du video-to-video propre (relighting,
  object insertion, novel view) sans re-générer
- **4K natif** sur Gen-4
- **Motion capture facial** via Act-Two
- **Workflows** : création de pipelines réutilisables

## Faiblesses

- **Pas d'audio natif** (à comparer avec Veo 3.1 et Sora 2)
- **Coût** : Gen-4 4K cher en crédits (Turbo plus accessible)
- **5 ou 10 s par clip** seulement (étendre via shot continuation Aleph)

## Workflow standard Mickael

1. Brief Mickael en FR
2. Frame de départ générée dans `midjourney/` ou `dall-e_gpt-image/` ou
   `stable-diffusion/` (voir `_video_common/image_to_video_workflow.md`)
3. Prompt Runway = motion + caméra uniquement (pas redécrire le sujet)
4. Génération clip 5 s
5. Si extension nécessaire → Aleph shot continuation
6. Si édition (relighting, object) → Aleph video-to-video
7. Si motion capture facial → Act-Two

## Pièges connus

- ⚠️ **Dolly vs zoom** : préciser, Runway les confond moins que les autres
  mais reste prudent
- ⚠️ **Texte dans l'image** : pas le fort de Runway, préférer overlay en post
- ⚠️ **Audio à ajouter en post** (Premiere, DaVinci, ou ElevenLabs / Suno)

## Liens projet

- Templates prompts : [prompt_template.md](prompt_template.md)
- Paramètres : [parameters_reference.md](parameters_reference.md)
- Vocabulaire caméra Runway : [camera_vocabulary.md](camera_vocabulary.md)
- Bibliothèque styles : [style_library.md](style_library.md)
- Log itérations : [iterations_log.md](iterations_log.md)
- Guide Aleph (édition vidéo) : [aleph_guide.md](aleph_guide.md)
- Guide Act-Two (motion capture) : [act_two_guide.md](act_two_guide.md)
- Guide références (Gen-4 image refs) : [references_guide.md](references_guide.md)

## Sources

- Doc officielle : `https://help.runwayml.com`
- Pricing : `https://runwayml.com/pricing`
- Aleph blog : `https://wavespeed.ai/blog/posts/introducing-runway-gen4-aleph-on-wavespeedai/`
