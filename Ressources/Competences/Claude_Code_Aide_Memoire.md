---
title: Claude Code — Aide-mémoire officiel
source: Documentation Anthropic (support.claude.com) — "Aide-mémoire Claude Code"
last_sync: 2026-04-22 (session 27)
purpose: Référence rapide du vocabulaire, commandes slash, raccourcis clavier Claude Code CLI. À consulter avant de chercher une solution de contournement.
---

# Claude Code — Aide-mémoire officiel

> Copie consolidée du memo Anthropic (transmise par Mickael session 27).
> À tenir à jour si la doc amont change.

La plupart des difficultés rencontrées par les nouveaux utilisateurs viennent du fait qu'ils ne savent pas qu'une commande existe déjà pour ce qu'ils essaient de faire. Jeter un œil ici avant d'inventer un workaround économise beaucoup de temps.

---

## Glossaire

| Terme | Définition |
|---|---|
| **Session** | Une exécution de `claude` dans un répertoire, du lancement à la fermeture. Chaque session a son propre historique de conversation, tandis que la mémoire du projet (`CLAUDE.md`) persiste entre les sessions. |
| **Fenêtre de contexte** | Quantité totale de texte (prompts + réponses + fichiers lus) que le modèle peut retenir à la fois. Quand elle se remplit, le contenu ancien est compacté ou supprimé. Gérée avec `/clear` et `/compact`. |
| **Jeton (token)** | Unité de mesure du texte (~¾ d'un mot). Les limites d'usage et la facturation API sont comptabilisées en jetons. Visible via `/cost` ou l'indicateur de contexte. |
| **CLAUDE.md** | Fichier markdown (racine projet, home, sous-dossier) lu automatiquement au début de chaque session. Contient conventions, commandes et contraintes pour ne pas les répéter. |
| **Mode Plan** | Mode lecture seule où Claude explore, explique et propose mais n'édite pas et n'exécute rien. Utile pour valider une approche avant exécution. Bascule : `Maj+Tab` ou `/plan`. |
| **Mode Accepter les modifications (acceptEdits)** | Approuve auto les modifications de fichiers pour le reste de la session ; les commandes shell restent à approuver. Bascule : `Maj+Tab`. |
| **Permissions** | Règles qui régissent les actions que Claude peut faire sans demander. Par défaut demande pour tout ce qui touche la machine. Ajustable par projet via `/permissions` ou `.claude/settings.local.json`. |
| **Outil (tool)** | Capacité invocable par Claude (lire fichier, éditer, exécuter bash, recherche web). Chaque appel apparaît dans la transcription. |
| **MCP (Model Context Protocol)** | Norme ouverte pour intégrer des systèmes externes (GitHub, Jira, bases de données, API internes) comme outils de Claude. |
| **Sous-agent** | Instance Claude secondaire générée pour une sous-tâche ciblée (tests, recherche, code review) avec sa propre fenêtre de contexte. Configurés via `/agents`. |
| **Hook (crochet)** | Commande shell exécutée automatiquement à un point du cycle de vie de Claude (avant un outil, après modif, au démarrage). Utile pour formatage auto, linting, blocage commandes non sécurisées. |
| **Compétence (skill)** | Ensemble d'instructions et fichiers d'aide qui enseigne un flux de travail spécifique (générer un PDF, runbook de déploiement). Invoqué avec `/` comme les commandes, peut aussi se charger automatiquement. |
| **Commande** | Toute entrée commençant par `/`. Les intégrées contrôlent la session, les personnalisées sont des skills définies dans `.claude/skills/<name>/SKILL.md` (le chemin `.claude/commands/` fonctionne toujours). |

---

## Commandes slash

> Tape `/` sur un input vide pour voir toutes les commandes disponibles dans ta config (y compris personnalisées, plugins, MCP).

### Gestion de session

| Commande | Rôle |
|---|---|
| `/help` | Liste toutes les commandes disponibles |
| `/clear` | Efface l'historique de conversation et recommence (la mémoire projet reste). Alias : `/reset`, `/new` |
| `/compact` | Résume la conversation jusqu'à présent pour libérer du contexte. Accepte des instructions de focus optionnelles |
| `/btw` | Pose une question rapide en parallèle sans l'ajouter à la conversation principale ni consommer de contexte |
| `/rewind` | Revient à un point de contrôle antérieur (conversation et/ou code) |
| `/resume` | Rouvre une session précédente. Alias : `/continue` |
| `/exit` | Quitte. Alias : `/quit` |

### Contexte et mémoire

| Commande | Rôle |
|---|---|
| `/init` | Explore la base de code et génère un `CLAUDE.md` de démarrage |
| `/context` | Visualise ce qui est actuellement chargé dans la fenêtre de contexte et où il est utilisé |
| `/memory` | Affiche ou modifie les fichiers `CLAUDE.md` dans la portée |
| `/add-dir` | Accorde à Claude l'accès aux fichiers d'un répertoire supplémentaire pour cette session |

### Mode et permissions

| Commande | Rôle |
|---|---|
| `/model` | Affiche ou change le modèle actif |
| `/plan` | Accède directement au Mode Plan (éventuellement avec description de tâche) |
| `/permissions` | Affiche ou modifie les outils qui nécessitent une approbation |
| `/config` | Ouvre les paramètres (thème, défauts, éditeur). Alias : `/settings` |

### Coûts et usage

| Commande | Rôle |
|---|---|
| `/cost` | Usage jetons et dépenses de la session |
| `/usage` | Limites de ton plan et état du rate limit |

### Outils et skills

| Commande | Rôle |
|---|---|
| `/mcp` | Gère les connexions et l'authentification MCP |
| `/agents` | Liste, crée ou modifie des sous-agents |
| `/hooks` | Affiche la configuration des hooks |
| `/skills` | Liste les skills disponibles |
| `/simplify` | Skill intégrée : examine les fichiers récemment modifiés pour réutilisation/qualité/efficacité et applique les corrections |

### Diff et export

| Commande | Rôle |
|---|---|
| `/diff` | Visionneuse interactive des modifications non validées |
| `/copy` | Copie la dernière réponse (ou un bloc de code) dans le presse-papiers |
| `/export` | Sauvegarde la conversation dans un fichier ou presse-papiers |

### Compte et diagnostic

| Commande | Rôle |
|---|---|
| `/status` | Compte, modèle, répertoire de travail, version |
| `/doctor` | Diagnostique les problèmes d'installation et d'environnement |
| `/feedback` | Signale un problème à Anthropic avec le contexte attaché. Alias : `/bug` |
| `/login` / `/logout` | Authentifie, change de compte ou déconnecte |

---

## Raccourcis clavier

| Touche | Action |
|---|---|
| `Maj + Tab` | Cycle du mode de permission : `default → acceptEdits → plan`. Inclut aussi `auto` après `claude --enable-auto-mode`, et `bypassPermissions` si activé |
| `Échap` | Interrompt Claude au milieu d'une réponse pour retaper |
| `Échap, Échap` | Ouvre le menu de rembobinage/point de contrôle |
| `Ctrl + C` | Annule l'entrée actuelle ou quitte sur un input vide |
| `Ctrl + R` | Recherche inversée dans l'historique des prompts |
| `Ctrl + O` | Développe la transcription détaillée |
| `↑` / `↓` | Parcourt l'historique des prompts |
| `@` + chemin | Référence un fichier ou répertoire dans le prompt |
| `/` | Ouvre le menu de commandes |
| `?` | **Affiche les raccourcis pour le terminal/IDE actuel** (utile — varie selon l'environnement) |

> Les raccourcis varient selon terminal et IDE. Appuyer sur `?` dans une session affiche la liste exacte pour l'environnement courant.

---

## Notes de raccord avec Jarvis

- Pour la session `claude` Phase 5 tri email Gmail : utiliser `/mcp` pour vérifier que `gmail-mcp-local` et `home-assistant` sont bien `connected` en début de session. Utiliser `Maj+Tab` pour basculer en `acceptEdits` si on veut fluidifier les validations répétitives lors des tests V1/V2.
- `/clear` avant de lancer un test V1/V2 pour repartir sur un contexte propre (charge CLAUDE.md + skill tri-email-gmail).
- `/context` pour vérifier ce qui est chargé si une skill semble ne pas se déclencher automatiquement.
- `/permissions` affiche l'allowlist/denylist de `settings.local.json` en lecture — pratique pour debug.
- `/doctor` en cas de problème d'install après un format / changement d'environnement (complémentaire de `scripts/install-claude-code.ps1`).

---

*Fiche mise à jour le 22 avril 2026 (session 27) à partir du memo officiel transmis par Mickael. À resynchroniser si la doc amont Anthropic évolue.*
