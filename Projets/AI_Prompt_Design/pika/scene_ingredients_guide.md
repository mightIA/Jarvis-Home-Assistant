# Guide Scene Ingredients — Pika 2.x

## Principe

**Scene Ingredients** = composer un clip à partir de **plusieurs images
de référence** (sujets, props, décors). Pika les combine automatiquement
dans un seul shot cohérent.

## Workflow

```
1. Préparer 2 à 5 images de référence (chacune représente un "ingrédient")
2. Upload des images dans l'UI Pika
3. Numéroter mentalement les images (1, 2, 3...)
4. Prompt : "Combine: [INGREDIENT 1 description] + [INGREDIENT 2 description]
   + ... in [SCENE]. [ACTION]. Camera [MOVEMENT]."
5. Génération 5 s
```

## Types d'ingrédients

| Type | Exemple |
|---|---|
| Sujet principal (personne, animal) | Image 1 : portrait du chef |
| Prop / objet | Image 2 : couteau de cuisine vintage |
| Décor / setting | Image 3 : cuisine ancienne avec lumière chaude |
| Style référence | Image 4 : palette colorimétrique cinématique |
| Vêtement / accessoire | Image 5 : tablier en lin |

## Bonnes pratiques

- **2 à 3 ingrédients** = sweet spot. 4-5 = composition plus complexe,
  plus instable
- **Cohérence stylistique** entre les images (pas mélanger photo + cartoon
  + 3D)
- **Décrire chaque ingrédient** dans le prompt (Pika ne devine pas)
- **Scene description claire** dans le prompt même si tous les ingrédients
  sont fournis

## Templates

### 3 ingrédients standard

```
Combine: [PERSONNE description] (image 1) + [PROP description] (image 2)
+ [DÉCOR description] (image 3). [ACTION]. Camera [MOVEMENT]. 5s.
```

**Exemple** :
```
Combine: the orange tabby cat (image 1) + the leather armchair (image 2)
+ the warm-lit Parisian living room (image 3). The cat jumps onto the
armchair and curls up. Camera dollies in slowly. 5s.
```

### 2 ingrédients + style

```
Combine: [PERSONNE] (image 1) + [DÉCOR] (image 2). [ACTION].
Style reference: image 3. Camera [MOVEMENT]. 5s.
```

## Pièges

- ❌ Mélanger Pikaffect + Scene Ingredients (très instable)
- ❌ 5 ingrédients avec actions complexes (cohérence se casse)
- ❌ Images de référence styles incompatibles (résultat hybride bizarre)
- ❌ Oublier de décrire un ingrédient dans le prompt (Pika peut l'ignorer)

## Sources

- Doc Pika : `https://pika.art`
