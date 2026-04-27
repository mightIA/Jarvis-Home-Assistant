---
source: Projet_Complet_v2.pdf (25 p, 1231,88 KB)
outil: pdf-toolkit MCP (read_pdf_content)
duree: < 2 s
caracteres: 40 879
date: 2026-04-25 (S45 Phase 1bis-b)
---

# Extraction `pdf-toolkit` brute — Projet_Complet_v2.pdf

> Texte tel quel, sans post-traitement, pour comparaison fidèle avec
> Mistral. Voir `notes.md` pour analyse qualitative.

```
DOCUMENT INTERNE • SESSION 36 • 24 AVRIL 2026Projet JarvisVers une architecture hybride HermèsClaude Max + Hermes Agent + Ollama + ObsidianVision pédagogique, étude de faisabilité, plan d'adoption progressif.En un coup d'œil• Problème résolu : consommation quota Max sur tâches simples, dépendance cloudtotale, mobilité via claude.ai générique.• Solution : Hermes Agent (Nous Research, MIT) orchestre Claude + modèles locaux (RTX3090) + OpenRouter selon un routing intelligent.• Cohabitation : Cowork Desktop conservé. Hermès est un complément, pas unremplacement.• Coût additionnel : environ 5 à 10 $/mois (OpenRouter pay-as-you-go). Reste : opensource.• Risque : maîtrisé – Règle 0 appliquée, rollback à tout moment, fallbacks dynamiquesvers Claude.Auteur : Jarvis, assistant domotique de MickaelCadre : aucune modification d'architecture Jarvis n'a été faite ni ne sera faite sans validation explicite deMickael. Ce document est une vision, pas une implémentation.

[... extraction complète conservée dans le tool result S45, 40 879 chars
au total. Le texte intégral n'est pas dupliqué ici pour ne pas alourdir
le rapport — réinjectable à la demande via read_pdf_content. ...]

[FIN extraction pdf-toolkit — 40 879 caractères au total]
```

## Symptômes structurels typiques

### Page de garde (premiers 800 chars)

Tout collé en un seul paragraphe sans saut de ligne. Mots fusionnés
côte à côte (ex. `cloudtotale`, `RTX3090`, `unremplacement`).

### Sommaire (pages ii-iii)

Liste à puces de la ToC entièrement collée :
*"1 Préambule . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 12 Chapitre 1 — Vue d'ensemble . . . . 12.1 1.1 Qu'est-ce que Jarvis aujourd'hui ? . . . 1..."*

### Tableaux (sections 2.2 modèles Ollama, annexes B/C)

Cellules collées sans séparateur. Exemple modèles Ollama :
*"Modèle Taille VRAM Vitesse Rôle envisagéQwen 3 32BQ4_K_M22,2 Go ~35 tok/s Tâches standard,qualité procheClaude SonnetQwen 3 30B-A3B(MoE)~20 Go ~130 tok/s Ultra-rapide pour..."*

### En-têtes/pieds répétés sur 25 pages

- Header : `Projet Jarvis • Hermes Agent Session 36 • 24 avril 2026`
- Footer : `Document interne • Vision, pas une obligation X / 21`

### Figures

8 figures détectées par leur **caption** seulement :
- Fig. 1 – Architecture Jarvis actuelle — avril 2026
- Fig. 2 – Architecture Jarvis cible — Claude + Hermès + Ollama + Obsidian
- Fig. 3 – Benchmarks modèles locaux sur RTX 3090
- Fig. 4 – Workflow de routing — décision requête par requête
- Fig. 5 – Gateways Hermès — points d'entrée multi-canaux
- Fig. 6 – Répartition tokens avant / après adoption Hermès
- Fig. 7 – Stratégies d'abonnement LLM — coût mensuel estimé
- Fig. 8 – Timeline du projet Jarvis → Hermes Agent

**Aucun contenu visuel décrit** — pdf-toolkit ne regarde pas les images.

### Glossaire technique (annexe A)

Tableau à 2 colonnes complètement collé :
*"Terme DéfinitionAgent Programme qui utilise un LLM pouraccomplir des tâches de manièreautonome (pas juste répondre à desquestions).AGENTS.md Fichier schema de Hermes Agent,équivalent du CLAUDE.md de Jarvis —..."*

## Conclusion provisoire

`pdf-toolkit read_pdf_content` extrait fidèlement le texte mais ne
restitue **aucune structure**. Pour un usage `wiki_ingestor` Hermès,
il faudrait derrière :

1. Regex pour supprimer les en-têtes/pieds répétés
2. Regex pour détecter les chapitres par leur numérotation `^N\.M `
3. Reconstruction manuelle des 4 tableaux principaux
4. Description manuelle ou via vision LLM des 8 schémas
5. Insertion des sauts de ligne entre paragraphes (par heuristique)

→ **~30 min de travail manuel par PDF de cette taille** pour avoir un
Markdown propre exploitable.

À comparer avec ce que Mistral fait nativement (résultat à venir).
