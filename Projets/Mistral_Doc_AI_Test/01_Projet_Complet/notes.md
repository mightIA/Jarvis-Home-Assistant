---
pdf: source.pdf (Projet_Complet_v2.pdf)
type: doc maison structuré (25 p, 1,26 Mo, 595×842 pts, A4)
form_fields: 0 (PDF statique, non AcroForm)
encrypted: non
---

# Notes test 01 — Projet_Complet_v2.pdf

## Métadonnées (via `pdf-toolkit get_pdf_info`)

- 25 pages
- 1231,88 KB (1,2 Mo)
- 595 × 842 pts (A4 portrait)
- 0 form fields (PDF statique)
- Non chiffré
- Texte natif (pas d'OCR nécessaire)

## Pré-requis cas d'usage

PDF généré via pandoc + XeLaTeX + DejaVu Sans + template custom S37.
Contient :
- Page de garde custom avec bandeaux + bloc "En un coup d'œil"
- Sommaire stylé (tocloft) sur 2 pages
- Table des figures (8 figures numérotées Fig. 1 à Fig. 8)
- 8 schémas embarqués (Graphviz DOT pour archi/workflow/gateways +
  Matplotlib pour benchmarks/tokens/timeline/coûts)
- 10 chapitres H1 + ~33 sous-sections H2 + quelques H3
- Annexes (glossaire, config PC, sources)
- En-têtes "Projet Jarvis • Hermes Agent Session 36 • 24 avril 2026"
  répétés sur chaque page
- Pieds "Document interne • Vision, pas une obligation X / 21" répétés
- Plusieurs **tableaux** : modèles Ollama, glossaire, config PC, etc.

## Extraction `pdf-toolkit` (`read_pdf_content`)

- **Durée** : instantanée (< 2 s, MCP local)
- **Caractères extraits** : 40 879
- **Encodage** : UTF-8 propre (é, è, œ, ✅, →, • tous présents)

### Points positifs

- ✅ Récupération **intégrale** du texte (5500 mots reconstitués vs
  5231 mots source — le surplus = en-têtes/pieds répétés)
- ✅ **Aucune erreur OCR** (texte natif PDF, pas d'image)
- ✅ **0 ligature cassée**, accents et caractères spéciaux préservés
- ✅ Sommaire et ToF préservés (utile si on veut les exploiter)

### Points négatifs majeurs

- ❌ **Pas de retours à la ligne** entre éléments — page de garde collée
  en un seul bloc : *"DOCUMENT INTERNE • SESSION 36 • 24 AVRIL 2026Projet
  JarvisVers une architecture hybride Hermès..."*
- ❌ **Distracteurs préservés** intégralement :
  - En-têtes répétés sur 25 pages (à filtrer en post-traitement)
  - Pieds "Document interne • Vision X / 21" répétés
  - Numéros de page accolés au texte
- ❌ **Hiérarchie des titres écrasée** : aucun `#`/`##`/`###` —
  tout est en texte plat. Les titres "1 Préambule", "2 Chapitre 1 — Vue
  d'ensemble", "2.1 1.1 Qu'est-ce que Jarvis aujourd'hui ?" sont
  reconnaissables mais sans markdown
- ❌ **Tableaux complètement défoncés** : colonnes collées sans
  séparateurs. Exemple ligne brute :
  *"Modèle Taille VRAM Vitesse Rôle envisagéQwen 3 32BQ4_K_M22,2 Go
  ~35 tok/s Tâches standard,qualité procheClaude Sonnet..."*
- ❌ **Pas de description des images** — les 8 figures sont mentionnées
  par leur caption *"Fig. 1 – Architecture Jarvis actuelle — avril 2026"*
  mais le **contenu visuel est totalement ignoré** (logique : pdf-toolkit
  lit le texte, pas les images)
- ❌ **Bullet lists** toutes collées sur la même ligne :
  *"• Multi-LLM natif : Anthropic (Claude), OpenAI (GPT)…• MCP natif :
  Hermès consomme…• Smart Model Routing…"*
- ❌ **Quelques mots collés** : `RTX3090`, `Plan Max`,
  `dépendance cloudtotale` (rares mais présents)

### Verdict pdf-toolkit (avant comparaison Mistral)

- **Cas idéal** : besoin du texte brut pour grep ou recherche full-text
- **Cas mauvais** : besoin d'un Markdown structuré exploitable
  directement par un sub-agent Hermès `wiki_ingestor` → **gros
  post-traitement requis** (regex en-têtes/pieds, détection chapitres
  par numérotation, reconstruction tableaux à la main, etc.)

## Extraction Mistral (Le Chat, modèle "Équilibré", 25/04/2026)

### Mesures

- **Durée upload** : 9 s (mesurée par Mickael)
- **Durée génération** : ~30 s à 1 min (estimation, pas de chrono précis)
- **Durée totale** : ~40 s à 1 min 10 s
- **Caractères extraits** : ~50 000 (vs 40 879 pdf-toolkit — surplus = formatage markdown + ToC + placeholders [IMAGE:])
- **Lignes** : 1211 (structurées, sauts de ligne corrects)

### Points positifs Mistral ✅

1. **Hiérarchie titres préservée** — `#` / `##` / `###` (mais échappés `\#`, voir bug ci-dessous)
2. **Sauts de ligne corrects** entre paragraphes et sections (vs tout collé pdf-toolkit)
3. **4 tableaux Markdown reconstruits** :
   - Modèles Ollama (Qwen 3 32B, Llama 3.1 8B, etc.)
   - Failure modes / mitigation (Risque + Mitigation)
   - Glossaire technique annexe A (Terme + Définition)
   - Configuration PC Mickael annexe B (Composant + Valeur)
4. **8 placeholders d'images** insérés à l'emplacement original :
   - `[IMAGE: Architecture Jarvis actuelle — avril 2026]`
   - `[IMAGE: Architecture Jarvis cible — Claude + Hermès + Ollama + Obsidian]`
   - `[IMAGE: Benchmarks modèles locaux sur RTX 3090]`
   - `[IMAGE: Workflow de routing — décision requête par requête]`
   - `[IMAGE: Gateways Hermès — points d'entrée multi-canaux]`
   - `[IMAGE: Répartition tokens avant / après adoption Hermès]`
   - `[IMAGE: Stratégies d'abonnement LLM — coût mensuel estimé]`
   - `[IMAGE: Timeline du projet Jarvis → Hermes Agent]`
5. **En-têtes/pieds filtrés** — aucun "Document interne • Vision X / 21" répété, aucun "Projet Jarvis • Hermes Agent…" parasite
6. **Sommaire reconstruit** comme liste numérotée avec liens d'ancrage Markdown
7. **Bullet lists** correctes (un point par ligne, pas tout collé)
8. **Texte fidèle** — restitution intégrale sans paraphrase

### Points négatifs Mistral 🔴

1. **Échappement excessif** (artefact copier-coller Le Chat) :
   - Tous les caractères Markdown préfixés `\` : `\#`, `\*\*`, `\-`, `\[`, `\|`, `\~`
   - **Markdown PAS directement utilisable** sans dé-échappement
   - Fix : `sed -i 's/\\\([#*\-|\[\]~]\)/\1/g'` côté Bash — ~5 s de post-traitement
   - **NB** : c'est une limite **du copy depuis Le Chat UI**, pas de Mistral en API. Côté API REST `/v1/ocr` ou Document AI le markdown serait probablement propre.

2. **Quelques erreurs textuelles** (Mistral a paraphrasé/altéré ~3 endroits) :
   - `callbacks dynamiques` (×3) au lieu de `fallbacks dynamiques` — confusion fr/en
   - `tools/include` au lieu de `tools.include` (slash au lieu de point)
   - `Ces fallback rendent` (singulier au lieu de pluriel)
   - Négligeable mais à signaler

3. **Numérotation des chapitres dupliquée** : `## 2.1 1.1 Qu'est-ce que Jarvis aujourd'hui ?` — Mistral a gardé la numérotation source ET ajoute la sienne (H2 = 2.1 + sous-section 1.1 du source). Fidèle mais visuellement bizarre.

4. **Tableau "Comparatif des stratégies d'abonnement"** raté (section 6.1) — Mistral a juste mis "Plusieurs combinaisons ont été évaluées" sans reproduire le tableau. **pdf-toolkit a aussi raté ce tableau** → cas limite des 2 outils.

5. **Espaces HTML parasites** : `&#x20;` (HTML entity de l'espace insécable) en début de quelques lignes de tableaux. Probablement transcription d'espaces spéciaux du PDF. À nettoyer avec un sed simple.

6. **Description des images limitée à la caption** — Mistral n'a pas vraiment "vu" les schémas, il a juste reproduit le titre de la figure. Donc on a `[IMAGE: Architecture Jarvis actuelle — avril 2026]` mais pas une description du contenu visuel (boîtes, flèches, textes).

7. **Sommaire en double** : Mistral génère son propre sommaire ET reproduit celui du PDF (qui était la ToC pandoc). Redondance.

## Comparatif final test 1 (Projet_Complet_v2.pdf)

| Critère | pdf-toolkit | Mistral | Gagnant |
|---|---|---|---|
| 1. Qualité texte | 5/5 (parfait, brut) | 4/5 (paraphrases mineures, échappement Markdown) | pdf-toolkit |
| 2. Fidélité tableaux | 1/5 (collés sans séparateur) | 4/5 (4 tableaux reconstruits, 1 raté) | **Mistral** |
| 3. Description images | 0/5 (ignorées) | 2/5 (placeholders avec caption, pas de description visuelle) | **Mistral** |
| 4. Distracteurs | 1/5 (en-têtes/pieds présents) | 5/5 (filtrés proprement) | **Mistral** |
| 5. Durée | 5/5 (< 2 s) | 2/5 (~40 s à 1 min) | pdf-toolkit |
| 6. Simplicité workflow | 5/5 (1 appel MCP local) | 2/5 (drag drop + copy + Notepad + post-traitement sed) | pdf-toolkit |
| **Total /30** | **17/30** | **19/30** | **Mistral** (de peu) |

### Verdict test 1

- **Mistral gagne sur la structure** (titres + tableaux + bullets + filtre distracteurs) — c'est ce qui compte pour un sub-agent `wiki_ingestor`.
- **pdf-toolkit gagne sur la rapidité et la fidélité** au texte brut — utile pour grep / recherche full-text.
- **Pour Phase 1bis-c (Hermès)** : si on retient Mistral, **passer par l'API** (pas par Le Chat) pour éviter l'artefact d'échappement, sinon prévoir un post-traitement systématique.
- **Cas d'usage idéal Mistral** : ingestion d'un nouveau PDF dans le vault Obsidian (un coup, post-traitement OK).
- **Cas d'usage idéal pdf-toolkit** : extraction rapide pour vérification, recherche, ou pré-traitement avant analyse LLM.

À confirmer avec **test 2 (manuel HA)** + **test 3 (CERFA AcroForm)** avant recommandation finale.
