# Midjourney — fiche IA

## Identité

- **Éditeur** : Midjourney, Inc.
- **Version courante** (2026) : **V7** (par défaut), mode anime **--niji 7**
- **Accès** : Discord bot (legacy) + **alpha.midjourney.com** (web app, recommandé)
- **Tarif** : payant, 4 plans (Basic, Standard, Pro, Mega) — pas de tier gratuit
- **Multimodal** : `--cref` pour cohérence personnage, `--sref` pour
  cohérence style, `--iw` pour pondération image

## Forces

- **Esthétique** la plus poussée du marché grand public — rendu
  "cinéma" / "concept art" naturel
- Excellent sur paysages, atmosphères, lumière, textures
- Cohérence personnage (`--cref`) très bonne depuis V6
- Web app moderne avec édition régionale (inpainting), variations,
  panoramique, upscale 4K

## Faiblesses

- **Texte dans l'image** : médiocre (préférer DALL·E 3 ou FLUX pour ça)
- **Mains** : encore fragiles malgré les progrès V6/V7
- **Compositions complexes** avec interactions multi-personnages : approximatif
- Tendance à la sur-stylisation par défaut (corriger avec `--style raw`)
- Modération plus stricte qu'avant (pas de personnalités vivantes,
  contenu sensible bridé)

## Documentation officielle

- Hub web : `https://docs.midjourney.com`
- Cheat sheet paramètres : voir [parameters_reference.md](parameters_reference.md)
- Showcase et inspiration : `https://www.midjourney.com/showcase`

## Méthodes communautaires

- **Image-to-image avec `--cref`** : url image en référence, `--cw 100`
  pour copier précisément, `--cw 0` pour ne garder que le visage
- **Style cloning avec `--sref`** : url image style référence,
  `--sw 0-1000` pour pondérer
- **Style raw** (`--style raw`) : moins d'auto-stylisation, plus fidèle
  au prompt brut
- **Permutations** : `{a, b, c}` génère 3 versions
- **Pondération multi-prompts** : `concept A ::2 concept B ::1` pour
  donner plus de poids à A

## Workflow standard Mickael

1. Brief Mickael en FR
2. Jarvis applique le template (voir [prompt_template.md](prompt_template.md))
3. Mickael copie dans la web app
4. Génération 4 images (grid)
5. Choix du meilleur, éventuellement upscale ou variations
6. Renvoi à Jarvis pour analyse comparative et v2

## Pièges connus

- ⚠️ Tendance à interpréter "réaliste" comme "cinéma stylisé" → forcer
  `--style raw --s 50`
- ⚠️ Saturation poussée par défaut → demander explicitement "muted, natural"
- ⚠️ Contradictions dans le prompt = MJ choisit pour toi (et pas
  forcément ton choix)
- ⚠️ Trop de mots = dilution → viser 30-60 mots utiles

## Web App vs Discord (état 2026)

| Feature | Web App `alpha.midjourney.com` | Discord bot |
|---|---|---|
| Génération de base | ✅ | ✅ |
| Upscale 4K | ✅ | 🟡 (via /upscale) |
| Vary Region (inpainting) | ✅ | ✅ |
| Pan / Zoom out | ✅ | ✅ |
| **Moodboards** | ✅ | ❌ |
| **Personalization V2** | ✅ | 🟡 (lecture seule) |
| **Style Creator** | ✅ | ❌ |
| **Editor (canvas multi-image)** | ✅ | ❌ |
| **Profiles (multi-personas)** | ✅ | ❌ |
| Conversational Mode | ✅ | ❌ |

→ **Recommandation Mickael** : tout faire en web app sauf workflow legacy.
Voir détail features V7 dans [parameters_reference.md](parameters_reference.md).

## V8 / V8.1 — choix volontaire V7 dans ce projet

Selon la roadmap MJ, **V8** (puis **V8.1**) doivent améliorer :
- **Texte rendu fiable** (rattrapage Ideogram pour la typo prod)
- Cohérence personnages multi-poses encore meilleure
- Vidéo native MJ (en concurrence avec Veo 3.1 et Runway)

**Choix de ce projet (S91, 03/05/2026)** : rester sur **V7** par défaut
tant que V8 n'est pas stabilisé. V8 sera intégré dans le projet quand
sortie + 2-3 mois de retours communauté.

## Liens projet

- Template prompt : [prompt_template.md](prompt_template.md)
- Référence paramètres : [parameters_reference.md](parameters_reference.md)
- Bibliothèque styles MJ : [style_library.md](style_library.md)
- Log itérations : [iterations_log.md](iterations_log.md)
