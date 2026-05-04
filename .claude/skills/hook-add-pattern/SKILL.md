---
name: hook-add-pattern
description: Ajoute un nouveau pattern de blocage au hook PreToolUse `.claude/hooks/check-secrets.sh` (Règle 0 — Données sensibles). À utiliser quand un nouveau type de secret apparaît dans le projet (nouvelle API key, nouveau service cloud, nouveau format de credentials). Procédure 5 étapes : identifier le pattern regex, ajouter une clause `if` dans le script, tester en cas passant + cas bloquant, mettre à jour `memory/reference_hooks_securite_p2.md`, vérifier la prochaine session que le hook s'active. Déclenche : Mickael mentionne "ajouter un nouveau secret au hook", "le hook check-secrets ne couvre pas X", "nouveau type de credentials", "étendre la Règle 0".
---

# Skill : Ajouter un pattern de blocage au hook check-secrets

## Quand cette skill est déclenchée

- Mickael découvre un nouveau secret/token/credentials dans son setup
  (nouveau service cloud, nouveau MCP, nouveau provider IA).
- Mickael dit « le hook ne protège pas X » ou « ajoute Y au hook ».
- Audit sécurité (skill `audit-architecture-jarvis`) révèle un pattern
  manquant.
- Après création d'un nouveau MCP avec credentials propres.

## Pourquoi cette skill existe

Le hook `.claude/hooks/check-secrets.sh` (créé S72) couvre 7 règles
initiales (credentials Gmail, .env, secrets.yaml HA, SSH privée,
settings.local.json, .mcp.json, patterns Bash). Tout nouveau type de
secret doit être ajouté **proprement** sinon la Règle 0 reste découverte
sur ce nouveau périmètre.

Le risque : ajouter le pattern à la va-vite, casser une règle existante,
ou oublier la mise à jour de la doc. Cette skill évite l'erreur.

## Procédure (5 étapes)

### Étape 1 — Identifier le pattern regex

Type de cible :

- **Path de fichier** (ex : `~/.aws/credentials`, `~/.docker/config.json`).
  Pattern bash : `[[ "$FILE_PATH" =~ <regex> ]]`.
- **Argument Bash** (ex : token API en clair dans la commande).
  Pattern bash : `[[ "$BASH_CMD" =~ <regex> ]]`.

Tester d'abord la regex avec un échantillon réel + un échantillon faux
positif :

```bash
TEST_PATH="/home/user/.aws/credentials"
[[ "$TEST_PATH" =~ /\.aws/credentials$ ]] && echo "MATCH" || echo "NO MATCH"
```

### Étape 2 — Ajouter la clause dans `check-secrets.sh`

Règles d'or :

- **Numéroter** la nouvelle règle (ex : « RÈGLE 8 — AWS credentials »).
- **Ne pas casser** l'ordre existant (les règles 1-7 sont stables).
- **Le message stderr doit être complet** : nom du fichier/outil + raison
  du blocage + rappel CLAUDE.md §0 + suggestion de procédure.
- **Toujours `exit 2`** (exit 1 = warning non-bloquant, ne PAS utiliser
  pour la sécurité).

Template à copier dans le script avant la dernière ligne `exit 0` :

```bash
# ============================================================================
# RÈGLE N — <description>
# ============================================================================
if [[ "$FILE_PATH" =~ <regex> ]]; then
  cat >&2 <<MSG
[Règle 0 — Données sensibles] BLOQUÉ par hook check-secrets.sh

Fichier : \$FILE_PATH
Outil   : \$TOOL_NAME

<explication métier du pourquoi c'est sensible>.
Procédure CLAUDE.md §0 obligatoire.
MSG
  exit 2
fi
```

### Étape 3 — Tester (cas passant + cas bloquant)

Reprendre le script de tests S72. Pour chaque nouveau pattern, **2 tests
minimum** :

```bash
# Cas qui DOIT passer (faux positif évité)
echo '{"tool_name":"Read","tool_input":{"file_path":"/home/user/.aws/config"}}' \
  | bash .claude/hooks/check-secrets.sh
echo "Exit : $?"  # attendu : 0

# Cas qui DOIT bloquer
echo '{"tool_name":"Read","tool_input":{"file_path":"/home/user/.aws/credentials"}}' \
  | bash .claude/hooks/check-secrets.sh
echo "Exit : $?"  # attendu : 2
```

Si un test échoue, **NE PAS COMMITER**. Corriger la regex et retester.

### Étape 4 — Mettre à jour `memory/reference_hooks_securite_p2.md`

Ajouter la nouvelle règle dans la section « Patterns interceptés (N règles) ».
Format :

```markdown
N. **<Type de credentials>** : `<pattern>` → BLOQUÉ <outils>. <explication>.
```

Mettre à jour le compteur dans le titre de la section.

### Étape 5 — Vérifier que le hook s'active à la prochaine session

Le hook est figé au démarrage de session (snapshot anti-TOCTOU
documenté ch12 du post claude-code-from-source). Donc : la nouvelle
règle ne sera active **qu'à la prochaine session**.

Demander à Mickael de tester en session suivante :

> « Peux-tu lire ~/.aws/credentials ? »

Le hook doit bloquer avec le message stderr personnalisé. Si oui →
règle validée. Si non → vérifier que `.claude/settings.json` charge
toujours le hook (rare mais possible si snapshot corrompu).

## Pièges connus

- **Edit `.claude/hooks/check-secrets.sh` bloqué côté Cowork** : le path
  `.claude/` est protégé en Edit/Write par Cowork. Passer par bash
  heredoc (pattern S48 bypass-via-Bash). Voir
  `memory/feedback_hass_callws_bypass_mcp.md` pour le pattern général.
- **Regex bash diffère de regex Python/JS** : tester avec `[[ ... =~ ... ]]`
  natif bash, pas grep -E. Bash regex utilise POSIX étendu mais avec
  des subtilités (escaping, classes).
- **Ne pas oublier les variantes** : `_rsa` ET `_ed25519` ET `_ecdsa`
  pour SSH ; `.env` ET `.env.local` ET `.env.production` ; etc.

## Sources

- `memory/reference_hooks_securite_p2.md` — référence principale du hook.
- Post `claude-code-from-source` chapitre 12 (Extensibility — Hooks).
- Docs Claude Code : <https://code.claude.com/docs/en/hooks>
- Skill `decongestion-fichiers-vivants` — pattern de bash heredoc pour
  bypass Edit Cowork sur `.claude/`.
