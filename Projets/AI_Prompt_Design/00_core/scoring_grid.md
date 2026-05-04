# Scoring grid — notation /50

Grille objective pour scorer une image générée par rapport au brief.
5 critères × 10 points = 50.

---

## Les 5 critères

### 1. Fidélité au prompt (/10)

> *L'image montre-t-elle ce qui était demandé ?*

| Score | Description |
|-------|-------------|
| 10 | Tous les éléments clés du brief sont présents et reconnaissables |
| 8 | 80% des éléments présents, 1 manquant ou ambigu |
| 6 | Concept général respecté, 2-3 éléments manquants/déformés |
| 4 | Image partiellement correcte, gros écarts |
| 2 | À peine reconnaissable par rapport au brief |
| 0 | Hors sujet |

### 2. Style (/10)

> *Le rendu correspond-il au style demandé (photo, illustration, anime…) ?*

| Score | Description |
|-------|-------------|
| 10 | Style demandé parfaitement rendu, niveau référence |
| 8 | Style respecté avec petites licences acceptables |
| 6 | Style globalement OK mais avec dérapes (ex : trop "AI look") |
| 4 | Style approximatif, mélange peu cohérent |
| 2 | Style très loin du brief |
| 0 | Style à l'opposé |

### 3. Composition (/10)

> *Cadrage, équilibre, règle des tiers, lecture visuelle.*

| Score | Description |
|-------|-------------|
| 10 | Composition pro, lecture immédiate, dynamisme parfait |
| 8 | Composition solide, 1 petit déséquilibre toléré |
| 6 | Composition correcte mais perfectible (sujet centré au lieu de off-center, etc.) |
| 4 | Composition faible (sujet mal cadré, fond qui mange le sujet) |
| 2 | Composition cassée |
| 0 | Composition incompréhensible |

### 4. Technique (/10)

> *Anatomie, détails, netteté, pas de défauts grossiers.*

| Score | Description |
|-------|-------------|
| 10 | Aucun défaut visible, niveau imprimable / pro |
| 8 | 1 micro-défaut détectable seulement à la loupe |
| 6 | Défauts mineurs (textures un peu floues, ombre étrange) |
| 4 | Défauts visibles (anatomie approximative, mains ratées) |
| 2 | Multiples défauts grossiers |
| 0 | Image inutilisable techniquement |

### 5. Mood (/10)

> *L'ambiance / émotion correspond-elle à l'intention ?*

| Score | Description |
|-------|-------------|
| 10 | Mood parfaitement transmis, on "sent" l'image |
| 8 | Mood présent mais légèrement off |
| 6 | Mood partiellement présent |
| 4 | Mood faible ou ambigu |
| 2 | Mood opposé à l'intention |
| 0 | Aucune ambiance, image plate |

---

## Total et seuils de décision (image)

| Total /50 | Décision Jarvis |
|-----------|-----------------|
| 45-50 | **Convergence** : capitalisation, fin de boucle, propose ajouts core/ |
| 40-44 | **Très bon** : 1 dernier tour optionnel pour polir le critère le plus bas |
| 30-39 | **Bonne base** : v2 ciblé sur le ou les 2 critères les plus bas |
| 20-29 | **Itération nécessaire** : v2 avec changements significatifs |
| 10-19 | **Réécriture** : v2 avec refonte d'au moins 50% du prompt |
| 0-9 | **Stop** : on remet à plat le brief avec Mickael |

---

## Extension vidéo — 3 critères additionnels (S90 — patch P2-9)

> Détail complet dans `00_core/dimensions_video.md`. Résumé scoring ici :

### 6. Duration (/5)

| Score | Description |
|---|---|
| 5 | Durée optimale pour l'action (ni trop courte ni trop longue) |
| 4 | Durée acceptable, légère perte de cohérence |
| 3 | Durée mal calibrée (sujet morphing en fin de clip) |
| 1-2 | Durée incompatible avec l'action prévue |

### 7. Camera Movement (/5)

| Score | Description |
|---|---|
| 5 | Mouvement caméra exactement comme prompté, fluide |
| 4 | Mouvement présent mais légèrement décalé (vitesse, axe) |
| 3 | Mouvement ambigu, modèle a interprété autrement |
| 1-2 | Mouvement absent ou totalement différent du prompt |

### 8. Audio (/5) — Veo 3.1, Sora 2 uniquement

| Score | Description |
|---|---|
| 5 | Dialogue lip-sync parfait + SFX synchros + ambient cohérent |
| 4 | Audio bon mais 1 décalage mineur |
| 3 | Dialogue in