---
name: Hook PreToolUse check-secrets — Renfort Règle 0 + actions destructives
description: Hook PreToolUse exit 2 qui bloque l'accès aux secrets (S72) ET les actions destructives (S108, T#66 R2). 10 règles cumulées, garde-fou technique non bypassable par injection de prompt.
type: reference
session_origine: 72
session_extension: 108
date: 2026-04-28
date_extension: 2026-05-04
applies_to: [".claude/settings.json", ".claude/hooks/check-secrets.sh", "CLAUDE.md §0", "CLAUDE.md §4"]
tags: [securite, hooks, regle-zero, donnees-sensibles, destructive-actions, p2]
---

# Hook PreToolUse check-secrets — Renfort technique de la Règle 0

## Contexte

CLAUDE.md §0 « Règle prioritaire — Données sensibles » repose, jusqu'à S72,
**uniquement sur le prompt**. Le post `claude-code-from-source` chapitre 12
documente le pattern Hook PreToolUse + exit 2 comme garde-fou technique
non bypassable par injection de prompt.

Ce hook a été installé en phase P2 de l'audit architecture S72 (28/04/2026).

## Architecture

| Composant | Rôle |
|---|---|
| `.claude/settings.json` | Déclare le hook PreToolUse avec `matcher: "Read\|Edit\|Write\|MultiEdit\|NotebookEdit\|Bash"` |
| `.claude/hooks/check-secrets.sh` | Script bash 304 lignes (S72: 178 + S108: +126 pour R8/R9/R10), lit JSON via stdin, parse via `jq`, exit 2 si match pattern sensible OU destructif |
| `${CLAUDE_PROJECT_DIR}` | Variable d'env injectée par Claude Code/Cowork pour résoudre le path absolu du script |

## Patterns interceptés (10 règles cumulées — S72 + S108)

### Règle 0 — Données sensibles (S72, R1→R7)

1. **Credentials OAuth Gmail** : `**/.gmail-mcp/credentials.json`,
   `**/.gmail-mcp/gcp-oauth.keys.json` → BLOQUÉ tous outils.
2. **Variables d'environnement** : `**/.env*`, `**/.env.local` → BLOQUÉ
   tous outils. Couvre OPENROUTER_API_KEY, MISTRAL_API_KEY, etc.
3. **Secrets HA** : `**/secrets.yaml`, `**/secrets.json` → BLOQUÉ
   tous outils.
4. **Clés SSH privées** : `**/.ssh/id_*`, `**/.ssh/*_rsa`,
   `**/.ssh/*_ed25519`, `**/.ssh/*_ecdsa` → BLOQUÉ. Exception : `*.pub`
   autorisés.
5. **Permissions Cowork** : `**/.claude/settings.local.json` → BLOQUÉ
   tous outils.
6. **`.mcp.json`** : Read AUTORISÉ (sinon Cowork ne charge pas les MCP),
   Edit/Write/MultiEdit BLOQUÉS (rotation secret_path doit passer par la
   procédure documentée).
7. **Patterns secrets dans Bash args** : `sk-or-v1-[A-Za-z0-9]{32,}`
   (OpenRouter), `Bearer ya29\.[A-Za-z0-9_-]{10,}` (Google), `private_[A-Za-z0-9]{16,}`
   (ha-mcp), `AKIA[0-9A-Z]{16}` (AWS), `ghp_[A-Za-z0-9]{36}` (GitHub).

### Règle CLAUDE.md §4 — Actions destructives (S108, R8→R10, T#66 R2)

8. **Suppressions Bash dangereuses** : `rm -rf/-r/-f/--recursive/--force`,
   `Remove-Item -Recurse|-Force`, `del /s|/q|/f`, `unlink` → BLOQUÉ.
   Formalise « JAMAIS supprimer sans validation explicite ».
9. **Commandes Git destructives** : `git reset --hard`,
   `git clean -f/-fd/-fdx`, `git push --force/-f/--force-with-lease`,
   `git branch -D`, `git checkout -- .`, `git stash drop|clear` → BLOQUÉ.
   Protection work tree + historique distant.
10. **Commandes système destructives** : `Format-Volume`, `diskpart`,
    `mkfs.*`, `fdisk`, `format A:`, `Stop-Computer`, `Restart-Computer`,
    `shutdown /s|/r|-h|-r`, `wsl --unregister|-u`, `ollama rm`,
    `npm uninstall -g|--global`, `docker system prune|volume rm|rm -f`
    → BLOQUÉ. Protection environnement Hermès/Ollama/ccusage.

## Tests de validation (S72 + S108)

