# Mode Réactif Jarvis — Architecture v1.1

**Version** : 1.1 (brouillon)
**Date** : 21 avril 2026
**Statut** : Document de référence — à valider par Mickael avant implémentation de la Phase 0

---

## 1. Principe directeur

Jarvis reste **l'agent unique**. Il fonctionne en deux modes complémentaires :

- **Mode conversationnel** (déjà en place) — Mickael discute avec Jarvis, Jarvis agit.
- **Mode réactif** (nouveau en v1.1) — Home Assistant émet des alertes, Jarvis les traite de façon semi-autonome selon un curseur d'autonomie configurable.

**Ce que le mode réactif n'est pas :**
- Pas un sous-agent séparé ("Jérôme" abandonné).
- Pas un daemon 24/7 qui tourne en tâche de fond.
- Pas un remplacement des notifications push iPhone pour les urgences critiques.

---

## 2. Schéma global

```
HOME ASSISTANT
    │
    │ automations.yaml (liste blanche d'événements)
    │
    ▼
notify.email → Gmail (filtre → label Jarvis-Alert)
    │
    │ [tampon — latence acceptable 15 min]
    │
    ▼
COWORK (PC Mickael allumé 24/24)
    │
    │ scheduled task toutes les 15 min
    │ → skill check-jarvis-alert
    │
    ▼
JARVIS
    │
    ├── lit le niveau d'autonomie actif
    ├── applique la règle de l'événement (action / propose / signaler / ignore)
    ├── logge dans memory/historique_reactif/AAAA-MM-JJ.md
    └── archive l'email traité

23h30 chaque jour :
    scheduled task → skill rapport-journalier-reactif
    → PDF envoyé à might57290@gmail.com
    → archive dans rapports/journalier/AAAA-MM-JJ.pdf
```

**Canal urgences critiques** (chauffage HS, intrusion, coupure réseau) :
HA → notification push iPhone **directe**, hors Jarvis. Jarvis ne prétend pas remplacer ce canal, il serait trop lent.

---

## 3. Les 5 niveaux d'autonomie

Fichier de config : `config/autonomie.yaml`
Niveau par défaut au démarrage : **3 (Prudent)**

| Niveau | Nom | Comportement |
|:---:|:---|:---|
| 5 | Max auto | Jarvis agit sur tous les événements classés *safe*, propose le reste |
| 4 | Équilibré | Actions *safe* auto, le reste en mode propose |
| 3 | Prudent *(défaut)* | Tout en mode propose, sauf debannissement IP (exception validée) |
| 2 | Signalement | Jarvis alerte uniquement, aucune action prise |
| 1 | Off réactif | Mode réactif éteint, seul le mode conversation reste actif |

La classification *safe / non-safe* de chaque événement est définie événement par événement en section 5.

---

## 4. Label Gmail `Jarvis-Alert`

### 4.1 Création côté Gmail

- **Label** : `Jarvis-Alert`
- **Filtre** : `Objet contient [JARVIS-ALERT]`
- **Actions du filtre** :
  - Appliquer le label `Jarvis-Alert`
  - Marquer comme important
  - **Ne jamais classer dans tri email quotidien** (exclure de la règle `tri-email-gmail`)
- **Conservation** : 30 jours puis archive automatique

### 4.2 Convention de sujet côté HA

Format normalisé pour tous les emails sortants des automations HA :

```
[JARVIS-ALERT] <type_evenement> | <gravite> | <entite>
```

Exemples :
- `[JARVIS-ALERT] ban_ip | high | 192.0.2.12`
- `[JARVIS-ALERT] log_erreur | high | sensor.zigbee_bridge`
- `[JARVIS-ALERT] update_dispo | low | hacs`

`gravite` ∈ `low` / `medium` / `high` — utilisée par Jarvis pour décider de l'ordre de traitement en cas de file d'attente.

---

## 5. Événements HA captés

*Section à remplir par Mickael et Jarvis après validation de ce document.*

### 5.1 Format d'un événement

```yaml
- id: ban_ip_detected
  description: "Détection d'un nouveau ban IP dans ip_bans.yaml"
  trigger_ha: "sensor.ha_ip_bans state changes"
  sujet_mail: "[JARVIS-ALERT] ban_ip | high | {{ new_ip }}"
  classification: safe
  action_par_niveau:
    5: debanish_auto
    4: debanish_auto
    3: debanish_auto    # exception règle 0 — validée en session 15
    2: signaler
    1: ignorer
  garde_fou: "max 3 debannissements / 24h, au-delà → signaler uniquement"
```

### 5.2 Liste prévue

**Phase 1 (événements safe)** :

- [ ] `ban_ip_detected` — détection ban IP dans `ip_bans.yaml`
- [ ] `log_erreur_critique` — ERROR/CRITICAL dans les logs HA

**Phase 2 (signalement)** :

