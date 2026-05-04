---
title: Jarvis — Index détaillé des skills
last_update: 2026-05-04 (S98 — +1 skill benchmark-modele-hermes)
version: 1.4
parent: ../CLAUDE.md
---

# SKILLS_INDEX — Détail des skills Jarvis

> Ce fichier complète CLAUDE.md (référence courte uniquement). Il n'est **pas** chargé automatiquement à chaque tour, donc pas de coût tokens récurrent.
>
> **Rappel** : les skills sont stockées dans `.claude/skills/<nom>/SKILL.md` et déclenchées automatiquement par Cowork/Claude Code selon leur description. Cet index sert de mémo descriptif pour humains.

## Skills disponibles (32 au total — S98)

### Sécurité / architecture (ajoutées S72)

- `hook-add-pattern` — Procédure 5 étapes pour ajouter un nouveau pattern de blocage au hook PreToolUse `.claude/hooks/check-secrets.sh` quand un nouveau secret apparaît (nouveau service, nouveau MCP, nouveau provider IA). Identifier regex → ajouter clause `if` → tester cas passant + cas bloquant → MAJ doc → vérif session suivante. Voir `memory/reference_hooks_securite_p2.md`.
- `audit-architecture-jarvis` — Audit architecture complet (méta) à déclencher trimestriellement ou sur signal Mickael (« ça rame », « on a dérivé »). 5 phases : lecture post `claude-code-from-source` (ch01/11/12/15) → cartographie état actuel → recherche pratiques communautaires → diagnostic 5 axes (mémoire/skills/sub-agents/hooks/MCP) → plan de remédiation chiffré P1/P2/P3/P4. Première application S72 (28/04/2026).

### Skills opérationnelles (existantes pré-S72)

- `tri-email-gmail` — tri quotidien de might57290@gmail.com (**refondue S27 Phase 5** : outils natifs `mcp__gmail-mcp-local__*` CRUD complet, CLI uniquement — Cowork ne charge pas stdio, rapport via service HA `notify.might57290_gmail_com` + filtre Gmail auto-label `Jarvis-RapportTri`, batch 50 messageIds, pondération CATEGORY_*)
- `tri-email-outlook` — tri quotidien automatise de might@live.fr (whitelist/blacklist/scores + rapport auto-envoye)
- `tri-email-outlook-priorites` — tri interactif Outlook via Brave avec 4 dossiers `Urgent/Perso/Info/À supprimer` (**creee session 28** ; Mickael valide par lot avec recap numerote ; complement du `tri-email-outlook` automatise)
- `ha-status` — statut des appareils Home Assistant
- `ha-scripts` — execution de scripts HA (snapshots cameras, etc.)
- `chaudiere-frisquet` — pilotage de la chaudiere Frisquet
- `cameras-dahua` — gestion des cameras (snapshots, records, PTZ)
- `dyson-purifier` — controle du Dyson (vitesse, angles, capteurs)
- `debannissement-ip` — procedure de suppression d'un ban IP HA
- `browser-mod` — controle du navigateur via Browser Mod
- `session-closure` — proposer la regen des fichiers en fin de session
- `redaction-email` — redaction d'emails avec adaptation du ton
- `yaml-automation` — generation d'automations YAML pour HA
- `lovelace-edit` — edition Lovelace via hass.callWS
- `install-claude-code-windows` — procedure installation Claude Code (Windows)
- `ha-mcp-install` — install add-on `homeassistant-ai/ha-mcp` (FastMCP+DCR) pour contourner bug mcp_server core HA (cree session 15 ; Phase 3 expo HTTPS publique reecrite et VALIDEE session 16)
- `home-assistant-best-practices` — bonnes pratiques HA (automations, dashboards, templates)
- `home-assistant-manager` — gestionnaire HA communautaire (komal-SkyNET)
- `cloudflare-access-ha` — config Cloudflare complete (SSL/TLS + HSTS + Access dashboard + bypass MCP) pour proteger une instance HA
- `traduction` — traduction FR/EN/DE (toutes directions) avec 4 modes : Professionnel, Accessible, Technique (glossaire), Personnel (style de Mickael appris)
- `check-jarvis-alert` — Mode Reactif v1.1 (session 22) : pipeline de traitement des alertes `[JARVIS-ALERT]` recues par email (label Gmail Jarvis-Alert), lit le niveau d'autonomie depuis HA (`input_select.jarvis_niveau_autonomie`), applique l'action, logge dans `memory/historique_reactif/`. A declencher toutes les 15 min par scheduled task a activer en Phase 1
- `rapport-journalier-reactif` — Mode Reactif v1.1 (session 22) : PDF quotidien des alertes traitees, envoi mail 23h30 a might57290@gmail.com, archive local + OneDrive. Reference : `Ressources/Competences/Mode_Reactif.md`
- `decongestion-fichiers-vivants` — Auto-déclenchée en début de session ou sur signalement Mickael (« ça rame », « ça coûte cher en tokens »). Mesure CLAUDE.md/TASKS.md/METRIQUES.md/MEMORY.md, applique seuils Vert/Jaune/Orange/Rouge, propose décongestion structurée (backup → archive trimestrielle `memory/historique/<scope>_archive_YYYY-Qn.md` → refonte → vérif refs → patches index → mesure). Pattern « pointer, don't embed » (S49→S52, ~57 K tokens cumulés libérés sur 3 fichiers). Auto-memory `feedback_decongestion_seuils.md`
- `git-github-push` — Procédure complète push repo Git Jarvis vers GitHub mightIA (créée S69 27/04/2026 après push initial réussi). Couvre création repo + push initial + push standard + 4 pré-flight checks (locks orphelins sandbox bash Cowork, user.email noreply, working tree clean, scan secrets) + 5 pièges S69 documentés (P1 `.git/index.lock` orphelin, P2 GH007 email privé, P3 cache index autocrlf, P4 auto-link Cowork chat corrompt blocs PS, P5 hashes filter-branch). Compte ref `mightIA` + noreply `278813549+mightIA@users.noreply.github.com`. Templates `.ps1` réutilisables. Auto-memory `feedback_git_sandbox_cowork_bloque.md` + `feedback_cowork_chat_markdown_pscode.md` + `reference_git_jarvis_repo.md`

