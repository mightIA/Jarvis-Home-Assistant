---
name: rapport-journalier-reactif
description: "Génère le rapport PDF quotidien des événements traités par le Mode Réactif Jarvis, l'archive en local/OneDrive, et envoie un mail récapitulatif à Mickael via le service HA notify. Utilise le pattern CLI headless (Claude Code) comme check-jarvis-alert. Déclenchée par la Task Scheduler Windows Jarvis-RapportJournalier chaque jour à 23h30."
---

# Skill — rapport-journalier-reactif

## Rôle

Produire un PDF synthétique de l'activité du Mode Réactif sur la journée écoulée, l'archiver localement (OneDrive sync passif), et notifier Mickael par email avec lien vers le PDF.

## Quand cette skill est déclenchée

- **Automatique** : Task Scheduler Windows `Jarvis-RapportJournalier` chaque jour à **23h30** (script `scripts/rapport-journalier-reactif-launcher.ps1`).
- **Manuel** : Mickael peut demander « génère le rapport du jour » depuis Claude Code CLI à tout moment.

## Mode d'exécution — ⚠️ CLI UNIQUEMENT

Comme `check-jarvis-alert` (S31), cette skill tourne via Claude Code CLI headless (`claude -p`), **pas via Cowork Desktop**.

Raisons :
- Le MCP `gmail-mcp-local` est stdio → non chargé par Cowork (auto-memory `feedback_cowork_no_stdio`).
- Cohérence architecturale : tout le pipeline Mode Réactif est en CLI depuis S31.
- Quota forfait Max : runs planifiés en heure creuse (23h30) pour préserver l'usage interactif journée.

Si Mickael demande un run manuel depuis Cowork : pattern **brain(Cowork) + hands(CLI)** — je prépare le prompt dans Cowork, Mickael lance `claude -p` côté PC.

## Architecture — source de vérité

| Élément | Source | Lecture | Écriture |
|---|---|---|---|
| Niveau d'autonomie actif | `input_select.jarvis_niveau_autonomie` | `ha_get_state` | Mickael (UI HA) |
| Kill switch global | `input_boolean.jarvis_mode_reactif` | `ha_get_state` | Mickael (UI HA) |
| Compteur alertes jour | `counter.jarvis_alertes_jour` | `ha_get_state` | script HA |
| Alertes en attente | `input_number.jarvis_alertes_attente` | `ha_get_state` | script HA |
| Historique détaillé | `memory/historique_reactif/AAAA-MM-JJ.md` | Read local | — |
| Config autonomie | `config/autonomie.yaml` | Read local | Humain |
| PDF généré | `rapports/journalier/AAAA-MM-JJ.pdf` | — | Write local |
| Notification mail | `notify.might57290_gmail_com` | — | `ha_call_service` |

## Principe sécu (cohérence S31)

- **Pas d'envoi mail via `send_email` / `draft_email` Gmail MCP** : ces outils sont en **deny** dans `settings.local.json` (scope OAuth `gmail.send` absent volontairement, Règle 0).
- **Envoi via service HA `notify.might57290_gmail_com`** : même canal que le rapport de tri-email-gmail (S27). Bug connu : exige `data.target=["might57290@gmail.com"]` sinon HTTP 500 (auto-memory locale `memory/feedback_notify_gmail_target.md`).
- **Pas de pièce jointe** : le service notify Gmail HA ne supporte pas les PJ fiablement. Le PDF est archivé dans `rapports/journalier/AAAA-MM-JJ.pdf` (synchronisé OneDrive), le mail contient juste le résumé texte + le chemin OneDrive cliquable.

## Outils utilisés

Côté Home Assistant (MCP `home-assistant`) :

| Outil | Usage |
|---|---|
| `ha_get_state` | Lecture niveau + kill switch + compteurs actuels |
| `ha_call_service` | **Restreint à `notify.might57290_gmail_com` uniquement pour cette skill** |

Côté système de fichiers (tools natifs Read/Write/Edit) :

