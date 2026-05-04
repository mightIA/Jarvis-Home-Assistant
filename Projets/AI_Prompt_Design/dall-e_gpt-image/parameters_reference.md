# DALL·E 3 / gpt-image-1 / 1.5 / 2 — référence paramètres

## Pas de paramètres formels

Contrairement à Midjourney (`--ar`, `--s`...) ou Stable Diffusion (CFG,
steps, sampler...), **DALL·E n'a pas de paramètres exposés à l'utilisateur**
côté ChatGPT/Bing. Tout passe par le **prompt en langage naturel**.

Côté API, quelques options existent mais sont limitées.

---

## Format / ratio

| Demande | Comment l'écrire dans le prompt |
|---------|----------------------------------|
| Carré 1:1 | "a square" / "1:1 ratio" / (default si rien dit) |
| Portrait 9:16 | "a vertical 9:16 poster of..." / "tall portrait orientation" |
| Paysage 16:9 | "a wide 16:9 cinematic shot of..." / "landscape orientation" |

Sortie réelle : 1024×1024 / 1024×1792 / 1792×1024.

---

## Matrice 4 modèles (état avril 2026)

> 🔴 **gpt-image-2 sorti le 21/04/2026** (OpenAI). Ce dossier couvre
> désormais 4 modèles : DALL·E 3 (legacy), gpt-image-1 (avr 2025),
> gpt-image-1.5 (oct 2025), gpt-image-2 (avr 2026).

| Param | DALL·E 3 | gpt-image-1 | gpt-image-1.5 | gpt-image-2 |
|---|---|---|---|---|
| `size` | 1024² / 1024×1792 / 1792×1024 | idem | idem + 2K | idem + 2K |
| `quality` | `standard` / `hd` | `high` / `medium` / `low` | idem | idem |
| `style` | `vivid` / `natural` | — | — | — |
| `n` | 1 | 1 - 10 | 1 - 10 | **1 - 8 (cohérence personnages native dans le batch)** |
| `input_fidelity` | — | `low` / `high` (edits only) | ignoré | ignoré |
| `background` | — | `transparent` / `opaque` / `auto` | idem (generate only) | idem |
| `output_format` | — | `png` / `jpeg` / `webp` | idem | idem |
| `moderation` | — | `auto` / `low` | idem | idem |
| `partial_images` | — | 1 - 3 (streaming, +100 image tokens / partial) | idem | idem |
| Aspect ratios | 3 standards | 3 standards | 3 + étendus | **continus 3:1 à 1:3** |
| Prompt rewriting | ✅ actif (UI / Responses API) | ❌ pas de rewriter API | ❌ idem | ❌ idem |

### Implications majeures

1. **Pas de rewriter sur gpt-image-1+ via API directe** → la consigne
   "Use this exact prompt without rewriting:" est **inutile** sur ces 3
   modèles via API directe. Elle reste utile uniquement via ChatGPT UI ou
   Responses API.
2. **gpt-image-2 = cohérence personnages native** dans `n=1..8` → premier
   modèle OpenAI offrant l'équivalent fonctionnel de `--cref` MJ.
3. **Texte dans l'image** : DALL·E 3 ~1-3 mots fiables, gpt-image-2 = step
   change (multi-line headlines, posters, manga). Ideogram reste meilleur
   pour typo prod fine.
4. **Modération** : assouplie mars-avril 2026 (public figures historiques
   OK, traits raciaux contextuels OK). `moderation="low"` débloque
   borderline non-violent sans toucher safety policies core.
5. **Sora 2 image generation deprecated le 24 sept 2026** → ne pas
   l'intégrer comme branche image de ce projet.

### Exemple d'appel API (gpt-image-2)

```python
client.images.generate(
    model="gpt-image-2",
    prompt="...",
    size="2048x2048",
    quality="high",
    n=4,                       # 4 variations cohérentes du même personnage
    background="transparent",
    output_format="png",
    moderation="low",          # débloque borderline non-violent
    partial_images=2,          # streaming 2 partials puis final
)
```

Côté **ChatGPT UI**, ces paramètres sont décidés en interne par le modèle
selon la formulation du prompt (mots comme "natural" ou "photographic" →
style natural).

---

## Prompt rewriting (à connaître absolument)

