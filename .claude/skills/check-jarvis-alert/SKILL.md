---
name: check-jarvis-alert
description: "Pipeline de traitement des alertes Mode Réactif Jarvis. Lit les mails Gmail avec label Jarvis-Alert, applique le niveau d'autonomie actif, appelle le script HA dédié pour logger l'action, archive le mail. Utilise les outils stdio mcp__gmail-mcp-local__* (CLI uniquement). Déclenchée par la Task Scheduler Windows Jarvis-CheckAlert toutes les 30 minutes."
---

# Skill — check-jarvis-alert

## Rôle

Traiter les alertes `[JARVIS-ALERT]` envoyées par Home Assistant via Gmail, selon le niveau d'autonomie configuré côté HA, de façon semi-autonome et tracée.

## Quand cette skill est déclenchée

- **Automatique** : Task Scheduler Windows `Jarvis-CheckAlert` toutes les 30 minutes (script `scripts/check-jarvis-alert-launcher.ps1`).
- **Manuel** : Mickael peut demander « vérifie les alertes » depuis Claude Code CLI à tout moment.

## Mode d'exécution — ⚠️ CLI UNIQUEMENT

Le serveur MCP `gmail-mcp-local` est en transport **stdio** : il est **chargé uniquement par Claude Code CLI**, pas par Cowork Desktop (découvert S26, auto-memory `feedback_cowork_no_stdio`).

Conséquences pratiques :

- Toute exécution se fait depuis `claude` CLI, dans `D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant`.
- Si je suis en Cowork quand Mickael demande un run manuel : pattern **brain(Cowork) + hands(CLI)** obligatoire (S19). Je prépare le prompt dans Cowork, Mickael lance `claude` CLI pour exécuter.
- La Task Scheduler Windows lance `claude -p` headless avec `settings.local.json` allowlist.

## Architecture — source de vérité

| État | Source | Lecture | Écriture |
|---|---|---|---|
| Niveau d'autonomie actif | `input_select.jarvis_niveau_autonomie` | `ha_get_state` | Mickael (UI HA) |
| Kill switch global | `input_boolean.jarvis_mode_reactif` | `ha_get_state` | Mickael (UI HA) |
| Flag par événement | `input_boolean.jarvis_event_<id>` | `ha_get_state` | Mickael (UI HA) |
| Compteur alertes jour | `counter.jarvis_alertes_jour` | `ha_get_state` | **`script.jarvis_reactif_log_alerte`** |
| Dernière alerte | `input_text.jarvis_derniere_alerte` | `ha_get_state` | **`script.jarvis_reactif_log_alerte`** |
| Alertes en attente | `input_number.jarvis_alertes_attente` | `ha_get_state` | **`script.jarvis_reactif_log_alerte`** |
| Définition des événements | `config/reactif_events.yaml` | Read local | Humain |
| Historique par jour | `memory/historique_reactif/AAAA-MM-JJ.md` | — | Write local |

**Principe sécu (mitigation S31)** : la skill n'appelle JAMAIS `ha_call_service` en free-form pour écrire dans HA. Elle passe exclusivement par le script HA dédié `script.jarvis_reactif_log_alerte` (point d'entrée unique, champs validés côté HA). Ceci limite le blast radius d'un éventuel bug/injection dans le prompt CLI headless.

## Outils MCP utilisés

Tous préfixés `mcp__gmail-mcp-local__` (stdio) :

| Outil | Usage |
|---|---|
| `search_emails` | Lister les threads `label:Jarvis-Alert -label:Jarvis-Alert/Traité` |
| `read_email` | Lire headers + corps pour parsing du sujet et de l'expéditeur |
| `modify_email` | Archivage : `+Jarvis-Alert/Traité` et `-Jarvis-Alert` après traitement |
| `list_email_labels` | Vérifier existence du label `Jarvis-Alert/Traité` (créer au besoin) |
| `create_label` | Créer `Jarvis-Alert/Traité` si absent (première exécution) |

Côté Home Assistant (MCP `home-assistant`) :

