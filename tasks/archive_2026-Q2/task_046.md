---
id: 46
title: "Refonte skill redaction-email post-Gmail MCP custom"
status: done
priority: P2
session_opened: S25
session_closed: S78
tags: [gmail, email, redaction-email, mcp]
source: "Session 25-27 / Gmail MCP custom"
---

# T#46 — Refonte skill redaction-email post-Gmail MCP custom

## Description

**[Refonte skill redaction-email post-Gmail MCP custom]** La skill `redaction-email` doit être mise à jour pour refléter que :

(a) `send_email` et `draft_email` retournent 403 (scope `gmail.send` / `gmail.compose` absents du Client OAuth `Gmail MCP` GCP) ;

(b) l'envoi effectif passe par le service HA `notify.might57290_gmail_com` (ou un service dédié si destinataire dynamique) ;

(c) la rédaction libre (réponse fournisseur, mail SAV, mail technique) reste possible mais le bouton "Envoyer" doit déclencher `ha_call_service` notify.might57290_gmail_com avec data.target obligatoire (auto-memory `feedback_gmail_send_scope_absent` S27/S32).

## Source / Échéance

Session 25-27 / Gmail MCP custom

## Statut

Fait S78 (29/04/2026, option A validée par Mickael — auto-envoi via `notify.might57290_gmail_com`, tiers via Brave) :

- **Skill `.claude/skills/redaction-email/SKILL.md`** réécrite (84 → 118 lignes) :
  - Section "⚠ Contraintes OAuth Gmail" explicite les 403 sur `send_email`/`draft_email`.
  - Tableau "Méthode préférée" distingue Auto-envoi (notify HA) / Tiers Gmail / Tiers Outlook.
  - Procédures auto-envoi (YAML `notify` + `data.target` obligatoire) et tiers (brouillon → screenshot → validation → Brave) séparées.
  - Pièges connus enrichis (403, `data.target`, HTML non validé sur intégration `google_mail`).
  - Formule fermeture Impôts harmonisée sur version longue ("Je vous prie d'agréer...").

- **`Ressources/Competences/Gestion_Emails.md`** (168 → 192 lignes) :
  - Phase 4 refondue en 4.1 (auto-envoi notify HA) + 4.2 (envoi tiers — 2 voies : MCP `create_draft` ou Brave manuel).
  - Section "LIMITATIONS ACTUELLES" mise à jour (Gmail MCP partiel, Outlook = Brave, T#48 référencée).

- **Sub-agent `redacteur-email`** (CLI-only) déjà mentionné dans le frontmatter — pas de modif corps (option A validée S78).

## Note migration

⚠ Ligne source tronquée dans TASKS.md.bak (442 chars seulement, fin de ligne coupée). Reconstitution faite à partir du contexte (auto-memory `feedback_gmail_send_scope_absent`, MEMORY.md, footer Hub Email S44). Refonte S78 alignée sur le brief original (a)+(b)+(c).
