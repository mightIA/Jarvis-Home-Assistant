---
name: install-claude-code-windows
description: >
  Procédure complète d'installation de l'environnement dev Claude Code sur Windows 11 (machine Mickael) :
  Node.js, Git Bash, Claude Code CLI, Python (pour scripts de validation skills).
  Utilise ce skill quand Mickael demande à installer Claude Code ou Python, ou quand il rencontre :
  "claude n'est pas reconnu", "npm n'est pas reconnu", "git-bash required", "python n'est pas reconnu",
  problèmes ExecutionPolicy PowerShell, ou scripts Python des skills qui échouent.
---

# Installation environnement dev Claude Code sur Windows — Procédure Jarvis

Contexte : Windows 11 PowerShell. Dossier cible : `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant`.

## Vue d'ensemble — ordre d'installation

1. Node.js LTS
2. Fix ExecutionPolicy PowerShell (pour npm)
3. Git pour Windows (git-bash requis par Claude Code)
4. Claude Code via npm
5. Python 3.12+ (optionnel mais recommandé pour skills avec scripts Python — ex. ESJavadex/homeassistant-config)

---

## 1. Node.js (LTS)

- URL : https://nodejs.org
- Choisir la version **LTS** (bouton recommandé)
- Installateur GUI : accepter les défauts (Next x5, Install)
- **Fermer et rouvrir PowerShell** après install (recharge PATH)
- Vérifier :
  ```powershell
  node --version
  npm.cmd --version
  ```

## 2. ExecutionPolicy PowerShell (pour autoriser npm.ps1)

Sans ça, npm affiche : *« Impossible de charger le fichier npm.ps1, l'exécution de scripts est désactivée »*.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Confirmer avec `O`.

## 3. Git pour Windows (requis pour git-bash)

Sans ça, `claude` affiche : *« Claude Code on Windows requires git-bash »*.

- URL : https://git-scm.com/downloads/win (64-bit Git for Windows Setup)
- Installateur GUI — **choix à faire** (ne pas garder tous les défauts) :

  | Écran | Choix |
  |-------|-------|
  | Default editor | **Notepad** ou **Visual Studio Code** (pas Vim) |
  | Initial branch name | **Override → main** |
  | Adjusting PATH | **Git from the command line and also from 3rd-party software** (Recommended, option 2) |
  | SSH executable | Use bundled OpenSSH (défaut) |
  | HTTPS transport | Use the native Windows Secure Channel library (défaut) |
  | Line endings | Checkout Windows-style, commit Unix-style (défaut) |
  | Terminal emulator | Use MinTTY (défaut) |
  | `git pull` behavior | Fast-forward or merge (défaut) |
  | Credential helper | Git Credential Manager (défaut) |
  | Extra options | file system caching ✅, symbolic links ❌ (défauts) |

- **Fermer et rouvrir PowerShell** après install.

## 4. Installer Claude Code — deux méthodes possibles

### Méthode A (recommandée depuis session 17) — Native Windows via install.ps1

Plus simple, pas besoin de npm ni ExecutionPolicy. Téléchargement direct d'un binaire natif.

```powershell
irm https://claude.ai/install.ps1 | iex
```

Le binaire est installé dans `C:\Users\<user>\.local\bin\claude.exe`.

> ### ⚠️ IMPORTANT — PATH utilisateur à ajouter manuellement
> `C:\Users\<user>\.local\bin` **n'est PAS dans le PATH par défaut**. L'installateur affiche l'avertissement :
> *« Native installation exists but C:\Users\<user>\.local\bin is not in your PATH »*
>
> **Ajout du PATH utilisateur** (GUI ou PowerShell) :
>
> **Option GUI** :
> 1. `Win + R` → `sysdm.cpl` → Entrée
> 2. Onglet **Paramètres système avancés** → **Variables d'environnement…**
> 3. Dans **Variables utilisateur**, sélectionner `Path` → **Modifier…** → **Nouveau**
> 4. Coller `C:\Users\<user>\.local\bin`
> 5. OK / OK / OK → **fermer et rouvrir PowerShell**
>
> **Option PowerShell (automatique)** :
> ```powershell
> $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
> $claudePath = "$env:USERPROFILE\.local\bin"
> if ($userPath -notlike "*$claudePath*") {
>     [Environment]::SetEnvironmentVariable("Path", "$userPath;$claudePath", "User")
>     Write-Host "PATH utilisateur mis à jour. Ferme et rouvre PowerShell."
> }
> ```

