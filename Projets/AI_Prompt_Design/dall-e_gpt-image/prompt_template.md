# DALL·E — template de prompt

## Approche : langage naturel

DALL·E **ne marche pas avec des tags virgulés** comme MJ ou SD. Il faut
écrire des **phrases complètes**, comme si on décrivait à un illustrateur.

## Structure recommandée

```
[OPENING : type d'image + format] of [SUBJECT description] [ACTION] in [SETTING].
The composition is [COMPOSITION]. Lighting is [LIGHTING].
The mood is [MOOD], dominated by [COLOR PALETTE].
[TECHNICAL details : style, qualité, anti-éléments].
```

## Préfixe anti-rewriting (UNIQUEMENT DALL·E 3 via UI / Responses API)

> ⚠️ **Précision avril 2026** : ce préfixe ne fait effet que pour
> **DALL·E 3 via ChatGPT UI ou Responses API**. Pour **gpt-image-1, 1.5
> et 2 via API directe** (`client.images.generate`), il n'y a **pas de
> rewriter** — le préfixe est inutile et pollue le prompt.

```
Use this exact prompt without rewriting:
[ton prompt ici]
```

Sans ce préfixe (DALL·E 3 UI / Responses uniquement), ChatGPT enrichit
et réécrit en interne avant d'envoyer à DALL·E 3 — souvent avec des
dérapes stylistiques.

| Modèle | Rewriter actif ? | Préfixe utile ? |
|---|---|---|
| DALL·E 3 (ChatGPT UI) | ✅ | ✅ |
| DALL·E 3 (Responses API) | ✅ | ✅ |
| gpt-image-1+ (API directe) | ❌ | ❌ inutile |

## Template type "photo réaliste"

```
Use this exact prompt without rewriting:
A 16:9 photorealistic photograph of [subject] [action] in [setting],
during [time/weather]. The composition is [wide shot / close-up], with
the subject positioned [centered / on the right third]. Lighting is
[natural / studio / dramatic], coming from [direction]. The mood is
[mood], with a palette of [colors]. The image has slight film grain and
candid imperfections to feel authentic. No text, no watermark.
```

**Exemple** :
```
Use this exact prompt without rewriting:
A 16:9 photorealistic photograph of an old fisherman mending a blue net
on a wooden quay, in a small Brittany harbor at dawn. The composition is
a medium-wide shot, with the fisherman on the right third. Lighting is
soft overcast, slightly cool. The mood is melancholic and respectful,
with a palette of weathered greys, faded blues, and rope-tan. Slight
film grain, candid feel. No text, no watermark.
```

## Template type "illustration"

```
A [vertical / horizontal / square] [illustration / painting / poster] of
[subject] [action] in [setting]. Drawn in the style of [reference: Studio
Ghibli / flat vector / aquarelle]. The colors are [palette]. The mood is
[mood]. [Composition details]. [No text].
```

## Template type "poster avec texte"

DALL·E 3 / gpt-image-1 sont **excellents** sur le texte court — c'est
leur force vs MJ.

```
A vertical 9:16 vintage travel poster of [destination], with the bold
title "[TEXT]" centered at the top in [font style: Art Deco / sans-serif].
The illustration shows [subject + setting], drawn in [style]. The color
palette is [colors]. The mood is [mood]. The bottom shows a smaller
subtitle "[smaller text]".
```

## Template type "portrait"

```
A 2:3 portrait photograph of [age, gender, ethnicity] [character] [pose
and expression]. The setting is [background]. Lighting is [setup, e.g.
Rembrandt lighting from the left]. The subject wears [clothing]. The
mood is [mood]. Shot on [camera/lens reference if applicable]. Sharp
focus on the eyes, shallow depth of field.
```

## Template type "scène narrative"

```
An illustration depicting [scene narrative]: [subject 1] does [action 1]
while [subject 2] does [action 2] in [setting]. [Time of day]. The viewer
sees this from [angle]. The atmosphere is [mood], with [color palette].
[Style reference]. No text.
```

## Bonnes pratiques DALL·E

- ✅ Phrases complètes, narration courte (2-4 phrases)
- ✅ "Use this exact prompt without rewriting:" si tu veux contrôler
- ✅ Mentionner le **format** dans le prompt ("a vertical 9:16...")
- ✅ Pour cohérence multi-images : redonner la description précise
  identique à chaque génération
- ✅ Pour modifier une image : "Generate a variation where [le seul
  changement]" en gardant le reste identique