### Skills lifecycle tâches (créées S71, 28/04/2026)

- `add-task` — Création d'une nouvelle tâche `tasks/task_NNN.md` : auto-incrémentation ID (max + 1, pad 3) + frontmatter YAML auto + relance `regen-tasks-index` derrière. Script `.claude/skills/add-task/scripts/add_task.py`. Déclenchement : *« ajoute une tâche »*, *« nouvelle tâche »*.
- `close-task` — Clôture d'une tâche : MAJ frontmatter `status: done` (ou `cancelled`) + `session_closed: SXX` + `git mv tasks/task_NNN.md tasks/archive_2026-Q2/` + relance `regen-tasks-index`. Préserve l'historique Git via `git mv`. Append-only sur les IDs (T#88 reste `task_088.md` à vie).
- `regen-tasks-index` — Régénère l'index `TASKS.md` à partir des frontmatters YAML de `tasks/*.md` (ouvertes) + `tasks/archive_2026-Q2/*.md` (clôturées). Tri par priorité (P0→P3) puis statut (in_progress → open → testing → pending → deferred → done → cancelled). Backup auto `TASKS.md.previous`. Compatible Obsidian Dataview. Script `.claude/skills/regen-tasks-index/scripts/rebuild_tasks_index.py`. Déclenchement : *« régénère l'index »*, *« rebuild tasks »*, *« MAJ TASKS.md »*.

### Hermès Agent (existante pré-S71)

- `hermes-agent` — Documentation / pilotage de l'agent local Hermès Agent (RTX 3090, modèles Ollama qwen3.5:27b post-update). Cookbook publié S64 dans repo public `mightIA/hermes-agent-rtx3090-cookbook`. Voir `memory/reference_cookbook_hermes_repo.md` + `Projets/Cookbook_Hermes_RTX3090/`.

### Maintenance / archives (créées S87, mai 2026)

- `ha-logs-archive` — Archive mensuelle des logs Home Assistant (3 sources MCP `ha_get_logs` : `error_log` brut + `system` ERROR/WARNING + `logbook`) dans `Archives/ha_logs/AAAA-MM/` + consolidation `.md` lisible (top erreurs / bans IP / reboots / extraits stack traces). Trigger : manuel (« archive les logs HA », avant formatage) + scheduled task Windows mensuelle (1er du mois 02h00) + rotation annuelle 1er janvier via helper `scripts/rotate_annual.py` (zip + vérif + purge mensuels). Logs jamais commit Git (Archives/* exclu .gitignore). Vérification fichier-par-fichier prévue post-stabilisation modèle. T#34.

---

## Conventions skills

- **Localisation** : `.claude/skills/<nom>/SKILL.md` (+ scripts éventuels dans `scripts/`).
- **Frontmatter SKILL.md obligatoire** : `name`, `description` (les deux servent au déclenchement automatique).
- **Cowork ne charge PAS les skills nécessitant des MCP stdio** (ex. Gmail-MCP-Local) → ces skills sont CLI-only, pattern brain (Cowork) / hands (Claude Code CLI) obligatoire.
- **Création nouvelle skill** : utiliser la skill `anthropic-skills:skill-creator` ou copier le template d'une skill existante.

*Index créé S71 lors de la décongestion CLAUDE.md (mode conservateur, déplacement §5 → fichier dédié pour économiser ~6.5 KB de réinjection à chaque tour). Complété S74 (28/04/2026) : ajout des 4 skills manquantes (`add-task`, `close-task`, `regen-tasks-index`, `hermes-agent`) suite à audit structure. Maj S84 (02/05/2026) : suppression `guidage-photo-etape` + `bascule-conversation` (obsolètes depuis mode PC permanent S24, T#24 cancelled). Maj S87 (02/05/2026) : ajout `ha-logs-archive` (T#34, archives mensuelles logs HA + rotation annuelle).*