| Outil | Usage |
|---|---|
| `ha_get_state` | Lecture pré-requis (niveau, kill switch, flags, compteurs actuels) |
| `ha_call_service` | **Restreint à `script.turn_on` sur `script.jarvis_reactif_log_alerte` uniquement** |

**Outils interdits dans cette skill** (via `settings.local.json` deny + discipline prompt) :
`delete_email`, `batch_delete_emails`, `send_email`, `draft_email`, et tout `ha_call_service` autre que `script.jarvis_reactif_log_alerte`.

## Règles de sécurité

1. **Règle 0 (CLAUDE.md)** : ne JAMAIS logger, afficher ou persister un token, mot de passe, cookie, ou tout contenu sensible aperçu dans un mail.
2. **Expéditeur filtré** : rejeter tout mail dont le champ `from` n'est PAS strictement `might57290@gmail.com` (l'alias `+jarvis` est le DESTINATAIRE, pas l'expéditeur — c'est Gmail qui route via l'alias, HA envoie depuis le compte principal `might57290@gmail.com` via `notify.might57290_gmail_com`). Si un attaquant envoie un mail avec sujet `[JARVIS-ALERT]` vers l'alias depuis une autre adresse, il matchera le filtre Gmail mais sera rejeté ici + log `ERROR spoof_attempt from=<adresse>`, **pas** archivé (Mickael pourra le voir dans `Jarvis-Alert`). Tolérance parsing : majuscules/minuscules, espaces, format `Name <email>`.
3. **Pas de ha_call_service free-form** : uniquement `script.jarvis_reactif_log_alerte`.
4. **Pas d'envoi de mail** : `send_email` et `draft_email` sont en deny. Si besoin de notifier Mickael au-delà du log, utiliser `persistent_notification.create` côté HA — mais *non implémenté Phase 1* (à ajouter plus tard si utile).
5. **Pas de suppression** : le mail traité est **archivé** via bascule de label, jamais supprimé. Mickael garde une trace.
6. **En cas d'erreur** : pas d'archivage, le mail reste dans `Jarvis-Alert` et sera retenté au run suivant. Après 5 erreurs consécutives sur le même `message-id` (compté dans le log du jour) → déplacer en label `Jarvis-Alert/Erreur` + log `ERROR max_retries`.

## Workflow en 9 étapes

### Étape 0 — Préparation

0.1 Vérifier que le label `Jarvis-Alert/Traité` existe (via `list_email_labels`). Si absent : `create_label(name="Jarvis-Alert/Traité")`.

0.2 Vérifier que le fichier du jour `memory/historique_reactif/AAAA-MM-JJ.md` existe. Si absent : le créer avec header `# Historique Mode Réactif — AAAA-MM-JJ`.

### Étape 1 — Pré-requis HA (lecture seule)

En un seul appel `ha_get_state` avec la liste des 3 entités :

- `input_boolean.jarvis_mode_reactif`
- `input_select.jarvis_niveau_autonomie`
- `counter.jarvis_alertes_jour` (pour le log, pas gating)

**Conditions d'arrêt** :
- Si `jarvis_mode_reactif` = `off` → log `STOP kill_switch_off`, sortir propre (pas d'erreur, pas de Gmail).
- Extraire le niveau entier depuis `input_select.jarvis_niveau_autonomie` state (ex `"3 - Prudent"` → `3`).
- Si niveau == `1` → log `STOP off_reactif`, sortir propre.

### Étape 2 — Recherche des alertes en attente

`search_emails(query="label:Jarvis-Alert -label:Jarvis-Alert/Traité", maxResults=50)`.

Si 0 résultat → log `RAS`, sortir propre.

### Étape 3 — Pour chaque thread trouvé (boucle)

Pour chaque messageId :

3.1 `read_email(messageId)` pour récupérer `from`, `subject`, `date`.

3.2 **Contrôle expéditeur** : si `from` ≠ `might57290@gmail.com` (tolérance : majuscules, espaces, format `Name <email>`) → log `ERROR spoof_attempt from=<email> subject=<sujet>`, **ne pas archiver**, passer au suivant. ⚠️ C'est bien le compte `might57290@gmail.com` (compte principal de Mickael, d'où HA envoie via `notify.might57290_gmail_com`), PAS l'alias `+jarvis` qui est le destinataire.