| Outil | Usage |
|---|---|
| `Read` | Lecture `memory/historique_reactif/AAAA-MM-JJ.md` + `config/autonomie.yaml` |
| `Write` | Création PDF via skill `pdf` dans `rapports/journalier/` |
| `Edit` | Ajout d'une ligne `RAS - rapport exécuté HH:MM:SS` dans le log du jour si RAS |

**Outils interdits dans cette skill** (via `settings.local.json` deny + discipline prompt) :
`send_email`, `draft_email`, `delete_email`, et tout `ha_call_service` autre que `notify.might57290_gmail_com`.

## Workflow en 7 étapes

### Étape 1 — Initialisation

- Date du jour au format `AAAA-MM-JJ` (timezone Europe/Paris, cohérent avec le reste du Mode Réactif).
- Chemin du log : `memory/historique_reactif/AAAA-MM-JJ.md`.
- Chemin du PDF : `rapports/journalier/AAAA-MM-JJ.pdf`.
- Créer le dossier `rapports/journalier/` s'il n'existe pas.

### Étape 2 — Cas "rien à signaler"

Si le fichier de log du jour n'existe pas **ou** ne contient QUE des lignes `RAS` / `STOP kill_switch_off` / `STOP off_reactif` :

- Ajouter une ligne `RAS - rapport journalier exécuté HH:MM:SS` dans le log (créer le fichier si besoin avec header `# Historique Mode Réactif — AAAA-MM-JJ`).
- **Stop ici** : aucun PDF généré, aucun mail envoyé.
- Exit code 0.

### Étape 3 — Collecte des données

- Lire `config/autonomie.yaml` → niveau actif + historique des changements du jour (si tracé).
- Via `ha_get_state` → état de `input_boolean.jarvis_mode_reactif` + `input_select.jarvis_niveau_autonomie` + `counter.jarvis_alertes_jour` + `input_number.jarvis_alertes_attente` au moment du rapport.
- Parser `memory/historique_reactif/AAAA-MM-JJ.md` :
  - Nombre total d'événements traités (hors RAS)
  - Répartition par type et par gravité (low / medium / high)
  - Nombre d'actions auto effectuées (`debanish_auto`, `creer_tache`, etc.)
  - Nombre de propositions en attente (`propose`)
  - Nombre de signalements (`signaler`, `ignorer`)
  - Nombre d'erreurs internes (`ERROR *`)
  - Liste des spoof_attempts (`ERROR spoof_attempt from=...`)

### Étape 4 — Génération du PDF

Via la skill `pdf` (existante, skill côté `.claude/skills/pdf/SKILL.md`) → `rapports/journalier/AAAA-MM-JJ.pdf` avec la structure :

#### Page 1 — En-tête et état système
- Titre : `Rapport Mode Réactif Jarvis — AAAA-MM-JJ`
- Niveau d'autonomie actif au moment du rapport (ex : "3 - Prudent")
- État du kill switch HA (`input_boolean.jarvis_mode_reactif`)
- Changements de niveau intervenus dans la journée (si `config/autonomie.yaml` les trace)

#### Page 2 — Statistiques
- Tableau : nombre d'événements par type
- Tableau : nombre d'événements par gravité (low / medium / high)
- Camembert ou bar chart : actions auto vs propositions vs signalements vs erreurs

#### Page 3+ — Chronologie détaillée
- Une entrée par événement traité dans l'ordre chronologique du log
- Horodatage, type, gravité, entité, niveau actif, flag HA, garde-fou, action décidée, action exécutée, résultat, messageId Gmail

#### Page finale — Actions en attente + anomalies
- Liste des propositions en attente de validation de Mickael (depuis `memory/propositions_attente/`)
- Liste des erreurs internes rencontrées + spoof_attempts
- Recommandations éventuelles (ex : "flag `jarvis_event_log_erreur_critique` OFF depuis X jours → à re-valider")

### Étape 5 — Archivage local (OneDrive sync passif)

- Sauvegarder dans `rapports/journalier/AAAA-MM-JJ.pdf`.
- Le dossier `rapports/` étant inclus dans le sync OneDrive automatique, l'archivage cloud est gratuit.
- **Ne JAMAIS écraser** un PDF existant du même jour : si présent, ajouter suffixe `_v2`, `_v3`, etc.

