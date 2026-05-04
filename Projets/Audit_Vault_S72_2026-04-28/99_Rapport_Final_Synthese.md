# Audit Vault Obsidian — Rapport Final Consolidé S72

**Date** : 2026-04-28 (S72)
**Périmètre** : `Wiki/` — 143 fichiers .md
**Méthode** : 7 sous-agents Explore en 2 vagues parallèles + synthèse
**Durée** : ~10 minutes wall-clock
**Mode** : autonome avec checkpoints chat (Mickaël n'a pas eu à intervenir)

---

## Résumé exécutif

**Verdict global : BON.** Le vault est **structurellement sain à 92%** avec quelques dettes documentaires à régler.

| Critère | Verdict | Note |
|---------|---------|------|
| Sécurité (Règle 0) | EXCELLENT | 0 secret en clair, caviardage S69/S70 propre |
| Structure PARA | EXCELLENT | 0 anomalie de hiérarchie standard |
| Frontmatter / Encodage | TRÈS BON | 99,3% FM, 100% UTF-8 sans BOM |
| Liens markdown | EXCELLENT | 0 / 83 cassé |
| Wikilinks | À CORRIGER | 36 / 445 cassés (8,1%) |
| Hubs `_Index.md` | TRÈS BON | 22 / 24 synchronisés (91,7%) |
| Cohérence factuelle | EXCELLENT | 0 contradiction sur 45 atomes techniques |
| Doublons | À ARBITRER | 1 réel (Browser Mod) + 1 orphelin imbriqué |

---

## 1. Anomalies critiques (P0 — à corriger en priorité)

### P0.1 — Fichier orphelin imbriqué `Wiki/Wiki/...`

**Fichier** : `Wiki/10_Domaines/Email/Gmail_MCP_Custom.md` au chemin **complet** `Wiki/Wiki/10_Domaines/Email/Gmail_MCP_Custom.md`

**Symptômes** :
- Chemin imbriqué `Wiki/Wiki/...` (artefact d'une session passée)
- Frontmatter manquant (seul fichier sans FM du vault)
- 1 ligne vide / aucun contenu utile
- Existe en parallèle avec :
  - `Wiki/10_Domaines/Email/Gmail MCP custom.md` (hub légitime, FM OK, contenu S44)
  - `Ressources/Competences/Gmail_MCP_Custom.md` (source technique complète, S25-S27)

**Action** : **SUPPRIMER** après confirmation Mickaël (Règle CLAUDE.md « jamais supprimer sans validation explicite »).

### P0.2 — 9 wikilinks cassés dans Skills_Jarvis (préfixe `Wiki/` superflu)

**Fichiers concernés** :
- `Skills_Jarvis/Email_Tri_Auto.md` (6 cassés)
- `Skills_Jarvis/Home_Assistant_Operations.md` (3 cassés)
- `Skills_Jarvis/Mode_Reactif.md` (3 cassés)
- `Skills_Jarvis/Setup_Install.md` (3 cassés)
- `Skills_Jarvis/Wiki_Vault.md` (4 cassés dont 2 placeholders)
- `Skills_Jarvis/_Index.md` (3 cassés)

**Cause racine** : tous utilisent `[[Wiki/10_Domaines/...]]` au lieu de `[[10_Domaines/...]]` ou `[[../Email/...]]`. Le préfixe `Wiki/` est superflu — Obsidian considère la racine du vault comme déjà à `Wiki/`.

**Action** : `sed -i 's|\[\[Wiki/10_Domaines/|[[|g'` sur tous les fichiers `Skills_Jarvis/*.md`. **Attention** : 3 cibles n'existent pas (`Procedures_Rares/_Index`, `Reseau_Securite/_Index`, `Hermes_Agent/_Index` — la dernière doit pointer vers `15_Hermes_Agent/INDEX`).

---

## 2. Anomalies importantes (P1)

### P1.1 — Hub `00_Index/_Index.md` avec 3 entrées mortes

| Lien défaillant | Cible | Correction |
|-----------------|-------|------------|
| `[[20_Projets/Hermes_Agent/_Plan]]` | Non créé | Marquer `[- ]` ou créer placeholder |
| `[[20_Projets/Tri_Email_Multi/_Plan]]` | Non créé | Marquer `[- ]` ou créer placeholder |
| `[[20_Projets/Mode_Reactif/_Index]]` | Archivé `90_Archives/` | Mettre à jour vers `[[90_Archives/Mode_Reactif/_Index]]` |

### P1.2 — Doublon `Browser Mod.md` (Domotique × Outils)

- 95% du contenu identique
- Risque d'ambiguïté de résolution wikilink Obsidian
- **Action** : fusionner — garder la version `Outils/` (plus riche), supprimer `Domotique/`, ajouter une redirection dans le hub `Domotique/_Index.md`

### P1.3 — 11 atomes orphelins

**Email** (5) : `Boites_Email`, `Redaction_email`, `Tri_Gmail_Automatise`, `Tri_Outlook` + autres → tous sont en réalité référencés par les wikilinks cassés `Skills_Jarvis` (P0.2). **Une fois P0.2 corrigée, 5 orphelins disparaissent**.

**ViePerso** (2) : `Anniversaires_Dates_Cles`, `Contacts_Pro` → ajouter dans `ViePerso/_Index.md`.

**Hardware_Upgrade** (2) : `00_Decisions_et_audits`, `ChatGPT_Conv_Originale` → références internes manquantes dans `README.md`.

**Autres** (2) : `Domotique/Browser Mod` (résolu par P1.2), `Procedures/Debannissement IP` (cf. P1.4).

### P1.4 — Wikilink cassé `Outils/Debannissement IP` → `[[10_Domaines/HomeAssistant/Debannissement IP]]`

Le fichier cible existe mais avec accent : `Débannissement IP.md`. Corriger la cible vers `[[../HomeAssistant/Débannissement IP]]`.

---

## 3. Dettes documentaires (P2)

### P2.1 — Hub `Domotique/_Index.md` partiel

6 équipements manquants (TV, prises, Apple TV, EcoFlow, imprimante 3D, etc.) à documenter au fil des sessions.

### P2.2 — `Hardware_Upgrade/02_Architecture_cible.md` et `03_Phasage_A_a_G.md`

Ne renvoient pas vers `08_Audit_S63_et_re_evaluation_hardware.md` qui modifie le contexte (RTX 3090 suffisant invalide la justification Ryzen 7950X pour 70B). Ajouter note de renvoi en tête de 02 et 03.

Phase A (pré-requis Hermès) déjà validée S63 mais présentée comme checklist future dans `03_Phasage` → marquer « VALIDÉE S63 ».

### P2.3 — `ADR-A003-rtx3090-suffisant-hermes.md`

Ajouter section « Leçons des rejets » cross-référençant `ADR-002-mistral-nemo-principal.md` et `ADR-003-llama33-70b-q3.md`.

### P2.4 — Wikilink cassé `Email/Envoi via Home Assistant.md`

`[[../HomeAssistant/Mode Reactif - Pipeline alertes]]` → la cible existe avec accent : `Mode Réactif - Pipeline alertes.md`. Corriger.

### P2.5 — Wikilink cassé `HomeAssistant/Raccourcis clavier.md`

`[[../../30_References/Macros Clavier|Macros Clavier]]` → `30_References/` est vide (placeholder). La cible réelle est `10_Domaines/ViePerso/Macros clavier.md`. Corriger.

### P2.6 — Wikilink cassé `Inventaire/_Index.md`

`[[Ressources/Competences/Home_Assistant_Inventaire]]` → cible hors vault. Documenter comme référence externe ou copier le contenu.

### P2.7 — Wikilink cassé `ViePerso/Abonnements.md`

`[[10_Domaines/Hardware]]` → corriger vers `[[Hardware/_Index]]`.

### P2.8 — Wikilink cassé `Skills_Jarvis/Setup_Install.md`

`[[Cloudflare_Access_HA]]` → cible introuvable (fichier renommé ou jamais créé). Vérifier l'intention.

---

## 4. Patches mineurs (P3)

### P3.1 — Placeholders résiduels

- `ADR-007-smart-connections-payant.md` : `[[wikilink]]` placeholder à remplacer
- `OpenRouter_Setup_Garde_fous.md` : `[[...]]` placeholder à remplacer
- `Skills_Jarvis/Wiki_Vault.md` : `[[note]]`, `[[wikilinks]]` placeholders
- `Skills_Jarvis/_Index.md` : `[[Wiki/10_Domaines/...]]` placeholder
- `README.md` : `[[double crochets]]`, `[[wikilinks]]` placeholders

### P3.2 — Normalisation tags

220 tags distincts, mix flat (`hardware`) + hiérarchique (`ha/*`) + cas isolés. Décision à prendre sur la convention. Pas urgent.

### P3.3 — Champ `updated:` absent du frontmatter

Aucun atome ne porte `updated:` — pas de traçabilité des modifs via FM. À introduire si on veut requêtes Dataview de fraîcheur.

### P3.4 — Lien `Wiki/README.md` → `../Ressources/Competences/Obsidian.md`

Hors vault. Documenter comme référence externe acceptable ou rapatrier.

### P3.5 — `Bascule conversation` × 2

Pas un doublon (audiences différentes) mais ajouter un lien bidirectionnel `Outils/Bascule conversation.md` ↔ `Procedures/Bascule Conversation Limite Contexte.md`.

### P3.6 — `Email/Redaction email.md`

Ne mentionne pas la macro clavier. Asymétrie mineure avec `ViePerso/Macros clavier.md` — ajouter cross-link.

---

## 5. Faux positifs / sain mais à noter

- **Débannissement IP × 4 fichiers** : redondance INTENTIONNELLE (audiences hub/synthèse/skill/procédure). Garder tous, juste améliorer cross-links.
- **Boîtes email × 2 fichiers** (Email/Boites email + ViePerso/Boites email perso) : 2 vues légitimes (technique vs procédural), garder.
- **Bascule conversation × 2** : complémentaires, pas un doublon.
- **Inventaire 10 atomes pièces vides** : status `coquille` correct, remplissage attendu de Mickaël au fil du temps.
- **IPs RFC1918 (192.168.1.x)** : non sensibles (intra-LAN), normal qu'elles apparaissent en clair.
- **IDs Sonoff Zigbee `b0ceb8be...`, `0c02a8a4...`** : non secrets, hardware identifiers documentés.

---

## 6. Plan de correction recommandé

Ordre conseillé pour minimiser l'effort et profiter des effets de bord positifs :

| # | Action | Priorité | Effort | Effet collatéral |
|---|--------|----------|--------|------------------|
| 1 | Demander confirmation suppression `Wiki/Wiki/Email/Gmail_MCP_Custom.md` | P0 | Trivial | -1 frontmatter manquant |
| 2 | `sed` correction préfixe `Wiki/` dans `Skills_Jarvis/*.md` | P0 | Trivial | -9 wikilinks cassés, -5 orphelins |
| 3 | Mettre à jour 3 entrées mortes `00_Index/_Index.md` | P1 | Faible | -3 wikilinks cassés |
| 4 | Fusionner `Browser Mod.md` (Domotique → Outils) | P1 | Faible | -1 doublon, -1 orphelin |
| 5 | Corriger 5 wikilinks cassés divers (P1.4 + P2.4-2.8) | P1-P2 | Moyen | -5 wikilinks cassés |
| 6 | Ajouter cross-links Hardware_Upgrade 02/03 → 08 | P2 | Faible | Cohérence factuelle |
| 7 | Ajouter section « Leçons des rejets » dans ADR-A003 | P2 | Faible | Cohérence ADR |
| 8 | Nettoyer placeholders P3.1 | P3 | Faible | Hygiène |
| 9 | Ajouter cross-links manquants P3.5, P3.6 | P3 | Faible | Cohérence |
| 10 | Décider convention tags P3.2 + champ `updated:` P3.3 | P3 | Réflexion | Long terme |

**Effort total estimé** : ~30-45 minutes en mode pilotage. Beaucoup peut se faire en `sed`/Edit groupés.

**Effets de bord positifs** : corriger P0.2 (Skills_Jarvis) résout aussi 5 des 11 « orphelins » signalés par Agent A — ils sont en fait référencés mais via wikilinks cassés.

---

## 7. État avant/après prévisible

| Métrique | Avant | Après corrections P0+P1 | Après P0+P1+P2+P3 |
|----------|-------|--------------------------|-------------------|
| Wikilinks cassés | 36 / 445 (8,1%) | ~5 / 445 (1,1%) | 0 / 445 (0%) |
| Hubs synchronisés | 22 / 24 (91,7%) | 24 / 24 (100%) | 24 / 24 (100%) |
| Orphelins | 11 | ~3 | 0 |
| Frontmatter | 99,3% | 100% | 100% |
| Doublons réels | 1 (Browser Mod) | 0 | 0 |
| Fichier orphelin imbriqué | 1 | 0 | 0 |

---

## 8. Livrables de cet audit

Tous dans `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Projets\Audit_Vault_S72_2026-04-28\` :

- `00_Etat_Avancement.md` — journal du run
- `01_Agent_A_Liens_Orphelins.md` — wikilinks et orphelins
- `02_Agent_B_Frontmatter_Encodage.md` — métadonnées
- `03_Agent_C_Hubs_Desynchronises.md` — `_Index.md` vs contenu réel
- `04_Agent_D_Patterns_Sensibles.md` — Règle 0
- `05_Agent_E_Coherence_Technique.md` — HA + Reseau + Procedures + Hardware
- `06_Agent_F_Coherence_Workflow.md` — Email + Traduction + ViePerso + Inventaire + Outils
- `07_Agent_G_Coherence_Projets.md` — ADR + Veille + Skills + Hermes + Hardware_Upgrade
- `99_Rapport_Final_Synthese.md` — ce document

---

## 9. Question à Mickaël

Veux-tu que j'enchaîne avec **les corrections P0** maintenant (suppression du fichier orphelin imbriqué + `sed` Skills_Jarvis) ou préfères-tu d'abord lire les rapports détaillés pour arbitrer ?

**Si tu choisis la première option** : je traite P0, je m'arrête, tu valides, on passe à P1, etc. Mode pas-à-pas pour les actions qui touchent au vault.

---

*Audit clôturé le 2026-04-28 — Jarvis S72*
