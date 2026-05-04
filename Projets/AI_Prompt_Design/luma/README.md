# Luma — fiche IA vidéo

## Identité (mai 2026)

- **Éditeur** : Luma Labs
- **Modèles couverts** : Ray2 / Ray2 Flash (text-to-video + image-to-video)
- **Features signature** :
  - **Keyframes start + end** : définir image de départ ET image
    d'arrivée, le modèle interpole l'animation
  - **Camera Concepts** : presets de concepts caméra (orbit, push in,
    crane shot, etc.) en un clic
  - Ray2 Flash : version rapide / moins chère

## Forces

- **Keyframes** : seul modèle grand public à offrir interpolation
  start+end frame native
- **Camera Concepts** : ergonomie excellente pour mouvement caméra
- Génération rapide en mode Flash

## Faiblesses

- **Détail mou** par rapport à Kling et Veo 3.1 (pas le meilleur sur les
  textures fines)
- Pas d'audio natif
- 5 s par clip (10 s composé via 2 clips keyframés)

## Workflow standard Mickael

1. Brief Mickael
2. Frame de départ (keyframe start)
3. Optionnel : keyframe end (image de fin)
4. Camera Concept choisi (ou prompt caméra libre)
5. Génération 5 s

## Pièges connus

- ⚠️ **Keyframes incohérents** : si start et end trop différents, morphing
  désagréable. Garder le sujet identique, varier setting/mouvement
- ⚠️ **Camera Concepts + prompt caméra texte** : conflit, choisir l'un

## Liens projet

- Templates prompts : [prompt_template.md](prompt_template.md)
- Paramètres : [parameters_reference.md](parameters_reference.md)
- Vocabulaire caméra Luma : [camera_vocabulary.md](camera_vocabulary.md)
- Bibliothèque styles : [style_library.md](style_library.md)
- Log itérations : [iterations_log.md](iterations_log.md)
- Guide Keyframes : [keyframes_guide.md](keyframes_guide.md)
- Catalogue Camera Concepts : [camera_concepts_catalog.md](camera_concepts_catalog.md)

## Sources

- Doc officielle : `https://lumalabs.ai`
