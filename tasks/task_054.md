---
id: 54
title: "Créer les profils réutilisables du MCP `pdf-toolkit` pour accélérer le rempli..."
status: pending
priority: P2
session_opened: S35
tags: [email, pdf, mcp]
source: "Session 35 / Demande Mickael"
blocked_by: [57]
---

# T#54 — Créer les profils réutilisables du MCP `pdf-toolkit` pour accélérer le rempli...

## Description

**[NOUVELLE session 35 — profils PDF Tools]** Créer les profils réutilisables du MCP `pdf-toolkit` pour accélérer le remplissage de formulaires admin (location, impôts, attestations, contrats). **Prérequis** : (1) avoir au moins un PDF AcroForm sous la main pour valider le flux (tâche #57 optionnellement avant), (2) vérifier où `pdf-toolkit` stocke ses profils (fichier local Windows, possiblement `%APPDATA%\pdf-toolkit\profiles.json` ou similaire — à investiguer au 1er `save_profile`), (3) définir avec Mickael si les profils doivent être backupés (OneDrive ? Git privé ?). **Profils à créer** : (A) **"Perso Mickael"** — nom, prénom, date de naissance, adresse postale Seremange-Erzange, téléphone, email(s), IBAN (si confort avec stockage) ; (B) **"Pro"** éventuel si Mickael a un contexte pro à part (SIRET, raison sociale, adresse pro). **Règle 0 appliquée** : les champs les plus sensibles (RIB/NIR/passeport) saisis par Mickael lui-même dans un éditeur texte, pas par Jarvis. Je m'occupe des champs non-sensibles. **Workflow** : (1) créer profil vide, (2) Mickael ajoute IBAN/RIB dans un bloc-notes, copie-colle, sauvegarde, (3) Jarvis complète les champs "safe" (nom/adresse/tel), (4) test avec 1 PDF AcroForm. **Livrables** : profils créés côté PC Mickael + documentation dans `Ressources/Competences/PDF_Tools_MCP.md` (nouveau) + stratégie backup décidée.

## Source / Échéance

Session 35 / Demande Mickael

## Statut

⏸️ `pending` (S83 — bloquée par T#57 test AcroForm)
