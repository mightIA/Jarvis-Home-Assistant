---
title: Skills Jarvis — Index
created: 2026-04-27
updated: 2026-05-02
tags: [moc, skill, index]
status: actif
domaine: Skills_Jarvis
---

# Skills Jarvis — MOC

Catalogue navigable des **30 skills** Jarvis (`.claude/skills/`). Les skills sont déclenchées automatiquement par leur `description` dans le frontmatter, selon le contexte conversationnel.

> **Important** : ce vault est un **index pointeur**, pas une copie. Le **détail exécutable** (procédures, commandes, fichiers de patterns, snippets YAML) reste dans `.claude/skills/<nom>/SKILL.md`. On ne duplique jamais le contenu — on documente seulement le « quand / pourquoi / dépendances ».

> Détail enrichi : `memory/SKILLS_INDEX.md` (description + frontmatter de chaque skill, tenu à jour S71+).

## Navigation par catégorie

| Catégorie | Skills | Atome |
|-----------|--------|-------|
| Tri & rédaction email | 4 | [[Email_Tri_Auto]] |
| Opérations Home Assistant | 11 | [[Home_Assistant_Operations]] |
| Mode Réactif | 2 | [[Mode_Reactif]] |
| Workflow & communication | 4 | [[Workflow_Communication]] |
| Setup & installation | 3 | [[Setup_Install]] |
| Hermès Agent | 1 | (skill `hermes-agent` dans `.claude/skills/`) |
| Sécurité / architecture (S72) | 2 | (à documenter) |
| Lifecycle tâches (S71) | 3 | (à documenter) |
| Wiki vault sub-agents (futur) | 0 (placeholder) | [[Wiki_Vault]] |

## Skills actuelles (vue à plat — 30 au 02/05/2026)

### Email (4)
| Nom | Trigger principal |
|-----|-------------------|
| `tri-email-gmail` | Cron 5h/14h + demande explicite |
| `tri-email-outlook` | Cron 5h/14h + demande explicite |
| `tri-email-outlook-priorites` | Demande explicite (interactif) |
| `redaction-email` | Demande de rédaction |

### Home Assistant Operations (11)
| Nom | Trigger principal |
|-----|-------------------|
| `ha-status` | Question d'état d'un appareil |
| `ha-scripts` | Demande d'exécution script HA |
| `chaudiere-frisquet` | Question chaudière / chauffage |
| `cameras-dahua` | Snapshot / record / PTZ |
| `dyson-purifier` | Question Dyson / qualité air |
| `debannissement-ip` | 2-3 erreurs 401/403 |
| `browser-mod` | Refresh Lovelace, popup HA |
| `home-assistant-best-practices` | Création/édition automation |
| `home-assistant-manager` | Gestion config HA via SSH/scp |
| `lovelace-edit` | Édition dashboard via callWS |
| `yaml-automation` | Demande "je voudrais une automation" |

### Mode Réactif (2)
| Nom | Trigger principal |
|-----|-------------------|
| `check-jarvis-alert` | Cron 30 min (Task Scheduler) |
| `rapport-journalier-reactif` | Cron 23h30 (Task Scheduler) |

### Workflow & communication (4)
| Nom | Trigger principal |
|-----|-------------------|
| `session-closure` | Fin de session importante |
| `traduction` | "traduis", "translate", "übersetze" |
| `decongestion-fichiers-vivants` | Début session + "ça rame" |
| `git-github-push` | Push repo Jarvis vers GitHub mightIA (S69) |

> **Note S84 (2026-05-02)** : `bascule-conversation` et `guidage-photo-etape`
> retirées (T#24 cancelled — obsolètes mode iPhone, mode PC permanent depuis S24).

### Setup & installation (3)
| Nom | Trigger principal |
|-----|-------------------|
| `install-claude-code-windows` | "claude n'est pas reconnu" |
| `ha-mcp-install` | Pairage MCP HA échoue |
| `cloudflare-access-ha` | Exposition HA derrière CF |

### Hermès Agent (1)
| Nom | Trigger principal |
|-----|-------------------|
| `hermes-agent` | "Hermes Agent", "Phase 1bis-c/d" |

### Sécurité / architecture — ajoutées S72 (2)
| Nom | Trigger principal |
|-----|-------------------|
| `hook-add-pattern` | Ajout d'un nouveau pattern de blocage au hook PreToolUse `check-secrets.sh` |
| `audit-architecture-jarvis` | Audit méta trimestriel ou signal "ça rame / on a dérivé" |

### Lifecycle tâches — ajoutées S71 (3)
| Nom | Trigger principal |
|-----|-------------------|
| `add-task` | "ajoute une tâche", "nouvelle tâche" |
| `close-task` | Clôture d'une tâche, archivage trimestriel |
| `regen-tasks-index` | "régénère l'index", "MAJ TASKS.md" |

## 