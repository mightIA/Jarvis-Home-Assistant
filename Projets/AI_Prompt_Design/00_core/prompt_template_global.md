# Template global de prompt image

Structure universelle, indépendante de l'IA. Sert de **squelette mental**
à Jarvis pour composer un prompt avant adaptation à la syntaxe cible.

---

## Les 12 dimensions

```
1.  SUBJECT       — Qui / quoi est représenté
2.  ACTION        — Ce que fait/subit le sujet
3.  SETTING       — Lieu, environnement, contexte
4.  TIME/WEATHER  — Moment, saison, météo
5.  STYLE         — Photo, peinture, anime, 3D, illustration...
6.  MOOD          — Émotion / ambiance dégagée
7.  COMPOSITION   — Cadrage, plan large/serré, règle des tiers
8.  ANGLE         — Vue de face, plongée, contre-plongée, low angle
9.  LENS / DOF    — Focale, ouverture, bokeh, profondeur de champ
10. LIGHTING      — Source, direction, qualité, intensité
11. COLOR         — Palette dominante, contraste, saturation
12. TECHNICAL     — Qualité, résolution, post-prod, anti-éléments
```

---

## Squelette canonique (ordre de pondération décroissante)

```
[STYLE] [SUBJECT] [ACTION], [SETTING], [TIME/WEATHER],
[COMPOSITION] [ANGLE] [LENS/DOF],
[LIGHTING], [COLOR],
[MOOD], [TECHNICAL],
[NEGATIVE / NO-LIST]
```

L'ordre compte : la plupart des modèles pondèrent davantage les premiers
mots/concepts. Mettre devant ce qui est non négociable.

---

## Mapping vers les 3 IA

### Midjourney V7

```
<STYLE keyword>, <SUBJECT> <ACTION>, <SETTING>, <TIME/WEATHER>,
<LIGHTING>, <COLOR>, <MOOD>, <LENS> --ar W:H --s 100 --c 10 --no <neg>
```

Tons : phrases descriptives plutôt que tags purs. Les paramètres
viennent à la fin.

### DALL·E 3 / gpt-image-1

```
A <STYLE> of <SUBJECT> <ACTION> in <SETTING>, during <TIME>.
The composition is <COMPOSITION> with <LIGHTING>.
The mood is <MOOD>, dominated by <COLOR>.
<TECHNICAL>.
```

Tons : narration en phrases complètes EN (ou FR). Pas de tags virgulés
en chaîne, pas de paramètres `--`.

### Stable Diffusion

```
(<STYLE>:1.2), <SUBJECT>, <ACTION>, <SETTING>, <TIME>,
(<LIGHTING>:1.1), <COMPOSITION>, <ANGLE>, <LENS>, <COLOR>,
<MOOD>, masterpiece, best quality, 8k, sharp focus

Negative: <baseline negative + ce qu'on évite>
CFG: 7  |  Steps: 30  |  Sampler: DPM++ 2M Karras  |  Size: 1024x1024
```

Tons : tags pondérés virgulés. Negative prompt obligatoire.

---

## Extension vidéo — 3 dimensions additionnelles (S90 — patch P2-10)

> Détail complet dans `00_core/dimensions_video.md`. Résumé ici :

Pour les briefs **vidéo** (Runway, Pika, Kling, Luma, Sora 2, Veo 3.1,
Hailuo), 3 dimensions s'ajoutent aux 12 dimensions image :

```
13. DURATION         — Durée du clip (5 s, 8 s, 10 s, jusqu'à 60 s sur Sora 2 Pro)
14. CAMERA MOVEMENT  — Mouvement caméra (dolly, pan, orbit, push in, etc.)
                       Vocabulaire : _video_common/camera_vocabulary_global.md
15. AUDIO            — Veo 3.1 / Sora 2 uniquement
                       Format Veo : Dialogue / SFX / Ambient noise / Music
                       Format Sora : langage naturel intégré
```

**Convention Option A actée S90** : 12 dim image gardées + 3 dim vidéo
séparées (pas d'unification en 15 dim). Permet de scorer image /50 et
vidéo /65 (ou /60 sans audio).

### Ordre de pondération vidéo

```
[STYLE] [SUBJECT] [ACTION], [SETTING],
[CAMERA MOVEMENT], [DURATION],
[LIGHTING], [COLOR], [MOOD], [TECHNICAL]

Audio: (uniquement Veo 3.1 / Sora 2)
- Dialogue: <si applicable>
- SFX: <si applicable>
- Ambient noise: <one clause>
- Music: <mood/texture>
```

### Patterns image-to-video (recommandé 2026)

Au lieu de générer la scène complète en text-to-video, **générer une
frame de départ** dans une IA image (MJ V7, FLUX.1, gpt-image-2), puis
prompter **uniquement le mouvement** dans le modèle vidéo. Détail :
`_video_common/image_to_video_workflow.md`.

---

## Defaults Mickael (à enrichir dans `style_preferences.md`)

Quand une dimension est absente, appliquer ces defaults par défaut **sauf
indication contraire** dans `style_preferences.md` :

| Dimension | Default v1 |
|-----------|-----------|
| Style | photo réaliste, sauf mention contraire |
| Mood | neutre / contemplatif |
| Composition | cadrage moyen, règle des tiers |
| Lighting | naturelle, golden hour si extérieur |
| Color | palette équilibrée, légèrement désaturée |
| Technical | 8K, sharp focus, high detail |

Ces defaults seront **écrasés** par les vrais goûts Mickael au fur et à
mesure des itérations.

---

## Exemple complet (les 3 IA pour le même brief)

**Brief Mickael** : *"un vieux phare breton sou