---
pdf: source.pdf (Z-Wave JS doc HA, export Brave PDF natif)
type: doc tiers technique web → PDF print
url_source: https://www.home-assistant.io/integrations/zwave_js/
form_fields: 0 (PDF statique)
encrypted: non
date: 2026-04-25 (S45 puis S46 Phase 1bis-b)
status: SCORÉ COMPLET S46 (v2 EN no-translate validée)
---

# Notes test 02 — Z-Wave JS doc HA

## Métadonnées (via `pdf-toolkit get_pdf_info`)

- **60 pages** (la doc Z-Wave JS est très dense)
- **6066,26 KB (5,9 Mo)**
- 595 × 842 pts (A4 portrait)
- 0 form fields
- Non chiffré
- **Type particulier** : PDF web imprimé via Brave/Chromium natif avec
  fonts custom embarquées

## Pré-requis cas d'usage

Page web HA officielle, contenu :
- Texte structuré (titres H1/H2/H3)
- Code blocks YAML / JSON
- Tableaux de configuration (Data attribute / Required / Description)
- Liens internes
- Images (logos d'intégration, screenshots)
- Composants Material Design (badges, callouts)

C'est un cas **représentatif** de ce que fait un sub-agent
`wiki_ingestor` Hermès quand il ingère une doc tierce trouvée sur le
web : page imprimée en PDF puis indexée.

## Extraction `pdf-toolkit` (S45)

⚠️ **ÉCHEC TOTAL** — voir `extraction_pdf_toolkit.md`.

Cause : fonts custom Chromium embarquées, mapping ToUnicode brisé,
extraction texte donne 9883 chars de charabia (`!""#$"%" &'()*(&)&+`
type lipogramme inutilisable).

Score : **5/30** (rapidité+simplicité élevées MAIS résultat
inutilisable, donc score effectif annule les bonus rapidité).

| Critère | Score brut | Score effectif | Note |
|---|---|---|---|
| 1. Qualité texte | 0/5 | 0/5 | charabia |
| 2. Fidélité tableaux | 0/5 | 0/5 | rien à extraire |
| 3. Description images | 0/5 | 0/5 | ignorées |
| 4. Distracteurs | 0/5 | 0/5 | tout est cassé |
| 5. Durée | 5/5 | 5/5 | < 2 s |
| 6. Simplicité workflow | 5/5 | 0/5 | sortie poubelle = workflow inutile |
| **Total** | 10/30 | **5/30** | échec total |

## Extraction Mistral v1 S45 (échec partiel)

Voir `extraction_mistral.md` (367 lignes, 25 808 chars).

- Durée : 3 min 4 s
- **Tronqué** au milieu d'un code block YAML sans signal de coupure
- **Traduit** EN → FR malgré consigne FR explicite (`Attribut de données |
  Requis | Description` au lieu de `data attribute | required | description`)
- Limite Le Chat ~25k chars FR atteinte (~30-40 % du PDF)

Conclusion : v1 inutilisable pour notre cas → relance v2 avec prompt EN.

## Extraction Mistral v2 S46 (succès)

Voir `extraction_mistral_v2_no_translate.md` (1136 lignes, 48 735 chars).
Prompt utilisé : `prompt_mistral_v2_no_translate.md` (EN explicite).

### Mesures

- **Durée upload** : ~30-60 s estimé (5,9 Mo)
- **Durée génération** : 3-4 min (vs 3 min 4 s v1 = comparable)
- **Lignes obtenues** : 1136 (vs 367 v1 = **3,1× plus dense**)
- **Caractères** : 48 735 (vs 25 808 v1 = **1,9× plus dense**)
- **Langue de sortie** : EN ✅
- **Troncature** : non — `[END OF DOCUMENT — 100 PAGES PROCESSED]` en fin
- **Échappement markdown** : absent ✅

### Points positifs Mistral v2 ✅

1. **DO NOT TRANSLATE respecté** intégralement (Getting Started, Data
   attribute, Required, Description, YAML keys, JSON properties tous en EN)
2. **Document complet** (pas tronqué, marker fin explicite)
3. **Distracteurs filtrés** (en-têtes/pieds Brave Chromium absents)
4. **Bullets corrects** (un point par ligne)
5. **Placeholders [IMAGE: ...]** insérés (au moins 1 vu : "Backup button
   in Z-Wave JS UI")
6. **Code YAML/JSON lisible** (avec labels "YAML"/"JSON" avant les blocs)
7. **Markdown standard** sans échappement parasite (pas de `\#`/`\*\*`/`\-`)

### Points négatifs Mistral v2 🔴

1. **Hiérarchie titres NON appliquée** : `Getting started`, `Setting Up
   a Z-Wave Server in Home Assistant`, `Network Devices`, `Action: Set
   Config Parameter` sont en **texte plat**, sans `#` / `##` / `###`.
   Critère 1 fortement pénalisé pour un sub-agent `wiki_ingestor`.

2. **Tableaux applatis en lignes individuelles** au lieu de `|...|...|`.
   Exemple lignes 343-366 :
   ```
   Data attribute
   Required
   Description
   entity_id
   no
   Entity (or list of entities) to set the configuration parameter on...
   device_id
   no
   Device ID (or list of device IDs)...
   ```
   Lisible humainement mais **pas exploitable** par parser markdown
   (impossible de reconstruire les colonnes).

3. **Code blocks sans fences** ``` ` ` ` ``` : juste un label "YAML" ou "JSON"
   avant les lignes de code. Lisible mais pas sémantique.

4. **Quelques placeholders dégradés** ("Txt / Mala / Model / Entity Domain"
   ligne 755-758) : Mistral n'a pas pu lire le tableau de devices d'image
   et a tenté un placeholder texte hasardeux.

5. **Numérotation de "100 pages"** alors que le PDF source en a 60 :
   Mistral compte différemment (probablement par section logique). Pas
   un bug, mais à noter.

### Score test 2 v2

| Critère | Score | Justification |
|---|---|---|
| 1. Qualité texte | 4/5 | EN préservé, pas d'erreur de transcription, mais hiérarchie titres absente (texte plat) |
| 2. Fidélité tableaux | 2/5 | Cellules applaties en lignes, pas de séparateurs `|`, lisible humainement mais pas parsable |
| 3. Description images | 3/5 | 1 placeholder explicite, 1 placeholder dégradé (Txt/Mala/Model) |
| 4. Distracteurs | 5/5 | En-têtes/pieds Brave filtrés totalement, propre |
| 5. Durée | 2/5 | 3-4 min lent mais utilisable (vs <2s charabia pdf-toolkit) |
| 6. Simplicité workflow | 2/5 | Drag drop + copy + paste + post-process à venir si parser strict |
| **Total /30** | **18/30** | Succès net mais structure imparfaite, post-traitement requis |

## Comparatif final test 2 (Z-Wave JS doc HA, PDF web Chromium 60 p)

| Critère | pdf-toolkit | Mistral v2 EN | Gagnant |
|---|---|---|---|
| 1. Qualité texte | 0/5 (charabia) | 4/5 | **Mistral** |
| 2. Fidélité tableaux | 0/5 | 2/5 | **Mistral** |
| 3. Description images | 0/5 | 3/5 | **Mistral** |
| 4. Distracteurs | 0/5 | 5/5 | **Mistral** |
| 5. Durée | 5/5 | 2/5 | pdf-toolkit (mais inutile) |
| 6. Simplicité workflow | 0/5 | 2/5 | **Mistral** |
| **Total /30** | **5/30** | **18/30** | **Mistral écrasant** |

### Verdict test 2

- **pdf-toolkit totalement inutile** sur ce cas (PDF Brave Chromium avec
  fonts custom = mapping ToUnicode brisé). Inutile de mesurer "rapidité"
  d'un outil qui produit du charabia.
- **Mistral v2 EN = unique solution** pour cette catégorie de PDF.
- **Limites Mistral** : structure imparfaite (titres + tableaux + fences
  code) → post-traitement automatique nécessaire pour pipeline `wiki_ingestor`
  Hermès. Solution probable : régex side-car ou bascule API REST `/v1/ocr`.
- **Découverte clé S46** : passer en EN multiplie par 3 la densité d'output
  (1136 lignes EN vs 367 lignes FR) en même temps de génération. Probable
  raison : tokenisation EN plus efficiente que FR pour le modèle Mistral
  Medium 3.

## Recommandation pour Phase 1bis-c (sub-agent `wiki_ingestor`)

1. **Détection automatique du PDF type** :
   - PDF natif fonts standard → pdf-toolkit OK (rapide, simple)
   - PDF Brave Chromium fonts custom → bascule Mistral OCR
   - Détection heuristique : taux de caractères non-Unicode > 30 % → bascule

2. **Choix langue prompt Mistral** : toujours adapter à la langue source du
   PDF (EN pour doc HA/Z-Wave, FR pour CERFA, etc.). Ne jamais demander une
   traduction lors de l'ingestion.

3. **Marker de fin obligatoire** dans le prompt → permet de détecter les
   troncatures pour relance automatique sur la suite.

4. **Post-traitement structurel** côté Hermès :
   - Détection titres par regex (lignes courtes en début de section + suivies
     d'un saut de ligne) → ajout `#`/`##`/`###`
   - Détection tableaux par regex (lignes de 1-3 mots répétitives suivies
     de descriptions) → reconstruction `|...|...|`
   - Détection code blocks par marqueur "YAML"/"JSON"/"Bash" → ajout fences
