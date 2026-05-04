---
name: ha-logs-archive
description: Archive QUOTIDIENNE des logs Home Assistant (system errors+warnings combinés + logbook complet) dans `Archives/ha_logs/AAAA-MM-JJ/` avec consolidation `.md` lisible (top erreurs, bans IP, reboots, extraits stack traces, warnings notables). DECLENCHEURS : "archive les logs HA", "sauvegarde les logs HA", "ha-logs-archive", déclenchement automatique quotidien via scheduled task Windows 02h00. Outil principal : MCP `ha_get_logs` (sources : `system` ERROR/WARNING + `logbook` 24h compact). Rotation annuelle vers `Archives/ha_logs_AAAA.zip` au 1er janvier (règle CLAUDE.md §9). Logs jamais commit Git (`.gitignore Archives/*`).
---

# Skill — Archive des logs Home Assistant (v2 — quotidien Option D)

> **Note S91 — refonte v2 post-test bout-en-bout T#34**
> Test bout-en-bout S91 (3 mai 2026) a révélé 5 pièges qui imposent une refonte :
> 1. `source=error_log` retourne **404** → endpoint retiré
> 2. `end_time` ignoré sur `source=system` (fonctionne uniquement sur `logbook`)
> 3. `purge_keep_days` HA initial = 1 → portée à 35 en S91, mais le mode **quotidien** Option D reste recommandé (fenêtre safe 24h)
> 4. Logbook 24h dépasse 25 KB output MCP → pattern `find tmp + cp` obligatoire
> 5. Compteurs `system_log` reset à chaque restart HA Core → archiver AVANT restart majeur
>
> Mode initial mensuel (v1) abandonné. Bascule éventuelle vers hebdo possible dans 7-10j (cf. section "Bascule hebdo").

## Quand cette skill est déclenchée

- **Manuel — avant un formatage / migration / restauration risquée**
  Mickael dit : *"archive les logs HA"*, *"sauvegarde les logs HA avant
  formatage"*, *"ha-logs-archive"*, *"backup logs Home Assistant"*.
- **Automatique — quotidien** via scheduled task Windows
  `Jarvis-HA-Logs-Archive-Quotidien` (chaque nuit 02h00) qui invoque
  `claude-code` + cette skill pour archiver les 24h précédentes.
- **Automatique — annuel** au 1er janvier via scheduled task séparée :
  zip des 365 dossiers quotidiens de l'année écoulée (helper Python
  `scripts/rotate_annual.py`).

## Quand NE PAS l'utiliser

- Pour consulter un log ponctuel ("erreur Dyson hier soir") → utiliser
  directement `ha_get_logs source=system level=ERROR limit=20`.
- Pour debug d'un crash en cours → ouvrir Settings > System > Logs côté
  HA UI (plus rapide), puis archiver après diagnostic.
- Si le MCP HA est down → suspendre la skill, déclencher
  `debannissement-ip` si 401/403 récurrents.

## Architecture des fichiers

```
Archives/ha_logs/                              ← Racine (gitignored par Archives/*)
├── 2026-05-03/                                ← 1 dossier par jour (AAAA-MM-JJ)
│   ├── raw_logbook_2026-05-03.json            ← Source logbook 24h compact
│   ├── raw_system_errors_2026-05-03.json      ← Source system ERROR + WARNING combinés
│   └── consolide_2026-05-03.md                ← Synthèse lisible humain
├── 2026-05-04/
│   └── ...
├── ha_logs_2025.zip                           ← Zip annuel (rotation 1er janv.)
└── README.md                                  ← Note conservation/rotation
```

> ⚠ Plus de `raw_home-assistant_*.log` (endpoint `error_log` 404 dans cette version HA).

## Procédure d'exécution (quotidienne)

### 1. Vérifier l'environnement

```bash
# Bash sandbox Cowork — repérer le mount du projet Jarvis
COWORK_DIR="$(find /sessions -maxdepth 4 -type d -name 'Jarvis - Home Assistant' 2>/dev/null | head -1)"
cd "$COWORK_DIR"

# Date du jour (= date de l'archive, fenêtre = 24h précédentes)
ARCHIVE_DATE="$(date +%Y-%m-%d)"
mkdir -p "Archives/ha_logs/${ARCHIVE_DATE}"
echo "Archive vers : Archives/ha_logs/${ARCHIVE_DATE}"
```

