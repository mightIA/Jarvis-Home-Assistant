# Backup PC Migration — Inventaire des configs hors-projet

> **Version 1.0 — S108 (04/05/2026).**
> Source : analyse session S108 demandée par Mickael en anticipation du BoM v4 S101 (3 662 €).
> Tâche associée : [T#96](../../tasks/task_096.md).

## Pourquoi ce protocole

Beaucoup de configurations critiques pour faire fonctionner Jarvis (Claude Code CLI, Hermès Agent, Cowork desktop, scripts auto Mode Réactif) vivent **en dehors** du repo Git du projet Jarvis. Si Mickael change de PC sans backup explicite, ces configs sont perdues et il faut tout reconfigurer manuellement.

Ce document fige l'inventaire complet de ce qui doit être sauvegardé, par catégorie de criticité.

## Légende criticité

- 🔴 **Critique** : perte = re-config manuelle longue + risque de perdre des secrets
- 🟡 **Important** : re-installable mais coût en temps significatif
- 🟢 **Faible** : re-téléchargeable / re-générable trivialement

---

## 3 catégories de configs

| Catégorie | Persistance Git ? | Backup nécessaire ? |
|---|---|---|
| **A. Le projet Jarvis** (skills, tâches, docs, scripts) | Oui (repo Git) | Push GitHub à jour |
| **B. Configs *globales* utilisateur Windows** (Claude CLI, Hermès, Ollama, npm, env vars, Task Scheduler) | **Non** — vivent ailleurs sur le PC | **Oui — backup manuel critique** |
| **C. État runtime** (caches Cowork, sessions Claude, modèles Ollama téléchargés, blobs) | Non | Re-téléchargeable / re-générable, pas critique |

La **catégorie B** est celle qui brûlerait Mickael si elle disparaissait. C'est le périmètre principal du script de backup à développer en T#96.

---

## Inventaire détaillé — Catégorie B

### B.1 — Claude Code CLI

| Chemin Windows | Contenu | Criticité |
|---|---|---|
| `C:\Users\Might\.claude\settings.json` | Config user (plugins HA, statusLine ccusage, autoUpdatesChannel, skipDangerousModePermissionPrompt) | 🔴 |
| `C:\Users\Might\.claude\plugins\` | Plugins Claude Code installés (homeassistant-config@claude-homeassistant-plugins, etc.) | 🟡 |
| `C:\Users\Might\.claude\settings.local.json` (si existant) | Permissions locales spécifiques projet ou user | 🟡 |
| `C:\Users\Might\.claude\` (autres fichiers) | Caches/auth tokens éventuels Claude Code | 🟡 |
| Liste npm globaux | `npm list -g --depth=0 > backup_npm.txt` (ccusage 18.0.11 + autres) | 🔴 |

**Restauration** :
1. Copier `~/.claude/` complet sur le nouveau PC
2. Réinstaller npm globaux : `npm install -g <chaque package listé>`
3. Vérifier `claude --version` puis ouvrir une session interactive pour valider la status bar ccusage

### B.2 — Hermès Agent (sandbox WSL2 Ubuntu)

| Chemin (WSL2 Ubuntu) | Contenu | Criticité |
|---|---|---|
| `/home/agent/.hermes/config.yaml` | Provider OpenRouter, modèles, MCP HA URL+headers Service Token CF Access en clair (perms 600), params auxiliaires | 🔴 |
| `/home/agent/.hermes/` complet | Tout l'état Hermès (logs, état compaction, etc.) | 🟡 |
| Modelfiles Ollama custom (qwen35-agent, etc.) | Export via `ollama show <model> --modelfile > <model>.modelfile` | 🔴 |
| Liste modèles Ollama installés | `ollama list > backup_ollama.txt` | 🟡 |
| `~/.ollama/models/` blobs | ~50-200 Go cumulés selon modèles | 🟢 |

**Cas particulier** — la sandbox WSL2 s'appelle `agent` (différent du compte `might`). Voir auto-memory `reference_hermes_sandbox_isolation.md`. Accès depuis PowerShell hôte via `\\wsl$\Ubuntu\home\agent\.hermes\` ou `wsl -d Ubuntu -- cat /home/agent/.hermes/config.yaml`.

**Restauration** :
1. Réinstaller WSL2 + Ubuntu sur nouveau PC
2. Suivre la procédure d'install Hermès (cf. `Ressources/Competences/Home_Assistant.md` et le repo `mightIA/hermes-agent-rtx3090-cookbook`)
3. Copier `~/.hermes/config.yaml` sauvegardé (vérifier les chemins absolus s'ils ont changé)
4. Réinstaller Ollama, re-pull les modèles listés dans `backup_ollama.txt`
5. Recréer les Modelfiles custom : `ollama create qwen35-agent -f qwen35-agent.modelfile`
6. Test fonctionnel S63 Test A / B / C (cf. `memory/reference_protocole_tests_modeles_hermes.md`)

### B.3 — Variables d'environnement utilisateur Windows

| Variable | Contenu | Criticité |
|---|---|---|
| `CF_ACCESS_CLIENT_ID` | Service Token CF Access Niveau 1 (T#60 résolu S102) | 🔴 |
| `CF_ACCESS_CLIENT_SECRET` | Idem | 🔴 |
| `MISTRAL_API_KEY` (si présente) | Cf. T#71 archivée S70 | 🟡 |
| `OPENROUTER_API_KEY` (si présente) | Clé Hermes-Jarvis cap $5/mois | 🔴 |

**Backup** :
```powershell
Get-ChildItem Env: | Where-Object {
    $_.Name -match '^(CF_ACCESS|MISTRAL|OPENROUTER|GITHUB|HA_|JARVIS)'
} | ForEach-Object { "$($_.Name)=$($_.Value)" } | Out-File backup_env.txt -Encoding UTF8
```

**Restauration** : injecter via PowerShell `[Environment]::SetEnvironmentVariable("...", "...", "User")` pour chaque variable, ou via Panneau de configuration → Variables d'environnement.

⚠️ **Le fichier `backup_env.txt` contient des secrets en clair** — perms 600 équivalent Windows (clic droit → Propriétés → Sécurité), à transférer par canal sécurisé (clé USB chiffrée, jamais email/cloud public).

### B.4 — Task Scheduler Windows (scripts auto Mode Réactif)

| Tâche | Rôle | Heure |
|---|---|---|
| `check-jarvis-alert` | Mode Réactif Phase 1 — check alertes HA | 04h00 |
| `rapport-journalier-reactif` | Mode Réactif Phase 1 — rapport quotidien | 23h30 |
| `tri-gmail-launcher` | Tri Gmail auto via Gmail MCP custom CLI | 05h00 |
| `tri-email-outlook-quotidien` (Cowork side) | Tri Outlook (until upgrade post-PC domo, cf. project_tri_outlook_cowork_report_pc_domotique) | Quotidien |
| `ha-logs-archive` (T#34 S100) | Archive logs HA mensuelle | 1er du mois |

**Backup** :
```powershell
$tasksDir = "D:\Might\IA\Backups_PC\backup_$(Get-Date -Format 'yyyyMMdd')\TaskScheduler"
New-Item -ItemType Directory -Path $tasksDir -Force | Out-Null
foreach ($task in @('check-jarvis-alert','rapport-journalier-reactif','tri-gmail-launcher','tri-email-outlook-quotidien','ha-logs-archive')) {
    schtasks /query /xml ONE /tn $task > "$tasksDir\$task.xml"
}
```

**Restauration** : sur le nouveau PC, `schtasks /create /xml <fichier>.xml /tn <nom>`.

⚠️ Vérifier les chemins absolus `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\` dans les commandes des tâches — si la lettre du disque change ou le path change, ajuster.

### B.5 — Le projet Jarvis lui-même (catégorie A, pas B mais à mentionner)

🚨 **Trou critique observé S108** : le repo Jarvis a énormément de modifs/untracked non committées (~150 fichiers vus dans `git status`). Si Mickael change de PC sans push, **tout disparaît**. Inclut :

- Toutes les modifs récentes des `tasks/*.md` (dont la clôture T#78 et la création T#96)
- Les 9+ nouvelles skills (close-task, regen-tasks-index, ha-logs-archive, audit-architecture-jarvis, benchmark-modele-hermes, hook-add-pattern, add-task, etc.)
- Le sub-agent dossier `.claude/agents/`
- Le hook `check-secrets.sh`
- Toute l'auto-memory récente (~30 nouveaux fichiers `memory/*.md`)
- Les ADR Wiki `Wiki/10_Domaines/ADR/accepted/ADR-A004-vault-connaissance-pure.md`
- Tous les protocoles ajoutés (dont **ce fichier**)

**Action obligatoire avant migration** : push GitHub via la skill `git-github-push` (procédure documentée S69 avec 5 pièges connus, capitalisée dans `feedback_5_pieges_push_github.md`).

### B.6 — Cowork desktop (catégorie B partielle)

| Chemin | Contenu | Criticité |
|---|---|---|
| `C:\Users\Might\AppData\Roaming\Claude\local-agent-mode-sessions\<session-id>\.mcp.json` | Config MCP Cowork (URLs, auth headers, plugins) | 🔴 |
| Settings Cowork (toggles Capacités, plugins activés, marketplaces) | UI Cowork | 🟡 |
| Sessions historiques Cowork (chats locaux) | Stockage local | 🟢 (probablement aussi côté serveur claude.ai) |

**Cas particulier** — le path `<session-id>` change à chaque session Cowork. Le script doit détecter le path actif via `Get-ChildItem` filtré par date de modif récente.

---

## Plan du script `backup-pc-migration.ps1` (T#96)

Le script à développer en T#96 doit produire un dossier daté `D:\Might\IA\Backups_PC\backup_YYYYMMDD\` avec la structure suivante :

```
backup_YYYYMMDD/
├── ClaudeCLI/
│   ├── .claude/                    (copie complète Copy-Item -Recurse)
│   └── npm-globaux.txt
├── Hermes/
│   ├── config.yaml                 (depuis WSL2 \\wsl$\Ubuntu\home\agent\.hermes\)
│   ├── modelfiles/
│   │   ├── qwen35-agent.modelfile
│   │   └── (autres modèles custom)
│   └── ollama-list.txt
├── EnvVars/
│   └── backup_env.txt              (perms 600 équivalent)
├── TaskScheduler/
│   ├── check-jarvis-alert.xml
│   ├── rapport-journalier-reactif.xml
│   ├── tri-gmail-launcher.xml
│   ├── tri-email-outlook-quotidien.xml
│   └── ha-logs-archive.xml
├── Cowork/
│   └── mcp.json                    (depuis session Cowork active)
└── README.md                       (rapport généré : date, machine source, taille, hash SHA256 par fichier critique)
```

**Hors scope** (Mickael S108) :
- ❌ Récurrence automatique via Task Scheduler — exécution manuelle uniquement
- ❌ Backup du projet Jarvis lui-même — déjà censé être en Git (push GitHub à faire avant migration)
- ❌ Backup des modèles Ollama (blobs `~/.ollama/models/`) — ~200 Go, plus économique de re-pull

**Fonctionnalités prévues** :
- Dry-run mode (`-WhatIf` PowerShell) pour valider sans écrire
- Vérification post-backup des hash SHA256 (intégrité)
- Rapport `README.md` auto-généré dans le dossier daté
- Résistance aux secrets : aucun secret loggé en console, redirections fichier uniquement

---

## Procédure de restauration sur nouveau PC

À développer en T#96 livrable 3. Plan grossier :

1. **Pré-requis nouveau PC** : Windows 11 installé, WSL2 + Ubuntu installé, Node.js + Ollama installés, Git installé, Cowork desktop installé.
2. **Cloner le repo Jarvis** : `git clone git@github.com:mightIA/Jarvis-Home-Assistant.git "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant"`.
3. **Copier `~/.claude/`** depuis le backup vers `C:\Users\<user>\.claude\`.
4. **Réinstaller npm globaux** : pour chaque ligne de `npm-globaux.txt`, lancer `npm install -g <package>`.
5. **Réinjecter variables env** : pour chaque ligne de `backup_env.txt`, `[Environment]::SetEnvironmentVariable("KEY", "VALUE", "User")`.
6. **Restaurer Hermès** : suivre cookbook RTX3090 + copier `config.yaml` + recréer Modelfiles custom + re-pull modèles Ollama listés.
7. **Restaurer Task Scheduler** : pour chaque XML, `schtasks /create /xml <fichier>.xml /tn <nom>`. Vérifier les paths dans les commandes.
8. **Restaurer Cowork `.mcp.json`** : copier dans le path `<session-id>` actif (à identifier).
9. **Tests fonctionnels** :
   - Lancer `claude` interactif → vérifier statusLine ccusage
   - Lancer un appel MCP HA depuis Cowork → vérifier connecteur Jarvis HA OK
   - Lancer `hermes` + Test S63 A → vérifier provider OpenRouter + MCP HA
   - Lancer manuellement chaque tâche Task Scheduler → vérifier output

---

## Liens

- Tâche associée : [T#96](../../tasks/task_096.md)
- BoM v4 S101 : [`Projets/Hardware_Upgrade/10_BoM_v4_S101_validee_pour_commande.md`](../../Projets/Hardware_Upgrade/10_BoM_v4_S101_validee_pour_commande.md)
- Service Token CF Access (T#60 S102) : [`memory/project_t60_cf_service_token_s100.md`](../../memory/project_t60_cf_service_token_s100.md)
- Hermès cookbook public : `github.com/mightIA/hermes-agent-rtx3090-cookbook`
- Skill push GitHub : `.claude/skills/git-github-push/SKILL.md`
- Auto-memory 5 pièges push : `memory/feedback_5_pieges_push_github.md`

---

*Protocole créé S108 (04/05/2026). Prochaine MAJ attendue : après dev script T#96 (avant migration PC).*
