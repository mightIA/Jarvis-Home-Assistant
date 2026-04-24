---
title: Wiki Jarvis — vault Obsidian
created: 2026-04-25
phase: 1bis-a
---

# Wiki Jarvis

Vault Obsidian de Mickael, sandbox **Phase 1bis** du projet
[Jarvis × Hermes Agent](../Projets/Jarvis_Hermes_Projet/Projet_Complet_v2.pdf).

## Objectif

Construire une base de connaissances locale, structurée et **versionnable**,
qui servira de matière première à Hermes Agent (Phase 1bis-c) via les
sub-agents `wiki_ingestor` / `wiki_librarian` / `wiki_query`.

D'ici là, le vault est utilisable seul comme second brain classique.

## Structure (5 dossiers — convention PARA + Karpathy LLM Wiki)

| Dossier | Rôle | Exemples |
|---|---|---|
| `00_Index/` | Maps Of Content (MOC), points d'entrée navigation | `_Index.md`, `MOC_HomeAssistant.md` |
| `10_Domaines/` | Domaines de connaissance **persistants** | `HomeAssistant/`, `Frisquet/`, `Cloudflare/`, `Reseau/` |
| `20_Projets/` | Projets **actifs** avec début/fin | `Hermes_Agent/`, `Tri_Email_Multi/`, `Mode_Reactif/` |
| `30_References/` | Références externes (manuels, datasheets, captures) | `Manuel_Frisquet.pdf`, `Datasheet_Dahua_IPC-T2A.pdf` |
| `90_Archives/` | Projets terminés, notes obsolètes mais conservées | Phase 1 Mode Réactif (clos S31) |

## Conventions

- **Nommage** : `snake_case.md` ou `PascalCase.md` selon préférence — pas
  d'espaces ni d'accents dans les noms de fichiers (compat WSL2 + Hermès).
- **Dates** : ISO `YYYY-MM-DD` partout (frontmatter, titres de notes datées).
- **Tags** : `#domaine/sous-domaine` hiérarchique
  (ex. `#ha/automation`, `#reseau/cloudflare/access`).
- **Liens** : `[[double crochets]]` pour les liens internes,
  `[texte](url)` pour les liens externes.
- **Frontmatter** : YAML en tête de chaque note (`title`, `created`,
  `tags`, `status`).

## Plugins (cf [`Ressources/Competences/Obsidian.md`](../Ressources/Competences/Obsidian.md))

- **Dataview** — requêtes SQL-like sur le vault (listes auto, dashboards)
- **Templater** — templates dynamiques pour notes datées et sub-agents
- **Excalidraw** — schémas dessinés à la main
- **Obsidian Git** — versioning auto (à activer après `git init` racine projet)

**Pas de plugin payant** (cf décision S38 — Hermès + Qwen 3 Embedding 4B
local fait mieux gratuitement que les plugins de vectorisation propriétaires).

## Philosophie d'écriture

- **Une idée par note**, atomique. Lien vers les autres via `[[wikilinks]]`.
- **Préférer les liens aux dossiers profonds** — l'arborescence n'est qu'un
  rangement physique, la vraie structure naît des liens.
- **Frontmatter systématique** — sera consommé par Hermès en Phase 1bis-d
  (sub-agent `wiki_ingestor` → métadonnées → `wiki_librarian`).

## Hors scope

Ce vault **n'est pas** la mémoire opérationnelle de Jarvis.
Cette dernière reste dans `memory/` à la racine du projet (auto-memories
+ historique sessions). Le Wiki est pour les **connaissances réutilisables**,
pas pour le journal de bord conversationnel.

---

*Créé Phase 1bis-a — session 41, 25 avril 2026.*