3.3 **Parse du sujet** : format attendu `[JARVIS-ALERT] type | gravite | entite`.
- Si format invalide → log `ERROR malformed subject=<sujet>`, **ne pas archiver**, passer au suivant.
- Extraire `type`, `gravite` (low/medium/high), `entite`.

3.4 **Recherche de l'événement** dans `config/reactif_events.yaml`.

⚠️ **Règle de matching** (clarification S31, dry-run) : le `type` parsé du sujet (ex `log_erreur`) ne correspond PAS toujours strictement à l'`id` YAML (ex `log_erreur_critique`). Le sujet est construit par HA à partir de `sujet_mail_pattern` qui utilise une forme courte par lisibilité humaine. Le matching doit donc être fait sur le **préfixe du champ `sujet_mail_pattern`** de chaque événement YAML :
- Pour chaque événement YAML : extraire le 1er token utile du `sujet_mail_pattern` (ex `sujet_mail_pattern: "[JARVIS-ALERT] log_erreur | {{ gravite }} | {{ logger }}"` → token = `log_erreur`).
- Comparer ce token au `type` parsé du sujet reçu.
- Premier match gagne. Si aucun event YAML ne matche → log `ERROR unknown_event type=<type>`, archiver quand même (évite boucle).

Cas particuliers :
- Si un `enabled: false` match → log `SKIPPED disabled id=<id YAML>`, archiver.
- Si le fichier YAML est malformé → log `ERROR yaml_parse`, ne pas archiver, alerter Mickael.

3.5 **Flag HA par événement** : `ha_get_state(flag_ha)` lu depuis le YAML (champ `flag_ha`).
- Si OFF → log `SKIPPED flag_off type=<type>`, archiver.

### Étape 4 — Décision selon le niveau

Récupérer `action_par_niveau[niveau_actif]` depuis le YAML.

Actions possibles :

