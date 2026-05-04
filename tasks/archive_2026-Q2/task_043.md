---
id: 43
title: "Migrer l'envoi d'alertes HA de `notify"
status: done
priority: P3
session_opened: S22
session_closed: S24
tags: [gmail, email, mode-reactif]
source: "Session 22 / Evolution"
---

# T#43 — Migrer l'envoi d'alertes HA de `notify

## Description

**[Mode Reactif v1.1 — robustesse]** Migrer l'envoi d'alertes HA de `notify.email` SMTP natif (option A retenue Phase 0) vers une integration Gmail dediee (HACS, option B). Plus robuste et maintenu.

## Source / Échéance

Session 22 / Evolution

## Statut

**OBSOLETE (session 24, 21/04/2026)** — absorbé dans #39 : Mickael a directement adopté l'intégration native HA `google_mail` via OAuth (pas HACS). Service `notify.might57290_gmail_com` livré en Phase 1, plus de passage par SMTP natif. Plus rien à migrer.
