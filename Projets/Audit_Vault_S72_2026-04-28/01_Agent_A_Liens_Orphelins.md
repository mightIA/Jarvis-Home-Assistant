# Audit Vault Obsidian — Liens et Orphelins

**Date** : 28 avril 2026  
**Vault** : `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Wiki\`  
**Fichiers analysés** : 143 fichiers .md  
**Périmètre** : Structure PARA (00_Index, 10_Domaines, 15_Hermes_Agent, 20_Projets, 30_References, 90_Archives)

---

## 1. Wikilinks Cassés (36 anomalies détectées)

### Résumé
- **Total wikilinks du vault** : 445
- **Wikilinks cassés** : 36
- **Taux de rupture** : 8,1%

### Liste complète des wikilinks cassés

| Fichier source | Cible non résolue |
|---|---|
| `00_Index/_Index.md` | `[[20_Projets/Hermes_Agent/_Plan]]` |
| `00_Index/_Index.md` | `[[20_Projets/Tri_Email_Multi/_Plan]]` |
| `10_Domaines/ADR/rejected/ADR-007-smart-connections-payant.md` | `[[wikilink]]` |
| `10_Domaines/Email/Envoi via Home Assistant.md` | `[[../HomeAssistant/Mode Reactif - Pipeline alertes]]` |
| `10_Domaines/HomeAssistant/Raccourcis clavier.md` | `[[../../30_References/Macros Clavier\|Macros Clavier]]` |
| `10_Domaines/Inventaire/_Index.md` | `[[Ressources/Competences/Home_Assistant_Inventaire]]` |
| `10_Domaines/Outils/Debannissement IP.md` | `[[10_Domaines/HomeAssistant/Debannissement IP]]` |
| `10_Domaines/README.md` | `[[Automation_Lumiere_Soir]]` |
| `10_Domaines/README.md` | `[[Setup_HA_Local]]` |
| `10_Domaines/README.md` | `[[URL_Locale_Distante]]` |
| `10_Domaines/Reseau/OpenRouter_Setup_Garde_fous.md` | `[[...]]` |
| `10_Domaines/Skills_Jarvis/Email_Tri_Auto.md` | `[[Wiki/10_Domaines/Email/Boites_Email]]` |
| `10_Domaines/Skills_Jarvis/Email_Tri_Auto.md` | `[[Wiki/10_Domaines/Email/Envoi_via_Home_Assistant]]` |
| `10_Domaines/Skills_Jarvis/Email_Tri_Auto.md` | `[[Wiki/10_Domaines/Email/Redaction_email]]` |
| `10_Domaines/Skills_Jarvis/Email_Tri_Auto.md` | `[[Wiki/10_Domaines/Email/Tri_Gmail_Automatise]]` |
| `10_Domaines/Skills_Jarvis/Email_Tri_Auto.md` | `[[Wiki/10_Domaines/Email/Tri_Outlook]]` |
| `10_Domaines/Skills_Jarvis/Email_Tri_Auto.md` | `[[Wiki/10_Domaines/Email/_Index]]` |
| `10_Domaines/Skills_Jarvis/Home_Assistant_Operations.md` | `[[Wiki/10_Domaines/Hardware/_Index]]` |
| `10_Domaines/Skills_Jarvis/Home_Assistant_Operations.md` | `[[Wiki/10_Domaines/Procedures_Rares/_Index]]` |
| `10_Domaines/Skills_Jarvis/Home_Assistant_Operations.md` | `[[Wiki/10_Domaines/Reseau_Securite/_Index]]` |
| `10_Domaines/Skills_Jarvis/Mode_Reactif.md` | `[[Wiki/10_Domaines/Email/Tri_Gmail_Automatise]]` |
| `10_Domaines/Skills_Jarvis/Mode_Reactif.md` | `[[Wiki/10_Domaines/Hardware/_Index]]` |
| `10_Domaines/Skills_Jarvis/Mode_Reactif.md` | `[[Wiki/10_Domaines/Procedures_Rares/_Index]]` |
| `10_Domaines/Skills_Jarvis/Setup_Install.md` | `[[Cloudflare_Access_HA]]` |
| `10_Domaines/Skills_Jarvis/Setup_Install.md` | `[[Wiki/10_Domaines/Procedures_Rares/_Index]]` |
| `10_Domaines/Skills_Jarvis/Setup_Install.md` | `[[Wiki/10_Domaines/Reseau_Securite/_Index]]` |
| `10_Domaines/Skills_Jarvis/Wiki_Vault.md` | `[[Wiki/10_Domaines/Hardware/_Index]]` |
| `10_Domaines/Skills_Jarvis/Wiki_Vault.md` | `[[Wiki/10_Domaines/Hermes_Agent/_Index]]` |
| `10_Domaines/Skills_Jarvis/Wiki_Vault.md` | `[[note]]` |
| `10_Domaines/Skills_Jarvis/Wiki_Vault.md` | `[[wikilinks]]` |
| `10_Domaines/Skills_Jarvis/_Index.md` | `[[Wiki/10_Domaines/...]]` |
| `10_Domaines/Skills_Jarvis/_Index.md` | `[[Wiki/10_Domaines/Email/_Index]]` |
| `10_Domaines/Skills_Jarvis/_Index.md` | `[[Wiki/10_Domaines/Hermes_Agent/_Index]]` |
| `10_Domaines/ViePerso/Abonnements.md` | `[[10_Domaines/Hardware]]` |
| `README.md` | `[[double crochets]]` |
| `README.md` | `[[wikilinks]]` |

### Patterns observés
- **Skills_Jarvis** : 9 wikilinks cassés (25% du total) — tous contiennent le préfixe `Wiki/` qui n'existe pas
- **Chemins relatifs mal résolus** : References à `../HomeAssistant/Mode Reactif - Pipeline alertes` (espace dans le nom)
- **Placeholder temporaires** : `[[...]]`, `[[wikilink]]`, `[[note]]`

---

## 2. Liens Markdown Cassés

### Résultat
- **Total liens markdown** : 83
- **Liens cassés** : 0

Tous les chemins relatifs `.md` trouvés dans les structures `[texte](chemin.md)` résolvent vers des fichiers existants. Aucune anomalie détectée.

---

## 3. Atomes Orphelins (11 fichiers)

Fichiers n'étant référencés par aucun autre fichier du vault. Les hubs (_Index.md, _README.md, README.md, INDEX.md) sont exclus du calcul car ils sont des points d'accès normalement non référencés.

### Liste des orphelins

1. `10_Domaines/Domotique/Browser Mod.md`
2. `10_Domaines/Email/Boites_Email.md`
3. `10_Domaines/Email/Redaction_email.md`
4. `10_Domaines/Email/Tri_Gmail_Automatise.md`
5. `10_Domaines/Email/Tri_Outlook.md`
6. `10_Domaines/Outils/Browser Mod.md`
7. `10_Domaines/Procedures/Debannissement IP.md`
8. `10_Domaines/ViePerso/Anniversaires_Dates_Cles.md`
9. `10_Domaines/ViePerso/Contacts_Pro.md`
10. `20_Projets/Hardware_Upgrade/00_Decisions_et_audits.md`
11. `20_Projets/Hardware_Upgrade/Documentation/Sources/ChatGPT_Conv_Originale.md`

### Note importante
Deux fichiers partagent le même nom `Browser Mod.md` :
- `10_Domaines/Domotique/Browser Mod.md`
- `10_Domaines/Outils/Browser Mod.md`

Cela peut créer une ambiguïté lors de la résolution de wikilinks dans Obsidian.

---

## 4. Anomalies de Chemin

### Résultat
**Aucune anomalie détectée.**

Critères vérifiés :
- Pas de doublons de segments consécutifs (ex. `Wiki/Wiki/`, `10_Domaines/10_Domaines/`)
- Pas de boucles de répertoires apparentes
- Structure conforme aux conventions PARA

---

## 5. Incohérence de Casse / Nommage

### Résultat
**Aucune incohérence détectée.**

Aucune paire de fichiers n'existe avec le même nom à la casse près (ex. `Gmail.md` vs `gmail.md`).

---

## 6. Statistiques Globales

| Métrique | Valeur |
|---|---|
| **Fichiers .md totaux** | 143 |
| **Répertoires principaux** | 6 (00_Index, 10_Domaines, 15_Hermes_Agent, 20_Projets, 30_References, 90_Archives) |
| **Wikilinks totaux** | 445 |
| **Wikilinks cassés** | 36 |
| **Taux de rupture** | 8,1% |
| **Liens markdown internes** | 83 |
| **Liens markdown cassés** | 0 |
| **Fichiers orphelins** | 11 |
| **Chemin anomalies** | 0 |
| **Casse incohérences** | 0 |

---

## Synthèse des Findings

### État de santé générale : Bon (82% des wikilinks fonctionnels)

### Principaux problèmes identifiés

1. **Foyer de ruptures : Skills_Jarvis (critique)**
   - 9 wikilinks cassés sur 36 (25%)
   - Cause : Utilisation systématique du préfixe `Wiki/` devant les chemins
   - Exemple : `[[Wiki/10_Domaines/Email/Boites_Email]]` au lieu de `[[../Email/Boites_Email]]`
   - **Impact** : Rend les fichiers skills inaccessibles via navigation interne

2. **Orphelins dispersés (priorité normale)**
   - 11 fichiers isolés, principalement en Email, ViePerso et Hardware_Upgrade
   - Suggère des contenus spécialisés non intégrés à la navigation principale

3. **Doublons de noms (risque de confusion)**
   - `Browser Mod.md` en double (Domotique vs Outils)
   - Peut causer des résolutions ambigües dans les wikilinks non qualifiés

4. **Chemins relatifs mal résolus**
   - Espaces dans les noms de fichiers (`Mode Reactif - Pipeline alertes`) non échappés
   - Résolution relative instable (`../HomeAssistant/...`)

### Force du vault
- 0 lien markdown cassé → les chemins relatifs externes sont solides
- Pas d'anomalies structurelles → structure PARA bien respectée
- 92% des références wikilink fonctionnelles → cohésion globale acceptable

