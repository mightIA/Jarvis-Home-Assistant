---
id: 57
title: "Valider le flux complet `fill_pdf` du MCP pdf-toolkit avec un PDF ayant de vr..."
status: pending
priority: P2
session_opened: S35
tags: [pdf, mcp, cowork]
source: "Session 35 / Demande Mickael"
blocks: [54]
---

# T#57 — Valider le flux complet `fill_pdf` du MCP pdf-toolkit avec un PDF ayant de vr...

## Description

**[NOUVELLE session 35 — test `fill_pdf` avec vrai AcroForm]** Valider le flux complet `fill_pdf` du MCP pdf-toolkit avec un PDF ayant de vrais champs AcroForm (contrairement au test S35 `Etat-des-lieux.pdf` qui était 100% statique — 0 form fields). **Étapes** : (1) Mickael trouve/télécharge un PDF AcroForm — **candidats recommandés** : CERFA 2042 (déclaration de revenus), CERFA 14011 (attestation d'hébergement), contrats DocuSign/Yousign archivés, ou n'importe quel PDF généré avec "Word → Enregistrer sous PDF avec champs" ; (2) upload dans la session Cowork ; (3) Jarvis copie uploads→workspace, lance `read_pdf_fields` pour lister les champs détectés, (4) remplissage test avec données **factices** (nom "Jean Test", adresse "1 rue de l'Exemple, 12345 Ville") via `fill_pdf` → nouveau PDF sauvegardé, (5) ouverture `display_pdf` pour vérification visuelle, (6) si OK → on valide le flux et on enchaîne avec #54 (création profils). **Bonus** : profiter du test pour documenter combien de tokens consomme un `fill_pdf` sur un gros formulaire 4-5 pages (base pour décider si on utilise `bulk_fill_from_csv` ou pas).

## Source / Échéance

Session 35 / Demande Mickael

## Statut

⏸️ `pending` (S83 — 01/05/2026) — double blocage observé :
1. **MCP `pdf-toolkit` non chargé** dans la session Cowork S83 (recherche de tools `read_pdf_fields` / `fill_pdf` / `display_pdf` négative). Vérifier toggle Cowork → Paramètres → Connecteurs.
2. **CERFA 13749-05 testé S83 = PDF statique** (0 AcroForm field, 1 page). Besoin d'un vrai AcroForm pour valider le flux : CERFA 14948 (Pôle Emploi), CERFA 2042 (déclaration revenus complète), DocuSign archivé, ou Word "Enregistrer en PDF avec champs".

À débloquer dans une future session une fois MCP réactivé + PDF AcroForm trouvé.
