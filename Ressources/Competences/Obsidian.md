---
title: Obsidian — install + vault Jarvis Wiki
created: 2026-04-25
session_creation: 41
phase: 1bis-a
---

# Obsidian — Setup vault Jarvis Wiki

Doc de référence pour installer/réinstaller Obsidian Desktop sur le PC
de Mickael avec la configuration Phase 1bis du projet Jarvis × Hermes
Agent. Sert aussi de checklist en cas de crash, formatage Windows, ou
migration vers un autre PC.

**Version Obsidian validée** : `1.12.7` (avril 2026, langue FR).

---

## 1. Install Desktop

### Source

Site officiel uniquement : [obsidian.md](https://obsidian.md/download).
Pas de version Microsoft Store, pas de version portable, pas de fork
(pas de Logseq, pas de Trilium — on reste sur Obsidian standard).

### Options retenues

| Option | Choix | Pourquoi |
|---|---|---|
| Cible install | **"Juste pour moi (Might)"** | Install dans `%LOCALAPPDATA%\Programs\Obsidian\` sans UAC à chaque MAJ. Pas system-wide. |
| Démarrage auto Windows | Non | Pas besoin, on lance manuellement. |
| Obsidian Sync | Non | Service payant Obsidian. On utilise **Obsidian Git** + repo Git privé à la place (cf §4). |

### Chemin de l'exécutable

```
C:\Users\Might\AppData\Local\Programs\Obsidian\Obsidian.exe
```

---

## 2. Vault "Wiki" — chemin et structure

### Chemin du vault

```
D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant\Wiki\
```

**Décision S41** : versionné dans le projet Jarvis, pas dans un dossier
séparé. Cohérent avec `Ressources/`, `memory/`, `Projets/` à la racine.

### Ouverture

Premier lancement → **"Ouvrir un dossier comme coffre"** → naviguer
sur le chemin ci-dessus → bouton **Ouvrir**. Obsidian détecte
automatiquement les `.md` existants (créés en S41 par Jarvis via Write).

⚠️ **Ne PAS ouvrir** le dossier `Jarvis - Home Assistant/` racine —
indexerait 1000+ fichiers du projet (skills, scripts, memory, etc.) =
performance dégradée + confusion.

### Structure (convention PARA + Karpathy LLM Wiki)

```
Wiki/
├── README.md                    ← Présentation + conventions
├── 00_Index/                    ← Maps Of Content (MOC), entrées navigation
│   └── _Index.md                ← MOC racine du vault
├── 10_Domaines/                 ← Domaines persistants (HA, Frisquet, Réseau)
│   └── README.md
├── 20_Projets/                  ← Projets actifs avec début/fin
│   └── README.md
├── 30_References/               ← Manuels, datasheets, captures externes
│   └── README.md
└── 90_Archives/                 ← Projets clos, notes obsolètes
    └── README.md
```

### Conventions de rédaction

- **Nommage fichiers** : `snake_case.md` ou `PascalCase.md` (pas
  d'espaces, pas d'accents — compat WSL2 + Hermès Phase 1bis-c).
- **Dates** : ISO `YYYY-MM-DD` (frontmatter, titres notes datées).
- **Tags hiérarchiques** : `#domaine/sous-domaine`
  (ex. `#ha/automation`, `#reseau/cloudflare/access`).
- **Liens internes** : `[[Wikilinks]]`, `[texte](url)` pour externes.
- **Frontmatter YAML** systématique en tête de note :

```yaml
---
title: Titre lisible
created: 2026-04-25
tags: [moc, ha]
status: actif
---
```

### Philosophie

- **Une idée = une note**, atomique, liée par `[[wikilinks]]`.
- L'arborescence dossiers n'est qu'un rangement physique — la **vraie**
  structure naît des liens (futur graph view + sub-agent
  `wiki_librarian` Hermès Phase 1bis-d).

---

## 3. Plugins communautaires installés

### Activation préalable

Settings → **Modules complémentaires** → désactiver le **Mode restreint**.
Active aussi le toggle "Vérifier automatiquement les mises à jour des
modules" (MAJ sécu).

### Liste

| Plugin | Auteur / Repo | Version (avril 2026) | Rôle |
|---|---|---|---|
| **Dataview** | [blacksmithgu/obsidian-dataview](https://github.com/blacksmithgu/obsidian-dataview) | 0.5.68 | Requêtes SQL-like sur le vault (TABLE/LIST/TASK). En phase de maintenance, successeur Datacore en beta — Dataview reste la référence. |
| **Templater** | [SilentVoid13/Templater](https://github.com/SilentVoid13/Templater) | 2.19.3 | Templates dynamiques avec variables et JS optionnel. ⚠️ Sécu : peut exécuter du JS arbitraire — ne JAMAIS importer de templates communautaires sans audit, garder le toggle "User Script Functions" désactivé tant qu'on n'écrit pas de scripts custom. |
| **Excalidraw** | [zsviczian/obsidian-excalidraw-plugin](https://github.com/zsviczian/obsidian-excalidraw-plugin) | 2.22.0 | Schémas dessinés à la main, intégration Excalidraw native. Pas d'exécution de code, sûr. |
| **Git** | [Vinzent03/obsidian-git](https://github.com/Vinzent03/obsidian-git) | 2.38.2 | Versioning auto (commit + push) du vault vers un repo Git distant. **Inactif tant que le projet Jarvis n'est pas un repo Git** — affichera "no git repository found", normal. |

### Plugins explicitement écartés

- **Aucun plugin payant** — décision S38 (cf auto-memory
  `feedback_obsidian_pas_de_plugin_payant.md`). Le combo Hermès + Qwen 3
  Embedding 4B local fait mieux gratuitement que les plugins de
  vectorisation propriétaires Obsidian.
- **Obsidian Sync** — service payant Obsidian, remplacé par Obsidian Git.

---

## 4. Versioning Git (à activer plus tard)

### État actuel S41

Le projet Jarvis racine **n'est pas** un repo Git
(`git config --get remote.origin.url` → vide). Obsidian Git affiche
donc "no git repository found" et reste inactif.

### À décider en session dédiée

| Option | Périmètre repo | Avantages | Inconvénients |
|---|---|---|---|
| A — Repo limité au vault | `git init` dans `Wiki/` uniquement | Repo léger, isolé, simple | Le reste du projet Jarvis n'est pas backupé Git |
| B — Repo racine projet | `git init` dans `Jarvis - Home Assistant/` | Backup Git complet (skills + scripts + Wiki + memory) | `.gitignore` complexe à écrire (credentials.json, .mcp.json secrets, Runtime/Gmail-MCP-Server/ 135MB node_modules, etc.) |

**Recommandation** : option B (repo racine) avec `.gitignore` strict —
cohérent avec ce qui a été écrit dans le README du vault, et avec la
décision S41 de versionner le vault avec le projet.

### Remote Git

À choisir : repo privé GitHub `mightIA/jarvis-home-assistant` (compte
GitHub Mickael, cf auto-memory `reference_compte_github_might.md`) ou
repo self-hosted Gitea/Forgejo.

**Règle 0** : ne JAMAIS push de tokens/credentials/secrets. Audit
`.gitignore` obligatoire avant le 1er push.

---

## 5. Raccourcis clavier utiles

| Raccourci | Action |
|---|---|
| `Ctrl + N` | Nouvelle note |
| `Ctrl + O` | Aller à un fichier (recherche fuzzy) |
| `Ctrl + E` | Toggle mode Édition ↔ Lecture |
| `Ctrl + P` | Palette de commandes (toutes les actions Obsidian) |
| `Ctrl + Maj + F` | Recherche dans tout le vault |
| `Ctrl + ,` | Paramètres |
| `Ctrl + Maj + I` | Console développeur (debug Dataview/Templater) |
| `Ctrl + R` | Recharger Obsidian (force re-index plugins) |
| `Ctrl + W` | Fermer onglet courant |

---

## 6. Vérification post-install (test vault OK)

Procédure de validation à refaire après chaque réinstall ou crash :

1. Ouvrir Obsidian sur le vault `Wiki/`
2. Vérifier que les 5 dossiers + README s'affichent dans la sidebar
3. Ouvrir `00_Index/_Index.md`
4. Basculer en mode Lecture (`Ctrl + E`)
5. Vérifier que les **2 blocs Dataview** s'affichent en TABLE générée
   (pas en code brut)
   - Bloc 1 : ≥ 6 entrées (les README + l'Index lui-même)
   - Bloc 2 : 1 entrée (`README` de `20_Projets/`)
6. Si KO : ouvrir console (`Ctrl + Maj + I`) → onglet Console → chercher
   message d'erreur Dataview/Templater

---

## 7. Prochaines phases (rappel)

| Sous-étape | Statut S41 | Contenu |
|---|---|---|
| **1bis-a** | ✓ FAIT | Install Obsidian + vault Wiki + plugins (cette doc) |
| **1bis-b** | À faire | Test Mistral Document AI (OCR + JSON) sur 3 PDF représentatifs |
| **1bis-c** | À faire | Install Hermes Agent WSL2 + Ollama RTX 3090 + 4 modèles locaux |
| **1bis-d** | À faire | Config `AGENTS.md` Hermès avec sub-agents `wiki_ingestor` / `wiki_librarian` / `wiki_query` + `context fork` + test V1 |

Détail complet des sous-étapes : `TASKS.md` ligne #58.

---

## 8. Backup

### Pré-Git

En attendant que le repo Git soit initialisé, le vault est backupé via :

- **OneDrive** : si le dossier `D:\Documents\IA\Projets Cowork\` est
  synchronisé OneDrive (à vérifier côté Mickael), backup passif auto.
- **Skill `Backup_Jarvis`** : `Ressources/Protocoles/Backup_Jarvis.md`
  (procédure manuelle session 17).

### Post-Git

Une fois `git init` fait :

- Obsidian Git commit auto toutes les N minutes (configurable dans
  Settings → Git)
- Push vers remote privé (mightIA GitHub ou self-hosted)
- Pas de purge auto des archives — les notes archivées restent
  accessibles via l'historique Git

---

*Dernière MAJ : session 41, 25 avril 2026 — Phase 1bis-a clôturée.*
