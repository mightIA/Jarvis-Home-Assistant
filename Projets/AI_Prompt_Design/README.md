# AI Prompt Design

Projet personnel de **Mickael** — système structuré de génération de prompts
optimisés pour les principales IA d'images, avec boucle d'amélioration
itérative pilotée par Jarvis.

> **Slogan** : *Décris une image. Reçois un prompt. Itère jusqu'à match.*

---

## Vision en 30 secondes

1. Mickael décrit une image en langage naturel (FR).
2. Jarvis lit ce projet en début de conversation et génère un prompt optimisé
   pour l'IA cible (Midjourney / DALL·E / Stable Diffusion).
3. Mickael teste le prompt, renvoie l'image générée.
4. Jarvis fait une **analyse comparative** (attendu vs obtenu), score le
   résultat, propose un prompt v2 + une mise à jour des fichiers projet
   (style preferences, lessons learned, error patterns).
5. On répète jusqu'à atteindre la qualité visée.

Ce n'est pas un système autonome qui apprend tout seul — c'est un
**framework itératif** où chaque cycle améliore la base de connaissances
partagée Jarvis ↔ Mickael.

---

## Architecture

```
Projets/AI_Prompt_Design/
├── README.md                     ← ce fichier
├── 01_PROJECT_TECHNICAL.md       ← spec technique dense (lue en début de conv)
├── 02_PROJECT_PEDAGOGIQUE.md     ← source du PDF pédagogique
├── 02_PROJECT_PEDAGOGIQUE.pdf    ← livrable doc projet (à imprimer/partager)
├── PROTOCOLE.md                  ← workflow d'itération step-by-step
├── 00_core/                      ← base commune toutes IA
│   ├── prompt_template_global.md
│   ├── style_preferences.md      ← goûts visuels Mickael (vivant)
│   ├── lessons_learned.md        ← apprentissages itérations (vivant)
│   ├── library_styles.md         ← bibliothèque réutilisable
│   ├── error_patterns.md         ← erreurs fréquentes + correctifs
│   └── scoring_grid.md           ← grille notation /50
├── midjourney/                   ← spécifique MJ V7
├── dall-e_gpt-image/             ← spécifique DALL·E 3 / gpt-image-1 / 1.5 / 2
├── stable-diffusion/             ← spécifique SD 1.5 / SDXL / SD3 / Flux
│
│   ─── BRANCHE VIDÉO (depuis S90, 03/05/2026) ───
│
├── _video_common/                ← référence transverse vidéo
│   ├── camera_vocabulary_global.md
│   ├── temporal_cues.md
│   └── image_to_video_workflow.md
├── runway/                       ← Runway Gen-4 / Aleph / Act-Two (4K, édition vidéo)
├── pika/                         ← Pika 2.x (Scene Ingredients, Pikaffects)
├── kling/                        ← Kling 2.1 / Master (physique réaliste, Motion Brush)
├── luma/                         ← Luma Ray2 / Flash (Keyframes start+end, Camera Concepts)
├── sora/                         ← Sora 2 ⚠️ déprécié 24/09/2026
├── veo3/                         ← Veo 3.1 (audio natif, prompt structuré)
└── hailuo/                       ← Hailuo 02 (rapport qualité/prix)
```

Chaque dossier IA **image** contien