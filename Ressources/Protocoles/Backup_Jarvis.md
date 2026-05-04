# Protocole — Backup et restauration du dossier Jarvis

## Contexte

Le dossier `D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant` contient **tout le capital du projet** :
- Instructions (`CLAUDE.md`, `CONTEXTE.md`)
- Tâches et métriques (`TASKS.md`, `METRIQUES.md`)
- Skills (`.claude/skills/`)
- Mémoire persistante (`memory/`)
- Ressources (protocoles, compétences, identité)
- Scripts (`scripts/`)
- Config MCP (`.mcp.json`)

**En cas de formatage PC ou de perte du drive D:** — si aucun backup, ce capital est perdu.
La réinstallation de Claude Code CLI ne prend que 10-15 min (voir skill `install-claude-code-windows`), mais reconstituer le dossier Jarvis à la main = impossible.

---

## Ce qui doit être sauvegardé

### ✅ À INCLURE dans le backup

Tout le contenu du dossier `D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant`, y compris :
- Tous les `.md`
- `.claude/skills/` entier
- `.claude/settings.json` (config Claude Code, non sensible)
- `.claude/hooks/`
- `.claude/jarvis-config.json`
- `.mcp.json` (secret path dans l'URL ha-mcp — sensibilité modérée, voir note ci-dessous)
- `memory/` entier
- `Ressources/`
- `Archives/`
- `outputs/`
- `scripts/`

### ❌ À EXCLURE du backup versionné (git, partage)

Ces fichiers contiennent des secrets qui ne doivent pas quitter le PC sans précaution :
- `.claude/settings.local.json` — tokens HA (LLAT), credentials Gmail, secrets divers
- Tokens OAuth stockés par Claude Code CLI (généralement dans `C:\Users\<user>\.claude\...`, hors du dossier Jarvis)

### ⚠️ Sensibilité modérée

- `.mcp.json` contient l'URL ha-mcp avec le secret path `/private_<secret>`. Ce n'est pas un mot de passe fort (juste un bypass CF), mais à protéger quand même. Pour un backup personnel (OneDrive / disque externe chiffré), OK. Pour un backup public (git public), interdit.

---

## Option A — OneDrive sync automatique (recommandée — le plus simple)

### Principe
Déplacer (ou sync-er) le dossier Jarvis vers un sous-dossier OneDrive. OneDrive gère le versioning (30 jours) et la sync continue.

### Setup

1. **Créer un dossier dédié dans OneDrive** :
   `C:\Users\Might\OneDrive\Jarvis-Backup`

2. **Option A1 — Copier tout le dossier dans OneDrive** (déplacement pur) :
   ```powershell
   $src = "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"
   $dst = "$env:USERPROFILE\OneDrive\Jarvis-Backup\Jarvis - Home Assistant"
   Copy-Item -Path $src -Destination $dst -Recurse -Exclude ".claude\settings.local.json"
   ```
   Ensuite tu travailles directement depuis OneDrive. La sync est instantanée.

3. **Option A2 — Sync miroir périodique** (garder le dossier original sur D: et copier dans OneDrive) :
   Créer une tâche planifiée Windows qui exécute toutes les X heures :
   ```powershell
   robocopy "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant" `
            "$env:USERPROFILE\OneDrive\Jarvis-Backup\Jarvis - Home Assistant" `
            /MIR /XF "settings.local.json"
   ```

### Restauration post-format

1. Se reconnecter au compte OneDrive sur le nouveau Windows
2. Attendre la sync du dossier `Jarvis-Backup`
3. Copier le contenu vers `D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant`
4. Recréer `.claude/settings.local.json` à partir du template `.template` (valeurs à re-saisir)
5. Lancer `scripts\install-claude-code.ps1`

### Avantages / Inconvénients

| ✅ Avantages | ⚠️ Inconvénients |
|-------------|-----------------|
| Transparent (sync auto) | Dépend du compte OneDrive |
| Historique 30 jours | Quota OneDrive (5 Go gratuit, 1 To avec Microsoft 365) |
| Accessible depuis autres PC | Sync peut être en retard si gros fichiers modifiés |

---

## Option B — Disque externe via tâche planifiée Windows

### Principe
Robocopy hebdomadaire vers disque externe USB/NAS. Mickaël reste maître des données (pas de cloud).

### Setup

1. **Créer un dossier cible sur le disque externe** :
   `E:\Backup\Jarvis\` (adapter la lettre selon ton disque)

2. **Créer le script `scripts\backup-jarvis.ps1`** (à créer séparément si souhaité) :
   ```powershell
   $src = "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"
   $dst = "E:\Backup\Jarvis\Jarvis - Home Assistant"
   $log = "E:\Backup\Jarvis\backup-$(Get-Date -Format 'yyyy-MM-dd').log"

   # /MIR = miroir, /XF = exclure fichiers, /LOG = journal
   robocopy $src $dst /MIR /XF "settings.local.json" /LOG:$log /TEE
   ```

3. **Planifier via Task Scheduler** :
   - Ouvrir `taskschd.msc`
   - Créer une tâche → Déclencheur : chaque dimanche à 22h00
   - Action : `PowerShell.exe -File "D:\...\scripts\backup-jarvis.ps1"`

### Restauration post-format

1. Brancher le disque externe
2. Copier `E:\Backup\Jarvis\Jarvis - Home Assistant` vers `D:\Documents\IA\Projets Cowork\`
3. Recréer `.claude/settings.local.json`
4. Lancer `scripts\install-claude-code.ps1`

### Avantages / Inconvénients

| ✅ Avantages | ⚠️ Inconvénients |
|-------------|-----------------|
| Données sous contrôle total | Dépend d'un disque externe branché |
| Pas de quota | Fréquence limitée (hebdo recommandée) |
| Restauration ultra-rapide | Perte possible entre 2 backups |

---

## Option C — Git privé (GitHub/GitLab)

### Principe
Versionner le dossier avec Git et pousser vers un repo **PRIVÉ** sur GitHub ou GitLab.

### Setup

1. **Créer un repo privé** sur github.com ou gitlab.com (nommé `jarvis-home-assistant-backup` par exemple)

2. **Initialiser Git dans le dossier Jarvis** :
   ```powershell
   cd "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"
   git init
   git branch -M main
   ```

3. **Créer `.gitignore` à la racine du dossier Jarvis** :
   ```gitignore
   # Secrets
   .claude/settings.local.json

   # Fichiers temporaires
   *.log
   *.tmp
   .DS_Store
   Thumbs.db

   # Outputs jetables (optionnel)
   outputs/*.tmp.md
   ```

4. **Premier commit et push** :
   ```powershell
   git add .
   git commit -m "Backup initial Jarvis - session 17 (2026-04-20)"
   git remote add origin git@github.com:<ton-user>/jarvis-home-assistant-backup.git
   git push -u origin main
   ```

5. **Commits réguliers** (idéalement après chaque session Jarvis) :
   ```powershell
   git add .
   git commit -m "Session NN - <titre court>"
   git push
   ```

### Restauration post-format

1. Installer Git sur le nouveau Windows (via `install-claude-code.ps1`)
2. Cloner le repo :
   ```powershell
   cd "D:\Documents\IA\Projets Cowork"
   git clone git@github.com:<ton-user>/jarvis-home-assistant-backup.git "Jarvis - Home Assistant"
   ```
3. Recréer `.claude/settings.local.json` (pas versionné)
4. Lancer `scripts\install-claude-code.ps1`

### Avantages / Inconvénients

| ✅ Avantages | ⚠️ Inconvénients |
|-------------|-----------------|
| Versioning fin (diff par commit) | Complexité Git (pour power users) |
| Restauration atomique (une commande) | Nécessite config SSH ou token GitHub |
| Historique infini | Engagement à commiter régulièrement |
| Possibilité de collaborer | Secrets à surveiller (`.gitignore` obligatoire) |

---

## Recommandation pour Mickaël

**Combinaison Option A + Option C** :

1. **OneDrive** en sync continue (filet de sécurité quotidien, pas d'effort)
2. **Git privé GitHub** en versioning manuel à chaque session importante (traçabilité, rollback possible)

L'option B (disque externe) reste intéressante comme 3e couche si tu veux une vraie règle 3-2-1 :
- 3 copies : dossier de travail (D:), OneDrive, disque externe
- 2 supports différents : SSD interne, cloud
- 1 hors site : disque externe chez un proche ou au bureau

---

## Fréquence recommandée

| Option | Sync auto | Backup manuel | Restauration |
|--------|-----------|---------------|--------------|
| OneDrive | Continu | — | ~10 min |
| Disque externe | — | Hebdo (dimanche 22h auto) | ~5 min |
| Git privé | — | À chaque session importante | ~5 min |

---

## Tester la restauration (exercice recommandé 1x / trimestre)

1. Créer un dossier test `D:\Test-Restauration\`
2. Restaurer depuis le backup vers ce dossier test
3. Vérifier :
   - Nombre de fichiers cohérent
   - `CLAUDE.md` lisible
   - `memory/historique/` contient toutes les sessions
   - `.mcp.json` présent
4. Supprimer le dossier test

Si la restauration échoue, le backup n'en est pas un.

---

*Protocole créé session 17 (2026-04-20) — à réviser si changement de setup backup.*
