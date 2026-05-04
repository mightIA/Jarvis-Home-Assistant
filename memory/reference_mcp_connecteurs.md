---
name: Connecteurs MCP — Référence enrichie Jarvis
description: Liste détaillée des connecteurs MCP configurés dans .mcp.json + permissions + pièges connus. Référence complémentaire au §6 CLAUDE.md (créée S75 T#81 option C).
type: reference
last_update: 2026-04-28
---

# Connecteurs MCP — Référence enrichie

> **Source de vérité** : `.mcp.json` à la racine du projet.
> **Résumé court** : §6 de `CLAUDE.md`. Ce fichier ajoute le détail.

## Connecteurs configurés

### Gmail (Cowork web)

- Mode : read + drafts + labels
- Usage : tri quotidien automatisé via skills `tri-email-gmail`
- Restriction : **lecture seule** (Cowork ne supporte que les MCP HTTP/SSE)

### Gmail-MCP-Local (Claude Code CLI uniquement)

- Mode : stdio
- Usage : écriture Gmail (`modify_email`, `batch_modify`, `create_label`, `create_filter`)
- Restriction : **CLI seulement** — Cowork ne charge pas les MCP stdio
- Runtime : `Runtime/Gmail-MCP-Server/`

### Home Assistant (add-on `ha-mcp`)

- URL publique : `https://mcp.might.ovh/private_<secret>` (rotation S70)
- Outils disponibles : 80+ outils `ha_*` couvrant toutes les actions HA
- Compatibilité : Cowork desktop + Claude Code CLI
- Auth : OAuth 2.0 via `.mcp.json`

### Claude in Chrome (inclus Cowork desktop)

- Usage : automation Brave pour les workflows navigateur résiduels
- Cas d'usage typiques : Outlook web, dashboards sans MCP natif
- Tab ID Brave à vérifier en début de chaque session (change à chaque ouverture)

### PDF Tools — `pdf-toolkit` (depuis S35, 23/04/2026)

- Éditeur : Open Document Alliance v0.7.3, MIT
- Outils : 21 outils + 14 invites MCP
- **Permissions Cowork (granularité par catégorie)** :
  - Lecture seule → AUTO
  - Interactifs + Écriture/suppression → APPROBATION
- **Pièges techniques connus** :
  - Chemins Windows absolus obligatoires (pas `/mnt/...`)
  - Copier `uploads/` → `workspace/` via Bash AVANT appel MCP
- **Règle pratique `fill_pdf`** : ne fonctionne que sur PDF AcroForm
  - PDF compatibles : CERFA service-public.fr, DocuSign/Yousign, Word « Enregistrer PDF avec champs »
  - PDF NON compatibles : image/scan, exports Word sans champs (=> statiques)

### Google Calendar (optionnel, non activé)

- Statut : prévu pour les rappels et planning, non configuré à ce jour
- Décision Mickael à venir si besoin métier identifié

---

*Créé S75 (28/04/2026) en complément du §6 CLAUDE.md — T#81 option C (refonte conservatrice, `@imports` non supporté par Cowork desktop, test concluant S75). Voir `memory/historique/2026-04-28_session_74_audit_structure_fichiers_vivants.md` pour le contexte audit S74.*