### S72 — 14/14 cas Règle 0

- **5 cas passants (exit 0)** : Read CLAUDE.md, Edit TASKS.md, Read .mcp.json,
  Bash `ls -la`, Read clé SSH `.pub`.
- **9 cas bloquants (exit 2)** : Read credentials Gmail, Read gcp-oauth keys,
  Edit .env Hermès, Write secrets.yaml HA, Read clé SSH privée, Read
  settings.local.json, Edit .mcp.json, Bash avec OpenRouter/ha-mcp/GitHub
  token.

### S108 — 8/8 cas R8/R9/R10 + non-régression (T#66 R2)

Test environnement : WSL2 Ubuntu Noble 24.04, jq 1.7.1.

- **3 cas passants (exit 0)** : `rm fichier.txt`, `git status`, `wsl --shutdown`.
- **5 cas bloquants (exit 2)** : `rm -rf /tmp/test`, `git clean -fd`,
  `wsl --unregister Ubuntu`, Read credentials Gmail (R1 non-régression),
  Bash `export X=sk-or-v1-...` (R7 non-régression).

Reproduire les tests :

```bash
echo '{"tool_name":"Read","tool_input":{"file_path":"/x/credentials.json"}}' \
  | bash .claude/hooks/check-secrets.sh
echo "Exit code : $?"  # attendu : 2
```

## Comportement attendu côté Claude

Quand un hook retourne exit 2 :

1. L'outil ne s'exécute pas (l'action est annulée).
2. Le contenu de stderr du hook est injecté dans le contexte de Claude
   comme message système (« the user / system blocked this action »).
3. Claude voit la raison du blocage (« BLOQUÉ par hook check-secrets.sh +
   Procédure CLAUDE.md §0 obligatoire ») et applique la Règle 0 :
   décrire ce qui serait vu, proposer à Mickael de le faire lui-même,
   demander accord explicite si action nécessaire.

## Bypass légitime (procédure)

Si Mickael donne accord explicite pour qu'une session accède à un
fichier sensible (rotation secret en cours, debug urgent), 3 options :

1. **Bypass complet de session** : `claude code --dangerously-skip-permissions`
   (CLI uniquement, désactive aussi tous les autres garde-fous — à éviter).
2. **Bypass ciblé d'une règle** : éditer `.claude/hooks/check-secrets.sh`
   pour commenter temporairement la règle concernée → relance session →
   ré-activer en fin.
3. **Mickael fait lui-même** : option par défaut Règle 0 — Mickael copie
   le contenu requis dans le chat sans passer par les outils.

Privilégier l'option 3 (la plus sûre).

## Pièges connus

- **Exit code 1 ne bloque pas** : seul exit 2 est interprété comme
  blocking par Claude Code/Cowork (post claude-code-from-source ch12 :
  « Exit code 1 is too common — any unhandled exception, assertion
  failure, or syntax error produces exit 1 »).
- **`jq` doit être disponible** dans le PATH du shell qui exécute le hook.
  Côté sandbox Cowork : OK (jq-1.6 installé). Côté CLI Windows : à
  vérifier (Git Bash/WSL2 ont jq, PowerShell natif non).
- **`hooks/hooks.json` est obsolète** : Issue Anthropic
  [#27398](https://github.com/anthropics/claude-code/issues/27398) confirme
  que le fichier `.claude/hooks/hooks.json` n'est PAS lu par Cowork.
  Toujours utiliser `.claude/settings.json` champ `hooks`.
- **Snapshot au démarrage** : Claude Code/Cowork fige la config hooks au
  démarrage de la session (anti-TOCTOU, ch12 du post). Modifier
  `settings.json` en cours de session ne prend effet qu'à la session
  suivante.

## Maintenance — quand ajouter une nouvelle règle

Ajouter dans `check-secrets.sh` une nouvelle clause `if [[ "$FILE_PATH"
=~ <pattern> ]]; then ... exit 2; fi` pour chaque nouveau pattern
sensible identifié (ex : nouveau service avec sa propre API key).

Tester systématiquement avec un cas passant + un cas bloquant avant
commit (cf. section « Tests de validation »).

## Sources

- Audit architecture S72 (28/04/2026) — phase P2.
- Post `claude-code-from-source` chapitre 12 (Extensibility — Skills and Hooks).
- Docs Claude Code officielles : <https://code.claude.com/docs/en/hooks>
- Issue Anthropic #27398 (`hooks/hooks.json` obsolète Cowork).
- Auto-memory `feedback_rotation_secret_curl_obligatoire.md` (S70) — pattern
  cousin pour rotation de secret.
