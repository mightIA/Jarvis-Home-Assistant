# Politique Cameos — Sora 2

> 🔴 API discontinuée le **24/09/2026**. Cameos disparaissent avec Sora 2.

## Principe

**Cameos** = feature Sora 2 permettant d'utiliser une **vidéo de référence
d'une personne** (consentante) pour la faire apparaître dans un clip généré.

Sans équivalent fonctionnel chez les concurrents en 2026.

## Cas d'usage légitimes

- Vidéos personnelles avec consentement explicite (ex : invitation
  anniversaire, message vidéo personnalisé)
- Tests avec sa propre image (Mickael peut s'utiliser comme cameo)
- Personnages historiques publics (entrée dans le domaine public)

## Restrictions OpenAI

- ❌ **Personnages réels vivants sans consentement** (refusé)
- ❌ **Mineurs** (refusé)
- ❌ **Contenu sexuel ou violent impliquant la personne** (refusé)
- ❌ **Désinformation politique** (refusé)
- 🟡 **Watermark obligatoire** sur tous les exports cameo

## Workflow Mickael (jusqu'au 24/09/2026)

1. Enregistrer une vidéo de référence (toi-même, 10-30 s, multi-angles)
2. Upload comme Cameo
3. Prompt : `[CAMEO REFERENCE] doing [ACTION] in [SETTING].`
4. Génération avec watermark
5. Archive le clip + le prompt pour mémoire

## Disparition septembre 2026

Pas d'équivalent prévu chez les concurrents 2026 :
- Veo 3.1 : cohérence personnage par image-to-video uniquement
- Runway Act-Two : transposition de performance, pas génération à partir
  d'une simple identité
- gpt-image-2 : cohérence personnages dans batch image, pas vidéo

→ Si tu veux préserver des Cameos, il faut **archiver les clips finis**
plutôt que les prompts (les prompts sans le service ne servent à rien).

## Sources

- Annonce dépréciation : `https://help.openai.com/en/articles/20001152-what-to-know-about-the-sora-discontinuation`
