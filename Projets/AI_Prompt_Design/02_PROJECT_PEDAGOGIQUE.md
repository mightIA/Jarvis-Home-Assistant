# AI Prompt Design

## Document projet — version pédagogique complète

*Mickael × Jarvis — v1.1 régénérée le 3 mai 2026 (S90) — v1.0 originale 26 avril 2026*

---

## Mise à jour v1.1 — Session 90 (3 mai 2026)

Cette version v1.1 intègre les findings de l'**audit S69 (27/04/2026)** et
les WebSearch ciblés effectués en S90 sur les modèles 2026 :

### Patches appliqués (40 patches sur 4 phases)

- **Phase A — 11 patches P0 critiques** : Midjourney V7 (`::` cassé,
  `--oref/--ow`, `--exp/--draft`, anti-patterns V7) ; DALL·E gpt-image
  (matrice 4 modèles dont **gpt-image-2 sorti 21/04/2026**, params API
  complets, clarif rewriter) ; Stable Diffusion (SD 3.5 Large/Turbo/Medium,
  écosystème FLUX étendu, Pony Diffusion V6 + Illustrious-XL).
- **Phase B — 61 nouveaux fichiers** : branche vidéo entière avec
  **7 modèles** (Runway Gen-4 + Aleph + Act-Two, Pika 2.x, Kling 2.1 +
  Master, Luma Ray2 + Flash, Sora 2, Veo 3.1, Hailuo 02), `_video_common/`
  (vocabulaire caméra, temporal cues, image-to-video workflow) et
  `00_core/dimensions_video.md` (3 dimensions vidéo additionnelles).
