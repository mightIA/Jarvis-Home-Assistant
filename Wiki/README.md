---
title: Wiki Jarvis — vault Obsidian
created: 2026-04-25
updated: 2026-04-30
phase: 1bis-a
tags: [moc, readme, structure]
---

# Wiki Jarvis

Vault Obsidian de Mickael, sandbox **Phase 1bis** du projet
Jarvis × Hermes Agent (projet hors vault, voir `Projets/Jarvis_Hermes_Projet/Projet_Complet_v2.pdf` à la racine du repo).

## Objectif

Construire une base de connaissances locale, structurée et **versionnable**,
qui servira de matière première à Hermes Agent (Phase 1bis-c) via les
sub-agents `wiki_ingestor` / `wiki_librarian` / `wiki_query`.

D'ici là, le vault est utilisable seul comme second brain classique.

## Structure (3 dossiers — vault = connaissance pure, S81)

| Dossier | Rôle | Exemples |
|---|---|---|
| `00_Index/` | Maps Of Content (MOC), points d'entrée navigation | `_Index.md`, `MOC_HomeAssistant.md` |
| `10_Domaines/` | Domaines de connaissance **persistants** | `HomeAssistant/`, `Frisquet/`, `Cloudflare/`, `Reseau/` |
| `30_References/` | Références externes (manuels, datasheets, captures) | `Manuel_Frisquet.pdf`, `Datasheet_Dahua_IPC-T2A.pdf` |

> **Règle structurelle (S81)** : le vault ne contient **AUCUN projet** (les projets vivent dans `Projets/` racine, en isolation totale) et **AUCUNE archive** (idem dans `Archives/` racine). Aucune conversation verbatim non plus. Voir [`ADR-A004-vault-connaissance-pure`](10_Domaines/ADR/accepted/ADR-A004-vault-connaissance-pure.md).

## Conventions

- **Nommage** : `snake_case.md` ou `PascalCase.md` selon préférence — pas
  d'espaces ni d'accents dans les noms de fichiers (compat WSL2 + Hermès).
- **Dates** : ISO `YYYY-MM-DD` partout (frontmatter, titres de notes datées).
- **Tags** : convention **tripartite** (cf. section dédiée plus bas).
- **Liens** : `[[double crochets]]` pour les liens internes,
  `[texte](url)` pour les liens externes.
- **Frontmatter** : YAML en tête de chaque note (`title`, `created`,
  `updated`, `tags`, `status`).

## Plugins (cf doc d'install hors vault : `Ressources/Competences/Obsidian.md`)

- **Dataview** — requêtes SQL-like sur le vault (listes auto, dashboards)
- **Templater** — templates dynamiques pour notes datées et sub-agents
- **Excalidraw** — schémas dessinés à la main
- **Obsidian Git** — versioning auto (à activer après `git init` racine projet)

**Pas de plugin payant** (cf décision S38 — Hermès + Qwen 3 Embedding 4B
local fait mieux gratuitement que les plugins de vectorisation propriétaires).

## Convention de tags (tripartite — formalisée S80)

Trois familles de tags coexistent **intentionnellement** dans le vault. Chacune répond à une question distincte que tu te poses en navigant.

### 1. Type de note — **flat** (1 tag obligatoire)

Dit *quel genre de fichier* tu lis. Toujours en racine, jamais hiérarchique.

| Tag | Signification |
|---|---|
| `moc` | Map of Content (`_Index.md`, hub, point d'entrée navigation) |
| `adr` | Architecture Decision Record |
| `accepted` / `rejected` | Statut d'un ADR (jumeau du tag `adr`) |
| `procedure` | Procédure exécutable, pas-à-pas (débans, backup, recovery) |
| `reference` | Fiche de référence (manuel, datasheet, spécif technique) |
| `journal` | Note datée (compte rendu, observation ponctuelle) |
| `coquille` / `stub` | Note vide ou minimale en attente de remplissage |
| `index` | Pointeur de navigation transverse |

### 2. Domaine fonctionnel — **hiérarchique** (1+ tag)

Dit *de quoi ça parle*. Format `racine` + `racine/sous-racine` ajoutés ensemble.

| Tag racine | Sous-tags fréquents |
|---|---|
| `ha` | `ha/automation`, `ha/lovelace`, `ha/mcp`, `ha/integration` |
| `domotique` | `domotique/zigbee`, `domotique/cameras`, `domotique/chauffage` |
| `email` | `email/envoi`, `email/tri`, `email/mcp` |
| `reseau` | `reseau/cloudflare`, `reseau/access`, `reseau/tunnel` |
| `vieperso` | `vieperso/abonnements`, `vieperso/garanties`, `vieperso/factures` |
| `traduction` | `traduction/fr-en`, `traduction/glossaire` |
| `jarvis` | `jarvis/skills`, `jarvis/agents`, `jarvis/memory` |

> **Règle (S79 / option C)** : quand on précise un sous-tag, on garde **AUSSI** le tag racine. Exemple : une note sur l'envoi Gmail porte `email` ET `email/envoi`, jamais juste `email/envoi`. Raison : Obsidian considère `email` et `email/envoi` comme tags distincts → la recherche `tag:email` ne remonte pas les sous-tags. Garder le racine résout la fragmentation sans casser la hiérarchie.

### 3. Technologie transversale — **flat** (0+ tag)

Dit *quelle techno spécifique* est en jeu, indépendamment du domaine.

| Tag | Usage |
|---|---|
| `rtx3090` / `ryzen` / `proxmox` | Hardware Hermès, infra |
| `ollama` / `hermes` | Stack LLM local |
| `mcp` | Tout ce qui touche un serveur MCP |
| `cloudflare` | Tunnel, Access, DNS, WAF |
| `pdf` / `docx` / `xlsx` | Type de fichier traité |

### Exemple concret

Une note sur l'automatisation HA d'envoi d'email via MCP, avec déclencheur Cloudflare Tunnel :

```yaml
tags: [procedure, ha, ha/automation, email, email/envoi, mcp, cloudflare]
```

→ **1 tag famille 1** (`procedure`) + **2 paires racine/sub famille 2** (`ha` + `ha/automation`, `email` + `email/envoi`) + **2 transverses famille 3** (`mcp`, `cloudflare`).

### Maintenance

- Pas de migration brutale des 220 tags actuels (cf. T#79 — refonte vault prévue plus tard).
- Règle appliquée **aux nouveaux atomes** et à ceux modifiés au fil de l'eau.
- Audit ponctuel possible via la skill `audit-architecture-jarvis`.

---

*Wiki Jarvis — Phase 1bis-a, README mis à jour S80 (convention tags) + S85 (règle option C T#79).*
