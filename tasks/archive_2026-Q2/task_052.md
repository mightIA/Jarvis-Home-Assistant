---
id: 52
title: "Mettre en place un tri automatique à **04h15** (15 min après `Jarvis-CheckAle..."
status: cancelled
priority: P2
session_opened: S31
session_closed: S83
tags: [gmail, outlook, email, mcp, brave, tri-email]
source: "Session 31 / Tri multi-boîtes 4h"
---

# T#52 — Mettre en place un tri automatique à **04h15** (15 min après `Jarvis-CheckAle...

## Description

**[NOUVELLE session 31 fin de nuit — tri priorités multi-boîtes auto 4h15]** Mettre en place un tri automatique à **04h15** (15 min après `Jarvis-CheckAlert`) qui trie les 4 boîtes email de Mickael avec les labels **Urgent / Perso / Info / À supprimer** (pattern S28 `tri-email-outlook-priorites` mais automatisé). **Décisions Mickael S31 (Q1-Q4)** : (Q1) 4 boîtes à traiter = `might57290@gmail.com` + `mighthomeassistant@gmail.com` + `mickael.rubino@gmail.com` + `might@live.fr` ; (Q2) fusion — un seul tri qui fait **labels priorités + suppression auto spams** évidents ; (Q3) règles de tri laissées à mon appréciation, on ajustera ; **ne rien supprimer** — tout mail "À supprimer" reste taggé en attente de validation Mickael ; (Q4) tri auto sans validation humaine accepté. **Plan en phases** : (a) installer 2 MCPs Gmail supplémentaires (GongRzhe Gmail MCP × 2 avec 2 Clients OAuth GCP distincts dans projet `Jarvis HA` ou projet dédié) pour `mighthomeassistant` et `mickael.rubino` — setup ~30 min/boîte (voir pattern S25) ; (b) pré-créer les labels `Urgent` + `Perso` + `Info` + `À supprimer` sur les 3 boîtes Gmail (might57290 a peut-être déjà ses labels IA — à vérifier et harmoniser) ; (c) refondre skill `tri-email-gmail` (ou créer skill dédiée `tri-email-priorites-multi`) pour gérer les 3 boîtes Gmail avec whitelist/blacklist par catégorie + logique fusion ; (d) créer `scripts/tri-priorites-launcher.ps1` modèle S27 + `scripts/jarvis-tripriorites.xml` Task Scheduler cadence 04h15 ; (e) dry-run + V1 sur 1 boîte puis extension. **Outlook `might@live.fr`** : reste **manuel via Brave** (skill `tri-email-outlook-priorites` S28) tant que tâche #48 (MCP Outlook Microsoft Graph API) pas faite. Intégrer plus tard quand #48 livrée. **Contraintes sécu** : (i) credentials OAuth de chaque boîte séparés + ACL NTFS ; (ii) règle 0 appliquée à chaque boîte (pas d'accès aux mots de passe/tokens dans les mails) ; (iii) denylist delete/send/draft pour les 3 boîtes Gmail. **Durée estimée** : ~3h total sur session PC dédiée (setup MCPs 1h + refonte skill 1h + scheduler+tests 1h).

## Source / Échéance

Session 31 / Tri multi-boîtes 4h

## Statut

❌ `cancelled` S83 (01/05/2026) — décision Mickael « on vire, on verra si ça bug ». Charge ~3h estimée (2 MCPs Gmail + skill + scheduler) jugée trop lourde sans besoin éprouvé. Workflow actuel (skills manuelles tri-email-gmail + tri-email-outlook + tri par vagues T#18) suffit. Si un jour le volume devient ingérable manuellement, ré-ouvrir une nouvelle tâche avec scope réduit (1 boîte d'abord).
