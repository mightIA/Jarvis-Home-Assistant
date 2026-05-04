# Hailuo — fiche IA vidéo

## Identité (mai 2026)

- **Éditeur** : MiniMax (Chine)
- **Modèle** : Hailuo 02 (text-to-video + image-to-video)
- **Accès** : `hailuoai.video` (web)
- **Différenciation** : meilleur **rapport qualité/prix** du marché 2026

## Forces

- **Prix** : tarif compétitif (alternative crédible à Pika sur le créneau
  entrée de gamme)
- **Cohérence acceptable** sur clip 6-10 s
- Image-to-video natif
- Audio limité disponible (qualité variable)

## Faiblesses

- **Doc EN limitée** (UI partiellement traduite, exemples souvent CN)
- **Censure** chinoise (sujets politiques/historiques sensibles)
- Détail textures inférieur à Kling et Veo 3.1
- Audio basique (uniquement musique d'ambiance, pas de lip-sync fiable)

## Workflow standard Mickael

1. Brief Mickael
2. Frame de départ
3. Prompt EN (le modèle gère mieux que prompt CN auto-traduit)
4. Durée 6 s par défaut (10 s OK si motion claire)
5. Audio désactivé sauf si ambient music acceptable
6. Comparer coût vs Pika sur même brief

## Pièges connus

- ⚠️ **UI partiellement traduite** : certains paramètres restent en CN
- ⚠️ **Audio peu fiable** : préférer ajout en post pour qualité pro
- ⚠️ **Sujets sensibles** : censure plus stricte que les modèles US

## Liens projet

- Templates prompts : [prompt_template.md](prompt_template.md)
- Paramètres : [parameters_reference.md](parameters_reference.md)
- Vocabulaire caméra Hailuo : [camera_vocabulary.md](camera_vocabulary.md)
- Bibliothèque styles : [style_library.md](style_library.md)
- Log itérations : [iterations_log.md](iterations_log.md)
- Comparatif pricing vs qualité : [pricing_vs_quality.md](pricing_vs_quality.md)

## Sources

- Doc officielle : `https://hailuoai.video`
