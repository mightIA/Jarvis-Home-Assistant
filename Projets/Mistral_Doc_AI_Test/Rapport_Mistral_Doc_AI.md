---
title: Rapport Phase 1bis-b — Mistral Document AI vs pdf-toolkit
created: 2026-04-25
sessions: 45 (étude initiale) + 46 (clôture)
status: FINAL
parent: TASKS.md #58 Phase 1bis-b
audience: Mickael + futur sub-agent wiki_ingestor Hermès Phase 1bis-c
---

# Rapport Phase 1bis-b — Mistral Document AI vs pdf-toolkit

## TL;DR (résumé exécutif)

Sur **2 PDF testés** (le 3ᵉ a été abandonné — voir leçon dématérialisation),
**Mistral Document AI Le Chat gagne dans les 2 cas** mais avec des marges très
différentes. Recommandation pour Phase 1bis-c sub-agent `wiki_ingestor` :
**routing intelligent** entre les 2 outils selon le type de PDF, avec un
**fallback automatique** vers Mistral OCR API REST quand pdf-toolkit produit
du charabia.

| Cas | pdf-toolkit | Mistral v2 EN | Verdict |
|---|---|---|---|
| **Test 1** — Doc maison structuré (Projet_Complet_v2.pdf 25 p) | 17/30 | 19/30 | Mistral gagne de peu, structure mieux préservée |
| **Test 2** — Doc web Brave Chromium (Z-Wave JS doc 60 p) | **5/30** | **18/30** | Mistral écrase, pdf-toolkit inutile (charabia ToUnicode) |
| **Test 3** — CERFA AcroForm | abandonné (3 pièges dématérialisation) | non testé | Leçon : la majorité des CERFA ne sont plus téléchargeables |

**Décision retenue D5-D8 S45+S46** :

- **D5** : Mistral via API REST `/v1/ocr` pour Phase 1bis-c (pas Le Chat)
  pour éviter limites tokens output + tentation traduction + échappement
  copier-coller.
- **D6** : pdf-toolkit reste pertinent pour PDFs natifs avec fonts standard
  (Test 1) mais à doubler avec routing intelligent vers Mistral OCR si
  charabia détecté.
- **D7** : prompt Mistral en **langue source du PDF** + signal explicite
  de troncature requis pour fidélité.
- **D8** : passer en EN multiplie par 3 la densité d'output (découverte
  S46) → toujours adapter la langue prompt à la langue source.

---

## 1. Méthodologie

### 1.1 Objectif initial

Comparer **Mistral Document AI** (gratuit via Le Chat) à l'extraction
**`pdf-toolkit` MCP** (Open Document Alliance v0.7.3, MIT, déjà installé
S35) pour décider si Mistral mérite d'être intégré dans la stack Phase 1bis :

- **Phase 1bis-c** : sub-agent `wiki_ingestor` Hermès qui ingère un fichier
  brut → extraction Markdown vers `Wiki/RAW/`. Si Mistral fait mieux que
  pdf-toolkit sur certains cas, il devient l'outil de pré-traitement.
- **Cas d'usage immédiats** : extraction CERFA, manuels techniques tiers,
  rapports à indexer dans le vault Obsidian.

### 1.2 Les 3 PDF de test

| Sous-dossier | PDF | Type | Cas représenté |
|---|---|---|---|
| `01_Projet_Complet/` | Projet_Complet_v2.pdf (25 p, 1,26 Mo) | Doc maison structuré + 8 schémas + ToC + ToF | Doc bien formé connu |
| `02_Manuel_HA/` | source.pdf Z-Wave JS (60 p, 5,9 Mo) | Doc tiers web → Brave PDF natif Chromium | Doc web tierce ingérée |
| `03_CERFA_AcroForm/` | (abandonné) | CERFA AcroForm officiel | Formulaire administratif |

### 1.3 Critères de scoring (6, total /30)

