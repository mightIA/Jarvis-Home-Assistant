---
title: Mode Réactif — Décisions S31 (bascule CLI)
created: 2026-04-25
tags: [ha/mode-reactif, jarvis/cli, jarvis/securite]
status: actif
session: 31
---

# Mode Réactif — Décisions S31 (bascule CLI Option A)

## Contexte

Pipeline Phase 1 livré en S29 (scheduled task Cowork 15 min) → activé en
S31. À 22:42 du 22/04 : **boucle infinie détectée** — 3 mails test
retraités à chaque run.

**Cause racine** : `gmail-mcp-local` (stdio) est **inaccessible depuis
Cowork** (auto-memory `feedback_cowork_no_stdio`). Cowork ne charge que
les MCP HTTP/SSE, pas les MCP stdio. Conséquence : pas d'archivage Gmail
possible, donc retraitement permanent.

**Coût estimé** : scheduled 15 min Cowork avec system prompt ~30-50k
tokens/run = **1 500-3 000 $/mois** en tarif Opus. **Pipeline non
viable** en l'état.

## Décision

Bascule **Option A : CLI complet** pour `check-jarvis-alert`.
`rapport-journalier-reactif` reste sur Cowork (1 run/jour, coût marginal,
puis basculé CLI aussi en S32).

## Paramètres retenus (Q1-Q6 de la session 31)

| # | Question | Choix | Raison |
|---|---|---|---|
| Q1 | Cadence du check CLI | **30 min** (révisé à **04h00 1×/jour** en S32) | Heure creuse, préserve quota Max |
| Q2 | Rapport journalier | Cowork puis CLI S32 | Cohérence architecture totale CLI |
| Q3 | Mode headless | `settings.local.json` allowlist + denylist | Sûr, pattern validé S27 |
| Q4 | Label Gmail | **Hiérarchique `Jarvis-Alert/Traité`** | Visuel clair, jamais TRASH |
| Q5 | Règle expéditeur | **Strict `might57290@gmail.com`** (pas `+jarvis`, c'est le destinataire) | Anti-spoofing |
| Q6 | Fallback gmail-mcp-local | Abort propre + log + no-op HA | Évite incrément compteur sur run dégradé |

## Mitigation sécurité — script HA dédié

En plus de Q3, mitigation **moindre privilège** : la skill CLI
n'appelle **JAMAIS** `ha_call_service` en free-form. Elle passe
exclusivement par le script HA dédié `script.jarvis_reactif_log_alerte`
créé S31, qui prend les champs (`type`, `gravite`, `entite`,
`action_executee`, `increment_attente`) et effectue les 3 écritures
(counter / input_text / input_number) en interne avec validation des
champs.

**Blast radius limité** : même si la skill CLI dérape (bug ou injection
prompt), elle ne peut écrire que dans les 3 entités prévues — pas de
lights, pas d'automations, pas de serrures.

## Architecture finale (S31-S32, 100% CLI)

```
HA automation → notify.might57290_gmail_com (data.target obligatoire) → Gmail filter → label Jarvis-Alert
    ↓
Windows Task Scheduler 04h00 — tâche "Jarvis-CheckAlert"
    ↓
scripts/check-jarvis-alert-launcher.ps1 (pré-filtre credentials + claude -p headless)
    ↓
.claude/settings.local.json allowlist stricte + denylist (delete/send)
    ↓
skill check-jarvis-alert (9 étapes, outils mcp__gmail-mcp-local__*)
    ├── ha_get_state (kill switch + niveau + flags + compteurs) — SAFE
    ├── search_emails / read_email / modify_email — pas de TRASH
    ├── ha_call_service UNIQUEMENT sur script.jarvis_reactif_log_alerte
    └── Write/Edit sur memory/historique_reactif/ (allowlist pattern)
    ↓
Archivage label Jarvis-Alert/Traité (jamais TRASH) → pas de boucle

23h30 : rapport-journalier-reactif (CLI aussi depuis S32)
```

## Bug INBOX corrigé S32

`modify_email` ne retirait pas `INBOX` initialement → label posé mais
mail visible toujours dans INBOX. Patch skill étape 7 :
`removeLabelIds=["Jarvis-Alert", "INBOX"]`. 4 mails test nettoyés.

## Critère de validation V1

Après 2 runs auto consécutifs avec un mail test reçu entre-temps :
- `counter.jarvis_alertes_jour` incrémenté **exactement 1 fois** (pas de boucle)
- Mail passé de `Jarvis-Alert` à `Jarvis-Alert/Traité`
- 2ᵉ run renvoie `RAS` (plus aucun mail non traité)

✅ **Validé S32, 22:42-23:00** — Option A confirmée.

## Notes liées

- [[Mode Réactif - Vue d'ensemble]]
- [[Mode Réactif - Pipeline alertes]]
- Skill : `.claude/skills/check-jarvis-alert/`
- Auto-memory : `feedback_cowork_no_stdio`, `feedback_gmail_send_scope_absent`,
  `feedback_notify_gmail_target`, `feedback_claude_cli_validation_pattern`

---

*Source : `Ressources/Competences/Mode_Reactif.md` §11 + footer CLAUDE.md S31-S32.*
