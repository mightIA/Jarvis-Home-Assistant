# Guide références Runway Gen-4

## Image references

Runway Gen-4 accepte une **image de référence** en input pour image-to-video.
Cette image **fige le sujet et le décor** dès la frame 1.

### Bonnes pratiques

- **Une seule image** pour i2v (pas de batch comme Pika Scene Ingredients)
- **Sujet net, lighting clair** (pas de brouillard ou flou de mouvement)
- **Cadrage qui laisse de la place** au mouvement prévu
- **Sujet en début d'action**, pas en milieu

### Génération de la frame de départ

Workflow recommandé : Midjourney V7, FLUX.1, ou DALL·E gpt-image-2 selon
le style cible.

| Style cible | IA recommandée |
|---|---|
| Photoréaliste cinéma | MJ V7 `--style raw` ou FLUX.1 |
| Illustration / animation | MJ V7 ou SDXL avec checkpoint dédié |
| Photo standard | DALL·E gpt-image-2 |
| Cohérence personnage multi-clips | gpt-image-2 batch n=8 ou MJ V7 `--oref` |

## Aleph references

Aleph (video-to-video) accepte aussi une **image de référence optionnelle**
pour guider l'édition (style, sujet à insérer, etc.).

### Cas d'usage

- **Object insertion** : référence image de l'objet à insérer
- **Style transfer** : référence d'une image avec le style cible
- **Character preservation** : référence du personnage à préserver lors d'un changement de scène

## Sources

- Doc Runway : `https://help.runwayml.com/hc/en-us/articles/37327109429011-Creating-with-Gen-4-Video`
