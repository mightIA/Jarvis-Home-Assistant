# Midjourney — template de prompt

## Structure recommandée

```
[STYLE keyword], [SUBJECT] [ACTION], [SETTING], [TIME/WEATHER],
[LIGHTING], [COLOR], [MOOD], [LENS/COMPOSITION]
--ar W:H --s 100 --c 10 --v 7 --no <neg>
```

**Ordre crucial** : MJ pondère plus les premiers mots. Mettre **devant**
ce qui est non négociable.

## Longueur cible

- **Sweet spot** : 30 à 60 mots utiles avant les paramètres
- **Au-dessus de 80 mots** : dilution, MJ ignore une partie
- **En dessous de 15 mots** : MJ improvise trop

## Template type "photo réaliste"

```
[STYLE: photography type], [SUBJECT description], [SETTING],
[time/weather], [lighting], [color palette], [mood], shot on [camera/lens]
--ar 16:9 --style raw --s 50 --c 5 --v 7 --no [unwanted elements]
```

**Exemple** :
```
documentary photography, an old fisherman mending a blue net on a wooden
quay, small Brittany harbor at dawn, soft overcast light, muted blues
and weathered greys, melancholic and respectful mood, shot on Leica
35mm f/2 --ar 3:2 --style raw --s 50 --c 5 --v 7 --no text, watermark,
deformed hands
```

## Template type "concept art / fantasy"

```
[STYLE: epic concept art / matte painting], [SUBJECT], [SETTING],
[dramatic lighting], [atmospheric details], [color], trending on
ArtStation, [artist references] --ar 21:9 --s 250 --c 15 --v 7
```

**Exemple** :
```
epic matte painting, a colossal ancient tree growing through the ruins
of a marble city, golden hour rays piercing through the canopy, dust
motes and fog in the air, lush emerald and gold palette, awe-inspiring
atmosphere, trending on ArtStation, in the style of Greg Rutkowski and
James Gurney --ar 21:9 --s 250 --c 15 --v 7
```

## Template type "portrait stylisé"

```
[medium: oil painting / digital portrait / studio photo], portrait of
[subject], [pose/expression], [background], [lighting setup],
[color palette], [art reference] --ar 2:3 --s 150 --v 7
```

## Template type "anime / manga"

```
[anime style: shonen action / shojo soft / studio ghibli], [subject]
[action], [setting], [lighting], [color palette], [mood]
--niji 7 --ar 9:16 --s 150 --c 10
```

## Template type "produit / clean shot"

```
product photography, [product] on [surface/background], [lighting setup],
[angle], commercial style, ultra-clean, hyper-detailed, 8k
--ar 1:1 --style raw --s 50 --c 0 --v 7 --no text, watermark, hands
```

## Workflow V7 recommandé (depuis avril 2026)

Workflow optimal pour V7, qui exploite Draft Mode :

```
1. Brief Mickael
2. Prompt v1 lancé en `--draft` (Draft Mode = 10× plus rapide, basse qualité)
3. Génération de 4-6 variations en mode draft (exploration rapide)
4. Choix de la variation la plus prometteuse
5. Bouton "Enhance" → repasse la variation choisie en haute qualité (≈ équivalent --v 7 standard)
6. Si nécessaire : v2 ciblée sur le critère le plus bas (scoring /50)
```

**Gain typique** : ~5-7× moins de crédits qu'un cycle direct en haute qualité.

## Texte dans l'image V7

V7 a progressé sur le texte mais reste **derrière Ideogram** pour la typo
production. Pattern recommandé :

```
[CONTEXT VISUEL], the bold title "[TEXT EN MAJUSCULES]" centered at
[POSITION], in [STYLE TYPO]
--ar W:H --s 50 --v 7
```

**Règles** :
- Texte **entre guillemets droits** `"..."`
- **`--s 50`** (basse stylisation = MJ respecte mieux la typo)
- **Mots courts** (1-3 mots fiables, 4-6 acceptables, > 8 = fails)
- **Si typo prod fine requise** : passer sur **Ideogram** (typographie native)

**Exemple** :
```
A vintage travel poster of Paris at golden hour, the bold title "PARIS"
centered at the top in Art Deco serif, the subtitle "1928" smaller below
--ar 2:3 --s 50 --v 7
```

## Paramètres par défaut Mickael (à valider en cours d'itération)

| Param | Default | Quand changer |
|-------|---------|---------------|
| `--v` | 7 | --niji 7 si anime/manga |
| `--ar` | dépend du brief | 16:9 paysage, 2:3 portrait, 1:1 carré, 21:9 cinéma |
| `--s` | 100 | 50 si "réaliste strict", 250+ si "très stylisé" |
| `--c` | 10 | 0 pour reproductibilité, 25-50 pour exploration créative |
| `--style` | (rien) | `raw` quand on veut moins de "MJ flair" |
| `--no` | quasi systématique | toujours mettre `text, watermark` au minimum |

## Checklist Jarvis avant de livrer un prompt MJ

- [ ] Le sujet principal est dans les 5 premiers mots ?
- [ ] Le style est explicite (pas implicite) ?
- [ ] Lighting + Color + Mood présents ?
- [ ] `--ar` cohérent avec l'usage déclaré (print, web, story, etc.) ?
- [ ] `--no` inclut `text, watermark` au minimum ?
- [ ] Pas de contradictions internes (ex : "minimalist" + "ornate") ?
- [ ] Longueur entre 30 et 60 mots utiles ?
- [ ] Si "photo réaliste" demandé : `--style raw --s 50` ?

## Anti-patterns Midjourney

- ❌ "highly detailed, 8K, hyper realistic, masterpiece" en chaîne
  → noise, MJ comprend déjà, alourdit
- ❌ Multiples styles concurrents ("anime + photo + 3D")
- ❌ Phrases narratives longues à la DALL·E ("There is a man who...")
  → préférer descriptif compact
- ❌ Oublier `--ar` quand on a un usage spécifique en tête

### Anti-patterns spécifiques V7 (avril 2026)

- ❌ **Syntaxe multi-prompt `::`** (`A :: B`, `::2`, `::-0.5`) → **cassée
  silencieusement en V7**. Reformuler ou rester sur `--v 6`.
- ❌ **Vouloir une illustration sans expliciter le médium** → V7 a un
  **biais photoréaliste fort**, dérape vers la photo. Toujours préciser
  "oil painting" / "watercolor" / "ink illustration" / etc.
- ❌ **Demander du pixel art en V7** → régression nette par rapport à V6.
  Basculer en `--v 6` pour ce style.
