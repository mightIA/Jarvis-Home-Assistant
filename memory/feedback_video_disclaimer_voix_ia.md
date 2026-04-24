---
name: Vidéo YouTube avec disclaimer "Contenu modifié ou synthétique" → recouper
description: Règle d'évaluation des sources — quand YouTube affiche "Contenu modifié ou synthétique (son ou images modifiés/générés numériquement)", la voix off est probablement IA et le contenu pédagogique doit être recoupé avec sources primaires avant d'être retenu.
type: feedback
---

# Règle : disclaimer YouTube "Contenu modifié ou synthétique" = recouper

**Énoncé** : quand une vidéo YouTube affiche le marqueur officiel **"Contenu modifié ou
synthétique — Le son ou les images ont été modifiés de manière significative ou générés
numériquement"** (apparu en 2024-2025 chez YouTube pour signaler les contenus générés par IA),
considérer le contenu pédagogique comme **non garanti par expertise humaine** et le recouper
systématiquement avec une source primaire avant de le retenir.

**Why** :
- La voix off et/ou les visuels sont probablement générés par IA (TTS type ElevenLabs +
  vidéo Sora/Veo/HeyGen ou similaire)
- L'auteur peut être réel mais déléguer la création à un pipeline IA → pas de garantie qu'il
  ait validé chaque affirmation
- Combiné à un pivot commercial fort (formation à vendre, code promo, urgence "24h avant
  hausse de prix"), le risque marketing > risque pédagogique
- Cas concret S38 (25/04/2026) : vidéo ParlonsIA "Obsidian + Claude 4.7" affichait ce
  disclaimer + 3 pivots formation + thèse complot Karpathy non démontrée. Verdict : utile
  pour 3 idées techniques piochées (Mistral OCR, Qwen Embedding, sub-agents wiki_*) mais
  formation auteur écartée et thèse complot non retenue

**How to apply** :
- À chaque vidéo YouTube partagée par Mickael ou consultée pour Phase 1bis / autre projet,
  vérifier la présence du disclaimer "Contenu modifié ou synthétique"
- Si présent : flagger explicitement dans la synthèse (comme fait S38) + demander à Mickael
  s'il veut recouper avec source primaire avant d'agir
- Sources primaires à privilégier pour les sujets techniques IA : doc Anthropic, repos GitHub
  officiels (Nous Research, OpenAI, Anthropic, Mistral), articles Karpathy/papers arXiv,
  documentation Hermes Agent
- **Ne pas** rejeter d'emblée le contenu (il peut contenir des idées justes), juste élever
  le seuil de confiance avant adoption

**Cas où on peut faire confiance malgré le disclaimer** :
- Vidéo factuelle simple (tutoriel install d'un outil, démo d'une fonctionnalité)
- Auteur reconnu indépendamment + sources citées vérifiables
- Pas de pivot commercial fort dans la vidéo

**Cas où méfiance forte (S38 = exemple type)** :
- Disclaimer + 3+ mentions formation payante + thèse complot ou attaque ad hominem +
  affirmations techniques pointues non sourcées

---

*Posée S38 (25/04/2026) suite analyse vidéo ParlonsIA. Règle générale, applicable à toute
vidéo IA-générée future.*
