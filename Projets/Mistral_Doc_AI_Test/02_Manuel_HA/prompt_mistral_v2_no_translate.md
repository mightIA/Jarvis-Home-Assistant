---
created: 2026-04-25
session: 46 (Phase 1bis-b clôture)
target: chat.mistral.ai (modèle "Équilibré")
input_pdf: 02_Manuel_HA/source.pdf (60 p, 5,9 Mo, Brave PDF natif)
goal: relance test 2 avec consigne anti-traduction explicite + signal troncature
status: prompt utilisé S46 — résultat dans extraction_mistral_v2_no_translate.md
---

# Prompt v2 anti-traduction pour relance Mistral Le Chat

## Pourquoi ce prompt

S45 test 2 a échoué sur 2 axes :

1. **Mistral a TRADUIT** la doc EN → FR (`Attribut de données | Requis |
   Description` au lieu des colonnes anglaises) malgré consigne FR explicite.
2. **Output tronqué** au milieu d'un code block YAML sans signal de coupure
   ni `\`\`\`` fermant — limite ~25k chars FR atteinte (~30-40 % du PDF).

Ce prompt v2 :

- Est **en anglais** (force Mistral à raisonner en EN, langue source)
- Demande explicitement **DO NOT TRANSLATE** (mot-clé fort)
- Demande un **signal de troncature** explicite si limite atteinte
- Précise le **format de sortie** souhaité (markdown standard, pas
  d'échappement)

## Procédure (à exécuter par Mickael)

1. Ouvrir [chat.mistral.ai](https://chat.mistral.ai/) (compte Google OAuth S45)
2. **Nouvelle conversation** (ne pas réutiliser le thread S45 pollué)
3. Modèle "Équilibré" sélectionné
4. Glisser `02_Manuel_HA/source.pdf` dans la zone d'upload (5,9 Mo, ~30 s)
5. Coller le **prompt EN ci-dessous** (bloc de code)
6. Attendre génération (S45 : 3 min 4 s pour 367 lignes — possiblement plus
   long si génération EN plus complète)
7. **Copier l'output complet** (Cmd+A puis Ctrl+C dans la zone de réponse,
   PAS le bouton "Copy" qui rajoute des artefacts d'échappement S45)
8. Coller dans `02_Manuel_HA/extraction_mistral_v2_no_translate.md` (créer
   le fichier, je le lirai ensuite)
9. Me dire "v2 ok" ou "v2 tronqué à X lignes" pour que je process

## Le prompt à copier

```
Extract the full content of this PDF as a clean Markdown document.

CRITICAL RULES:
1. DO NOT TRANSLATE — keep the source language (English) exactly as it
   appears in the PDF. Do not translate column headers, field labels,
   YAML keys, code comments, or any other text. Preserve all English
   technical terms (data attribute, required, supported, etc.).
2. Preserve the original structure: H1 / H2 / H3 headings using # / ## / ###.
3. Preserve all tables as Markdown tables with | separators.
4. Preserve all code blocks with ``` fences and language tags (yaml, jinja, etc.).
5. Preserve bullet lists with - or * markers.
6. Filter out repeating page headers and footers (do not include them
   in the output).
7. For images, insert a placeholder line: [IMAGE: <caption or short
   description>].

OUTPUT REQUIREMENTS:
- Write standard Markdown (no escaping of special characters like
  \#, \*, \-, \|, \[).
- If you reach a length limit and cannot finish, end your response with
  the exact line:
  [OUTPUT TRUNCATED AT PAGE N — RESUME REQUIRED]
  where N is the last page number you fully processed. This is critical
  so we know where to resume.
- If you finish the full PDF, end with:
  [END OF DOCUMENT — N PAGES PROCESSED]

Begin extraction now.
```

## Mesures observées (S46)

- **Durée upload** : non chronométré séparément (~30-60 s estimé pour 5,9 Mo)
- **Durée génération** : 3-4 min (vs 3 min 4 s v1 S45 tronquée)
- **Lignes obtenues** : 1136 (vs 367 v1 = 3,1× plus dense)
- **Caractères** : 48 735 chars (vs 25 808 v1 = 1,9× plus dense)
- **Langue de sortie** : EN ✅ (DO NOT TRANSLATE respecté)
- **Troncature** : non — `[END OF DOCUMENT — 100 PAGES PROCESSED]` en fin
- **Échappement markdown** : absent ✅ (pas de `\#`, `\*\*`, `\-`, `\|`)

## Verdict consignes appliquées

- ✅ Règle 1 (DO NOT TRANSLATE) → respectée totalement
- ⚠️ Règle 2 (hiérarchie # / ## / ###) → **PAS appliquée** (titres en texte plat)
- ⚠️ Règle 3 (tables avec |) → **PAS appliquée** (cellules applaties en lignes individuelles)
- ⚠️ Règle 4 (code blocks avec ``` fences) → **PAS appliquée** (juste un label "YAML"/"JSON" avant les lignes de code)
- ✅ Règle 5 (bullet lists) → respectée
- ✅ Règle 6 (filtre en-têtes/pieds) → respectée
- ✅ Règle 7 ([IMAGE: ...]) → respectée (au moins 1 placeholder vu)
- ✅ Sortie standard Markdown sans échappement → respectée
- ✅ Marker fin explicite → respecté `[END OF DOCUMENT — 100 PAGES PROCESSED]`

## Hypothèses confirmées / infirmées

| Hypothèse pré-test | Résultat S46 |
|---|---|
| Si Mistral respecte "DO NOT TRANSLATE" → critère 1 remonte à 4-5/5 | ✅ Confirmé (4/5) |
| Si Mistral signale la troncature explicitement → workflow chunking automatisable | ✅ Confirmé (marker fin présent) |
| Si Mistral traduit malgré tout → confirme limitation forte Le Chat | Infirmé pour ce cas (EN tient) |

## Conclusion test 2 v2

Mistral en EN sur PDF web Chromium = **succès net mais structure imparfaite**.
Hierarchy + tables + fences code à reconstruire en post-traitement (regex
side-car) ou via API REST `/v1/ocr` Phase 1bis-c qui devrait mieux respecter
les consignes structurelles (à valider).

**pdf-toolkit reste totalement échoué** sur ce cas (charabia ToUnicode
brisé), donc Mistral est l'**unique solution** pour cette catégorie de PDF.
