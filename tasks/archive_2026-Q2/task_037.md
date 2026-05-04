---
id: 37
title: "Configurer cote Gmail"
status: done
priority: P2
session_opened: S22
session_closed: S23
tags: [gmail, email, mode-reactif, tri-email]
source: "Session 22 / Phase 0"
---

# T#37 — Configurer cote Gmail

## Description

**[Mode Reactif v1.1 — Phase 0 finalisation]** Configurer cote Gmail : label `Jarvis-Alert` + filtre sur alias `might57290+jarvis@gmail.com` avec sujet `[JARVIS-ALERT]` -> appliquer label + marquer important + exclure du tri email quotidien. Procedure fournie par Jarvis session 22.

## Source / Échéance

Session 22 / Phase 0

## Statut

**FAIT (session 23, 21/04/2026)** — label `Jarvis-Alert` cree + filtre Gmail `to:(might57290+jarvis@gmail.com) subject:([JARVIS-ALERT])` avec actions `Appliquer Jarvis-Alert` + `Ne jamais envoyer dans Spam` + `Toujours marquer comme important`. Skill `tri-email-gmail` MAJ : etape 1 workflow ajoute `-label:Jarvis-Alert` a la query, et regle de securite "Ne jamais toucher aux threads avec label `Jarvis-Alert`" ajoutee. Operation via Claude in Chrome.