- **Phase C — 17 patches P1** : workflow Draft V7, stack créatif V7
  (jusqu'à 6 références combinées), 5 techniques cohérence personnage
  gpt-image-2, modération 2026 + `moderation="low"`, streaming
  `partial_images`, **12 nouveaux styles tendance 2026** (Liminal Space,
  Y2K, Brutalist, Wabi-sabi, Solarpunk, Risograph, Editorial Fashion,
  Cozy Storybook, Dark Academia, Vaporwave, Cottagecore, Brut Tech),
  **7 nouveaux styles DALL·E**, ControlNet Union SDXL (12 modes en 1),
  PuLID-FLUX (best-in-class identité 2026), checkpoints communautaires
  (Pony V7 AuraFlow, Illustrious, NoobAI, Juggernaut XI, RealVisXL V5),
  negative_prompt_baseline étendue (Pony, Illustrious, Animagine, FLUX.2,
  SD 3.5, `negativeXL_D` remplaçant `EasyNegative` en SDXL).
- **Phase D — 12 patches P2** : section Web App vs Discord MJ, mention
  V8/V8.1 (choix volontaire V7), workflow ComfyUI FLUX dev + Hyper-FLUX
  8 steps LoRA (gain ×3 vitesse), pattern PuLID-FLUX, scoring vidéo /65
  (ou /60 sans audio), template iterations_log enrichi avec stack
  créatif V7.

### Nouveautés majeures vs v1.0

| Domaine | v1.0 (avril) | v1.1 (mai) |
|---|---|---|
| Modèles couverts | 3 IA images | **3 IA images + 7 IA vidéo** |
| DALL·E | DALL·E 3 + gpt-image-1 | **+ gpt-image-1.5 + gpt-image-2** (cohérence personnages native) |
| Midjourney | V7 base | **V7 + Stack créatif (oref/ow/exp/draft) + V8/V8.1 mention** |
| Stable Diffusion | SDXL + FLUX.1 | **+ SD 3.5 + FLUX.2 (nov 2025) + Pony V7 (AuraFlow) + Illustrious + PuLID-FLUX + ControlNet Union** |
| Vidéo | ❌ | **✅ 7 modèles + tronc commun + extras (~60 fichiers)** |
| Audio vidéo | N/A | **Veo 3.1 (Dialogue/SFX/Ambient/Music) + Sora 2 (langage naturel) — Sora déprécié 24/09/2026** |
| Scoring | /50 image uniquement | **/50 image + /65 vidéo (avec audio) ou /60 (sans audio)** |
| Dimensions | 12 | **12 image + 3 vidéo (Duration / Camera Movement / Audio)** |

### Décisions actées (Q1 → Q6 audit S69)

- **Q1** : 7 dossiers vidéo (Runway / Pika / Kling / Luma / Sora / Veo3 / Hailuo)
- **Q2** : `dall-e/` renommé en `dall-e_gpt-image/` (matrice 4 modèles unifiée)
- **Q3** : Option A — 12 dim image + 3 dim vidéo séparées
- **Q4** : WebSearch effectués sur Sora 2 access, Veo 3.1 audio, Runway
  Gen-4 + Aleph, FLUX.2, Pony V7
- **Q5** : Phase A → B → C → D toutes appliquées en S90
- **Q6** : régénération PDF v1.1 = ce document (post-stabilisation)

### Pièges silencieux 2026 critiques (à connaître)

| Piège | Modèle | Solution |
|---|---|---|
| **`::` multi-prompt cassé** | MJ V7 | Reformuler ou rester sur V6 |
| **gpt-image-2 sorti 21/04/2026** | DALL·E API | Migrer matrice 4 modèles |
| **Sora 2 web/app discontinued 26/04/2026** | OpenAI | API jusqu'au 24/09/2026 puis migrer Veo 3.1 |
| **Pony V7 utilise AuraFlow** (pas SDXL) | SD | Tags qualité différents de V6 |
| **`background=transparent` ignoré silencieusement** | gpt-image-1 edit | Retirer du prompt |
| **`tilt` confondu avec `pedestal`** | Pika, Hailuo | Préciser "vertical movement, framing tilts" |

---

## Préambule

Ce document décrit l'intégralité du projet **AI Prompt Design** : sa
vision, sa mécanique, ses livrables, ses fichiers, et la méthode de
travail itérative entre Mickael (utilisateur, donneur d'ordre) et Jarvis
(assistant IA). Il sert à la fois de **manuel d'utilisation** et de
**document de référence** pour onboard une nouvelle conversation Jarvis
sur ce projet.

> Document **hybride FR + EN** pour les termes techniques de prompt
> engineering qui n'ont pas d'équivalent français propre (CFG, LoRA,
> sampler, denoising, rim light, golden hour, etc.).

---

## 1. Vision

### Le problème

Mickael utilise plusieurs IA de génération d'image (Midjourney, DALL·E,
Stable Diffusion). Chacune a sa **syntaxe propre**, ses **paramètres**
spécifiques, ses **forces** et ses **faiblesses**. Construire un bon
prompt demande à la fois :

- une intention claire,
- une connaissance pointue de l'IA cible,
- une expérience de ce qui marche / ne marche pas,
- une capacité à itérer et corriger.

C'est chronophage et frustrant quand on doit recommencer depuis zéro à
chaque session, sans capitaliser sur les apprentissages.

### La solution

**AI Prompt Design** est un système de **génération assistée de prompts
optimisés**, structuré comme un **framework itératif** où :

1. Mickael décrit en langage naturel (FR) une image qu'il veut.
2. Jarvis lit les fichiers du projet (préférences, lessons, templates IA)
   et **traduit** la description en prompt optimisé pour l'IA cible.
3. Mickael teste, récupère l'image, la renvoie.
4. Jarvis fait une **analyse comparative**, score le résultat, propose
   une v2, et **propose une mise à jour** des fichiers du projet pour
   capitaliser.
5. On itère jusqu'à match.

Avec le temps, le projet devient une **base de connaissances vivante**
qui reflète les goûts de Mickael, les patterns qui marchent, et les
défauts récurrents à éviter.

### Le slogan

> *Décris une image. Reçois un prompt. Itère jusqu'à match.*

---

## 2. Pourquoi ce projet est pertinent

| Constat | Conséquence |
|---------|-------------|
| Chaque IA a sa syntaxe propre | Apprendre 3 syntaxes ≠ savoir prompt-engineer |
| Les goûts visuels de Mickael sont uniques | Aucun "best prompt" générique ne lui correspond |
| Les itérations s'oublient sans trace | On refait les mêmes erreurs |
| Les bons prompts sont durs à reformuler de mémoire | Besoin d'une bibliothèque réutilisable |
| Les paramètres techniques (CFG, --s, ratio) varient | Tableau de référence indispensable |

Ce projet **codifie** ces dimensions et les rend exploitables session
après session.

---

## 3. Périmètre v1

### Inclus

- **3 IA d'images** : Midjourney V7, DALL·E 3 / gpt-image-1, Stable
  Diffusion (1.5 / SDXL / SD3 / FLUX.1).
- **Workflow itératif complet** : description → prompt → analyse → v2.
- **Système de scoring** sur 50 points.
- **Bibliothèque de styles** réutilisables.
- **Catalogue d'erreurs fréquentes** + correctifs.
- **Templates par IA** + référence paramètres.
- **Préférences personnelles** Mickael (vivant, enrichi à chaque cycle).
- **Lessons learned** (vivant, enrichi à chaque convergence).
- **Logs d'itération** par IA (traçabilité complète).

### Hors scope v1

- IA **vidéo** (Runway, Pika, Kling, Luma) — extension future possible.
- IA **avatar / humain parlant** (HeyGen, D-ID).
- IA **texte / chat** (Claude, Gemini, Copilot, Perplexity, Le Chat) —
  projet jumeau possible.
- **Auto-scoring** sans intervention Mickael (impossible aujourd'hui).
- **Connexion API directe** aux services (génération automatique) —
  Mickael fait toujours le geste copier/coller pour rester maître.

---

## 4. Architecture du projet

### Arborescence complète

```
Projets/AI_Prompt_Design/
│
├── README.md                         # Point d'entrée court
├── 01_PROJECT_TECHNICAL.md           # Spec technique (lue par Jarvis)
├── 02_PROJECT_PEDAGOGIQUE.md         # Ce document (source du PDF)
├── 02_PROJECT_PEDAGOGIQUE.pdf        # Livrable PDF
├── PROTOCOLE.md                      # Workflow step-by-step
│
├── 00_core/                          # Base commune toutes IA
│   ├── prompt_template_global.md     # Squelette universel 12 dimensions
│   ├── style_preferences.md          # Goûts Mickael (vivant)
│   ├── lessons_learned.md            # Apprentissages cumulés (vivant)
│   ├── library_styles.md             # Bibliothèque de styles ~50 entrées
│   ├── error_patterns.md             # Catalogue erreurs + correctifs
│   └── scoring_grid.md               # Grille notation /50
│
├── midjourney/                       # Spécifique Midjourney V7
│   ├── README.md
│   ├── prompt_template.md
│   ├── parameters_reference.md       # --ar, --s, --c, --v, --niji, --no...
│   ├── style_library.md
│   └── iterations_log.md
│
├── dall-e_gpt-image/                 # Spécifique DALL·E 3 / gpt-image-1 / 1.5 / 2
│   ├── README.md
│   ├── prompt_template.md
│   ├── parameters_reference.md       # matrice 4 modèles, params API
│   ├── style_library.md
│   └── iterations_log.md
│
└── stable-diffusion/                 # Spécifique SD (1.5/XL/3/FLUX)
    ├── README.md
    ├── prompt_template.md
    ├── parameters_reference.md       # CFG, steps, samplers, LoRA, ControlNet
    ├── negative_prompt_baseline.md   # Negative prompts par cas d'usage
    ├── style_library.md
    └── iterations_log.md
```

**Total : 24 fichiers Markdown + 1 PDF**.

### Logique d'organisation

- **Niveau 0 (racine)** : documents méta du projet.
- **Niveau 1 — `00_core/`** : connaissances **transverses** à toutes les
  IA. Le préfixe `00_` garantit qu'il apparaît en haut visuellement.
- **Niveau 1 — `<ia>/`** : un dossier par IA, structure identique pour
  faciliter la mémorisation et l'extension future.

### Fichiers vivants (mis à jour souvent)

- `00_core/style_preferences.md`
- `00_core/lessons_learned.md`
- `00_core/library_styles.md` (au fil des validations)
- `<ia>/iterations_log.md`
- `<ia>/style_library.md`

### Fichiers stables (modifiés rarement)

- `README.md`
- `01_PROJECT_TECHNICAL.md`
- `02_PROJECT_PEDAGOGIQUE.md` + `.pdf`
- `PROTOCOLE.md`
- `00_core/prompt_template_global.md`
- `00_core/error_patterns.md`
- `00_core/scoring_grid.md`
- `<ia>/README.md`
- `<ia>/prompt_template.md`
- `<ia>/parameters_reference.md`
- `<ia>/negative_prompt_baseline.md` (SD only)

---

## 5. Workflow détaillé

### Vue d'ensemble du cycle

```
       ┌─────────────────────────────────┐
       │  1. Mickael décrit l'image      │
       │     (FR, libre)                 │
       └──────────────┬──────────────────┘
                      ▼
       ┌─────────────────────────────────┐
       │  2. Jarvis lit les fichiers     │
       │     du projet                   │
       └──────────────┬──────────────────┘
                      ▼
       ┌─────────────────────────────────┐
       │  3. Jarvis extrait les          │
       │     12 dimensions du brief      │
       └──────────────┬──────────────────┘
                      ▼
       ┌─────────────────────────────────┐
       │  4. Jarvis applique le template │
       │     IA cible                    │
       └──────────────┬──────────────────┘
                      ▼
       ┌─────────────────────────────────┐
       │  5. Jarvis livre :              │
       │     prompt + hypothèses +       │
       │     variantes + paramètres      │
       └──────────────┬──────────────────┘
                      ▼
       ┌─────────────────────────────────┐
       │  6. Mickael copie, génère,      │
       │     renvoie l'image             │
       └──────────────┬──────────────────┘
                      ▼
       ┌─────────────────────────────────┐
       │  7. Jarvis analyse comparative  │
       │     (12 dimensions, score /50)  │
       └──────────────┬──────────────────┘
                      ▼
                 score < 40 ?
                 ┌────┴─────┐
                YES         NO
                 │           │
                 ▼           ▼
       ┌────────────┐  ┌────────────────┐
       │  8. v2,    │  │  10. Capitali- │
       │  diff de   │  │  sation :      │
       │  v1        │  │  proposer MAJ  │
       └─────┬──────┘  │  fichiers core │
             │         └────────────────┘
             ▼
   retour étape 6
```

### Les 12 dimensions analysées

Pour chaque brief Mickael, Jarvis identifie :

| # | Dimension | Exemple |
|---|-----------|---------|
| 1 | **Subject** | "un chat roux" |
| 2 | **Action / pose** | "qui dort" |
| 3 | **Setting** | "dans un grenier poussiéreux" |
| 4 | **Time / weather** | "lumière du matin" |
| 5 | **Style** | "réaliste" / "anime" / "aquarelle" |
| 6 | **Mood** | "mélancolique" / "joyeux" |
| 7 | **Composition** | "plan large" / "portrait serré" |
| 8 | **Camera angle** | "vue plongeante" / "low angle" |
| 9 | **Lens / DOF** | "85mm bokeh" / "wide-angle 24mm" |
| 10 | **Lighting** | "rim light" / "golden hour" |
| 11 | **Color** | "tons chauds" / "monochrome bleu" |
| 12 | **Technical** | "8K" / "anti-éléments" |

Pour chaque dimension absente du brief : soit Jarvis applique le default
de `style_preferences.md`, soit il **demande** (jamais inventer).

---

## 6. Rôle de Jarvis dans le système

Jarvis n'est **pas** un système autonome qui apprend tout seul. C'est un
**assistant méthodologique** qui :

- **Lit** systématiquement les fichiers du projet en début de conversation.
- **Traduit** un brief FR en prompt EN syntaxiquement correct pour l'IA
  cible.
- **Justifie** chaque choix qu'il fait (lecture du brief explicite ou
  application d'un default).
- **Score** objectivement les images renvoyées sur 5 critères.
- **Propose** des mises à jour des fichiers — il n'écrit jamais sans
  l'accord de Mickael.
- **Trace** chaque cycle dans `iterations_log.md` pour mémoire.

### Ce que Jarvis ne peut pas faire

- ❌ Générer l'image lui-même (Mickael garde le geste)
- ❌ Lire automatiquement la doc d'un site externe en continu
- ❌ Modifier sans autorisation explicite les fichiers `00_core/*`
- ❌ Inventer des goûts Mickael non documentés
- ❌ Garantir qu'un v1 sera parfait — c'est itératif

---

## 7. Méthode d'itération

### Le scoring sur 50

5 critères × 10 points :

1. **Fidélité au prompt** — l'image montre-t-elle ce qui était demandé ?
2. **Style** — le rendu correspond-il au style demandé ?
3. **Composition** — cadrage, équilibre, lecture visuelle.
4. **Technique** — anatomie, détails, netteté, absence de défauts.
5. **Mood** — l'ambiance / émotion correspond-elle à l'intention ?

### Seuils de décision

| Total /50 | Décision |
|-----------|----------|
| 45-50 | Convergence : capitalisation, fin de boucle |
| 40-44 | Très bon, 1 dernier polish optionnel |
| 30-39 | Bonne base, v2 ciblé sur les critères les plus bas |
| 20-29 | Itération nécessaire, changements significatifs |
| 10-19 | Réécriture > 50% du prompt |
| 0-9 | Stop, on remet le brief à plat |

### Format de v2 : diff plutôt que rewrite

Pour ne pas faire perdre Mickael dans des prompts entiers :

```
Changements
- ❌ retire `<segment>`
- ➕ ajoute `<segment>`
- 🔄 remplace `<a>` → `<b>`
- ⚙️ paramètre : `--s 100` → `--s 250`

Prompt complet
[prompt v2 prêt à copier]
```

---

## 8. Système de scoring (détaillé)

### Critère 1 — Fidélité au prompt (/10)

Mesure : tous les éléments du brief sont-ils présents et reconnaissables ?

- 10 : tout présent
- 8 : 80%, 1 manquant
- 6 : concept général OK, 2-3 éléments manquants
- 4 : partiellement correct, gros écarts
- 2 : à peine reconnaissable
- 0 : hors sujet

### Critère 2 — Style (/10)

Mesure : le rendu match-il la direction stylistique demandée ?

- 10 : niveau référence
- 8 : style respecté avec petites licences
- 6 : style globalement OK mais dérapes (ex : "AI look")
- 4 : approximatif
- 2 : très loin du brief
- 0 : à l'opposé

### Critère 3 — Composition (/10)

Mesure : cadrage, équilibre, règle des tiers, lecture immédiate.

### Critère 4 — Technique (/10)

Mesure : anatomie, détails, netteté, absence de défauts.

### Critère 5 — Mood (/10)

Mesure : l'image transmet-elle l'émotion / l'ambiance voulue ?

### Pondération optionnelle

Par défaut tous les critères pèsent égal. Mickael peut demander une
pondération adaptée :

```
Total pondéré = 0.4 × Fidélité + 0.2 × Style + 0.15 × Composition
              + 0.15 × Technique + 0.1 × Mood
```

---

## 9. Templates par IA — synthèse

### Midjourney V7

**Syntaxe** : phrase descriptive EN + paramètres `--ar W:H --s 100 --c 10`.

**Structure** :
```
[STYLE keyword], [SUBJECT] [ACTION], [SETTING], [TIME/WEATHER],
[LIGHTING], [COLOR], [MOOD], [LENS/COMPOSITION]
--ar W:H --s 100 --c 10 --v 7 --no [unwanted]
```

**Particularités** :
- Aime les concepts visuels concrets et les références cinéma/photo.
- Évite les phrases trop longues (> 60 mots).
- Tendance naturelle à sur-styliser ; corriger avec `--style raw --s 50`.
- `--cref` pour cohérence personnage, `--sref` pour cohérence style.

### DALL·E 3 / gpt-image-1

**Syntaxe** : langage naturel EN ou FR, phrases complètes.

**Structure** :
```
A [STYLE] of [SUBJECT] [ACTION] in [SETTING], during [TIME].
The composition is [COMPOSITION] with [LIGHTING].
The mood is [MOOD], dominated by [COLOR].
[TECHNICAL].
```

**Particularités** :
- Préfixer `Use this exact prompt without rewriting:` pour bypass le
  prompt rewriting de ChatGPT.
- Ne pas utiliser de tags virgulés ou de paramètres `--ar`.
- Format dans le prompt : "a vertical 9:16 poster of...".
- Excellent pour le **texte dans l'image** (force différenciante).
- Modération stricte (pas de personnalités vivantes, contenu sensible).

### Stable Diffusion

**Syntaxe** : tags pondérés `(word:1.2)`, séparés par virgules + negative
prompt + paramètres techniques.

**Structure** :
```
(masterpiece:1.2), [STYLE], [SUBJECT], [ACTION], [SETTING],
[LIGHTING], [COMPOSITION], [COLOR], 8k, sharp focus

Negative: <cf negative_prompt_baseline.md>

CFG: 6-8 | Steps: 25-35 | Sampler: DPM++ 2M Karras | Size: 1024x1024
```

**Particularités** :
- **Negative prompt obligatoire**.
- Pondération sans espace : `(word:1.2)` et pas `(word: 1.2)`.
- Limite ~75 tokens.
- Choix du **checkpoint** (modèle de base) crucial : RealisticVision
  pour photo, MeinaMix pour anime, DreamShaper XL pour concept art.
- LoRA pour ajouter style/concept/personnage : `<lora:name:0.7>`.
- Open source, gratuit en local sur la RTX 3090 de Mickael.

---

## 10. Bonnes pratiques de prompt engineering (transverses)

### Règles d'or

1. **Le sujet en premier**. Toujours mettre le concept principal dans
   les 5 premiers mots/tokens.
2. **Une intention, un prompt**. Ne pas mélanger 2 styles concurrents.
3. **Spécifique > générique**. "85mm f/1.8" vaut mieux que "professional
   photography".
4. **Références concrètes**. "Dans le style de Roger Deakins" donne plus
   d'info à l'IA que "cinematic".
5. **Anti-éléments**. Toujours déclarer ce qu'on ne veut pas (text,
   watermark, deformed hands).
6. **Format = usage**. Choisir l'aspect ratio en fonction de la
   destination finale (story 9:16, wallpaper 16:9, print 2:3).
7. **Itérer ≠ tout réécrire**. Changer une dimension à la fois pour
   isoler ce qui marche.

### Erreurs fréquentes à éviter

- "8K, masterpiece, hyper realistic, ultra detailed, intricate" en
  chaîne sans spécificité = noise.
- Contradictions internes ("minimalist + ornate", "bright + dark").
- CFG ou stylize trop hauts = images cuites / sur-stylisées.
- Negative trop long en SD = dilution.
- Demander un texte long en image (sauf DALL·E 3 / gpt-image-1).

### Patterns transverses qui marchent

- Mention d'une **focale** (35mm, 50mm, 85mm) pour la photo.
- Mention d'une **direction de lumière** (de gauche, par derrière, du
  haut).