- [ ] `update_ha_dispo` — nouvelle version HA Core disponible
- [ ] `update_addon_dispo` — MAJ d'un add-on installé disponible
- [ ] `cameras_stockage_plein` — seuil disque caméras dépassé
- [ ] `acces_ha_perdu` — test ping HA depuis Cowork échoue N fois de suite

**À compléter avec Mickael** :

- [ ] *(autres événements à identifier)*

---

## 6. Triple kill switch

### 6.1 Interrupteur global côté HA

Helper : `input_boolean.jarvis_mode_reactif`

- ON par défaut
- Si OFF → les automations HA n'envoient plus d'email `Jarvis-Alert`
- Accessible depuis l'app HA iPhone en 1 clic
- Carte Lovelace dédiée sur le dashboard admin (à créer)

### 6.2 Curseur d'autonomie côté Cowork

Fichier : `config/autonomie.yaml`

- Contient le niveau actif (1 à 5)
- Lu à chaque exécution de la skill `check-jarvis-alert`
- Modifiable par Mickael directement ou par Jarvis sur demande explicite

### 6.3 Flags par événement

Fichier : `config/reactif_events.yaml`

- Chaque événement a un champ `enabled: true | false`
- Permet de désactiver un type d'alerte précis sans toucher au reste
- Utilisé aussi pour suspendre temporairement un événement qui spam

---

## 7. Log + rapport journalier

### 7.1 Log temps réel

Dossier : `memory/historique_reactif/`
Un fichier par jour : `AAAA-MM-JJ.md`

Format d'une entrée :

```markdown
## 2026-04-21 14:23:17
- Événement : ban_ip_detected
- Source : sensor.ha_last_ban (192.0.2.12)
- Niveau autonomie : 3 (Prudent)
- Action : debannissement automatique
- Résultat : OK, IP supprimée de ip_bans.yaml
- Email source : Gmail message-id <xxxx>
```

### 7.2 PDF journalier par email

Skill : `rapport-journalier-reactif`
Scheduled task Cowork : **chaque jour à 23h30**

Contenu du PDF :
- En-tête : date, niveau d'autonomie actif, kill switch HA on/off
- Stats : nombre d'événements par type et par gravité
- Détail chronologique de chaque événement traité
- Actions en attente de validation de Mickael
- Anomalies ou erreurs internes rencontrées

Destination : **might57290@gmail.com**
Sujet : `[JARVIS] Rapport réactif AAAA-MM-JJ`
Archive locale : `rapports/journalier/AAAA-MM-JJ.pdf`

Si aucun événement dans la journée : pas d'email envoyé, simple ligne "RAS" ajoutée au log.

---

## 8. Ce que Jarvis NE fait PAS en v1.1

- Pas de **mise à jour automatique** HA Core ou add-ons — reporté post-migration Proxmox (v1.2).
- Pas d'accès aux **données sensibles** sans accord explicite (règle 0 du CLAUDE.md reste prioritaire).
- Pas de **polling haute fréquence** sur HA — c'est HA qui pousse les événements, pas Jarvis qui tire.
- Pas de remplacement des **notifications push iPhone** pour les urgences critiques.
- Pas de **boucle d'optimisation autonome** HA sans validation de Mickael.
- Pas de **sous-agent** (abandonné par décision du 21/04/2026).

---

## 9. Roadmap de build

| Phase | Contenu | Conditions |
|:---:|:---|:---|
| **0** | Fondations : ce doc, configs, kill switches, skeleton pipeline, skill rapport journalier | Validation de ce document |
| **1** | Événements *safe* : `ban_ip_detected`, `log_erreur_critique` | Phase 0 validée |
| **2** | Événements signalement : updates, stockage caméras, perte accès HA | Phase 1 validée |
| **3** | Update auto HA avec snapshot / rollback via API Proxmox | Migration du Raspberry Pi vers PC + Proxmox effectuée |

---

## 10. Points à trancher avant Phase 0

1. **Envoi email depuis HA** — passer par `notify.email` SMTP natif ou via intégration Gmail dédiée ?
2. **Règle de filtrage** — sujet `[JARVIS-ALERT]` seul (simple) ou combiné à un expéditeur dédié `jarvis-alert@...` (plus robuste) ?
3. **Dashboard Lovelace "Admin Jarvis"** — créer une carte regroupant kill switch + niveau d'autonomie actif + dernière alerte traitée ? (Recommandé.)
4. **Archivage des rapports** — PDFs uniquement en local, ou aussi synchronisés vers OneDrive et/ou Git privé ?
5. **Démarrage auto Cowork au boot Windows** — à faire dès maintenant ou plus tard ?

---

*Document de référence Mode Réactif Jarvis — v1.1 brouillon — 21 avril 2026*
*À valider par Mickael avant de démarrer la Phase 0.*

---

## 11. Décisions session 31 (22/04/2026) — Bascule CLI Option A

### Contexte

