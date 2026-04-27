# Protocole d'itération AI Prompt Design

Cycle complet step-by-step. À suivre à chaque session de génération
d'image. Chaque étape a un format canonique pour rester déterministe.

---

## Étape 1 — Description Mickael

**Format attendu** (libre mais structurable) :

```
[IA CIBLE]    Midjourney | DALL·E | Stable Diffusion | les 3
[INTENTION]   Description en FR, 1-3 phrases
[STYLE]       (optionnel) référence à un style nommé
[CONTRAINTES] (optionnel) format, ratio, ce qu'il NE FAUT PAS
[USAGE]       (optionnel) print, web, réseau social, perso
```

**Exemple** :

```
[IA CIBLE]    Midjourney
[INTENTION]   Un vieil atelier de luthier en fin de journée, soleil
              rasant qui passe par une fenêtre couverte de poussière,
              violons accrochés au mur en arrière-plan
[STYLE]       photo réaliste façon National Geographic
[CONTRAINTES] format paysage, pas de texte dans l'image
[USAGE]       fond d'écran perso 16:9
```

Si Mickael fait court (*"un chat dans un grenier, MJ"*) → Jarvis applique
les defaults de `00_core/style_preferences.md` et liste ses hypothèses
explicitement.

---

## Étape 2 — Lecture contexte Jarvis

Avant de générer, Jarvis lit (dans cet ordre, en parallèle) :

1. `01_PROJECT_TECHNICAL.md` (méthodo)
2. `00_core/style_preferences.md` (goûts Mickael)
3. `00_core/lessons_learned.md` (apprentissages cumulés)
4. `00_core/library_styles.md` (si Mickael cite un style nommé)
5. `<ia>/prompt_template.md` (syntaxe spécifique)
6. `<ia>/iterations_log.md` (ce qui a déjà marché/raté avec cette IA)
7. `<ia>/style_library.md` (briques EN testées sur cette IA)

---

## Étape 3 — Génération du prompt v1

**Output Jarvis** (format strict) :

````markdown
## Prompt v1 — <IA cible>

```
<le prompt prêt à copier, syntaxe IA-spécifique>
```

**Hypothèses** (defaults appliqués, à valider)
- Style : <choix> car <raison>
- Lighting : <choix> car <raison>
- Composition : <choix> car <raison>
- (autres dimensions inférées)

**Variante stylistique** (optionnelle)
```
<un autre angle, ex. plus sombre / plus saturé / autre référence>
```

**Paramètres techniques**
- <IA-spécifique : --ar, CFG, steps, sampler, dimensions>

**Quoi tester en priorité**
Si v1 rate, jouer d'abord sur : <param le plus impactant>
````

---

## Étape 4 — Test côté Mickael

Mickael copie le prompt, génère sur l'IA cible, renvoie l'image dans la
conv (drag & drop ou upload).

---

## Étape 5 — Analyse comparative Jarvis

**Format strict** (Jarvis voit l'image en multimodal) :

```markdown
## Analyse v1 — <IA cible>

**Observation rapide** : <1 phrase, ce que je vois>

**Comparaison sur les 12 dimensions**
| Dimension | Attendu | Obtenu | Match |
|-----------|---------|--------|-------|
| Subject | ... | ... | ✅/⚠️/❌ |
| Action | ... | ... | ... |
| ... (12 lignes) |

**Score selon scoring_grid.md**
- Fidélité au prompt : X/10
- Style : X/10
- Composition : X/10
- Technique (anatomie/détails) : X/10
- Mood : X/10
- **Total : XX/50**

**Gap principal** (le seul qui compte pour v2)
<la chose la plus loin de l'attendu>

**Cause probable**
<pourquoi l'IA a interprété comme ça>
```

---

## Étape 6 — Prompt v2 (diff only)

```markdown
## Prompt v2 — <IA cible> (diff de v1)

**Changements**
- ❌ retire `<segment>`
- ➕ ajoute `<segment>`
- 🔄 remplace `<a>` → `<b>`
- ⚙️ paramètre : `--s 100` → `--s 250`

**Prompt complet**
```
<v2 entier prêt à copier>
```

**Pourquoi ces changements**
<1-2 phrases ciblées sur le gap principal>
```

Boucle Étape 4 → 6 jusqu'à score ≥ 40/50 ou stop Mickael.

---

## Étape 7 — Capitalisation (à chaque convergence)

Quand le résultat match, Jarvis **propose** (ne fait jamais sans accord) :

```markdown
## Capitalisation suggérée

À ajouter dans `00_core/style_preferences.md` :
- <règle découverte sur les goûts Mickael>

À ajouter dans `00_core/lessons_learned.md` :
- 2026-MM-DD | <IA> | <leçon> | <contexte>

À ajouter dans `<ia>/style_library.md` :
- "<nom du style>" → "<formulation EN qui marche>"

À ajouter dans `<ia>/iterations_log.md` :
- entrée datée du cycle complet (description → v1 → vN → score final)

OK pour appliquer ?
```

Mickael répond "OK" → Jarvis fait les `Edit` ou `Write`.
Mickael dit "non" ou propose autre chose → on ajuste.

---

## Étape 8 — Cas d'usage spéciaux

### Mickael veut comparer les 3 IA en même temps

Jarvis génère **3 prompts en parallèle**, un par IA, avec leur syntaxe
propre. Étape 5 devient un comparatif des 3 images sur la même grille.

### Mickael repart d'une image existante

Format input :

```
[IA CIBLE]    <IA>
[REFERENCE]   <upload image>
[VARIATION]   "comme ça mais en hiver" / "même style mais une femme"
```

Jarvis utilise `--cref` (MJ) ou décrit la référence en mots (DALL·E) ou
ControlNet/IP-Adapter (SD).

### Mickael ne sait pas trop ce qu'il veut

Jarvis pose **3 questions max** (AskUserQuestion) sur les axes les plus
discriminants : style global / palette / mood. Puis génère 2 variantes
volontairement opposées pour cadrer.

---

## Anti-patterns

- ❌ Pondre 3 prompts sans demander quelle IA → demander d'abord.
- ❌ Réécrire tout v2 sans diff → frustrant à diff manuel pour Mickael.
- ❌ Modifier `00_core/*` sans demander → règle CLAUDE.md §4.
- ❌ Inventer un goût ("je suppose que tu aimes le bleu marine") → si pas
  dans `style_preferences.md`, demander.
- ❌ Continuer à itérer après score ≥ 45/50 → stop, capitalisation, fin.

---

*Version 1.0 — 2026-04-26*