- Mention d'une **palette nommée** (warm tones, cool tones, monochrome
  blue, sepia).
- Mention d'une **époque** (1970s, victorian era, near-future).
- Mention d'une **référence artiste** (uniquement si style proche du
  rendu voulu).

---

## 11. Système d'amélioration continue

### Capitalisation à chaque convergence

Quand un cycle aboutit (score ≥ 40/50), Jarvis propose 4 mises à jour
possibles :

1. **`00_core/style_preferences.md`** — si une règle persistante des
   goûts Mickael s'est confirmée.
2. **`00_core/lessons_learned.md`** — entrée datée avec leçon retenue.
3. **`<ia>/style_library.md`** — si un style nommé a été validé avec
   une formulation EN qui marche.
4. **`<ia>/iterations_log.md`** — entrée complète du cycle (description
   → vN → score) pour traçabilité.

Mickael valide avec un simple "OK" → Jarvis applique. Si refus ou
ajustement → on en discute.

### Promotion en "consolidé"

Quand une règle / un style / un fix se confirme sur **3+ itérations**
indépendantes, il est promu en gras dans le tableau correspondant. Cela
indique à Jarvis qu'il peut l'utiliser comme **default** sans demander.

### Anti-patterns de capitalisation

- ❌ Sur-écrire un fichier core sans diff lisible.
- ❌ Créer trop de "lessons" trop tôt → bruit dans le fichier.
- ❌ Supprimer une lesson sans validation Mickael.
- ❌ Modifier `style_preferences.md` sans citation Mickael explicite.