### Étape 6 — Envoi mail via service HA notify

```
ha_call_service(
  domain="notify",
  service="might57290_gmail_com",
  data={
    "target": ["might57290@gmail.com"],
    "title": "[JARVIS] Rapport réactif AAAA-MM-JJ",
    "message": """Rapport quotidien du Mode Réactif Jarvis — AAAA-MM-JJ

Niveau actif : N (Nom)
Kill switch HA : ON|OFF
Événements traités : X (dont Y actions auto, Z propositions, W erreurs)

Propositions en attente de validation :
- <liste ou "aucune">

Erreurs à examiner :
- <liste ou "aucune">

PDF détaillé disponible :
OneDrive : C:\\Users\\Might\\OneDrive\\...\\rapports\\journalier\\AAAA-MM-JJ.pdf
Local    : D:\\Might\\IA\\Projets Cowork\\Jarvis - Home Assistant\\rapports\\journalier\\AAAA-MM-JJ.pdf
"""
  }
)
```

⚠️ **Le champ `target` est OBLIGATOIRE** sinon HTTP 500 ValueError (bug service HA Gmail découvert S27, auto-memory `feedback_notify_gmail_target.md`).

### Étape 7 — Fallback en cas d'erreur

- **Si le PDF échoue à se générer** → envoyer le mail en texte seul avec le résumé complet dans le corps, logger l'erreur dans `memory/historique_reactif/AAAA-MM-JJ.md` section `## HH:MM:SS — Rapport journalier`.
- **Si l'envoi du mail échoue** → logger l'erreur, sauvegarder le PDF localement quand même (l'archivage OneDrive reste utile), ré-essayer à la prochaine exécution (J+1).
- **Si les deux échouent** → logger, sortir avec exit code 2 (le launcher enverra un webhook HA d'alerte).

## Règles

- Ne JAMAIS supprimer le fichier `.md` de l'historique après génération du PDF (conservation permanente dans `memory/historique_reactif/`).
- Ne JAMAIS écraser un PDF existant du même jour → suffixe `_v2`, `_v3` si plusieurs exécutions.
- **Règle 0 (CLAUDE.md)** : ne jamais logger/afficher/persister un token/mdp/cookie aperçu dans un mail ou un log HA.
- Rester dans l'allowlist `.claude/settings.local.json` (pas de nouveau `ha_call_service` hors `notify.might57290_gmail_com`).

## Dépendances

| Dépendance | Où | Statut Phase 1 |
|---|---|---|
| Skill `pdf` | `.claude/skills/pdf/SKILL.md` | ✅ présente |
| MCP `home-assistant` (ha-mcp) | `.mcp.json` | ✅ installé S15-16 |
| Service HA `notify.might57290_gmail_com` | HA | ✅ S24 |
| Helpers HA (kill switch + niveau + compteurs) | Storage HA | ✅ S22-S24 |
| Fichier `config/autonomie.yaml` | Projet | ✅ |
| Dossier `memory/historique_reactif/` | Projet | ✅ |
| Dossier `rapports/journalier/` | Projet | ⏳ créé à la 1re exécution |
| Launcher `scripts/rapport-journalier-reactif-launcher.ps1` | Projet | ✅ S32 |
| Task Scheduler `Jarvis-RapportJournalier` (XML) | Windows | ✅ S32 |

## Décisions archi S32 (bascule CLI)

- **Q1 (S31) Q2 Mickael** : "oui bascule aussi" → rapport journalier passe de scheduled task Cowork à Task Scheduler Windows + Claude Code CLI headless.
- **Choix d'envoi mail** : via `notify.might57290_gmail_com` HA (pas de `send_email` Gmail MCP) pour rester cohérent avec la discipline `send/draft_email` deny en S27 (scope OAuth `gmail.send` volontairement absent). PDF en archive locale + OneDrive, mail en texte seul.
- **Cadence** : 1 run/jour à 23h30 heure Paris (minuit - 30 min pour avoir tous les events du jour).
- **Pas de fallback Gmail MCP** : si `notify.might57290_gmail_com` tombe, on accepte le saut d'une journée (PDF local reste accessible).
