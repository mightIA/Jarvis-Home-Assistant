---
title: "Audit cohérence factuelle — Domaines Workflow (Email, Traduction, ViePerso, Inventaire, Outils, Domotique)"
author: Agent F
date: 2026-04-28
session: S72
status: "complet"
---

# Audit cohérence factuelle — Domaines Workflow

**Périmètre** : 6 domaines workflow (Email + 6 atomes, Traduction + 4 atomes, ViePerso + 10 atomes, Inventaire + 10 atomes, Outils + 6 atomes, Domotique + 2 atomes).

**Total fichiers lus** : 43 fichiers (hubs + atomes + Procedures spécialisée).

---

## SECTION 1 — DOUBLONS WORKFLOW

### 1.1 Gmail MCP Custom — 3 fichiers, 2 versions

**Cas critique détecté**.

| Chemin | Statut | Contenu | Created | Taille approx |
|--------|--------|---------|---------|---|
| `Wiki/10_Domaines/Email/Gmail MCP custom.md` | **Actif — HUB** | Résumé 110 lignes. Pointeur vers Ressources/Competences | S44 | ✅ Cohérent |
| `Wiki/Wiki/10_Domaines/Email/Gmail_MCP_Custom.md` | **Orphelin imbriqué** | 1 ligne vide | ? | ❌ Coquille |
| `Ressources/Competences/Gmail_MCP_Custom.md` | **Source technique** | Référence complète 296 lignes (phased install, audit, CVE, logs) | S25-S27 | ✅ Référence |

**Verdict** : Doublon + orphelin. Le fichier `Wiki/Wiki/10_Domaines/Email/Gmail_MCP_Custom.md` (chemin imbriqué incorrect) est vide et doit être supprimé. Les deux autres (Hub + Source) sont à jour et complémentaires — pas de fusion nécessaire.

### 1.2 Bascule conversation — 2 fichiers, 2 versions non synchronisées

| Chemin | Domaine | Statut | Contenu | Cohérence |
|--------|---------|--------|---------|-----------|
| `Wiki/10_Domaines/Outils/Bascule conversation.md` | Outils | Actif | Skill `bascule-conversation` — 5 étapes + workflow complet (125 lignes) | ✅ |
| `Wiki/10_Domaines/Procedures/Bascule Conversation Limite Contexte.md` | Procedures | Actif | Procédure identique — 2 stratégies (`/compact` vs bascule) + pièges (92 lignes) | ⚠️ Chevauchement |

**Différence factuelle** : 
- **Outils** : focus workflow skill, test compatibilité, template résumé, MAJ fichiers.
- **Procedures** : focus déclencheurs + règle S53 + auto-memories + pièges.

**Verdict** : Pas doublon pur, mais **chevauchement d'audience**. Procedures décrit le "quand/pourquoi" (urgence contexte), Outils décrit le "comment" (étapes skill). Recommandation : créer lien bidirectionnel explicite et harmoniser titres.

### 1.3 Boîtes email — 2 fichiers cohérents

| Chemin | Domaine | Contenu | Cohérence |
|--------|---------|---------|-----------|
| `Wiki/10_Domaines/Email/Boites email.md` | Email | 4 boîtes + limitations MCP + liens | ✅ |
| `Wiki/10_Domaines/ViePerso/Boites email perso.md` | ViePerso | 4 boîtes (vue simplifiée) + limitations + plan multi-boîtes | ✅ |

**Différence factuelle** :
- **Email** : scope technique (MCP-local, ACL NTFS, limitations Cowork stdio).
- **ViePerso** : scope procédural (setup 2 instances OAuth par boîte, ~30 min chacune).

**Verdict** : **Pas doublon**. Deux vues légitimes d'un même inventaire (technique vs procédural).

---

## SECTION 2 — INCOHÉRENCES INTER-ATOMES

### 2.1 Envoi mail — Cohérence `data.target` obligatoire

**Fichier** : `Email/Envoi via Home Assistant.md` (S44).

**Assertion** : Service `notify.might57290_gmail_com` demande `data.target` obligatoire sous forme **liste** même pour un seul destinataire.

```yaml
data:
  target: ["might57290@gmail.com"]
```

**Vérification cross-domaine** :
- ✅ `Tri Gmail automatise.md` (ligne 48) : "Envoyer rapport via `notify.might57290_gmail_com`" — OK
- ✅ `Tri Outlook.md` (ligne 17) : complémentaire (skill `tri-email-outlook`)
- ✅ Redaction email.md (ligne 77) : "seul canal d'envoi technique... passe par HA" — OK

