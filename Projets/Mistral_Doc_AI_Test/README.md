---
title: Test Mistral Document AI vs pdf-toolkit
created: 2026-04-25
session: 45 (Phase 1bis-b)
status: en-cours
parent: TASKS.md #58 Phase 1bis-b
---

# Test Mistral Document AI vs pdf-toolkit

## Objectif

Comparer **Mistral Document AI** (gratuit, OCR + extraction structurée
+ description images annotées en JSON) à l'extraction **`pdf-toolkit`**
MCP déjà installé (Open Document Alliance v0.7.3, MIT, 21 outils).

Décider si Mistral mérite d'être intégré dans la stack Phase 1bis :

- **Phase 1bis-c** : sub-agent `wiki_ingestor` Hermès qui charge
  fichier brut → extraction propre Markdown vers `Wiki/RAW/`. Si
  Mistral fait mieux que `pdf-toolkit` sur certains cas, il devient
  l'outil de pré-traitement.
- **Cas d'usage immédiats** : extraction CERFA, manuels techniques,
  rapports tiers à indexer dans le vault.

## Les 3 PDF de test

| Sous-dossier | PDF | Caractéristiques | Cas représenté |
|---|---|---|---|
| `01_Projet_Complet/` | `Projet_Complet_v2.pdf` (25 p, 1,26 Mo) | Doc maison structuré + 8 schémas Graphviz/Matplotlib + page de garde + ToC + ToF + en-têtes/pieds | Doc bien formé connu |
| `02_Manuel_HA/` | À choisir avec Mickael | Doc tiers technique avec code blocks YAML, liens, peut-être tableaux | Texte + code |
| `03_CERFA_AcroForm/` | CERFA 2042 ou 14011 (service-public.fr) | Formulaire avec champs AcroForm, cases à cocher, structure rigide | Formulaire administratif |

## Critères de comparaison (6)

Pour chaque PDF, noter Mistral et pdf-toolkit sur :

| Critère | Description | Pondération |
|---|---|---|
| **1. Qualité du texte** | Caractères corrects, ligatures, accents, césures résolues | ⭐⭐⭐ |
| **2. Fidélité des tableaux** | Tableau Markdown propre, pas de cellules cassées | ⭐⭐⭐ |
| **3. Description des images** | Caption préservée, image décrite (alt-text) si schéma | ⭐⭐ |
| **4. Distracteurs résiduels** | En-têtes/pieds répétés, numéros de page, watermarks parasites | ⭐⭐ |
| **5. Durée traitement** | Temps wall-clock (drag drop → markdown) | ⭐ |
| **6. Simplicité workflow** | Nb d'étapes manuelles + sortie utilisable directement vs nettoyage | ⭐ |

Note de 1 à 5 par critère, total /30, recommandation finale :
**Mistral préféré / pdf-toolkit préféré / dépend du cas**.

## Arborescence

```
Projets/Mistral_Doc_AI_Test/
├── README.md (ce fichier)
├── 01_Projet_Complet/
│   ├── source.pdf
│   ├── extraction_mistral.md
│   ├── extraction_pdf_toolkit.md
│   └── notes.md (durée, observations qualitatives)
├── 02_Manuel_HA/
│   └── (idem)
├── 03_CERFA_AcroForm/
│   └── (idem)
└── Rapport_Mistral_Doc_AI.md (livrable final)
```

## Workflow de la session

1. ✅ Création arborescence + README (cette tâche)
2. ✅ Copie `Projet_Complet_v2.pdf`
3. ⏳ Création compte Mistral sur [console.mistral.ai](https://console.mistral.ai/)
4. ⏳ Découverte UI Mistral : voie d'extraction la + simple (chat web vs Document AI dédié vs API)
5. ⏳ Téléchargement manuel HA + CERFA
6. ⏳ Extraction Mistral des 3 PDF (par Mickael, drag drop)
7. ⏳ Extraction `pdf-toolkit` des 3 PDF (par Jarvis via `read_pdf_content`)
8. ⏳ Tableau comparatif + recommandation finale dans `Rapport_Mistral_Doc_AI.md`
9. ⏳ Patches vivants TASKS / METRIQUES / CLAUDE / MEMORY

## Règle 0 appliquée

- **Pas de clé API Mistral manipulée** dans cette session si possible —
  voie chat web préférée (option 1 AskUserQuestion S45).
- Si clé API requise pour Document AI : Jarvis demandera accord
  explicite avant tout usage.
- Les 3 PDF de test ne contiennent pas de données sensibles
  personnelles (Projet_Complet est public, manuel HA est tiers public,
  CERFA téléchargé sera vide, **PAS rempli**).

## Sortie attendue

Rapport `Rapport_Mistral_Doc_AI.md` avec :

- Tableau scoring 3 PDF × 6 critères × 2 outils
- Verdict par cas d'usage (doc structuré / texte+code / formulaire)
- Recommandation pour Phase 1bis-c (sub-agent `wiki_ingestor`)
- Plan d'intégration si Mistral retenu (clé API, MCP custom, ou drag-drop manuel)
