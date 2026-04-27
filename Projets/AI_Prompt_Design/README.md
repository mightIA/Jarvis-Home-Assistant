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
├── dall-e/                       ← spécifique DALL·E 3 / gpt-image-1
└── stable-diffusion/             ← spécifique SD 1.5 / SDXL / SD3 / Flux
```

Chaque dossier IA contient : `README.md`, `prompt_template.md`,
`parameters_reference.md`, `style_library.md`, `iterations_log.md`
(+ `negative_prompt_baseline.md` pour SD).

---

## Statut

| Phase | État | Date |
|-------|------|------|
| Structure projet créée | ✅ | 2026-04-26 |
| Fichiers core remplis | ✅ | 2026-04-26 |
| Dossiers IA initialisés | ✅ | 2026-04-26 |
| Premier cycle itératif | ⏳ | À lancer |
| 10 itérations cumulées | ⏳ | — |
| Templates stabilisés | ⏳ | — |

---

## Pour démarrer une session

Mickael : *"Jarvis, on continue AI Prompt Design. Décris-moi : <description image>"*

Jarvis : lit `01_PROJECT_TECHNICAL.md` + `00_core/style_preferences.md` +
`00_core/lessons_learned.md` + le `prompt_template.md` de l'IA cible →
génère le prompt optimisé.

Voir `PROTOCOLE.md` pour le détail du cycle complet.

---

*Créé en session 60 — 26 avril 2026 — par Jarvis avec Mickael.*
