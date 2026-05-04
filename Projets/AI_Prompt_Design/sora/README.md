# Sora 2 — fiche IA vidéo

> 🔴 **ALERTE DÉPRÉCATION (mai 2026)** : Sora web et app **discontinued
> le 26 avril 2026**. L'**API Sora 2 sera discontinuée le 24 septembre
> 2026**. Mickael ne devrait **pas investir dans des workflows Sora 2**
> au-delà de tests ponctuels d'ici septembre.
>
> **Recommandation** : utiliser **Veo 3.1** (Google) qui couvre le même
> périmètre (audio natif + image-to-video) et n'est pas en fin de vie.

## Identité (état mai 2026)

- **Éditeur** : OpenAI
- **Modèle** : Sora 2 (sortie 30 sept 2025)
- **Statut consumer** : ❌ Web/app discontinued 26/04/2026
- **Statut API** : ⏳ encore actif jusqu'au **24/09/2026**, puis arrêt
- **Référence dépréciation** :
  `https://help.openai.com/en/articles/20001152-what-to-know-about-the-sora-discontinuation`

## Forces (historiques)

- **Audio natif** (premier modèle vidéo grand public à offrir audio
  synchronisé : dialogue, SFX, ambient, music)
- **Cameos** (fonction de référence sociale unique)
- Cohérence physique correcte
- Durée de clip jusqu'à 60 s sur ChatGPT Pro (vs 5-10 s ailleurs)

## Faiblesses

- **Service en fin de vie** — voir alerte en haut de fiche
- Watermark obligatoire sur les exports gratuits
- Modération assez stricte
- Accès gated même pendant la période active

## Workflow restreint Mickael (jusqu'au 24/09/2026)

1. Tester Sora 2 via API uniquement (web/app fermés)
2. Comparer rendu vs Veo 3.1 sur les mêmes briefs
3. Si Sora 2 reste préféré sur certains cas → archiver les prompts qui
   marchent dans `iterations_log.md` pour réutilisation post-déprécation
   (mais sans investissement long terme)

## Pièges connus

- ⚠️ **Investir des heures dans des workflows Sora 2 = perte sèche**
  après le 24/09/2026
- ⚠️ **Cameos** : feature impossible à reproduire ailleurs, mais inutilisable
  hors période active
- ⚠️ **Documentation OpenAI** sur Sora 2 va disparaître progressivement,
  archiver tout snapshot utile

## Liens projet

- Templates prompts : [prompt_template.md](prompt_template.md)
- Paramètres : [parameters_reference.md](parameters_reference.md)
- Vocabulaire caméra Sora : [camera_vocabulary.md](camera_vocabulary.md)
- Bibliothèque styles : [style_library.md](style_library.md)
- Log itérations : [iterations_log.md](iterations_log.md)
- Guide audio prompting : [audio_prompting_guide.md](audio_prompting_guide.md)
- Politique Cameos : [cameos_policy.md](cameos_policy.md)
- Statut accès (à jour) : [access_status.md](access_status.md)

## Sources

- Annonce dépréciation : `https://help.openai.com/en/articles/20001152-what-to-know-about-the-sora-discontinuation`
- API status : `https://community.openai.com/t/is-the-sora2-api-still-working/1379946`
- Doc historique : `https://openai.com/index/sora-2/`