ChatGPT **réécrit ton prompt avant** de l'envoyer à DALL·E 3 :

1. Tu envoies "a cat in a garden"
2. ChatGPT réécrit en interne : *"A photorealistic image of a fluffy
   orange tabby cat lounging in a sunlit garden with blooming
   sunflowers, depth of field, soft golden hour lighting..."*
3. DALL·E 3 reçoit cette version enrichie

C'est utile pour les briefs vagues (ChatGPT améliore), **gênant** pour
les briefs précis (ChatGPT dérive).

### Désactiver le rewriting

Préfixer ton prompt par :

```
Use this exact prompt without rewriting:
[prompt]
```

ou

```
I NEED to test how the tool works with extremely simple prompts.
DO NOT add any detail, just use it AS-IS:
[prompt]
```

ou (pour API DALL·E 3) :
```python
prompt = "<your prompt>"
# pas de désactivation officielle, mais préfixer comme ci-dessus aide
```

### Voir le prompt réécrit

Dans ChatGPT, après génération, demander :
> "What was the exact prompt you sent to DALL·E?"

ChatGPT le révèle (parfois). Utile pour reverse-engineer le rewriting.

---

## Streaming `partial_images` (gpt-image-1+, 2026)

Les modèles gpt-image-1, 1.5 et 2 supportent le **streaming de partials**
via API. Permet d'afficher un aperçu progressif pendant la génération.

```python
response = client.images.generate(
    model="gpt-image-2",
    prompt="...",
    n=1,
    partial_images=2,  # 2 partials puis l'image finale
    stream=True,
)

for event in response:
    if event.type == "image.partial":
        save_partial(event.image, event.index)
    elif event.type == "image.completed":
        save_final(event.image)
```

| Param | Valeurs | Coût supplémentaire |
|---|---|---|
| `partial_images` | 0 (off) à 3 | **+100 image tokens par partial** |
| `partial_images=1` | 1 aperçu intermédiaire | +100 tokens |
| `partial_images=2` | 2 aperçus intermédiaires | +200 tokens |
| `partial_images=3` | 3 aperçus intermédiaires | +300 tokens |

**Cas d'usage** : UI temps réel (dashboard, app mobile) où l'attente de
2-5 secondes est une friction. Pour batch jobs ou génération offline =
inutile, désactiver.

---

## Particularités par modèle

### DALL·E 3 (legacy)
- Style polished par défaut
- Prompt rewriting actif via ChatGPT UI / Responses API (préfixer pour bypasser)
- 1 image par appel

### gpt-image-1 (avril 2025, multimodal)
- Edit + variations + inpainting natif via `client.images.edit(...)`
- Param `input_fidelity` (`low` / `high`) pour cohérence avec image de réf
- Texte court fiable (1-3 mots), 1-10 images par batch

### gpt-image-1.5 (octobre 2025)
- Aspect ratios étendus, sortie 2K
- Texte multi-mots plus fiable
- `input_fidelity` ignoré (rendu natif déjà fidèle)

### gpt-image-2 (avril 2026)
- **Cohérence personnages native** dans batch `n=1..8` (équivalent `--cref`)
- Aspect ratios continus 3:1 à 1:3
- Texte multi-line / poster / manga fiable
- 2K natif, 8 images max par batch

```python
# Edit avec gpt-image-1 (image existante + masque)
client.images.edit(
    model="gpt-image-1",
    image=open("base.png", "rb"),
    mask=open("mask.png", "rb"),  # zone à remplacer
    prompt="Add a small cat sitting on the chair",
    input_fidelity="high",
)
```

> ⚠️ **Piège silencieux** : `background="transparent"` n'est pas supporté
> sur `client.images.edit(...)` avec gpt-image-1 (uniquement sur generate).
> Aucun message d'erreur, le param est juste ignoré.

---

## Sources

- DALL·E 3 system card : `https://openai.com/research/dall-e-3-system-card`
- API images : `https://platform.openai.com/docs/guides/images`
- gpt-image-1 doc : `https://platform.openai.com/docs/models/gpt-image-1`
- Bing Image Creator : `https://www.bing.com/images/create`
- Help articles OpenAI : `https://help.openai.com/en/collections/3742473-dall-e`

---

*Version 1.0 — 2026-04-26*