Vérifier (après réouverture PowerShell) :
```powershell
claude --version
```

### Méthode B (legacy) — via npm

Nécessite Node.js + ExecutionPolicy RemoteSigned (voir sections 1 et 2 ci-dessus).

```powershell
npm install -g @anthropic-ai/claude-code
```

Si `npm` affiche encore une erreur ExecutionPolicy, utiliser `npm.cmd install -g @anthropic-ai/claude-code`.

Vérifier :
```powershell
claude --version
```

Avantage npm : le PATH est automatiquement géré par npm (pas d'ajout manuel). Inconvénient : dépend de Node.js et d'une ExecutionPolicy moins stricte.

## 5. Python 3.12+ (pour scripts de validation des skills)

Requis notamment par le plugin **ESJavadex/homeassistant-config** (scripts validate_yaml.py, check_config.py, lovelace_validator.py, find_duplicates.py).

- URL : https://www.python.org/downloads/ (bouton **Download Python 3.12.x**)
- Lance l'installateur Python

> ### ⚠️ IMPORTANT — point 3 (pendant l'installation)
> **Coche impérativement la case "Add Python to PATH"** (en bas du premier écran de l'installateur).
> Sans cette case, `python` et `pip` ne seront pas reconnus dans PowerShell et tous les scripts Python des skills échoueront avec *« python n'est pas reconnu »*.
>
> Puis clique **"Install Now"**.

- **Fermer et rouvrir PowerShell** après install.
- Vérifier :
  ```powershell
  python --version
  pip --version
  ```
- Installer la dépendance minimale pour valider YAML (requise par ESJavadex) :
  ```powershell
  pip install pyyaml
  ```

## Lancement de Claude Code

```powershell
cd "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant"
claude
```

Claude Code détectera automatiquement le `CLAUDE.md` et les skills dans `.claude/skills/`.

Pour reprendre une conversation existante (utile en développement itératif) :
```powershell
claude --continue
```

---

## Après l'install — première session (retour d'expérience S17)

### Étape 1 — Bilan de chargement

Au premier démarrage dans le dossier Jarvis, lancer :
```
salut, lis CLAUDE.md et fais-moi le bilan de la session pour valider que tout est bien chargé (skills, mémoire, MCP).
```

Jarvis doit confirmer :
- CLAUDE.md chargé (version courante)
- Liste des skills disponibles
- Liste des serveurs MCP configurés dans `.mcp.json`
- État de la mémoire (`memory/MEMORY.md`)

### Étape 2 — Trust prompt MCP

Au premier lancement avec un serveur MCP dans `.mcp.json`, Claude Code affiche un prompt de confiance :
*« Trust this MCP server? »*

Répondre **Yes, approve** pour autoriser le contact avec le serveur.

### Étape 3 — Flow OAuth DCR (pour MCP ha-mcp)

Si le MCP utilise `"auth": "oauth"` (cas add-on ha-mcp validé session 17) :

1. Un onglet navigateur s'ouvre automatiquement vers `https://mcp.might.ovh/private_<secret>/.well-known/...`
2. Redirection vers l'interface Home Assistant → cliquer **Autoriser**
3. Le token OAuth est stocké côté CLI (PAS dans `.mcp.json`)

**Navigateur par défaut** : si un navigateur autre que Brave est configuré par défaut (Edge, Chrome…), le popup s'y ouvrira. Forcer Brave pour cette session si besoin :
```powershell
$env:BROWSER="brave"
claude --continue
```

### Étape 4 — Test bout-en-bout

Une fois le flow OAuth validé, tester un appel MCP réel :
```
statut de light.ampoule_chambre
```
ou, avec une entité connue :
```
statut de climate.chaudiere
```

Si Jarvis retourne un payload structuré (état, attributs, last_updated), le pairage CLI → ha-mcp → HA est validé 🟢.

### Signaux d'échec à surveiller

| Signal | Cause probable | Action |
|--------|---------------|--------|
| Popup navigateur ne s'ouvre pas | `BROWSER` env non défini | Forcer : `$env:BROWSER="brave"` puis relancer |
| Redirect vers `cloudflareaccess.com` | CF Access bypass cassé sur l'endpoint MCP | Skill `cloudflare-access-ha`, règle Bypass+Everyone |
| 401/403 persistant après OAuth | Ban IP HA (trop d'essais OAuth) | Skill `debannissement-ip` |
| Erreur `ofid_*` ou DCR fail | Régression add-on ha-mcp | Skill `ha-mcp-install` (vérifier v7.3+) |
| `MCP n'est pas chargé` après relance | `.mcp.json` lu une seule fois au démarrage | Faire `/exit` puis `claude --continue` |

### Piège URL ha-mcp (confirmé S17)

L'URL du serveur ha-mcp dans `.mcp.json` doit être **exactement** :
```
https://mcp.might.ovh/private_<secret>
```

- **Pas** de suffixe `/sse` (retour 404)
- **Pas** de suffixe `/mcp` (retour 404)
- **Pas** de trailing slash `/` (retour 307 redirect vers `http://`, piège tunnel CF)

Transport = MCP streamable HTTP (FastMCP 3.x), pas SSE.

Validation curl rapide de l'endpoint (POST + headers Accept corrects) :
```bash
curl -s -o /dev/null -w "%{http_code}\n" --max-redirs 0 --max-time 8 \
  -X POST -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}' \
  "https://mcp.might.ovh/private_<secret>"
```
→ Attendu : `200`

---

## Commandes slash utiles une fois Claude Code démarré

```
/plugin marketplace add ESJavadex/claude-homeassistant-plugins
/plugin install homeassistant-config@claude-homeassistant-plugins
/plugin
/reload-plugins
```

## Troubleshooting rapide

| Erreur | Cause | Fix |
|--------|-------|-----|
| `claude : n'est pas reconnu` (install natif) | PATH utilisateur pas mis à jour après `install.ps1` | Ajouter `C:\Users\<user>\.local\bin` au PATH utilisateur (voir méthode A section 4) puis fermer/rouvrir PowerShell |
| `claude : n'est pas reconnu` (install npm) | Claude Code pas installé OU PATH pas rechargé | `npm install -g @anthropic-ai/claude-code` puis fermer/rouvrir PowerShell |
| `npm : n'est pas reconnu` | Node.js pas installé | Installer Node.js LTS depuis nodejs.org |
| `npm.ps1 : l'exécution de scripts est désactivée` | ExecutionPolicy trop stricte | `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| `Claude Code requires git-bash` | Git pour Windows pas installé | Installer Git depuis git-scm.com |
| `CLAUDE_CODE_GIT_BASH_PATH` (après install Git) | PATH pas mis à jour | Fermer/rouvrir PowerShell, ou `$env:CLAUDE_CODE_GIT_BASH_PATH = "C:\Program Files\Git\bin\bash.exe"` |
| `python : n'est pas reconnu` | "Add Python to PATH" pas coché OU PATH pas rechargé | Réinstaller Python en cochant la case, ou ajouter manuellement `C:\Users\<user>\AppData\Local\Programs\Python\Python312\` au PATH |
| `pip : n'est pas reconnu` | PATH Python pas rechargé | Fermer/rouvrir PowerShell |
| `ModuleNotFoundError: No module named 'yaml'` | PyYAML pas installé | `pip install pyyaml` |

## Mode automatique (si Mickael demande)

Si tout est déjà installé et que `claude --version` + `python --version` fonctionnent, aller directement à la section "Lancement". Sinon, dérouler uniquement les pré-requis manquants.

Les installateurs GUI (Node, Git, Python) nécessitent des clics utilisateur — impossible à 100% automatique. Je (Jarvis) peux te guider écran par écran en validant tes choix.