- ✅ Si modération bloque : reformuler avec des termes plus neutres

## Anti-patterns DALL·E

- ❌ Tags virgulés à la MJ ("portrait, 8K, dramatic, --ar 16:9") →
  DALL·E ignore les `--ar`, traite mal la liste de tags
- ❌ Prompts ultra-courts (< 10 mots) → DALL·E improvise trop
- ❌ Termes potentiellement filtrés (violence, nudité, célébrités
  vivantes) → bloque sans message clair
- ❌ Demander >1 personnage avec "exactement la même tête" sans description
  ultra-précise → DALL·E perd la cohérence
- ❌ Demander un texte long en image (>10 mots) → erreurs orthographiques

## Cohérence personnage (5 techniques 2026)

Avant gpt-image-2, la cohérence personnage entre images DALL·E était
quasi-impossible. Avec gpt-image-2 (avril 2026), 5 techniques fonctionnent :

### 1. Description single-block répétée (toutes versions)

```
A young woman with shoulder-length auburn hair, green eyes, freckles
across the nose, wearing a navy blue knit sweater. [VARIATION ACTION/SETTING]
```

→ Coller ce bloc en début de prompt, modifier uniquement action/setting.

### 2. Layout keywords

```
... positioned center-left of the frame, facing slightly to the right,
medium shot from the chest up.
```

### 3. gen_id (ChatGPT UI uniquement)

```
Generate a variation based on gen_id [GEN_ID] where the character is
now [NEW ACTION]. Keep the character identical.
```

### 4. Batch n=8 gpt-image-2 (NOUVEAU avril 2026)

```python
client.images.generate(
    model="gpt-image-2",
    prompt="The same character (described in detail) in 4 different settings: ...",
    n=4,
)
```

→ Cohérence personnage native dans le batch.

### 5. Multi-input edits avec index (gpt-image-1+)

```python
client.images.edit(
    model="gpt-image-1",
    image=[open("char_ref.png", "rb"), open("scene_base.png", "rb")],
    prompt="Insert the character from image 1 into the scene from image 2...",
    input_fidelity="high",
)
```

## Modération 2026 (substitutions et `moderation="low"`)

OpenAI a **assoupli la modération** mars-avril 2026 :
- **Public figures historiques** : OK (Napoléon, Mozart, Lincoln...)
- **Traits raciaux contextuels** : OK quand justifié
- **Borderline non-violent** : `moderation="low"` débloque

### Substitutions efficaces (si bloqué)

| Terme bloqué | Substitution |
|---|---|
| `blood` (sang) | `red liquid` / `crimson splash` |
| `nude` (nu) | `draped figure` / `classical sculpture pose` |
| `weapon` (arme) | `prop` / `period accessory` |
| `wound` (blessure) | `mark` / `dark stain on fabric` |
| `corpse` (cadavre) | `figure lying still` |
| `drug` (drogue) | `vintage apothecary bottle` |
| Personnalité vivante par nom | Description physique uniquement |

### `moderation="low"` (API uniquement, gpt-image-1+)

```python
client.images.generate(
    model="gpt-image-2",
    prompt="...",
    moderation="low",  # débloque borderline non-violent
)
```

⚠️ **Ne désactive PAS** safety policies core (CSAM, violence explicite,
hate speech). Juste assouplit le filtre artistique.

## Format / ratios

DALL·E 3 / gpt-image-1 supportent **3 ratios** :

| Ratio | Pixels | Usage |
|-------|--------|-------|
| 1:1 (carré) | 1024×1024 | Default, polyvalent |
| 2:3 (portrait, ~9:16) | 1024×1792 | Story, poster, mobile |
| 3:2 (paysage, ~16:9) | 1792×1024 | Wallpaper, web, vidéo |

À demander en mots ("a vertical 9:16...", "a wide 16:9..."). Pas de
syntaxe `--ar`.

## Checklist Jarvis avant de livrer un prompt DALL·E

- [ ] Phrases complètes (pas de tags virgulés) ?
- [ ] Format/ratio mentionné en mots dans le prompt ?
- [ ] "Use this exact prompt without rewriting:" si brief précis ?
- [ ] Aucun terme à risque modération ?
- [ ] Si texte dans l'image : court, entre guillemets, dans le prompt ?
- [ ] Anti-éléments à la fin ("no text, no watermark") ?
- [ ] Style explicite (pas implicite) ?

---

*Version 1.0 — 2026-04-26*
