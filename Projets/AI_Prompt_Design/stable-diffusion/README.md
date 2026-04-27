# Stable Diffusion — fiche IA

## Identité

- **Éditeur d'origine** : Stability AI (open source) ; FLUX par
  Black Forest Labs (anciens chercheurs Stability)
- **Versions principales** :
  - **SD 1.5** (2022) — légendaire, énorme écosystème CivitAI/LoRA
  - **SDXL** (2023) — meilleure compréhension prompt, qualité native
  - **SD3 / SD3.5** (2024) — langage naturel mieux supporté, texte OK
  - **FLUX.1** (2024-2026) — concurrent direct, excellent réalisme + texte
- **Open source** → tu peux l'installer en local **gratuit illimité**
- Modèles communautaires (CivitAI) : milliers de variantes fine-tunées

## Forces

- **100% gratuit** si install local (RTX 3090 de Mickael = idéal)
- **Contrôle ultra-fin** : CFG, steps, samplers, dimensions, seeds
- **Modèles spécialisés** : photoreal (RealisticVision, Juggernaut),
  anime (AnythingV5, MeinaMix), 3D (Disney Pixar XL), etc.
- **LoRA** : adaptateurs pour ajouter des concepts/styles/personnages
- **ControlNet** : contrôle pose / canny / depth / openpose etc.
- **IP-Adapter** : référence d'image style sans entraînement
- **Image-to-image / inpainting / outpainting** natifs
- **Pas de modération** côté local (responsabilité utilisateur)

## Faiblesses

- **Courbe d'apprentissage raide** : tags pondérés, negative prompts,
  paramètres techniques, samplers... pas pour novices
- **Anatomie / mains** : SD 1.5 catastrophique sans LoRA correctifs ;
  SDXL/SD3/FLUX bien meilleurs
- **Texte dans l'image** : SD 1.5/SDXL = très mauvais ; SD3/FLUX = OK
- **Setup local** : nécessite Auto1111, ComfyUI, Forge, ou Fooocus +
  GPU + modèles à télécharger
- **Qualité variable selon checkpoint** : trouver le bon modèle pour
  chaque besoin demande de tester

## Interfaces / clients

| Interface | Pour qui | Notes |
|-----------|----------|-------|
| **Automatic1111 (A1111)** | Débutants/intermédiaires | Web UI complète, beaucoup d'extensions |
| **Forge** | A1111 fork | Plus rapide, optimisations modernes |
| **ComfyUI** | Avancés | Node-based, pipeline complexes, contrôle total |
| **Fooocus** | Débutants | Wrapper SDXL ultra-simple, "MidJourney-like" |
| **InvokeAI** | Pro | Très polyvalent, canvas inpainting puissant |
| **Krita + plugin** | Artistes | Inpainting/édition dans Krita avec SD intégré |

## Modèles populaires (CivitAI)

| Domaine | Modèle phare | Type |
|---------|--------------|------|
| Photoréalisme | Juggernaut XL, RealisticVision | SDXL / SD 1.5 |
| Anime | Animagine XL, MeinaMix, AnythingV5 | SDXL / SD 1.5 |
| Portrait fine art | epiCRealism, AbsoluteReality | SD 1.5 |
| Concept art | DreamShaper XL | SDXL |
| Pixar 3D | Disney Pixar XL | SDXL |
| Tout-terrain moderne | FLUX.1 dev / schnell | FLUX |

## Documentation officielle / communautaire

- Stability AI : `https://stability.ai`
- HuggingFace models : `https://huggingface.co/stabilityai`
- CivitAI (modèles communautaires) : `https://civitai.com`
- A1111 GitHub : `https://github.com/AUTOMATIC1111/stable-diffusion-webui`
- ComfyUI : `https://github.com/comfyanonymous/ComfyUI`
- FLUX par BFL : `https://blackforestlabs.ai`

## Workflow standard Mickael

1. Brief Mickael en FR + version SD ciblée (SD 1.5 / SDXL / SD3 / FLUX)
2. Jarvis applique le template (voir [prompt_template.md](prompt_template.md))
3. Mickael colle dans son interface (A1111/ComfyUI/Forge selon install)
4. Génération avec params suggérés
5. Renvoi à Jarvis pour analyse + v2

## Pièges connus

- ⚠️ Negative prompt **obligatoire** sinon défauts récurrents
- ⚠️ Pondération syntaxe : `(word:1.2)` **sans espace** après `:`
- ⚠️ Limite tokens ~75, le début pèse plus
- ⚠️ CFG > 9 = "AI plastic look" / sur-cuisson
- ⚠️ Steps < 20 = flou ; > 50 = diminishing returns
- ⚠️ Mauvais checkpoint = on peut bricoler le prompt sans rien améliorer
- ⚠️ Ne pas confondre SD 1.5 prompt style (booru tags) vs SDXL/SD3
  (langage plus naturel possible)

## Liens projet

- Template prompt : [prompt_template.md](prompt_template.md)
- Référence paramètres : [parameters_reference.md](parameters_reference.md)
- Negative prompt baseline : [negative_prompt_baseline.md](negative_prompt_baseline.md)
- Bibliothèque styles SD : [style_library.md](style_library.md)
- Log itérations : [iterations_log.md](iterations_log.md)
