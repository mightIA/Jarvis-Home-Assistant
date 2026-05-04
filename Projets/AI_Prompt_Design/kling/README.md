# Kling — fiche IA vidéo

## Identité (mai 2026)

- **Éditeur** : Kuaishou (Chine)
- **Modèles couverts** : Kling 2.1 / Master (text-to-video + image-to-video)
- **Features signature** :
  - **Réalisme physique** top niveau (chutes, fluides, tissus)
  - **Motion Brush** : painter de zones de mouvement sur image source
  - **Master shots** : presets de mouvement caméra cinématographiques

## Forces

- **Physique réaliste** : best-in-class pour gravité, fluides, particules,
  cheveux, tissus
- **Motion Brush** : contrôle précis des zones animées
- Détail textures et matériaux excellent

## Faiblesses

- **UI en CN** par défaut (web app `klingai.com` partiellement EN)
- **Censure** plus stricte que les modèles US (sujets sensibles, politique,
  religion)
- Pas d'audio natif

## Workflow standard Mickael

1. Brief Mickael
2. Frame de départ
3. Motion Brush si zones animées spécifiques (peindre les zones)
4. Master shot preset si caméra cinématique
5. Génération 5 ou 10 s

## Pièges connus

- ⚠️ **Sujets sensibles** : reformuler avant de soumettre
- ⚠️ **Master shots + Motion Brush** : combinaison instable, tester séparément
- ⚠️ **UI Discord-like** : exporter le clip en .mp4 puis nettoyer le watermark
  selon le plan

## Liens projet

- Templates prompts : [prompt_template.md](prompt_template.md)
- Paramètres : [parameters_reference.md](parameters_reference.md)
- Vocabulaire caméra Kling : [camera_vocabulary.md](camera_vocabulary.md)
- Bibliothèque styles : [style_library.md](style_library.md)
- Log itérations : [iterations_log.md](iterations_log.md)
- Guide Motion Brush : [motion_brush_guide.md](motion_brush_guide.md)
- Master shot presets : [master_shot_presets.md](master_shot_presets.md)

## Sources

- Doc officielle : `https://klingai.com`
