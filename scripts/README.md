# Scripts Jarvis

Scripts utilitaires pour l'installation et la maintenance de l'environnement Claude Code / Jarvis.

## `install-claude-code.ps1`

Script PowerShell d'installation automatisee de Claude Code CLI sur Windows.

### Usage

**Option 1 — Clic droit** (le plus simple) :
1. Clic droit sur `install-claude-code.ps1`
2. Choisir **Executer avec PowerShell**

**Option 2 — Terminal PowerShell** :
```powershell
cd "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant"
.\scripts\install-claude-code.ps1
```

### Ce que fait le script

1. Detecte les outils presents (node, npm, git, python, claude)
2. Verifie l'ExecutionPolicy PowerShell (propose RemoteSigned si trop stricte)
3. Installe Claude Code CLI en mode natif via `install.ps1` si manquant
4. Ajoute automatiquement `C:\Users\<user>\.local\bin` au PATH utilisateur si necessaire
5. Guide pour installer Git et Python si manquants (ouvre les URL de download)
6. Affiche la checklist post-install (PATH, premier claude, MCP, OAuth)

### Ce que le script NE fait PAS

- N'installe PAS Node.js, Git, Python en mode silencieux (installateurs GUI obligatoires)
- Ne modifie PAS le dossier Jarvis (uniquement outils systeme + PATH utilisateur)
- Ne gere PAS la restauration depuis backup (voir `Ressources/Protocoles/Backup_Jarvis.md`)

### Apres un format Windows — procedure complete

1. Restaurer le dossier Jarvis depuis ton backup cloud (OneDrive, Google Drive, ou zip sur disque externe)
2. Copier-coller le dossier restauré vers `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant`
3. Lancer `install-claude-code.ps1` (il est dans le dossier Jarvis restauré)
4. Suivre la checklist affichée par le script
5. `cd` dans le dossier Jarvis, `claude --continue`, valider le flow OAuth DCR
6. Tester `statut de light.ampoule_chambre`

Temps estime total : **15-20 minutes** (incluant les downloads).

---

## `tri-gmail-launcher.ps1`

Pré-filtre + lanceur du tri email Gmail quotidien (Phase 5 Gmail MCP custom).

### Usage

Appelé automatiquement par Windows Task Scheduler (tâche `Jarvis-TriGmail-Quotidien`) à 5h et 14h. Peut aussi être lancé manuellement pour tester :

```powershell
cd "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant"
.\scripts\tri-gmail-launcher.ps1
```

### Ce que fait le script

1. Vérifie que `credentials.json` existe dans `C:\Users\Might\.gmail-mcp\`
2. Vérifie que le token n'est pas trop vieux (âge < 6 jours, marge OAuth Consent Testing 7j)
3. Crée le dossier `memory\historique_tri_gmail\` si absent
4. Lance `claude -p` headless avec le prompt du tri + `--output-format json`
5. Redirige stdout vers `memory\historique_tri_gmail\run_YYYY-MM-DD_HHMMSS.json`
6. Alerte Mickael via webhook HA `jarvis_gmail_token_alert` en cas de pré-filtre échec (webhook optionnel à créer côté HA)

### Exit codes

| Code | Signification |
|---|---|
| 0 | Tri réussi |
| 1 | Pré-filtre échoue (credentials manquants, token expiré, projet introuvable, claude absent) |
| 2 | `claude -p` a échoué |

### Référence

- Ressources/Protocoles/Gmail.md v3.0 (session 27)
- Ressources/Competences/Gmail_MCP_Custom.md
- .claude/settings.local.json (allowlist pour mode headless)

---

## `jarvis-cli.ps1` + `jarvis-cli.bat`

Lanceur rapide d'une **session interactive Claude Code CLI** dans le dossier Jarvis.

### Usage

**Option 1 — Double-clic** (le plus simple) :
- Double-clic sur `jarvis-cli.bat` → ouvre PowerShell + lance `claude` dans le bon dossier.

**Option 2 — Clic droit PowerShell** :
- Clic droit sur `jarvis-cli.ps1` → Exécuter avec PowerShell.

**Option 3 — Raccourci Bureau** :
- Clic droit sur `jarvis-cli.bat` → Créer un raccourci → glisse le raccourci sur le Bureau (ou épingle à la barre des tâches).

### Ce que fait le script

1. Vérifie que `claude` est dans le PATH (sinon erreur + pause).
2. Se place dans `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant`.
3. Lance `claude` en mode interactif (charge CLAUDE.md + skills + MCP `gmail-mcp-local` + `home-assistant`).

### Différence avec `tri-gmail-launcher.ps1`

- `jarvis-cli.*` = **session interactive** (tu dialogues avec Jarvis)
- `tri-gmail-launcher.ps1` = **session headless** (`claude -p` pour la tâche planifiée, pas d'interaction)

---

*References : `.claude/skills/install-claude-code-windows/SKILL.md`, `.claude/skills/tri-email-gmail/SKILL.md`*