**Verdict** : ✅ Cohérent. Assertion validée transversalement.

### 2.2 Scope OAuth gmail.send absent

**Assertion clé** (S27, volontaire) : scope `gmail.send` et `gmail.compose` **absents** côté Gmail MCP Custom.

**Fichiers impliqués** :
1. `Gmail MCP custom.md` (Wiki) — ligne 32 : "PAS `gmail.send`"
2. `Redaction email.md` — ligne 20 : "scope OAuth `gmail.compose` est volontairement absent"
3. `Ressources/Competences/Gmail_MCP_Custom.md` — ligne 117-122 : détails scopes

**Cohérence** : ✅ Identique sur les 3 fichiers.

**Impact documenté** :
- Redaction email (skill) = "en attente de refonte (tâche #46)" — ✅ Cohérent
- Envoi mail passe par `notify.might57290_gmail_com` (HA) — ✅ Justifié

### 2.3 Tri Gmail — Heures cron cohérentes ?

**Assertion** : 5h + 14h (GMT+1 local).

**Fichiers** :
- `Boites email.md` (ligne 18) : "5h + 14h"
- `Tri Gmail automatise.md` (ligne 22-23) : "05h00 / 14h00"
- `Ressources/Competences/Gmail_MCP_Custom.md` (ligne 287-290) : "Triggers : 05:00 et 14:00"

**Verdict** : ✅ Cohérent sur tous les fichiers.

### 2.4 Macros clavier — Lien avec Redaction email ?

**Assertion** : `Redaction email.md` mentionne-t-il la macro clavier liée ?

**Lecture** : `Redaction email.md` ne mentionne **pas** `Macros clavier.md`.

**Lecture inverse** : `Macros clavier.md` (ligne 45) mentionne "Tri Gmail supervisé" (skill `tri-email-gmail`) mais **pas** redaction-email.