### 2. Tester la connexion MCP HA (pré-flight)

Appel MCP **avant** la grosse récup pour vérifier que ha-mcp répond :

```
ha_get_logs source=system level=ERROR limit=1
```

Si erreur → **suspendre**, vérifier ban IP via skill `debannissement-ip`.
Si 2-3 erreurs 401/403 consécutives → **arrêter** (règle CLAUDE.md §2).

### 3. Vérifier `purge_keep_days` HA (avertissement si trop bas)

Le logbook MCP renvoie `0 entries` au-delà de la fenêtre `purge_keep_days`.
Si `purge_keep_days < 2`, l'archive 24h est déjà à la limite. Avertissement :

```
ha_get_logs source=logbook hours_back=48 limit=1
```

Si retour `entries: []` mais `period: "48 hours back from <today>"`,
alerter dans le consolidé que `purge_keep_days` est < 2j et qu'un test
ponctuel sur 24h pourrait manquer des entrées.

### 4. Récupérer les 2 sources brutes

#### 4a. system errors + warnings (combinés)

⚠ `end_time` est ignoré sur `source=system` (warning explicite MCP). Mode
"depuis maintenant" uniquement.

```
ha_get_logs source=system level=ERROR limit=5000
ha_get_logs source=system level=WARNING limit=5000
```

→ Combiner les 2 retours dans un objet JSON unique :

```json
{
  "_meta": {
    "archive_date": "AAAA-MM-JJ",
    "period": "Depuis dernier restart HA Core ou window MCP",
    "source": "ha_get_logs source=system",
    "error_log_status": "ENDPOINT 404 — retiré de la SKILL v2"
  },
  "errors": { ... retour ERROR ... },
  "warnings": { ... retour WARNING ... }
}
```

→ Save vers `Archives/ha_logs/<ARCHIVE_DATE>/raw_system_errors_<ARCHIVE_DATE>.json`.

#### 4b. logbook 24h compact

```
ha_get_logs source=logbook hours_back=24 compact=true limit=20000
```

⚠ La sortie peut dépasser 25 KB (souvent 70+ KB pour 599 entrées sur 24h).
Le tool MCP sauvegardera automatiquement dans un fichier tmp Cowork.
Pattern obligatoire :

```bash
LOGBOOK_TMP="$(find /sessions -name 'mcp-*ha_get_logs-*.txt' 2>/dev/null | tail -1)"
cp "${LOGBOOK_TMP}" "${ARCHIVE_DIR}/raw_logbook_${ARCHIVE_DATE}.json"
```

`compact=true` strip les attribute dicts pour gagner ~30% de taille.

### 5. Consolider en `.md` lisible

Lire les 2 sources brutes puis produire `consolide_<ARCHIVE_DATE>.md`
avec ces sections :

#### En-tête

```
# Logs HA — <Date>

**Période** : ~24h roulants jusqu'à AAAA-MM-JJ HH:MM UTC
**Tailles brutes** :
- raw_logbook_*.json : X.X KB (N entrées)
- raw_system_errors_*.json : X.X KB (E erreurs + W warnings)
**Généré le** : AAAA-MM-JJ HH:MM (skill ha-logs-archive v2)
```

#### Top 5 erreurs récurrentes

Compter les occurrences groupées par `name` du système log + tableau
Markdown 4 colonnes : # / Composant / Message / Occurrences. Annoter les
entrées correspondant à des tâches T# connues (Moonraker T#90, etc.).

#### Bans IP détectés

⚠ Section partiellement disponible (sans error_log brut). Workaround :

```
ha_get_logs source=system search="banned" limit=500
ha_get_logs source=system search="invalid authentication" limit=500
```

Filtrer les entrées correspondantes. Si rien : "Aucun ban détecté sur la
fenêtre".

#### Reboots HA détectés

Détection via timestamp `first_occurred` proche du début de la fenêtre
+ erreurs typiques de boot (HomeKit port already in use, child_lock
entities not yet available). Tableau : Date / Trigger probable /
Downtime estimé.

#### Extraits stack traces (3-5 max)

Sélectionner les erreurs critiques avec `exception` non vide. Inclure
3-5 extraits courts (10-15 lignes max). Privilégier les nouveautés
(non vues dans archives précédentes).

#### Warnings notables

