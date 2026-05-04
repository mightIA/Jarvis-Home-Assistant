# DALL·E / gpt-image — fiche IA

## Identité

- **Éditeur** : OpenAI
- **Versions couvertes par ce dossier** :
  - **DALL·E 3** (legacy, intégré ChatGPT UI, Bing/Copilot, Responses API)
  - **gpt-image-1** (avril 2025, multimodal, edits/variations natifs)
  - **gpt-image-1.5** (octobre 2025, aspect ratios étendus, sortie 2K)
  - **gpt-image-2** (**21 avril 2026**, cohérence personnages native dans
    un batch `n=1..8`, équivalent fonctionnel `--cref` MJ)
- **Accès gratuit** : ChatGPT (limité), Microsoft Copilot (Bing Image
  Creator), Bing Image Creator standalone (DALL·E 3 uniquement)
- **Accès payant** : ChatGPT Plus / Team / Enterprise, API OpenAI
  (`client.images.generate(model="gpt-image-2", ...)`)
- **À éviter** : Sora 2 image generation (**deprecated 24 sept 2026**)

## Forces

- **Texte dans l'image** : meilleur du marché grand public, lit et
  reproduit fidèlement les phrases courtes
- **Instruction-following** : suit les briefs complexes mieux que MJ
  (multiples sujets, scènes narratives)
- **Langage naturel** : pas besoin de syntaxe spéciale, on décrit comme
  on parlerait
- Cohérence stylistique entre plusieurs images d'une même session
- gpt-image-1 : excellent pour infographies, schémas, posters avec texte

## Faiblesses

- **ChatGPT réécrit le prompt** en interne ("prompt rewriting") — il
  faut souvent forcer "Use this exact prompt without rewriting:"
- **Modération stricte** : refuse violence, contenu sensible,
  personnalités vivantes (sauf historiques anciennes)
- **Style "polished"** par défaut — moins de grain, moins de réalisme
  brut que MJ V7 raw
- **Pas de paramètres formels** : tout passe par le prompt
- Format limité aux 3 ratios standards (1024×1024, 1024×1792, 1792×1024)
- Pas de cohérence personnage entre images comme `--cref` MJ

## Documentation officielle

- DALL·E 3 system card : `https://openai.com/research/dall-e-3-system-card`
- API docs : `https://platform.openai.com/docs/guides/images`
- gpt-image-1 docs : `https://platform.openai.com/docs/guides/images-vision`
- Best practices : `https://help.openai.com/en/articles/8400977`

## Méthodes communautaires

- **Préfixe "exact prompt"** : `Use this exact prompt without rewriting:` →
  bypass le prompt rewriting de ChatGPT
- **Format d'image dans le prompt** : `"A vertical 9:16 poster of..."` →
  DALL·E 3 dans ChatGPT comprend et adapte
- **Cohérence personnage entre images** : décrire le personnage en détail
  identique d'une image à l'autre (pas de système type --cref)
- **gen_id pour variation** : `gen_id` retourné par ChatGPT, le citer pour
  obtenir variations
- **Edit / inpainting** : possible côté API (DALL·E 2 historique) ou
  modes spécifiques web

## Workflow standard Mickael

1. Brief Mickael en FR
2. Jarvis applique le template (voir [prompt_template.md](prompt_template.md))
3. Mickael colle dans ChatGPT (ou Bing Image Creator pour version gratuite)
4. Génération 1 image (ChatGPT) ou 4 images (Bing Image Creator)
5. Renvoi à Jarvis pour analyse + v2

## Pièges connus

- ⚠️ ChatGPT réécrit le prompt → toujours préfixer "Use this exact
  prompt without rewriting:" pour les briefs précis
- ⚠️ ChatGPT ajoute parfois des éléments "pour rendre plus joli" →
  expliciter "do not add elements not described"
- ⚠️ Modération bloque parfois sur des termes neutres (ex : "blood orange")
  → reformuler
- ⚠️ Le style par défaut est "trop propre" pour réalisme strict → demander
  "with imperfections, slight grain, candid feel"
- ⚠️ Personnages réels vivants : refusés. Personnages historiques OK
  (Napoléon, Mozart...)

## Liens projet

- Template prompt : [prompt_template.md](prompt_template.md)
- Référence paramètres : [parameters_reference.md](parameters_reference.md)
- Bibliothèque styles DALL·E : [style_library.md](style_library.md)
- Log itérations : [iterations_log.md](iterations_log.md)
