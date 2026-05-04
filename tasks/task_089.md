---
id: 89
title: "Intégrer `script.jarvis_voice` aux 3 workflows Jarvis (rapport 23h30, alertes, tri Gmail)"
status: pending
priority: P3
session_opened: S84
session_inprogress: S85
session_paused: S91
tags: [tts, piper, workflows, rapport-journalier, mode-reactif, tri-email]
source: "Session 84 / Suite T#53 — création script.jarvis_voice mais intégration aux workflows reportée"
---

# T#89 — Intégration `script.jarvis_voice` aux workflows Jarvis

## Contexte

T#53 a livré le script HA `script.jarvis_voice` (S84), qui :
- Diffuse un message TTS Piper (`fr_FR-gilles-low`) sur HomePod salle de bain + Samsung TV salon si `person.mickael == home`.
- Envoie une notif push iPhone systématique (fallback distance).

L'intégration aux 3 workflows existants n'a pas été faite en S84, faute de temps + push iPhone cassé (T#88 bloquant pour le canal push).

## Périmètre

Brancher `script.jarvis_voice` dans 3 workflows :

### 1. Rapport journalier 23h30 (Mode Réactif)

- Skill : `.claude/skills/rapport-journalier-reactif/SKILL.md`
- Trigger actuel : Task Scheduler Windows 23h30 → script Python qui génère PDF + envoie email via `notify.might57290_gmail_com`
- Ajout : appel `script.jarvis_voice` avec résumé court (1 phrase) en plus de l'email PDF
- Exemple message : « Bonsoir Mickael. Rapport du jour : 3 alertes traitées, 0 ban IP, 12 emails triés. Détails par mail. »

### 2. Alertes [JARVIS-ALERT] (Mode Réactif)

- Skill : `.claude/skills/check-jarvis-alert/SKILL.md`
- Trigger actuel : Task Scheduler Windows toutes les 15 min → script Python qui scanne label Gmail `Jarvis-Alert`
- Ajout : appel `script.jarvis_voice` à chaque alerte traitée (selon niveau d'autonomie HA)
- Exemple message : « Alerte Frigate : mouvement détecté dans la zone couloir. Action : enregistrement clip 30 secondes. »

### 3. Tri email Gmail (matin + après-midi)

- Skill : `.claude/skills/tri-email-gmail/SKILL.md`
- Trigger actuel : Cron 5h / 14h → tri auto via MCP Gmail
- Ajout : appel `script.jarvis_voice` à la fin du tri pour signaler la complétion
- Exemple message : « Bonjour Mickael, le tri Gmail du matin est terminé. 24 mails traités, 3 prioritaires laissés en boîte de réception. »

## Architecture retenue (révision S85, 02/05/2026)

Décisions prises avec Mickael en session S85 :

- **MCP direct** (pas de helper Python) — chaque skill appelle directement `mcp__home-assistant__ha_call_service` sur `script.jarvis_voice`. Plus simple que la version Python initialement proposée, déjà disponible dans toutes les skills CLI.
- **Étape 3 (alertes) chaînée HA-side** — pas de modif allowlist `.claude/settings.local.json`, c'est `script.jarvis_reactif_log_alerte` qui appelle `script.jarvis_voice` en interne. Discipline « point d'entrée unique » S31 conservée.
- **Filtre niveau autonomie + gravité** côté HA pour anti-spam vocal : N5=all, N3-4=high+medium, N2=high seul, N1=silence (cohérent avec mode réactif éteint).
- **Anti-spam tri Gmail** : voix uniquement sur runs cron 5h/14h, pas sur runs manuels, pas si RAS (0 mail traité).
- **Cas RAS rapport** : pas de voix (cohérent avec absence de mail).

## Pré-requis

- ✅ `script.jarvis_voice` créé (S84)
- ⚠️ T#88 (push iPhone payload vide) confirmé S85 lors test partiel — **pas bloquant** : push titre OK, payload vide acceptable comme fallback distance le temps du fix
- ✅ `HA_LONG_LIVED_TOKEN` déjà présent dans `.env` (cf. config existante)

## Avancement S85 (02/05/2026)

### ✅ Étape 3 — Chaînage TTS HA-side (DONE)

- Modifié `script.jarvis_reactif_log_alerte` via `ha_config_set_script` (mode `python_transform`, config_hash optimistic locking)
- Ajout 4e action conditionnelle qui appelle `script.jarvis_voice` selon niveau autonomie + gravité (mapping ci-dessus)
- Test partiel **OK** : appel chaîné confirmé via MCP (3 entités triggered même context_id), 2 push iPhone reçus avec titre `Jarvis - Alerte high`, payload vide (T#88 confirmé). Test vocal complet HomePod + TV salon au retour Might-1000D (besoin `person.mickael == home`).

### ✅ Étape 1 — `rapport-journalier-reactif/SKILL.md` (PATCH APPLIQUÉ)

- Ajout étape 6b après étape 6a (envoi mail) : appel `script.jarvis_voice` avec message court récapitulatif. Annonce d'erreur si étape 6a échoue.
- Mise à jour 7 sections (frontmatter, outils utilisés, outils interdits, dépendances, règles, workflow étapes 6a/6b, principe sécu).
- Pas d'annonce vocale en cas RAS (cohérent avec « pas de mail »).
- Application via `_patches_s85/apply_patches.ps1` (Copy-Item depuis `_patches_s85/dot_claude/`, sandbox Cowork bloque Edit direct sur `.claude/`).
- Backup conservé dans `_patches_s85/backup_20260502_085225/`.

### ✅ Étape 2 — `tri-email-gmail/SKILL.md` (PATCH APPLIQUÉ)

- Ajout étape 9bis après étape 9 (confirmation finale) : appel `script.jarvis_voice` avec récap mails traités + prioritaires.
- Filtre **cron-only** : voix uniquement sur runs 5h/14h, pas sur runs manuels (anti-spam vocal).
- Filtre **anti-RAS** : pas d'annonce si 0 mail traité.
- Formules de salutation différenciées 5h (« Bonjour ») vs 14h (« le tri de l'après-midi est terminé »).
- Application via même script Copy-Item, même backup.

### ✅ Mise à jour `.claude/settings.local.json` (PATCH APPLIQUÉ)

- Note documentaire `_note_ha_call_service` étendue à `script.jarvis_voice` (allowlist technique inchangée, juste précision intent).

### ⏳ Tests fonctionnels CLI (au retour Might-1000D)

À faire dès que Mickael est rentré à la maison :

1. Test rapport-journalier-reactif via `claude -p` (mode test, sans envoi mail réel)
2. Test tri-email-gmail via `claude -p` (run forcé manuel pour valider qu'on ne déclenche PAS la voix en mode manuel)
3. Test alertes [JARVIS-ALERT] avec un mail de test → validation vocale audible (HomePod + TV salon, person.mickael=home)

### ⏳ Sauvegarde Might-KT → Might-1000D au retour

Les patches ont été appliqués sur le laptop Might-KT (en déplacement). Au retour à la maison, **refaire la sauvegarde manuelle habituelle Might-KT → Might-1000D** pour propager les `.claude/` modifs (sinon prisonniers du laptop).

## Pièges découverts S85

- **Sandbox Cowork bloque `.claude/` en écriture** : Edit/Write impossibles sur `.claude/skills/*` ou `.claude/settings.local.json` depuis Cowork desktop. Workaround : préparer fichiers dans `_patches_s85/dot_claude/` puis Copy-Item PowerShell. Documenté dans `feedback_sync_manuelle_postes.md` (auto-memory Cowork).
- **MCP `script.jarvis_reactif_log_alerte` HTTP 500** quand appelé via `ha_call_service` avec `domain="script", service="jarvis_reactif_log_alerte"` directement. Bon pattern : `domain="script", service="turn_on", entity_id="script.NAME", data={"variables": {...}}`. Re-vérifié S85, déjà documenté en `feedback_mcp_call_service_script_entity_id.md` S84.
- **Might-KT en déplacement** : pas de Node, pas de Claude Code CLI, pas de Task Scheduler Jarvis-* (l'infra CLI tourne sur Might-1000D). Découverte S85, documentée en auto-memory `reference_postes_mickael.md` (Cowork) — était une zone d'ombre dans CLAUDE.md / mémoires précédentes.

## Avancement S91 (03/05/2026) — Test 0 ping direct + résolution canal TV

### ✅ Test 0 — `script.jarvis_voice` ping direct

- **HomePod salle de bain** (AirPlay HA natif via `media_player.salle_de_bain`) : message audible. Validé deux fois.
- **TV Q80 salon** : ❌ d'abord muet via `media_player.samsung_q80_series_65` (intégration Samsung Smart TV WS / Tizen — bug connu : ne forwarde pas le `tts.speak`).
- **Push iPhone** : ⚠️ T#88 reconfirmé S91 — push reçu avec **titre OK** mais **message vide** (1er test : VPN actif iPhone bloquait totalement la notif HA Companion).

### ✅ Diagnostic + résolution canal TV salon (Music Assistant DLNA)

Découverte : HA expose **3 entités** pour la même TV via 3 intégrations parallèles :

| Entité | Intégration | Verdict |
|---|---|---|
| `media_player.samsung_q80_series_65` | Samsung Smart TV WS (Tizen) | TTS muet |
| `media_player.samsung_q80_series_65_2` | **Music Assistant** (`app_id: music_assistant`, `device_class: speaker`) | **TTS OK via DLNA** ✅ |
| `media_player.tv_samsung_q80_series_65` | Custom `[TV]` (intégration ?) | Non testée |

Le player Music Assistant `_2` expose 3 protocoles : AIRPLAY, SENDSPIN, DLNA. Par défaut `Preferred Output Protocol = Auto-select` → choisit AirPlay → demande code de pairage à la TV (timeout, jamais validé).

**Solution appliquée** : Music Assistant → Paramètres → Lecteurs → Samsung Q80 Series (65) → ⚙️ Configurer → section « Paramètres du protocole » → toggle **« Enable AirPlay support » désactivé** + redémarrage add-on Music Assistant Server. Force DLNA.

Résultat : annonce TTS audible sur TV avec ducking auto Chérie FM (volume 44% → 75% pendant l'annonce, conforme paramètres MA `Volume for Announcements: 85, Max: 75`).

### ✅ Patch `script.jarvis_voice` (config_hash optimistic locking)

Modification chirurgicale via `ha_config_set_script` python_transform :

```python
config['sequence'][1]['then'][0]['data']['media_player_entity_id'][1] = 'media_player.samsung_q80_series_65_2'
```

- **Avant** : `["media_player.salle_de_bain", "media_player.samsung_q80_series_65"]`
- **Après** : `["media_player.salle_de_bain", "media_player.samsung_q80_series_65_2"]`
- **config_hash** : `225de8656f5bc5ce` → `9fe50a97bd26ae01`

### ✅ Test 0 final validé

Run `script.jarvis_voice` (HomePod + TV Music Assistant DLNA) : audible sur les 2 canaux, push iPhone titre OK / message vide.

### Découvertes auto-memory (à capitaliser fin S91)

- `reference_canal_tts_tv_q80_dlna.md` — solution DLNA via Music Assistant `_2` + désactivation AirPlay support (pattern récurrent transposable à d'autres TV Tizen / Q60/Q70/Q80/Q90).
- `feedback_iphone_vpn_bloque_ha.md` — VPN actif sur iPhone bloque les notifs HA Companion (différent de T#88 qui est titre OK / message vide).
- T#88 reconfirmé S91 (au 3e test du jour).

### ⏳ Reste à faire pour clôturer T#89

Tests fonctionnels CLI (pattern brain Cowork + hands CLI) :

1. Test 1 — `rapport-journalier-reactif` via `claude -p` (mode test)
2. Test 2 — `tri-email-gmail` run **manuel** via `claude -p` (valider que la voix NE se déclenche PAS en run manuel — anti-spam vocal)
3. Test 3 — alerte `[JARVIS-ALERT]` avec mail test → validation chaînage HA-side

## Statut

⏸️ `pending` — P3, ~85 % livré (S85 patches + S91 canal TV résolu + script corrigé). Reste 3 tests fonctionnels CLI pour clôturer. Mis en pause volontairement S91 par Mickael pour traiter d'autres tâches.