| Action | Comportement |
|---|---|
| `debanish_auto` | Invoquer skill `debannissement-ip` (si disponible en CLI) puis log résultat. **Phase 1 limitée** : si la skill n'est pas disponible CLI → basculer en `signaler` + noter `SKIPPED debanish_auto cli_unavailable` |
| `creer_tache_et_analyser` | Ajouter ligne dans `TASKS.md` section "Créées auto Mode Réactif" + log contexte |
| `creer_tache` | Ajouter ligne dans `TASKS.md` section "Créées auto Mode Réactif" |
| `propose` | Créer fichier `memory/propositions_attente/AAAA-MM-JJ_HH-MM_<type>.md` avec le contexte et la proposition. Incrémenter `input_number.jarvis_alertes_attente` (via script HA, param `increment_attente=true`) |
| `signaler` | Aucune action externe, log uniquement (compteur jour sera incrémenté à l'étape 5) |
| `ignorer` | Log + archive, aucune action |

### Étape 5 — Garde-fous

Avant d'exécuter l'action, vérifier `garde_fou` de l'événement :

- **`max N X / 24h`** (ex `max 3 debannissements / 24h`) : compter les entrées `debanish_auto` OK dans les logs `memory/historique_reactif/*.md` des 24 dernières heures. Si ≥ N → basculer en `signaler` + log `GARDE_FOU_DECLENCHE`.
- **`max N par X / heure`** (ex `max 1 alerte par logger / heure`) : idem, vérif heure glissante.

### Étape 6 — Exécution de l'action

Appeler le script HA dédié **dans tous les cas** (y compris `ignorer` et `skipped` — pour traçage uniforme) :

```
ha_call_service(
  domain="script",
  service="turn_on",
  entity_id="script.jarvis_reactif_log_alerte",
  data={
    "variables": {
      "type": "<type>",
      "gravite": "<gravite>",
      "entite": "<entite>",
      "action_executee": "<action finale après garde-fou>",
      "increment_attente": <true si action == propose, sinon false>
    }
  }
)
```

Si `action` == `debanish_auto` et skill dispo : exécuter la skill en supplément.
Si `action` == `creer_tache` ou `creer_tache_et_analyser` : éditer `TASKS.md`.
Si `action` == `propose` : créer fichier `memory/propositions_attente/...md`.

### Étape 7 — Archivage Gmail

Uniquement si l'étape 6 a réussi :

```
modify_email(
  messageId=<id>,
  addLabelIds=["Jarvis-Alert/Traité"],
  removeLabelIds=["Jarvis-Alert", "INBOX"]
)
```

⚠️ **Ne JAMAIS** ajouter `TRASH` dans `addLabelIds` — le mail doit rester accessible pour audit.

⚠️ **Toujours retirer `INBOX`** dans `removeLabelIds` (patch S32) : sans ça, le mail garde le label `Jarvis-Alert/Traité` mais reste visible dans l'inbox principale, ce qui encombre visuellement Mickael. L'archivage Gmail se fait en retirant `INBOX`. Bug découvert fin S31 sur les 4 mails test.

### Étape 8 — Logging mémoire

Ajouter une entrée dans `memory/historique_reactif/AAAA-MM-JJ.md` :

```markdown
## HH:MM:SS
- Événement : <type>
- Gravité : <gravite>
- Entité : <entite>
- Niveau autonomie : <niveau_actif> (<nom_niveau>)
- Flag HA : <ON|OFF>
- Garde-fou : <OK|DECLENCHE raison>
- Action décidée : <action_par_niveau>
- Action exécutée : <action après garde-fou>
- Résultat : <OK|ERROR message>
- Gmail messageId : <id>
- Déclencheur : <Task Scheduler|manuel>
```

### Étape 9 — Ordre de priorité (si plusieurs mails)

Trier les mails avant traitement :

1. `gravite: high` d'abord
2. Puis `gravite: medium`
3. Puis `gravite: low`
4. À gravité égale : ordre chronologique (plus ancien d'abord)

Si plus de 10 mails en attente → log `WARNING backlog=<N>`, traiter quand même dans l'ordre (pas de cap — on veut rattraper).

## Fin de run

En fin de boucle, logger une ligne de synthèse dans `memory/historique_reactif/AAAA-MM-JJ.md` :

```markdown
## HH:MM:SS — Fin de run
- Mails trouvés : <N>
- Traités : <N_ok>
- Erreurs (non archivés) : <N_err>
- Sorties propres (kill switch / niveau 1 / RAS) : <oui|non>
```

## Dépendances

| Dépendance | Où | Statut Phase 1 |
|---|---|---|
| MCP `gmail-mcp-local` stdio | `.mcp.json` | ✅ installé S25 |
| MCP `home-assistant` (ha-mcp) | `.mcp.json` | ✅ installé S15-16 |
| Script HA `jarvis_reactif_log_alerte` | Storage HA | ✅ créé S31 |
| Label Gmail `Jarvis-Alert` | Gmail web | ✅ S23 |
| Label Gmail `Jarvis-Alert/Traité` | Gmail web | ⏳ à créer au 1er run (auto) |
| Helpers HA (kill switch + niveau + flags + compteurs) | Storage HA | ✅ S22-S24 |
| Fichier `config/reactif_events.yaml` | Projet | ✅ S24 |
| Skill `debannissement-ip` CLI | `.claude/skills/` | ⚠️ à vérifier dispo CLI |

## Évolutions prévues (hors Phase 1)

- **Phase 2** : activation des 4 événements signalement (`update_ha_dispo`, `update_addon_dispo`, `cameras_stockage_plein`, `acces_ha_perdu`).
- **Phase 3** : update HA auto avec snapshot Proxmox (après migration #41).
- **Optimisation future** : mode push (HA webhook → Task Scheduler trigger) au lieu de pull 30 min, pour baisser encore la latence et la charge.
