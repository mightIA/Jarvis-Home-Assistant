---
title: Email — Hub
created: 2026-04-25
updated: 2026-04-25
tags: [moc, email, domaine/email]
status: actif
source_skills:
  - .claude/skills/tri-email-gmail/SKILL.md
  - .claude/skills/tri-email-outlook/SKILL.md
  - .claude/skills/tri-email-outlook-priorites/SKILL.md
  - .claude/skills/redaction-email/SKILL.md
source_ressources:
  - Ressources/Protocoles/Gmail.md
  - Ressources/Competences/Gmail_MCP_Custom.md
---

# Email — Hub central

Point d'entrée du domaine **Email** de Jarvis. Couvre les **4 boîtes** de
Mickael, le tri automatisé Gmail/Outlook, le serveur MCP Gmail custom local
et l'envoi via Home Assistant.

## Atomes du domaine

- [[Boites email]] — les 4 boîtes (might57290 Gmail stdio, mighthomeassistant, mickael.rubino, might@live.fr) et leur canal de tri.
- [[Tri Gmail automatise]] — pipeline CLI Windows Task Scheduler 5h + 14h, auto-apprentissage 3 JSON, pondération `CATEGORY_*`.
- [[Tri Outlook]] — 2 skills (automatisé + interactif par priorités), workflow Brave / Claude in Chrome.
- [[Gmail MCP custom]] — serveur stdio local GongRzhe/Gmail-MCP-Server, outils `mcp__gmail-mcp-local__*`, scope `gmail.send` absent.
- [[Envoi via Home Assistant]] — service `notify.might57290_gmail_com`, paramètre `data.target` obligatoire.
- [[Redaction email]] — skill `redaction-email` (ton adapté par destinataire) — en attente de refonte tâche #46.

## Workflow standard

Tri quotidien automatique :

1. **05h00 + 14h00** — Windows Task Scheduler lance `tri-gmail-launcher.ps1`.
2. Pré-filtre PowerShell : vérifie `credentials.json` (existence + âge < 6 j).
3. `claude -p` headless exécute la skill `tri-email-gmail` (CLI uniquement).
4. Scan `in:inbox -label:Jarvis-Alert -label:Jarvis-RapportTri` via MCP stdio.
5. Comparaison whitelist/blacklist + scores 0-100 + pondération `CATEGORY_*`.
6. Vidage Spam + suppression auto (≥ 90) via `batch_modify_emails` TRASH.
7. Rapport HTML envoyé via `ha_call_service notify.might57290_gmail_com`.
8. Filtre Gmail natif `Jarvis-RapportTri` archive automatiquement le rapport.
9. Logs JSON dans `memory/historique_tri_gmail/run_*.json`.

## Déclencheurs des skills

- « tri Gmail / tri email Gmail » → skill `tri-email-gmail` (CLI uniquement).
- « tri Outlook / vidage Outlook » → skill `tri-email-outlook` (auto).
- « tri Outlook par priorités » → skill `tri-email-outlook-priorites`
  (interactif, validation Mickael par recap numéroté).
- « rédige un mail / réponds à ... » → skill `redaction-email` (ton adapté
  au type de destinataire).

## Règles transverses

- **Jamais** `delete_email` ni `batch_delete_emails` (hard delete) — toujours
  passer par TRASH label. Outils en `deny` dans `.claude/settings.local.json`.
- **Jamais** toucher aux threads avec label `Jarvis-Alert` — réservés au Mode
  Réactif (skill `check-jarvis-alert`).
- **Toujours** nommer explicitement la boîte traitée (4 boîtes Mickael).
- **Toujours** respecter 50 messageIds max par `batch_modify_emails` (quota
  Gmail API 250 units/s).
- **Toujours** archiver (`removeLabelIds=["INBOX"]`) reçus de dons (Restos du
  Cœur, MSF) et factures pro (déductibles impôts).

## Règle 0 — Données sensibles

Boîtes mail = potentiellement sensibles (factures, RIB, identités, codes 2FA).
Avant tout accès en lecture massive ou en écriture (relabel, archive, TRASH),
appliquer la **Règle 0** `CLAUDE.md` section 0 : ARRÊT systématique, description
de ce qui serait vu, accord explicite requis. Exception : tri quotidien
automatique 5h + 14h (skill et allowlist déjà validées par Mickael).

## Mode d'exécution

- **Tri Gmail** : `claude -p` headless (Claude Code CLI uniquement). Cowork
  Desktop ne charge **PAS** les MCP stdio (auto-memory `feedback_cowork_no_stdio`).
- **Tri Outlook** : Cowork ou Claude.ai fallback via Brave + Claude in Chrome
  (pas de MCP Outlook officiel à ce jour, voir tâche #48).
- **Rédaction libre** : skill `redaction-email`, hors scope tri auto. Envoi
  technique via `notify.might57290_gmail_com`.

## Liens externes

- Protocole Gmail détaillé : `Ressources/Protocoles/Gmail.md` (v3.0 — S27)
- Stack technique Gmail MCP : `Ressources/Competences/Gmail_MCP_Custom.md`
- Patterns auto-apprentissage : `Ressources/Data/gmail_patterns/`
- Logs runs : `memory/historique_tri_gmail/`

---

*Hub créé S44 (25/04/2026). Convention atomique stricte D4-S42.*
