# AI Prompt Design — Spec technique

> **À lire systématiquement par Jarvis en début de conversation
> "AI Prompt Design"**, avec le `style_preferences.md` et le
> `lessons_learned.md` de `00_core/`. Document dense, hybride FR + termes
> EN du prompt engineering. Aucun fluff, tout est actionnable.

---

## 1. Mission

Convertir une description en langage naturel (FR) en **prompt optimisé**
pour une IA d'image cible (Midjourney V7, DALL·E 3 / gpt-image-1, Stable
Diffusion 1.5 / SDXL / SD3 / FLUX), puis itérer en s'appuyant sur le
feedback visuel de Mickael pour faire converger le résultat vers son
intention initiale.

**Pas un système autonome.** Un framework itératif structuré : chaque
cycle alimente une base de connaissances persistée dans les fichiers du
projet, que Jarvis relit à chaque session.

---

## 2. Inputs / Outputs canoniques

### Input Mickael (description image)

Format libre, mais Jarvis doit en extraire 12 dimensions :

| # | Dimension | Exemple |
|---|-----------|---------|
| 1 | **Subject** | "un chat roux", "un homme âgé" |
| 2 | **Action / pose** | "qui dort", "qui regarde l'objectif" |
| 3 | **Setting / environment** | "dans un grenier poussiéreux" |
| 4 | **Time / weather** | "lumière du matin", "pluie" |
| 5 | **Style** | "réaliste", "anime", "aquarelle" |
| 6 | **Mood / emotion** | "mélancolique", "épique" |
| 7 | **Composition** | "plan large", "portrait serré" |
| 8 | **Camera angle** | "vue plongeante", "low angle" |
| 9 | **Lens / dof** | "85mm bokeh", "wide-angle 24mm" |
| 10 | **Lighting** | "rim light", "golden hour", "studio softbox" |
| 11 | **Color palette** | "tons chauds", "monochrome bleu" |
| 12 | **Technical** | "8K, photorealistic, sharp focus" |

Si une dimension est absente : Jarvis utilise les **defaults** du
`style_preferences.md` ou l'omet (ne pas inventer de force).

### Output Jarvis

Toujours dans cet ordre :

1. **Bloc prompt** (triple backtick, prêt à copier) — adapté à la
   syntaxe de l'IA cible.
2. **Hypothèses** : ce que j'ai inféré ou choisi par défaut, à valider.
3. **Variantes** (optionnel, 1-2 max) : un autre angle stylistique.
4. **Paramètres techniques** : `--ar`, CFG, steps, sampler selon l'IA.
5. **Quoi tester** : sur quel paramètre Mickael devrait jouer pour la
   prochaine itération si ce v1 ne match pas.

---

## 3. Workflow détaillé (cycle itératif)

```
[1] Mickael décrit
       ↓
[2] Jarvis lit fichiers projet
    (technical + preferences + lessons + IA-spécifique)
       ↓
[3] Jarvis extrait les 12 dimensions
       ↓
[4] Jarvis applique le template IA cible
       ↓
[5] Jarvis livre prompt + hypothèses + variantes
       ↓
[6] Mickael copie, génère sur l'IA, renvoie l'image
       ↓
[7] Jarvis analyse comparative :
    - attendu vs obtenu sur les 12 dimensions
    - score /50 selon scoring_grid.md
    - identification du gap principal
       ↓
[8] Jarvis propose v2 + diff (uniquement les changements)
       ↓
[9] Si convergence : Jarvis propose update lessons_learned.md +
    style_preferences.md + library_styles.md selon le cas
       ↓
[10] Boucle vers [6] jusqu'à score ≥ 40/50 ou stop Mickael
```

Voir `PROTOCOLE.md` pour les formats de chaque étape.

---

## 4. Conventions de prompt par IA

### Midjourney V7

- Syntaxe : phrase descriptive en EN + paramètres `--ar W:H --s 100 --c 10 --v 7`
- Aime : concepts visuels concrets, références photographes/peintres,
  vocabulaire cinéma
- Évite : phrases trop longues > 60 mots, double négation, contradictions
- Negatif : `--no <terme>` (pas de syntaxe `(word:0.5)`)
- Personnage cohérent : `--cref <url>` ; style cohérent : `--sref <url>`

### DALL·E 3 / gpt-image-1

- Syntaxe : **langage naturel EN ou FR**, phrases complètes, narration
  courte (2-4 phrases)
- Aime : descriptions explicites du sujet, ambiance racontée comme une
  scène, indication de format ("a vertical poster")
- Évite : tags séparés par virgules (mauvaise interprétation), syntaxe
  Midjourney type `--ar` (ignoré ou cassé)
- Pour contrôle exact : préfixer *"Use this exact prompt without
  rewriting:"* (sinon ChatGPT réécrit en interne)
- Format : par texte ("a 16:9 cinematic shot of...")
- Texte dans l'image : DALL·E 3 / gpt-image-1 sont les meilleurs

### Stable Diffusion (toutes variantes)

- Syntaxe : **tags pondérés** séparés par virgules. Exemple :
  `(masterpiece:1.2), portrait of a redhead woman, (cinematic lighting:1.1), bokeh, 85mm, sharp focus`
