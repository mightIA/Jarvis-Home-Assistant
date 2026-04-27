# AI Prompt Design

## Document projet — version pédagogique complète

*Mickael × Jarvis — 26 avril 2026 — v1.0*

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
├── dall-e/                           # Spécifique DALL·E 3 / gpt-image-1
│   ├── README.md
│   ├── prompt_template.md
│   ├── parameters_reference.md       # ChatGPT rewriting, formats, API
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
cinematic photography, an old Breton lighthouse standing on jagged
cliffs, violent storm at night, lightning striking the sea, towering
waves crashing, dramatic chiaroscuro lighting, deep blues and stormy
greys, ominous and powerful mood, wide-angle 24mm, ultra-detailed
--ar 16:9 --style raw --s 100 --c 5 --v 7 --no text, watermark
```

**Hypothèses appliquées**
- `cinematic photography` car "photo réaliste" + cadrage 16:9 wallpaper
- `--style raw --s 100` pour rester réaliste (default Midjourney sur-style)
- `--c 5` pour des résultats reproductibles
- `--no text, watermark` baseline universelle

**Variante stylistique**
```
hyperrealistic photo, an old Breton lighthouse battered by a violent
night storm, single beam piercing the rain, neutral tones, claustrophobic
moody atmosphere, shot on 35mm --ar 16:9 --style raw --s 50 --c 5 --v 7
```

**Quoi tester en priorité**
Si v1 trop spectaculaire → baisser `--s` à 50 et retirer "epic".
Si v1 pas assez dramatique → monter `--s` à 250 et ajouter "epic
atmosphere, cinematic".
````

**Mickael** : copie, génère sur Midjourney, renvoie l'image.

**Jarvis** : analyse comparative, score, v2 si besoin, etc.

---

## 14. Glossaire

| Terme | Définition |
|-------|------------|
| **CFG** | Classifier-Free Guidance. Force avec laquelle SD suit le prompt vs créativité. |
| **Steps** | Nombre d'itérations de denoising en SD. |
| **Sampler** | Algorithme de denoising (DPM++ 2M Karras, Euler a, etc.). |
| **Seed** | Graine numérique pour reproductibilité d'une génération. |
| **Checkpoint** | Modèle de base SD (`.safetensors` 2-7 GB). |
| **LoRA** | Low-Rank Adaptation. Petit adaptateur qui ajoute un concept au modèle. |
| **VAE** | Variational Autoencoder. Composant qui encode/décode. |
| **Hires fix** | Technique SD 1.5 : générer petit puis upscale + refine. |
| **Inpainting** | Modifier une zone précise d'une image existante. |
| **Outpainting** | Étendre une image hors de son cadre original. |
| **ControlNet** | Modèle de contrôle SD (pose, depth, canny, openpose...). |
| **IP-Adapter** | Référence d'image de style sans LoRA. |
| **`--ar`** | Paramètre Midjourney : aspect ratio. |
| **`--s`** | Paramètre Midjourney : stylize (0-1000). |
| **`--c`** | Paramètre Midjourney : chaos (0-100). |
| **`--cref`** | Character reference Midjourney. |
| **`--sref`** | Style reference Midjourney. |
| **Prompt rewriting** | DALL·E : ChatGPT réécrit le prompt avant envoi. |
| **gpt-image-1** | Modèle d'image OpenAI 2025+, plus puissant que DALL·E 3. |
| **FLUX.1** | Modèle d'image Black Forest Labs (alternative à SD). |
| **Negative prompt** | Liste de tags à éviter (SD essentiellement). |
| **Token** | Unité de découpage du prompt par le modèle (~75 max en SD). |
| **Pondération** | `(tag:1.2)` = booster un tag de 20% en SD. |
| **Booru tags** | Système de tags inspiré des sites anime (1girl, 1boy...). |

---

## 15. Annexes

### A. Liens utiles

- Midjourney : `https://docs.midjourney.com` ; `https://alpha.midjourney.com`
- DALL·E 3 / gpt-image-1 : `https://platform.openai.com/docs/guides/images`
- Stability AI : `https://stability.ai`
- CivitAI : `https://civitai.com` (modèles communautaires SD)
- A1111 : `https://github.com/AUTOMATIC1111/stable-diffusion-webui`
- ComfyUI : `https://github.com/comfyanonymous/ComfyUI`
- Black Forest Labs (FLUX) : `https://blackforestlabs.ai`
- Bing Image Creator : `https://www.bing.com/images/create`

### B. Références bibliographiques

- "DALL·E 3 system card", OpenAI 2023.
- "Stable Diffusion v1.5 paper", Stability AI 2022.
- "FLUX.1 technical report", Black Forest Labs 2024.
- "Prompt Engineering Guide", DAIR.AI (général LLM/image).

### C. Versionnement de ce document

| Version | Date | Auteur | Changements |
|---------|------|--------|-------------|
| 1.0 | 2026-04-26 | Jarvis × Mickael | Création initiale du projet |

### D. Contact / questions

Mickael × Jarvis. Conversations Cowork sur le PC Mickael, dossier
`D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Projets\AI_Prompt_Design\`.

---

*Fin du document — AI Prompt Design v1.0 — 26 avril 2026*
