# Pika — fiche IA vidéo

## Identité (mai 2026)

- **Éditeur** : Pika Labs
- **Modèles couverts** : Pika 2.1 / 2.2 (text-to-video + image-to-video)
- **Features signature** :
  - **Scene Ingredients** : combiner plusieurs éléments (sujets, props,
    décor) référencés image en un seul clip cohérent
  - **Pikaffects** : effets VFX paramétriques (explosion, melt, inflate,
    crush, etc.) — leader du marché sur ce créneau
- **Accès** : `pika.art` (web app + Discord)

## Forces

- **VFX paramétriques** (Pikaffects) inégalés sur transformations type
  "melt the building" ou "inflate the cat"
- **Scene Ingredients** : composition multi-références propre
- Bon rapport qualité/prix entrée de gamme

## Faiblesses

- **Cohérence longue moyenne** : durée 5 s nominale, extension à 10 s
  perd en qualité
- Pas d'audio natif
- Détail textures inférieur à Kling et Veo 3.1

## Workflow standard Mickael

1. Brief Mickael
2. Frame de départ ou Scene Ingredients (multi-images de référence)
3. Prompt = motion + style transformation si Pikaffect
4. Génération 5 s
5. Pikaffect ciblé si transformation voulue

## Pièges connus

- ⚠️ **`tilt` confondu avec `pedestal`** : être explicite (cf
  `_video_common/camera_vocabulary_global.md`)
- ⚠️ **Pikaffects + camera movement** : ne pas combiner, choisir l'un
  ou l'autre par clip
- ⚠️ **Scene Ingredients + Pikaffect** : combinaison instable, tester
  séparément

## Liens projet

- Templates prompts : [prompt_template.md](prompt_template.md)
- Paramètres : [parameters_reference.md](parameters_reference.md)
- Vocabulaire caméra Pika : [camera_vocabulary.md](camera_vocabulary.md)
- Bibliothèque styles : [style_library.md](style_library.md)
- Log itérations : [iterations_log.md](iterations_log.md)
- Guide Scene Ingredients : [scene_ingredients_guide.md](scene_ingredients_guide.md)
- Catalogue Pikaffects : [pikaffects_catalog.md](pikaffects_catalog.md)

## Sources

- Doc officielle : `https://pika.art`