Le pipeline Phase 1 en scheduled task Cowork (15 min, check-jarvis-alert + rapport-journalier-reactif) livré en S29 a été activé en S31. Premier run automatique OK (RAS kill switch), deuxième run chargé. À 22:42 une boucle infinie a été détectée : 3 mails test retraités à chaque run car `gmail-mcp-local` (stdio) est **inaccessible depuis Cowork** (auto-memory `feedback_cowork_no_stdio`). Conséquence : pas d'archivage Gmail, donc retraitement permanent avec incrément des compteurs HA. Coût estimé (scheduled 15 min Cowork, system prompt ~30-50k tokens/run) : **1500-3000 $/mois** en tarif Opus. Pipeline non viable.

### Décision prise

Bascule **Option A : CLI complet** pour `check-jarvis-alert`. `rapport-journalier-reactif` reste en Cowork (Q2=a, 1 run/jour, coût marginal, skill PDF Cowork-friendly).

### Paramètres retenus (Q1-Q6)

| # | Question | Choix | Raison |
|---|---|---|---|
| Q1 | Cadence du check CLI | **30 min** (b) | Bon compromis réactivité/charge, Mode Réactif pas critique temps-réel |
| Q2 | Rapport journalier | **Cowork** (a) | 1 run/jour = coût marginal, skill PDF native Cowork |
| Q3 | Mode headless | **settings.local.json allowlist + denylist** (a) | Sûr, pattern validé S27 tri-gmail |
| Q4 | Label Gmail structure | **Hiérarchique `Jarvis-Alert/Traité`** (a) | Visuel clair, bascule label = archive propre, jamais TRASH |
| Q5 | Règle expéditeur | **Filtrage strict `might57290+jarvis@gmail.com`** (a) | Anti-spoofing, cohérent avec filtre Gmail S23 |
| Q6 | Fallback gmail-mcp-local | **Abort propre + log + no-op HA** (a) | Safe, évite d'incrémenter compteurs sur run dégradé |

### Mitigation sécurité — script HA dédié

En plus de Q3, une mitigation "moindre privilège" a été ajoutée : la skill CLI n'appelle **JAMAIS** `ha_call_service` en free-form sur les entités HA. Elle passe exclusivement par le script HA dédié `script.jarvis_reactif_log_alerte` créé S31, qui prend les champs (`type`, `gravite`, `entite`, `action_executee`, `increment_attente`) et effectue les 3 écritures (counter / input_text / input_number) en interne avec validation des champs.

Objectif : limiter le blast radius d'un bug/injection dans le prompt headless. Même si la skill CLI dérape, elle ne peut écrire que dans les 3 entités prévues — pas allumer/éteindre des lights, pas déclencher des automations, pas débloquer une serrure.

### Architecture mise à jour

```
HA automation → notify.might57290_gmail_com → Gmail filter → label Jarvis-Alert
    ↓
Windows Task Scheduler (30 min) — tâche "Jarvis-CheckAlert"
    ↓
scripts/check-jarvis-alert-launcher.ps1 (pré-filtre credentials age + claude -p headless)
    ↓
claude -p avec .claude/settings.local.json allowlist stricte
    ↓
skill check-jarvis-alert (9 étapes, outils stdio mcp__gmail-mcp-local__*)
    ├── ha_get_state (lecture kill switch + niveau + flags + compteurs) — SAFE
    ├── search_emails / read_email / modify_email (Gmail) — dans denylist pour delete/send
    ├── ha_call_service UNIQUEMENT sur script.jarvis_reactif_log_alerte — mitigation moindre privilège
    └── Write/Edit sur memory/historique_reactif/ + TASKS.md (allowlist pattern-restreint)
    ↓
Archivage label Jarvis-Alert/Traité (JAMAIS TRASH) → pas de boucle

23h30 : rapport-journalier-reactif (Cowork, reste inchangé)
```

### Livrables S31

- Script HA `script.jarvis_reactif_log_alerte` (storage HA, via `ha_config_set_script`)
- Skill `.claude/skills/check-jarvis-alert/SKILL.md` refondue CLI (9 étapes, règle 0, expéditeur filtré, pas de TRASH)
- Launcher `scripts/check-jarvis-alert-launcher.ps1` (modèle S27 tri-gmail)
- XML `scripts/jarvis-checkalert.xml` (UTF-16 LE BOM, 30 min, trigger CalendarTrigger + Repetition PT30M)
- `.claude/settings.local.json` étendu (ha_get_state + writes memory/historique_reactif + TASKS.md)
- Prompts brain/hands `scripts/brain-hands-bascule-cli-s31.md` pour les étapes stdio (label Jarvis-Alert/Traité, archivage 3 mails test, schtasks, dry-run, V1)

### Critère de validation V1 CLI

Après 2 runs auto consécutifs avec un mail test reçu entre-temps, vérifier que :
- `counter.jarvis_alertes_jour` a été incrémenté **exactement 1 fois** (pas de boucle).
- Le mail est passé de `Jarvis-Alert` à `Jarvis-Alert/Traité`.
- Le 2e run renvoie `RAS` (plus aucun mail non traité).

Si OK → Option A validée, bug S31 résolu définitivement. Scheduled task Cowork `check-jarvis-alert` à désactiver/supprimer.
