---
id: 44
title: "Verifier au prochain reboot du PC que Cowork demarre bien automatiquement ave..."
status: done
priority: P3
session_opened: S22
session_closed: S91
tags: [mode-reactif, cowork]
source: "Session 22 / Verification"
---

# T#44 — Verifier au prochain reboot du PC que Cowork demarre bien automatiquement ave...

## Description

**[Mode Reactif v1.1 — rodage]** Verifier au prochain reboot du PC que Cowork demarre bien automatiquement avec Windows. Si non : ajouter raccourci dans `shell:startup`.

## Source / Échéance

Session 22 / Verification

## Réalisation S91 (2026-05-03)

✅ **Vérifié et validé** par Mickael au retour de déplacement (Might-KT) :

- **Apps de démarrage Windows** (Gestionnaire des tâches → Applications de démarrage) : `Claude` (publisher Anthropic, PBC) → état **Activé**, niveau "Non mesuré".
- Confirmation visuelle screenshot S91.
- Combiné au paramètre Cowork "Maintenir l'ordinateur actif" ON (S83 — auto-memory `reference_cowork_parametres_avances.md`) + paramètres veille Windows désactivés (Mickael S91), le PC ne se met pas en veille et Cowork est relancé automatiquement après tout reboot Windows (Update, coupure courant, redémarrage manuel).

**Implication Mode Réactif v1.1** : les scheduled tasks nocturnes (`check-jarvis-alert` 04h00 + `tri-email-gmail-quotidien` 05h00 + `rapport-journalier-reactif` 23h30 + nouveau `Jarvis-HA-Logs-Archive-Quotidien` 02h00 créé S91) continueront à tourner sans intervention après reboot.

## Statut

✅ `done` (S91 — 2026-05-03)
