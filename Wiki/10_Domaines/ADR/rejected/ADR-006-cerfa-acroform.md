---
title: ADR-006 — CERFA AcroForm pour test pdf-toolkit
created: 2026-04-27
tags: [adr, rejected, pdf, cerfa, mistral]
status: rejected
session_origine: S46
---

# ADR-006 — Utiliser un CERFA AcroForm `service-public.fr` comme cas de test pour pdf-toolkit + Mistral Document AI

## Contexte

Phase 1bis-b Mistral Document AI (S45-S46) : comparer la qualité d'extraction de `pdf-toolkit` (lecture passive de champs AcroForm) vs Mistral Document AI (OCR + structuration). Test 3 prévu sur un CERFA AcroForm officiel pour valider la chaîne `read_pdf_fields` + `fill_pdf` côté pdf-toolkit, et l'OCR + JSON côté Mistral. Le CERFA était considéré comme l'archétype du formulaire officiel téléchargeable.

## Décision

**REJETÉE** le 25/04/2026 (S46).

## Raison du rejet

3 pièges dématérialisation successifs rencontrés en cherchant un CERFA téléchargeable sur `service-public.fr` :

| # | URL tentée | Réalité | Diagnostic |
|---|---|---|---|
| 1 | `vosdroits/R39697` | Lettre type web (modèle attestation hébergement) | Pas un CERFA, formulaire interactif HTML |
| 2 | `vosdroits/F2191` (CERFA 10798) | Attestation d'accueil | Délivrée en mairie après dépôt, pas téléchargeable |
| 3 | `vosdroits/F1359` (CERFA 15646*01) | Autorisation sortie territoire | Bouton de téléchargement absent (re-piège) |

Mention pour mémoire : CERFA 15776*02 (cession véhicule) abandonné dès l'AskUserQuestion (100% portail ANTS depuis 2017).

**Leçon structurante** : la majorité des CERFA `service-public.fr` ne sont **plus téléchargeables**. La procédure est 100% en ligne via portails dédiés (ANTS, impots.gouv.fr, FranceConnect, Ameli, MSA, CAF). Le PDF papier a été retiré, on est redirigé vers une démarche web qui génère un récépissé/attestation en sortie. Le sub-agent `wiki_ingestor` doit anticiper qu'un "CERFA téléchargeable" est devenu l'exception, pas la règle.

## Impact

- **Test 3 Phase 1bis-b abandonné** documenté ; rapport final livré sur 2 tests valides au lieu de 3 (pas de blocage).
- **Règle `fill_pdf` ne marche que sur PDF AcroForm** capitalisée (auto-memory `feedback_pdf_statique_vs_acroform.md`) — toujours `read_pdf_fields` AVANT `fill_pdf`.
- **Candidats viables** identifiés pour test différé : CERFA 13406*15 (permis de construire, encore téléchargeable au 25/04/2026), CERFA 2042 (déclaration revenus, AcroForm complexe), ou tout PDF DocuSign/Yousign tiers.

## Alternative retenue

Stack hybride **pdf-toolkit + Mistral OCR API REST** recommandée pour Phase 1bis-c (rapport `Projets/Mistral_Doc_AI_Test/Rapport_Mistral_Doc_AI.md` section 9). Test AcroForm reporté à un PDF DocuSign/Yousign tiers que Mickael aura sous la main.

## Source

- `memory/historique/2026-04-25_session_46_phase1bisb_cloture.md`
- `Projets/Mistral_Doc_AI_Test/Rapport_Mistral_Doc_AI.md` (section 4 + leçon dématérialisation)
- Auto-memory `feedback_pdf_statique_vs_acroform.md`