Synthèse texte courte (5-10 lignes) sur les warnings récurrents et leurs
fréquences. Annoter les warnings actionables (HACS cards abandonnées,
HomeKit 150 device limit, OAuth reauth required).

### 6. Vérifications post-archive

```bash
ls -lah "${ARCHIVE_DIR}/"
# Validation JSON
for f in "${ARCHIVE_DIR}"/*.json; do
  python3 -c "import json; json.load(open('$f'))" 2>&1 && echo "OK: $f"
done
```

Doit voir 3 fichiers :
- `raw_logbook_*.json` (logbook 24h)
- `raw_system_errors_*.json` (system ERROR + WARNING combinés)
- `consolide_*.md` (synthèse)

Vérifier :
- ✅ 3 fichiers présents
- ✅ Tailles cohérentes (logbook > 1 KB sauf si HA très silencieux)
- ✅ JSON valides (parse-test au passage)
- ✅ `.md` consolidé contient les 6 sections (En-tête + 5 sections)

## Procédure d'exécution (annuelle, 1er janvier)

Helper Python : `scripts/rotate_annual.py` (à adapter pour patterns
quotidiens AAAA-MM-JJ au lieu de mensuels AAAA-MM).

À coller côté **PowerShell** (Might-1000D, scheduled task) :

```powershell
cd "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant"
python .claude\skills\ha-logs-archive\scripts\rotate_annual.py --year 2025
```

Le script (à mettre à jour pour quotidien) :
1. Liste tous les dossiers `Archives/ha_logs/2025-*-*/` (~365 dossiers)
2. Crée `Archives/ha_logs/ha_logs_2025.zip` les contenant
3. Vérifie le zip (intégrité, comptage fichiers)
4. **Supprime les dossiers quotidiens uniquement après vérification OK**
5. Affiche un résumé (taille zip, nb fichiers, ratio compression)

## Trigger automatique quotidien — scheduled task Windows

Sur **Might-1000D**, créer une scheduled task :

- **Nom** : `Jarvis-HA-Logs-Archive-Quotidien`
- **Trigger** : chaque jour à **02h00**
- **Action** : commande `claude` (CLI headless) avec invocation skill
- **Conditions** : exiger PC allumé, démarrer même si manqué (catch-up)
- **Login** : tâche tournée sous compte Mickael (pas SYSTEM)

Fichier `.bat` (à créer dans `scripts/`) :

```batch
@echo off
cd /d "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant"
claude -p "Lance la skill ha-logs-archive en mode quotidien automatique" >> "Archives\ha_logs\_run_logs\run_%date:~6,4%-%date:~3,2%-%date:~0,2%.txt" 2>&1
```

(à adapter selon le format date de Windows — voir lors de la création
de la scheduled task)

## Bascule éventuelle vers hebdo (dans 7-10 jours après S91)

Si dans 7-10j la BD recorder a tenu à `purge_keep_days: 35` sans
exploser en taille (vérifier HA UI Settings → System → Storage), on
peut basculer le mode quotidien en **hebdomadaire** pour réduire le
nombre de dossiers (52/an au lieu de 365/an) :

1. Modifier `Trigger` scheduled task : passer de "chaque jour 02h00" à
   "chaque lundi 02h00".
2. Modifier `hours_back` dans la skill : 24 → 168.
3. Format dossier : `AAAA-Wnn` (ex `2026-W18`) au lieu de `AAAA-MM-JJ`.
4. Adapter `rotate_annual.py` aux patterns hebdo.

Test : refaire un test bout-en-bout sur 7j pour valider que le logbook
revient bien plein (devrait, si recorder tient).

## Règles de sécurité — Règle 0 (CLAUDE.md)

- 🔴 Logs HA peuvent contenir : **IPs LAN**, **URLs internes**
  (`http://192.168.1.X`), **tokens partiels** dans des stack traces, IDs
  d'appareils. **Jamais** commit Git.
- ✅ `Archives/*` est exclu via `.gitignore` (ligne 51), donc
  `Archives/ha_logs/` est de facto hors repo.
- ⚠️ **Ne jamais** uploader le contenu des logs HA hors du PC sans
  validation explicite Mickael (Règle 0).
- ⚠️ **Pas de partage** des consolidés `.md` même synthétiques sans relire
  manuellement — ils peuvent contenir des extraits stack traces avec
  paths/IPs.

## Pièges connus (5 figés S91)

