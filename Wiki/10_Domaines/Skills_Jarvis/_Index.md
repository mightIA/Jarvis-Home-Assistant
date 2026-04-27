---
title: Skills Jarvis — Index
created: 2026-04-27
tags: [moc, skill, index]
status: actif
domaine: Skills_Jarvis
---

# Skills Jarvis — MOC

Catalogue navigable des **27 skills** Jarvis (`.claude/skills/`). Les skills sont déclenchées automatiquement par leur `description` dans le frontmatter, selon le contexte conversationnel.

> **Important** : ce vault est un **index pointeur**, pas une copie. Le **détail exécutable** (procédures, commandes, fichiers de patterns, snippets YAML) reste dans `.claude/skills/<nom>/SKILL.md`. On ne duplique jamais le contenu — on documente seulement le « quand / pourquoi / dépendances ».

## Navigation par catégorie

| Catégorie | Skills | Atome |
|-----------|--------|-------|
| Tri & rédaction email | 4 | [[Email_Tri_Auto]] |
| Opérations Home Assistant | 11 | [[Home_Assistant_Operations]] |
| Mode Réactif | 2 | [[Mode_Reactif]] |
| Workflow & communication | 5 | [[Workflow_Communication]] |
| Setup & installation | 3 | [[Setup_Install]] |
| Hermès Agent (1) | 1 | voir [[Wiki/10_Domaines/Hermes_Agent/_Index]] |
| Wiki vault sub-agents (futur) | 0 (placeholder) | [[Wiki_Vault]] |

## Skills actuelles (vue à plat)

| Nom | Catégorie | Trigger principal |
|-----|-----------|-------------------|
| `tri-email-gmail` | Email | Cron 5h/14h + demande explicite |
| `tri-email-outlook` | Email | Cron 5h/14h + demande explicite |
| `tri-email-outlook-priorites` | Email | Demande explicite (interactif) |
| `redaction-email` | Email | Demande de rédaction |
| `ha-status` | HA Operations | Question d'état d'un appareil |
| `ha-scripts` | HA Operations | Demande d'exécution script HA |
| `chaudiere-frisquet` | HA Operations | Question chaudière / chauffage |
| `cameras-dahua` | HA Operations | Snapshot / record / PTZ |
| `dyson-purifier` | HA Operations | Question Dyson / qualité air |
| `debannissement-ip` | HA Operations | 2-3 erreurs 401/403 |
| `browser-mod` | HA Operations | Refresh Lovelace, popup HA |
| `home-assistant-best-practices` | HA Operations | Création/édition automation |
| `home-assistant-manager` | HA Operations | Gestion config HA via SSH/scp |
| `lovelace-edit` | HA Operations | Édition dashboard via callWS |
| `yaml-automation` | HA Operations | Demande "je voudrais une automation" |
| `check-jarvis-alert` | Mode Réactif | Cron 30 min (Task Scheduler) |
| `rapport-journalier-reactif` | Mode Réactif | Cron 23h30 (Task Scheduler) |
| `bascule-conversation` | Workflow | Limite images / "bascule" |
| `guidage-photo-etape` | Workflow | Capture d'écran reçue |
| `session-closure` | Workflow | Fin de session importante |
| `traduction` | Workflow | "traduis", "translate", "übersetze" |
| `decongestion-fichiers-vivants` | Workflow | Début session + "ça rame" |
| `install-claude-code-windows` | Setup | "claude n'est pas reconnu" |
| `ha-mcp-install` | Setup | Pairage MCP HA échoue |
| `cloudflare-access-ha` | Setup | Exposition HA derrière CF |
| `hermes-agent` | Hermès Agent | "Hermes Agent", "Phase 1bis-c/d" |

## Convention de lecture

Pour chaque skill, l'atome catégorie indique :

- **Déclencheur** : ce qui fait charger la skill (mots-clés, événements, cron)
- **Dépendances** : MCP requis, fichiers de patterns, scheduled tasks, autres skills
- **Détail exécutable** : pointeur vers `.claude/skills/<nom>/SKILL.md`
- **Liens vault** : ressources connexes (`[[Wiki/10_Domaines/...]]`)

## Pattern d'évolution

Toute nouvelle skill créée dans `.claude/skills/` doit :

1. Être ajoutée à l'atome catégorie correspondant (ou créer une nouvelle catégorie + atome).
2. Apparaître dans la table « Skills actuelles » ci-dessus.
3. Conserver le frontmatter `name` + `description` clair (premier paragraphe = trigger).

## Voir aussi

- `CLAUDE.md` § 5 — liste de référence des skills disponibles
- `.claude/skills/` — sources exécutables
- [[Wiki/10_Domaines/Email/_Index]] — domaine email
- [[Wiki/10_Domaines/Hermes_Agent/_Index]] — domaine Hermès Agent