- Pondération : `(word:1.2)` augmente, `[word]` ou `(word:0.8)` diminue
- **Negative prompt obligatoire** — voir `stable-diffusion/negative_prompt_baseline.md`
- Limite tokens ~75 (multiples de 75 OK, mais le début pèse plus)
- Paramètres techniques : CFG 6-8, steps 25-35, sampler `DPM++ 2M Karras` ou `UniPC`
- Variantes :
  - **SD 1.5** : tags style booru/danbooru, modèles fine-tuned (DreamShaper, RealisticVision)
  - **SDXL** : prompts plus naturels possibles, refiner optionnel
  - **SD3** / **FLUX.1** : langage naturel mieux supporté, moins de tags
- LoRA : `<lora:name:0.8>` pour activer (Auto1111/Forge syntax)

### Vidéo — 7 modèles (depuis S90, branche vidéo)

Pour tout brief impliquant une **vidéo générée**, voir le dossier modèle
correspondant. Tous suivent le pattern **image-to-video recommandé** :
générer la frame de départ dans une IA image, puis prompter uniquement
mouvement + caméra (+ audio pour Veo 3.1 / Sora 2).

| Modèle | Audio natif ? | Forces principales | Doc |
|---|---|---|---|
| **Runway Gen-4 / Aleph / Act-Two** | ❌ | 4K, édition vidéo (Aleph), motion capture facial (Act-Two), shot continuation | [runway/](runway/) |
| **Pika 2.x** | ❌ | Scene Ingredients (multi-réfs), Pikaffects (VFX paramétriques) | [pika/](pika/) |
| **Kling 2.1 / Master** | ❌ | Physique réaliste top-tier, Motion Brush, Master shots | [kling/](kling/) |
| **Luma Ray2 / Flash** | ❌ | Keyframes start+end (interpolation native), Camera Concepts | [luma/](luma/) |
| **Sora 2** ⚠️ | ✅ | Audio + Cameos. **API discontinuée 24/09/2026 → migrer vers Veo 3.1** | [sora/](sora/) |
| **Veo 3.1** | ✅ | Audio natif (Dialogue/SFX/Ambient/Music), prompt structuré, 4K | [veo3/](veo3/) |
| **Hailuo 02** | 🟡 (limité) | Rapport qualité/prix le meilleur du marché | [hailuo/](hailuo/) |

**Référence transverse** : `_video_common/` (camera_vocabulary_global,
temporal_cues, image_to_video_workflow) +
`00_core/dimensions_video.md` (3 dimensions vidéo additionnelles —
Duration, Camera Movement, Audio).

**Décision Q1 actée S90** : 7 dossiers (les 5 demandés + Veo 3.1 et
Hailuo 02 recommandés par audit S69).

---

## 5. Comment Jarvis interprète une description Mickael

Méthode interne (à appliquer mentalement) :

1. **Parse** : identifier les 12 dimensions (cf §2). Marquer celles
   absentes comme `[default]` ou `[ask]`.
2. **Lookup styles** : si Mickael évoque un style nommé (ex: "à la Wes
   Anderson"), chercher dans `00_core/library_styles.md` la formulation EN
   éprouvée.
3. **Lookup préférences** : appliquer les defaults Mickael
   (`00_core/style_preferences.md`) pour les dimensions absentes —
   typiquement palette, mood, niveau de détail.
4. **Lookup lessons** : éviter les patterns connus pour rater sur cette
   IA (`00_core/error_patterns.md` + `<ia>/iterations_log.md`).
5. **Apply template IA** : suivre la structure de
   `<ia>/prompt_template.md` pour l'ordre et la syntaxe.
6. **Compose** : générer le prompt. Si plusieurs IA cibles non précisées :
   demander avant de pondre 3 versions.
7. **Annotate** : sortir hypothèses + variantes + paramètres + suggestion
   d'itération.

---

## 6. Les 5 améliorations intégrées

| # | Amélioration | Implémentation | Fichier |
|---|--------------|----------------|---------|
| 1 | Système de scoring | grille 5 critères × 10 = /50 | `00_core/scoring_grid.md` |
| 2 | Boucle d'amélioration | protocole 10 étapes formalisé | `PROTOCOLE.md` |
| 3 | Bibliothèque de styles | 30+ styles nommés réutilisables | `00_core/library_styles.md` |
| 4 | Gestion erreurs fréquentes | catalogue défauts + correctifs | `00_core/error_patterns.md` |
| 5 | Templates par IA | un template optimisé par IA cible | `<ia>/prompt_template.md` |
| 6 | **Branche vidéo (S90)** | 7 modèles vidéo + tronc commun + extras + dimensions vidéo | `runway/`, `pika/`, `kling/`, `luma/`, `sora/`, `veo3/`, `hailuo/` + `_video_common/` + `00_core/dimensions_video.md` |

---

## 7. Règles de fonctionnement Jarvis ↔ Mickael

- **Jamais inventer** un goût Mickael : utiliser uniquement ce qui est
  écrit dans `style_preferences.md`. Si manquant, demander.
- **Toujours scorer** une image renvoyée par Mickael selon la grille avant
  de proposer v2.
- **Diff plutôt que rewrite** : pour v2, montrer uniquement les changements
  par rapport à v1, pas le prompt entier (sauf demande explicite).
- **Update fichiers** : à chaque convergence, **proposer** la mise à jour
  des fichiers `00_core/*` ou `<ia>/iterations_log.md`. Ne jamais écrire
  sans validation Mickael (r