1. **`source=error_log` 404** — endpoint inexistant dans cette version HA.
   N'utiliser que `source=system` (ERROR + WARNING) et `source=logbook`.
   Si besoin d'erreurs très détaillées plus tard, tester `source=supervisor`.
2. **`end_time` ignoré** sur `source=system` — fonctionne uniquement sur
   `logbook`. Mode "X dernières heures depuis maintenant" obligatoire pour
   system. Pour cibler une fenêtre passée précise, archiver via le
   `recorder` SQL directement (workaround complexe, hors scope skill v2).
3. **`purge_keep_days < 2`** — si HA est configuré avec une rétention
   recorder < 2j, le logbook 24h frôle la limite. La skill vérifie via le
   pré-flight §3 et alerte dans le consolidé. Reco : `purge_keep_days >= 7`.
4. **Logbook output > 25 KB** — pattern `find tmp + cp` obligatoire :
   ```bash
   LOGBOOK_TMP="$(find /sessions -name 'mcp-*ha_get_logs-*.txt' 2>/dev/null | tail -1)"
   cp "${LOGBOOK_TMP}" "${ARCHIVE_DIR}/raw_logbook_${ARCHIVE_DATE}.json"
   ```
   Le tool MCP gère automatiquement la sauvegarde tmp en cas d'output
   trop gros.
5. **Reset compteurs system_log au restart HA Core** — le `count` total
   d'une erreur récurrente est perdu après chaque restart HA Core. Pour
   suivre une régression long terme, archiver AVANT toute modif config HA
   nécessitant restart (ex : changement `purge_keep_days`, intégration
   majeure).

## Volume estimé (basé sur S91)

- Logbook 24h : ~70 KB compact (~600 entrées)
- System errors + warnings : ~5-10 KB
- Consolidé .md : ~5 KB
- **Total quotidien** : ~80 KB
- **Total mensuel** : ~2.5 MB
- **Total annuel (avant zip)** : ~30 MB
- **Zip annuel** : ~3-5 MB (logbook compresse bien)

## À faire post-stabilisation (vérification long terme)

> **Note S91** : Mickael prévoit après stabilisation complète du modèle
> (et refonte vault terminée) une **vérification fichier-par-fichier**
> que ce processus archive bien les logs sans perte. À ce moment-là :
>
> 1. Choisir 1 jour de référence (ex J-3 du moment)
> 2. Comparer `raw_system_errors` ↔ HA UI Settings > System > Logs
>    sur la même fenêtre (cohérence des entries critiques)
> 3. Vérifier que le consolidé `.md` ne **manque** pas d'erreurs vues
>    par Mickael depuis 24h (pas de filter qui drop des entries
>    importantes)
> 4. Tester la rotation annuelle sur un dataset minimal (créer 5
>    dossiers bidons, lancer le script, vérifier intégrité du zip)
> 5. Tester la skill `debannissement-ip` en parallèle pour s'assurer du
>    fallback en cas d'erreur 401/403

## Évolutions possibles (v3+)

- **Dashboard HA dédié** : sensor `sensor.ha_logs_archive_last_run` pour
  voir la dernière archive depuis Lovelace.
- **Alerte si archive ratée** : email/notification si la scheduled task
  n'a pas tourné depuis > 36h.
- **Mode "before formatage"** : archive instantanée sur N jours
  configurable (pas seulement les 24h précédentes).
- **Compression à la volée** : zipper le `raw_logbook_*.json` directement
  pour économiser ~70% d'espace.
- **Diff inter-jours** : ajouter au consolidé un comparatif "+X erreurs
  vs hier, top régressions".
- **Investigation `source=supervisor`** pour récupérer les logs
  add-ons (ha-mcp, frigate, mosquitto, studio-code-server, etc.) qui
  enrichiraient nettement les sources.

## Références

- Skill créée S87 (mai 2026), refonte v2 S91 post-test bout-en-bout T#34
- Source : T#34 (`tasks/task_034.md`)
- Test bout-en-bout S91 : `Archives/ha_logs/2026-05-03/consolide_2026-05-03.md`
- MCP utilisé : `ha_get_logs` (add-on `ha-mcp` v7.4.1, voir `.mcp.json`)
- Pattern fichiers inspiré de `memory/historique/<scope>_archive_YYYY-Qn.md`
- Règle rotation annuelle : CLAUDE.md §9
- Helper Python : `scripts/rotate_annual.py` (à adapter quotidien)