---

## 12. Extensions futures

### Vidéo

Ajouter `runway/`, `pika/`, `kling/`, `luma/` quand Mickael veut
s'attaquer à la génération vidéo. Structure identique : README +
prompt_template + parameters_reference + style_library + iterations_log.

### Avatar / humain parlant

`heygen/`, `d-id/` pour la création de clones vidéo et photos parlantes.

### LLM texte (projet jumeau)

`AI_Prompt_Text/` pour optimiser les prompts vers Claude / Gemini /
Copilot / Perplexity / Le Chat. Structure : `00_core/` (prompt patterns
universels) + dossier par LLM (specs propres à chaque modèle).

### Auto-scoring multimodal

Si une future version de Jarvis voit l'image directement, le scoring
peut être plus précis (mesures objectives : symétrie, anatomie,
composition par règle des tiers, palette dominante détectée).

### Export presets

Générer des fichiers `.json` Auto1111 / `.workflow` ComfyUI à partir des
prompts SD validés, pour rejouer un combo en un clic.

### Connecteurs API

Brancher l'API Stability / OpenAI / Midjourney pour génération directe
sans copier/coller. Hors scope actuel (Mickael préfère garder la main).

---

## 13. Démarrage type d'une session

**Mickael** :
> Jarvis, on continue AI Prompt Design. Décris-moi : un vieux phare
> breton sous orage la nuit, en photo réaliste, format 16:9 wallpaper.
> IA cible : Midjourney.

**Jarvis** (en interne) :
1. Lit `01_PROJECT_TECHNICAL.md` + `00_core/style_preferences.md` +
   `00_core/lessons_learned.md` + `midjourney/prompt_template.md` +
   `midjourney/style_library.md`.
2. Extrait les 12 dimensions : Subject = phare breton, Setting = côte,
   Time/Weather = orage nuit, Style = photo réaliste, Composition = 16:9,
   etc.
3. Applique le template Midjourney V7.

**Jarvis** (sortie) :

````markdown
## Prompt v1 — Midjourney V7

```
cinematic photography, an old Breton l