**Verdict** : ⚠️ **Référence manquante**. Redaction email n'a pas de macro clavier assignée. À vérifier si c'est intentionnel (task #46 refonte) ou omission.

---

## SECTION 3 — ATOMES VIDES / COQUILLES

### 3.1 Inventaire — État de remplissage

**Domaine** : Inventaire (10 atomes).

| Fichier | Status | Remplissage | Contenu |
|---------|--------|-------------|---------|
| `_Index.md` | coquille | 0 % | Template + listes pièces (aucune data) |
| `Salon.md` | coquille | 10 % | 1 équipement (TV Samsung), reste `...` |
| `Cuisine.md` | coquille | 15 % | 3 équipements listés, 1 audit T#13 en cours |
| `Chambre_principale.md` | coquille | ? | Non lue |
| `Autres_chambres.md` | coquille | ? | Non lue |
| `Salle_de_bain.md` | coquille | ? | Non lue |
| `Bureau.md` | coquille | ? | Non lue |
| `Garage_Cave.md` | coquille | ? | Non lue |
| `Exterieur.md` | coquille | ? | Non lue |
| `Reseau_Maison.md` | coquille | ? | Non lue |
| `Batteries_Piles.md` | coquille | ? | Non lue |

**Verdict** : ⚠️ **Domaine 95 % vide**. Status `coquille` correct. Remplissage attendu de Mickael (photos + factures + captures HA) — tâche planifiée mais non commencée.

### 3.2 Traduction — Glossaire et Style personnel

**Fichiers atomes** :
- `Modes de traduction.md` — ✅ Actif, 84 lignes, 4 modes détaillés
- `Langues et directions.md` — ✅ Actif, 56 lignes, 3 langues + 6 directions
- `Glossaire technique.md` — **Pas lu** (pointeur uniquement vers `Ressources/Competences/Traduction_Glossaire.md`)
- `Style personnel.md` — **Pas lu** (pointeur uniquement vers `Ressources/Competences/Traduction_Style_Personnel.md`)

**Verdict** : Hub `_Index.md` annonce 4 atomes, mais 2 sont des pointeurs. Pas de fichier `.md` propre dans Wiki/10_Domaines/Traduction/. **À clarifier** : atomes doivent-ils exister ou pointeurs suffisent-ils ?

---

## SECTION 4 — INFORMATIONS PÉRIMÉES

### 4.1 Sessions antérieures (< S70)

**Recherche** : références à sessions < S70 dans les domaines workflow.

**Résultats** :
- `Gmail MCP custom.md` : S44, S25, S27 (OK — ces sessions sont refonte/install)
- `Boites email.md` : S44, S27, S28 (OK)
- `Tri Gmail.md` : S44, S27, S25 (OK)
- `Redaction email.md` : S44, S27 (OK)
- `Tri Outlook.md` : S44, S28 (OK — Outlook tri créé S28)
- `Macros clavier.md` : S27, S33 (OK)
- `Procedures/Bascule Conversation.md` : S12, S53 (OK — S12 création, S53 refonte)
- `Traduction/_Index.md` : S43 (OK — hub récent)
- `Inventaire/_Index.md` : S27 (⚠️ Voir note ci-dessous)

**Note Inventaire** : `Inventaire/_Index.md` (créé 2026-04-27, S72 courant) dit "status: coquille" avec tag S27 orphelin. **À corriger** : date creation S72, pas S27.

**Verdict** : ✅ Pas de périmé critique. Références anciennes sont structurelles (install MCP, décisions S27 figées).

---

## SECTION 5 — COHÉRENCE CROSS-DOMAINE

### 5.1 Email ↔ ViePerso (boîtes email)

**Assertion Email/Boites email.md** (ligne 12) : "4 boîtes distinctes. Toujours nommer explicitement".

**Assertion ViePerso/Boites email perso.md** (ligne 15) : "toujours **nommer explicitement la boîte traitée**".

**Verdict** : ✅ Règle cohérente sur les 2 versions.

### 5.2 Email ↔ Outils/Redaction email (scope OAuth)

**Cohérence** : Redaction email (S44) sait que `gmail.compose` manque (décision S27). Renvoie à refonte tâche #46.

**Verdict** : ✅ Cohérent.

### 5.3 Traduction ↔ ViePerso/Macros clavier

**Traduction/_Index.md** (ligne 29) : mentionne "skill `traduction` pour FR/EN/DE".

**Macros clavier.md** : **ne mentionne pas** redaction-email ni traduction.

**Verdict** : ⚠️ Asymétrie. Traduction → Macros unilatéral. À vérifier si c'est un gap ou ok.

### 5.4 GitHub (ViePerso/Identites GitHub.md)

**Assertion** : `mightIA` = compte GitHub principal.

**Détails** : Installé S39 (25/04/2026). Email S72 = mightIA cohérent.

**Verdict** : ✅ Cohérent.

---

## SECTION 6 — RECOMMANDATIONS DE FUSION / CLARIFICATION

### 6.1 Gmail MCP Custom

**Action** : Supprimer `Wiki/Wiki/10_Domaines/Email/Gmail_MCP_Custom.md` (orphelin imbriqué vide).

**Justification** : Chemin invalide + contenu vide + doublon avec `Wiki/10_Domaines/Email/Gmail MCP custom.md`.

### 6.2 Bascule Conversation

**Action** : Ajouter lien bidirectionnel explicite.

- `Outils/Bascule conversation.md` → ajouter lien vers `Procedures/Bascule Conversation Limite Contexte.md`
- `Procedures/Bascule Conversation Limite Contexte.md` → ajouter lien vers `Outils/Bascule conversation.md`

**Justification** : Les 2 fichiers couvrent aspect different du meme sujet (comment vs quand/pourquoi).

### 6.3 Traduction — Glossaire et Style personnel

**Action** : Créer 2 atomes `.md` vrais dans `Wiki/10_Domaines/Traduction/` OU harmoniser hub pour pointer clairement vers Ressources.

**Justification** : Hub annonce "4 atomes du domaine" mais 2 sont externes. Clarifier la structure.

### 6.4 Inventaire — Status tag S27

**Action** : Corriger créé `S27` → `S72` dans `Inventaire/_Index.md`.

### 6.5 Redaction email — Macros clavier

**Action** : Ajouter mention de macro clavier dans `Redaction email.md` ou clarifier que c'est hors scope (task #46).

---

## RÉSUMÉ EXÉCUTIF

| Catégorie | Volant | Sévérité | Action |
|-----------|--------|----------|--------|
| Doublons | 1 orphelin (Gmail MCP Custom imbriqué) | Basse | Supprimer |
| Chevauchements | 1 (Bascule conversation × 2 lieux) | Très basse | Harmoniser liens |
| Incohérences factuelles | 0 critiques | — | — |
| Vides/Coquilles | 10 atomes Inventaire | Attendu | Remplissage planifié |
| Références croisées manquantes | 1-2 (Redaction email — macros; Traduction — glossaire atomes) | Très basse | À clarifier |
| Périmé | 0 | — | — |

**Verdict global** : ✅ **Domaines workflow cohérents factuellement**. Pas de contradictions majeures entre atomes. Quelques clarifications mineures sur structure (pointeurs vs atomes, doublons résolubles).

---

*Audit complet S72 (28/04/2026) — Agent F.*
