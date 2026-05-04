# Agent C — Audit Hubs `_Index.md` désynchronisés

**Date** : 2026-04-28
**Périmètre** : 24 hubs analysés sur 143 fichiers vault

## Section 1 — Tableau récapitulatif

| Hub | Atomes réels | Listés | Manquants | Entrées mortes | Statut |
|-----|-------------|--------|-----------|----------------|--------|
| `Wiki/README.md` | 5 dossiers | 0 | — | 1 lien cassé | DESYNC |
| `00_Index/_Index.md` | 1 | 25 (parcellaires) | Hermes_Agent, Tri_Email, Mode_Reactif | 3 | INCOMPLET |
| `10_Domaines/README.md` | placeholder | — | — | — | OK |
| `HomeAssistant/_Index` | 14 | 14 | — | 0 | OK |
| `Email/_Index` | 6 | 6 | — | 0 | OK |
| `Traduction/_Index` | 4 | 4 | — | 0 | OK |
| `Outils/_Index` | 6 | 6 | — | 0 | OK |
| `ViePerso/_Index` | 4 | 4 | — | 0 | OK |
| `Inventaire/_Index` | 10 | 10 | — | 0 | OK (coquille) |
| `Reseau/_Index` | 8 | 8 | — | 0 | OK |
| `Veille/_Index` | 5 | 5 | — | 0 | OK |
| `Procedures/_Index` | 7 | 7 | — | 0 | OK |
| `Skills_Jarvis/_Index` | 26+ | 27 | — | 0 | OK |
| `Cloudflare/_Index` | 1 | 0 | — | 0 | OK (hub-atome) |
| `Frisquet/_Index` | 1 | 0 | — | 0 | OK (hub-atome) |
| `Cameras/_Index` | 2 | 2 | — | 0 | OK |
| `Domotique/_Index` | 2 | 2 + 6 TODO | — | 0 | PARTIEL |
| `ADR/_Index` | 10 (3+7) | 10 | — | 0 | OK |
| `ADR/accepted/_README` | 3 | 3 | — | 0 | OK |
| `ADR/rejected/_README` | 7 | 7 | — | 0 | OK |
| `20_Projets/README.md` | placeholder | — | — | — | OK |
| `20_Projets/Hardware_Upgrade/README.md` | 8 | 8 | — | 0 | OK |
| `30_References/README.md` | placeholder | — | — | — | OK (vide) |
| `90_Archives/README.md` | placeholder | — | — | — | OK (vide) |

**Synthèse** : 22/24 hubs synchronisés (91,7%) — 2 désynchronisations majeures.

## Section 2 — Hubs problématiques

### `Wiki/README.md` (racine)
- Référence cassée : `../Ressources/Competences/Obsidian.md` (hors vault — acceptable mais à expliciter)

### `00_Index/_Index.md` (point d'entrée)
- État : version 1bis-a (incomplet)
- 25 entrées listées dont plusieurs marquées TODO
- 3 entrées mortes (cf. Section 3)

## Section 3 — Entrées mortes détectées

| Hub | Lien défaillant | Statut réel | Correction proposée |
|-----|-----------------|-------------|---------------------|
| `00_Index/_Index.md` | `[[20_Projets/Hermes_Agent/_Plan]]` | Non créé | Marquer `[- ]` ou créer |
| `00_Index/_Index.md` | `[[20_Projets/Tri_Email_Multi/_Plan]]` | Non créé | Marquer `[- ]` ou créer |
| `00_Index/_Index.md` | `[[20_Projets/Mode_Reactif/_Index]]` | Archivé `90_Archives/` | Mettre à jour vers `[[90_Archives/Mode_Reactif/_Index]]` |
| `Wiki/README.md` | `[[../Ressources/Competences/Obsidian.md]]` | Hors vault | Documenter référence externe |

## Section 4 — Hubs vides / placeholders

| Dossier | Hub | Contenu | Verdict |
|---------|-----|---------|---------|
| `30_References/` | README.md | Placeholder + conventions | Approprié |
| `90_Archives/` | README.md | Placeholder + conventions | Approprié |
| `Inventaire/_Index.md` | Coquille + 10 templates pièces | À compléter par Mickaël | OK pour l'instant |
| `Domotique/_Index.md` | 2 atomes + 6 TODO | Sous-équipé — TV, prises, Apple TV, EcoFlow, imprimante 3D non documentés | À compléter au fil des sessions |

## Section 5 — Cas spéciaux

### ADR (Architecture Decision Records)
- **Parfaitement synchronisé** : 3 accepted + 7 rejected, conventions claires (`ADR-ANNN` accepted, `ADR-NNN` rejected)

### Hubs-atomes (Cloudflare, Frisquet)
- Domaines à 1 seul atome où le hub fait office d'atome — schéma valide

## Section 6 — Statistiques

```
Hubs synchronisés      : 22/24 (91,7%)
Hubs problématiques    : 1 (00_Index/_Index.md)
Hubs partiels/coquilles: 2 (Inventaire, Domotique)

Atomes manquants des hubs : 0 (aucun .md oublié dans son hub)
Entrées mortes des hubs   : 3 (projets non créés + archive non redirigée)
Liens cassés externes     : 1 (Obsidian.md hors vault)
```

---

## Verdict

Vault **structuré et cohérent à 92%**. Les 2 hubs problématiques (Index racine + Domotique partiel) sont identifiés et correctibles en une session rapide. Aucun atome orphelin de hub, aucune entrée morte massive. Excellente base pour ingestion Hermes Phase 1bis-c.

---

*Source : sortie Agent C sous-agent Explore — vague 1 audit S72*