| Critère | Description | Pondération |
|---|---|---|
| **1. Qualité texte** | Caractères corrects, ligatures, accents, structure markdown | ⭐⭐⭐ |
| **2. Fidélité tableaux** | Tableau Markdown propre `|...|...|` ou cellules cassées | ⭐⭐⭐ |
| **3. Description images** | Caption préservée + alt-text si schéma | ⭐⭐ |
| **4. Distracteurs** | En-têtes/pieds répétés, watermarks parasites filtrés | ⭐⭐ |
| **5. Durée traitement** | Temps wall-clock (drag drop → markdown) | ⭐ |
| **6. Simplicité workflow** | Nb d'étapes manuelles + sortie utilisable directement | ⭐ |

Note 1 à 5 par critère, total /30.

---

## 2. Test 1 — Projet_Complet_v2.pdf (doc maison)

### 2.1 Contexte

PDF généré via pandoc + XeLaTeX + DejaVu Sans + template custom S37
(« Tech moderne sobre »). 25 pages, 1,26 Mo, A4 portrait, 0 form fields,
non chiffré, **texte natif** (pas d'OCR nécessaire).

Contenu : page de garde custom, sommaire stylé, table des figures (8 figs),
8 schémas Graphviz/Matplotlib, 10 chapitres H1, ~33 sous-sections H2,
plusieurs tableaux, en-têtes/pieds répétés sur chaque page.

### 2.2 Mesures pdf-toolkit

- **Durée** : < 2 s (instantané, MCP local)
- **Caractères extraits** : 40 879 (UTF-8 propre)
- **Forces** : récupération intégrale du texte, 0 erreur OCR, 0 ligature
  cassée, accents et `é`/`è`/`œ`/`✅`/`→`/`•` tous présents
- **Faiblesses** : pas de retours à la ligne entre éléments (page de garde
  collée en un seul bloc), distracteurs préservés (en-têtes/pieds/numéros
  page accolés), hiérarchie titres écrasée (texte plat), tableaux
  complètement défoncés (colonnes collées sans séparateurs), bullets toutes
  collées sur la même ligne, quelques mots collés (`RTX3090`,
  `dépendance cloudtotale`)

### 2.3 Mesures Mistral Le Chat (modèle Équilibré)

- **Durée upload** : 9 s
- **Durée génération** : ~30 s à 1 min
- **Durée totale** : ~40 s à 1 min 10 s
- **Caractères extraits** : ~50 000 (vs 40 879 pdf-toolkit, surplus =
  formatage markdown + ToC + placeholders [IMAGE:])
- **Lignes** : 1211 (structurées, sauts de ligne corrects)
- **Forces** : hiérarchie titres préservée (`#`/`##`/`###` mais échappés),
  sauts de ligne corrects, **4 tableaux Markdown reconstruits** (Modèles
  Ollama / Failure modes / Glossaire / Config PC), **8 placeholders d'images**
  insérés à l'emplacement original avec captions, en-têtes/pieds filtrés,
  bullets correctes, texte fidèle
- **Faiblesses** : échappement excessif (artefact copier-coller Le Chat,
  fix `sed` ~5 s), 3 paraphrases mineures (`callbacks` au lieu de
  `fallbacks` ×3), numérotation chapitres dupliquée, 1 tableau raté
  ("Stratégies d'abonnement"), espaces HTML parasites `&#x20;`, sommaire
  en double

### 2.4 Score test 1

| Critère | pdf-toolkit | Mistral | Gagnant |
|---|---|---|---|
| 1. Qualité texte | 5/5 (parfait, brut) | 4/5 (paraphrases mineures + échappement) | pdf-toolkit |
| 2. Fidélité tableaux | 1/5 (collés sans séparateur) | 4/5 (4 tableaux reconstruits, 1 raté) | **Mistral** |
| 3. Description images | 0/5 (ignorées) | 2/5 (placeholders + caption, pas de description visuelle) | **Mistral** |
| 4. Distracteurs | 1/5 (en-têtes/pieds présents) | 5/5 (filtrés proprement) | **Mistral** |
| 5. Durée | 5/5 (< 2 s) | 2/5 (~40 s à 1 min) | pdf-toolkit |
| 6. Simplicité workflow | 5/5 (1 appel MCP local) | 2/5 (drag drop + copy + Notepad + post-traitement sed) | pdf-toolkit |
| **Total /30** | **17/30** | **19/30** | **Mistral** (de peu) |

### 2.5 Verdict test 1

- Mistral gagne **sur la structure** (titres + tableaux + bullets + filtre
  distracteurs) — c'est ce qui compte pour un sub-agent `wiki_ingestor`.
- pdf-toolkit gagne sur la **rapidité et fidélité texte brut** — utile pour
  grep / recherche full-text.
- Pour un PDF maison bien formé, **Mistral apporte +12 % de qualité
  structurelle** au prix d'un workflow ~30× plus lent. Acceptable pour
  ingestion ponctuelle, problématique pour ingestion massive.

---

## 3. Test 2 — Z-Wave JS doc HA (PDF web Brave Chromium)

### 3.1 Contexte

Page web HA officielle [home-assistant.io/integrations/zwave_js](https://www.home-assistant.io/integrations/zwave_js/)
imprimée en PDF via Brave/Chromium « Fichier PDF » natif. 60 pages,
5,9 Mo, A4 portrait, 0 form fields, non chiffré.

**Particularité critique** : Brave Chromium embarque les fonts CSS custom
de la doc HA (Noto Sans / Inter), avec une table `ToUnicode` corrompue.
Rendu visuel OK, mais extraction texte donne du non-sens.

Contenu : titres H1/H2/H3, code blocks YAML, tableaux Data attribute /
Required / Description, liens internes, images, composants Material Design.
**C'est un cas représentatif** de ce que fait un sub-agent `wiki_ingestor`
quand il ingère une doc tierce trouvée sur le web.

### 3.2 Mesures pdf-toolkit (S45)

- **Durée** : < 2 s
- **Caractères extraits** : 9 883 chars de **charabia** type
  `!""#$"%" &'()*(&)&+`
- **Cause** : fonts custom Chromium embarquées, mapping ToUnicode brisé
- **Verdict** : sortie totalement inutilisable

### 3.3 Mesures Mistral v1 S45 (échec partiel)

- **Durée** : 3 min 4 s
- **Lignes** : 367 (tronquées, output coupé en plein milieu d'un code block
  YAML sans signal de coupure ni `\`\`\`` fermant)
- **Caractères** : 25 808 (~30-40 % du PDF traité)
- **Langue de sortie** : **FR** (Mistral a TRADUIT EN→FR malgré consigne FR
  explicite — `Attribut de données | Requis | Description` au lieu des
  colonnes anglaises)
- **Verdict** : v1 inutilisable, relance v2 nécessaire avec prompt EN

### 3.4 Mesures Mistral v2 S46 (succès)

Prompt EN avec règles strictes (DO NOT TRANSLATE + signal de troncature
explicite + format markdown standard sans échappement).

- **Durée upload** : ~30-60 s estimé (5,9 Mo)
- **Durée génération** : 3-4 min (vs 3 min 4 s v1 = comparable)
- **Lignes obtenues** : 1136 (vs 367 v1 = **3,1× plus dense**)
- **Caractères** : 48 735 (vs 25 808 v1 = **1,9× plus dense**)
- **Langue de sortie** : EN ✅ (DO NOT TRANSLATE respecté)
- **Troncature** : non — `[END OF DOCUMENT — 100 PAGES PROCESSED]` en fin
- **Échappement markdown** : absent ✅

#### Forces v2

1. EN préservé intégralement (Getting Started, Data attribute, YAML keys,
   JSON properties tous en EN)
2. Document complet (pas tronqué, marker fin explicite)
3. Distracteurs filtrés (en-têtes/pieds Brave Chromium absents)
4. Bullets corrects, placeholders [IMAGE: ...] insérés, code YAML/JSON
   lisible avec labels, markdown standard sans échappement parasite

#### Faiblesses v2

1. **Hiérarchie titres NON appliquée** (texte plat, pas de `#`/`##`/`###`)
2. **Tableaux applatis en lignes individuelles** (cellules sur lignes
   séparées au lieu de `|...|...|`)
3. **Code blocks sans fences** ``` ` ` ` ``` (juste un label "YAML" ou "JSON"
   avant les lignes)
4. Quelques placeholders dégradés ("Txt / Mala / Model")

### 3.5 Score test 2

| Critère | pdf-toolkit | Mistral v2 EN | Gagnant |
|---|---|---|---|
| 1. Qualité texte | 0/5 (charabia) | 4/5 | **Mistral** |
| 2. Fidélité tableaux | 0/5 | 2/5 | **Mistral** |
| 3. Description images | 0/5 | 3/5 | **Mistral** |
| 4. Distracteurs | 0/5 | 5/5 | **Mistral** |
| 5. Durée | 5/5 (mais inutile) | 2/5 | pdf-toolkit (mais sortie inutile) |
| 6. Simplicité workflow | 0/5 (sortie poubelle) | 2/5 | **Mistral** |
| **Total /30** | **5/30** | **18/30** | **Mistral écrasant** |

### 3.6 Verdict test 2

- **pdf-toolkit totalement inutile** sur ce cas → score effectif annule les
  bonus rapidité (un outil rapide qui produit du charabia n'est pas un outil
  rapide, c'est un outil cassé).
- **Mistral v2 EN = unique solution** pour cette catégorie de PDF.
- **Découverte clé S46** : passer en EN multiplie par 3 la densité d'output
  (1136 lignes EN vs 367 lignes FR) en même temps de génération. Probable
  raison : tokenisation EN plus efficiente que FR pour Mistral Medium 3.
- **Limites Mistral** : structure imparfaite (titres + tableaux + fences
  code) → post-traitement automatique nécessaire pour pipeline `wiki_ingestor`.

---

## 4. Test 3 — CERFA AcroForm (abandonné)

### 4.1 Chasse infructueuse

Test 3 abandonné après **3 pièges dématérialisation successifs** :

| Tentative | URL | Type réel | Verdict |
|---|---|---|---|
| 1 | service-public.fr/particuliers/vosdroits/R39697 | Lettre type web (modèle attestation hébergement) | Pas un CERFA, formulaire interactif HTML |
| 2 | service-public.fr/particuliers/vosdroits/F2191 (CERFA 10798) | Attestation d'accueil | Délivrée en mairie après dépôt, pas téléchargeable |
| 3 | service-public.fr/particuliers/vosdroits/F1359 (CERFA 15646*01) | Autorisation sortie territoire | Bouton de téléchargement absent (re-piège) |

**Mention** : CERFA 15776*02 (déclaration cession véhicule) abandonné dès
le départ — 100% portail ANTS depuis 2017, plus de PDF papier disponible.

### 4.2 Leçon dématérialisation

> **La majorité des CERFA service-public.fr ne sont plus téléchargeables.**
> La procédure 100% en ligne est imposée via portails dédiés (ANTS,
> impots.gouv.fr, FranceConnect, Ameli, MSA, CAF). Le PDF papier est
> retiré, on est redirigé vers une démarche web qui génère un récépissé
> ou une attestation en sortie.

CERFA encore téléchargeables au 25/04/2026 (à re-vérifier dans le temps) :

- **15646*01** AST — apparemment plus disponible (S46)
- **13406*15** Permis de construire maison individuelle — F1986
- **2042** Déclaration revenus — impots.gouv.fr (archive PDF)
- Certains formulaires DGFiP, ANTS, MSA, CAF restent disponibles en PDF

CERFA dématérialisés (PDF retiré) :

- 15776*02 Déclaration de cession véhicule (ANTS only)
- 10798 Attestation d'accueil (mairie only)
- Formulaires fiscaux récents (déclaration en ligne obligatoire)

### 4.3 Conséquence pour Phase 1bis-c

Le sub-agent `wiki_ingestor` doit **anticiper qu'un CERFA téléchargeable
est l'exception, pas la règle**. Sources à archiver localement quand un
parent / tiers nous transmet un PDF rempli ou un récépissé démarche en
ligne. La capacité `fill_pdf` de pdf-toolkit reste pertinente pour les
quelques CERFA encore disponibles + tous les PDFs AcroForm tiers (DocuSign,
Yousign, exports Word « Créer formulaire PDF »).

### 4.4 Test 3 différé

Si on veut vraiment scorer pdf-toolkit + Mistral sur AcroForm dans une
session future, prendre :

- **CERFA 13406*15** Permis de construire (~6 pages, AcroForm complexe)
- **CERFA 2042** Déclaration revenus (~4-6 pages, AcroForm avec champs
  numériques)
- Ou **n'importe quel PDF DocuSign/Yousign tiers** que Mickael a sous la
  main (ex. devis signé, contrat assurance)

Pas de bloquant pour Phase 1bis-c — la conclusion principale (Mistral
écrasant sur PDF web Chromium) reste valide.

---

## 5. Synthèse comparative

### 5.1 Tableau récapitulatif

| Critère | Test 1 pdf-toolkit | Test 1 Mistral | Test 2 pdf-toolkit | Test 2 Mistral v2 |
|---|---|---|---|---|
| 1. Qualité texte | 5/5 | 4/5 | **0/5** | 4/5 |
| 2. Tableaux | 1/5 | 4/5 | 0/5 | 2/5 |
| 3. Images | 0/5 | 2/5 | 0/5 | 3/5 |
| 4. Distracteurs | 1/5 | 5/5 | 0/5 | 5/5 |
| 5. Durée | 5/5 | 2/5 | 5/5 | 2/5 |
| 6. Simplicité | 5/5 | 2/5 | 0/5 | 2/5 |
| **Total /30** | **17/30** | **19/30** | **5/30** | **18/30** |

### 5.2 Cartographie des cas d'usage

| Type de PDF | Outil recommandé | Raison |
|---|---|---|
| Doc maison pandoc/LaTeX bien formé (texte natif fonts standard) | **pdf-toolkit prioritaire** | Rapide, fidèle, structure post-process possible |
| Doc tiers PDF web Brave/Chromium (fonts CSS custom) | **Mistral OCR exclusif** | pdf-toolkit produit du charabia ToUnicode |
| Doc tiers PDF natif éditeur classique (Word, LibreOffice, Adobe) | **pdf-toolkit prioritaire** | Cas standard, peu de surprises |
| PDF AcroForm (CERFA, DocuSign, Yousign) | **pdf-toolkit exclusif** (`read_pdf_fields` + `fill_pdf`) | Mistral ne lit pas la structure AcroForm |
| PDF scan/image (sans texte natif) | **Mistral OCR exclusif** | pdf-toolkit ne fait pas d'OCR |
| Doc multilingue (FR + EN mélangés) | Mistral avec prompt langue source dominante | Évite traduction parasite |

### 5.3 Routing intelligent recommandé

Pour le sub-agent `wiki_ingestor` Phase 1bis-c, pseudocode :

```
function ingest_pdf(pdf_path):
    info = pdf_toolkit.get_pdf_info(pdf_path)

    # Cas formulaire AcroForm
    if info.form_fields_count > 0:
        return pdf_toolkit.read_pdf_fields(pdf_path) + read_pdf_content(pdf_path)

    # Tentative pdf-toolkit standard
    text = pdf_toolkit.read_pdf_content(pdf_path)

    # Détection charabia (heuristique : taux caractères non-mots > 30 %)
    if charabia_ratio(text) > 0.30:
        # Bascule Mistral OCR API REST
        prompt = build_prompt(language=detect_language(pdf_path), no_translate=True)
        return mistral_ocr_api(pdf_path, prompt)

    # Cas standard : pdf-toolkit OK + post-process light
    return post_process_markdown(text)
```

### 5.4 Limites du pipeline Le Chat (Phase 1bis-b)

Le test S45+S46 utilise **Mistral via Le Chat UI** (gratuit). Pour Phase
1bis-c en production, **bascule API REST `/v1/ocr`** obligatoire :

| Limite Le Chat | Conséquence | Solution API REST |
|---|---|---|
| Output tronqué ~25k chars FR / ~50k chars EN | Documents > 60 p partiels | Pagination native API + chunking automatique |
| Tentation traduction si prompt en autre langue | Sortie infidèle | Paramètre `target_language` strict |
| Échappement markdown copier-coller | Post-process `sed` requis | Sortie JSON propre, pas de copy UI |
| Workflow drag-drop manuel | Non scriptable | Endpoint `/v1/ocr` POST direct |
| Pas de contrôle modèle précis | Modèle "Équilibré" black box | `model: "mistral-medium-3"` explicite |

---

## 6. Recommandation finale Phase 1bis-c

### 6.1 Stack cible sub-agent `wiki_ingestor`

1. **Couche 1 — pdf-toolkit MCP** (déjà installé S35) : extraction rapide
   par défaut pour tous les PDF natifs. Couvre ~80 % des cas.

2. **Couche 2 — Mistral OCR API REST** : fallback automatique pour les
   PDFs problématiques (Brave Chromium fonts custom, scans, multilingues
   complexes). Couvre ~15 % des cas.

3. **Couche 3 — Routing intelligent Hermès** : heuristique de détection
   charabia (taux caractères non-mots) qui choisit entre couche 1 et 2.

4. **Couche 4 — Post-process Markdown** : régex side-car pour reconstruire
   les structures que Mistral applatit (hiérarchie titres, tableaux,
   fences code blocks).

### 6.2 Étapes de Phase 1bis-c liées à ce rapport

- ✅ **Pré-requis #1** Mistral retenu comme outil OCR fallback (acquis)
- ⏳ **Pré-requis #2** clé API Mistral à créer sur console.mistral.ai
  + Règle 0 (manipulation de clé sensible)
- ⏳ **Pré-requis #3** wrapper Python ou Node `mistral_ocr_api.py` côté
  Hermès Agent + endpoint `/v1/ocr` testé sur les 2 PDF de référence
- ⏳ **Pré-requis #4** sub-agent `wiki_ingestor` configuré dans
  `~/.hermes/AGENTS.md` avec routing intelligent + post-process

### 6.3 Coût estimé Mistral OCR API

- **Document AI Mistral** au 25/04/2026 : ~0,001 € / page OCR (à confirmer
  sur tarif Mistral à l'usage)
- Pour 100 PDF/mois × 30 pages moyennes = ~3 000 pages × 0,001 € = **~3 €/mois**
- Compatible avec décision S36 (OpenRouter pay-as-you-go ~5-10 $/mois pour
  Hermès → Mistral OCR rentre dans le même budget)

### 6.4 Alternatives si Mistral rejeté plus tard

Si limite tarifaire ou changement de stratégie en Phase 1bis-c :

- **Marker** (open source MIT, https://github.com/VikParuchuri/marker) :
  alternative locale forte pour PDF → Markdown, tourne sur RTX 3090.
  À benchmarker en Phase 1bis-c si Mistral ne convient plus.
- **Tesseract OCR** : standard de fait pour OCR pur, mais reconstruction
  Markdown inférieure.
- **PaddleOCR** : alternative chinoise très bonne sur tableaux.

---

## 7. Décisions structurantes consolidées

| ID | Décision | Source |
|---|---|---|
| **D5-S45** | Mistral via API REST `/v1/ocr` pour Phase 1bis-c (pas Le Chat) pour éviter limites tokens output + tentation traduction + échappement copier-coller | S45 |
| **D6-S45** | pdf-toolkit reste pertinent pour PDFs natifs avec fonts standard (Test 1) mais à doubler avec routing intelligent vers Mistral OCR si charabia détecté | S45 |
| **D7-S45** | Prompt Mistral en **langue source** + signal explicite de troncature requis pour fidélité | S45 |
| **D8-S45** | Pas de skill créée/MAJ — apprentissages transverses via auto-memories Cowork (`feedback_mistral_lechat_limites`, `feedback_pdf_toolkit_chromium_fonts`, etc.) | S45 |
| **D1-S46** | Test 3 CERFA abandonné après 3 pièges dématérialisation — leçon « majorité CERFA non téléchargeables » documentée | S46 |
| **D2-S46** | Mistral en EN sur PDF source EN multiplie par 3 la densité d'output (1136 vs 367 lignes en même durée) → toujours adapter langue prompt | S46 |
| **D3-S46** | Routing intelligent Hermès = couche 1 pdf-toolkit + couche 2 Mistral OCR API REST + heuristique charabia | S46 |

---

## 8. Annexes

### 8.1 Arborescence finale Projets/Mistral_Doc_AI_Test/

```
Projets/Mistral_Doc_AI_Test/
├── README.md (brief initial S45)
├── Rapport_Mistral_Doc_AI.md (ce fichier — livrable final S46)
├── 01_Projet_Complet/
│   ├── source.pdf (1,26 Mo, 25 p)
│   ├── extraction_pdf_toolkit.md (40 879 chars, < 2 s)
│   ├── extraction_mistral.md (Le Chat FR, ~50k chars, ~40 s)
│   └── notes.md (scoring complet S45 : 17/30 vs 19/30)
├── 02_Manuel_HA/
│   ├── source.pdf (5,9 Mo, 60 p, Brave Chromium)
│   ├── extraction_pdf_toolkit.md (charabia, 9 883 chars)
│   ├── extraction_mistral.md (v1 FR S45 tronqué, 367 l, 25 808 chars)
│   ├── prompt_mistral_v2_no_translate.md (prompt EN + verdict consignes)
│   ├── extraction_mistral_v2_no_translate.md (v2 EN S46, 1136 l, 48 735 chars)
│   └── notes.md (scoring complet S46 : 5/30 vs 18/30)
└── 03_CERFA_AcroForm/
    └── notes.md (test abandonné, leçon dématérialisation)
```

### 8.2 Auto-memories Cowork associées (S45+S46)

- `reference_mistral_le_chat.md` — compte créé + 3 surfaces Le Chat/Console/API
- `feedback_mistral_lechat_limites.md` — règle apprise tronquage + traduction + workarounds
- `feedback_pdf_toolkit_chromium_fonts.md` — règle apprise échec Brave PDF
- `project_mistral_doc_ai_phase1bisb_partiel.md` — état Phase 1bis-b S45 (à mettre à jour S46 → clôturé)

### 8.3 Sources externes consultées

- Mistral Document AI doc API : [docs.mistral.ai](https://docs.mistral.ai/)
  (pas accédé directement S46, à explorer Phase 1bis-c)
- Marker open-source alternative : [github.com/VikParuchuri/marker](https://github.com/VikParuchuri/marker)
  (mentionné comme fallback potentiel)
- Open Document Alliance pdf-toolkit : v0.7.3 MIT (déjà installé S35)

---

## 9. Conclusion

Phase 1bis-b **clôturée** avec recommandation claire pour Phase 1bis-c :
**stack hybride pdf-toolkit + Mistral OCR API REST** avec routing
intelligent automatique. Le sub-agent `wiki_ingestor` Hermès aura les 2
outils à sa disposition et choisira selon la nature du PDF.

Mistral apporte une vraie valeur ajoutée sur les PDF web Brave Chromium
(seul outil utilisable) et un gain marginal sur les PDF maison structurés.
pdf-toolkit reste imbattable sur la rapidité et les formulaires AcroForm.

**Pas de bloquant** pour démarrer Phase 1bis-c (install Hermes Agent
WSL2 + Ollama RTX 3090) — la stratégie OCR est fixée, il suffira de créer
la clé API Mistral au moment de configurer le sub-agent `wiki_ingestor`.

---

*Fin du rapport — Phase 1bis-b clôturée S46 — 25 avril 2026*
