# Prompts brain/hands — bascule CLI Mode Réactif (S31)

**Contexte** : session 31 du 22/04/2026 — Cowork a préparé tous les livrables de la bascule Option A, reste à exécuter côté Claude Code CLI les étapes nécessitant `gmail-mcp-local` (stdio) ou Windows (`schtasks`).

**Pré-requis** : Claude Code CLI installé, `gmail-mcp-local` connecté (`/mcp` → `gmail-mcp-local · connected`), dossier projet Jarvis ouvert.

---

## Étape A — Création du label Gmail `Jarvis-Alert/Traité`

**But** : créer le label hiérarchique d'archivage.

**Prompt à coller dans Claude Code CLI** :

```
Créer un label Gmail hiérarchique "Jarvis-Alert/Traité" via mcp__gmail-mcp-local__create_label (name="Jarvis-Alert/Traité", messageListVisibility="show", labelListVisibility="labelShow"). Vérifier ensuite via mcp__gmail-mcp-local__list_email_labels que le label existe bien. Afficher son id de label.
```

**Résultat attendu** : label ID `Label_N` retourné, visible dans la sidebar Gmail sous `Jarvis-Alert` → `Traité`.

---

## Étape B — Archivage des 3 mails test actuellement en Jarvis-Alert

**But** : nettoyer les 3 mails test qui traînent pour partir propre avant le V1.

**Prompt à coller dans Claude Code CLI** :

```
Lister les mails actuellement dans le label Gmail "Jarvis-Alert" sans filtrage supplémentaire via mcp__gmail-mcp-local__search_emails (query="label:Jarvis-Alert", maxResults=50). Afficher pour chacun : messageId, subject, from, date.

Ensuite, pour chaque messageId retrouvé, appeler mcp__gmail-mcp-local__modify_email avec addLabelIds=["Jarvis-Alert/Traité"] et removeLabelIds=["Jarvis-Alert"]. NE PAS mettre TRASH. NE PAS supprimer.

Confirmer à la fin : "X mails archivés vers Jarvis-Alert/Traité" + afficher la liste des messageIds traités.
```

**Résultat attendu** : les 3 mails test (2 `ban_ip` + 1 `log_erreur` selon les logs précédents) passent de `Jarvis-Alert` à `Jarvis-Alert/Traité`. Un `search_emails label:Jarvis-Alert -label:Jarvis-Alert/Traité` doit renvoyer 0 résultat après coup.

---

## Étape C — Installation de la Task Scheduler Windows

**But** : enregistrer la tâche `Jarvis-CheckAlert` toutes les 30 min.

**Commande PowerShell** (depuis une console admin, dans le dossier projet) :

```powershell
schtasks /Create /XML "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\scripts\jarvis-checkalert.xml" /TN "Jarvis-CheckAlert"
```

**Résultat attendu** : `OPERATION_RÉUSSITE` + tâche visible dans `taskschd.msc` sous `\Jarvis-CheckAlert`.

**Vérification** :

```powershell
schtasks /Query /TN "Jarvis-CheckAlert" /FO LIST /V
```

Doit afficher : `Status: Prêt`, `Schedule: Multiple schedules`, `Next Run Time: <la prochaine demi-heure>`, `Task To Run: powershell.exe -NoProfile -ExecutionPolicy Bypass -File "...\check-jarvis-alert-launcher.ps1"`.

**Note de sécurité** : `schtasks /Create /XML` n'élève pas les privilèges du script. Le launcher PS1 tournera sous le compte `MIGHT-1000D\Might` avec `LeastPrivilege`, donc sans admin. Correct.

---

## Étape D — Dry-run manuel (test bout-en-bout)

**But** : valider la skill refondue avant de laisser la Task Scheduler auto-gérer.

### D.1 Réactiver le kill switch HA

Depuis Cowork ou HA UI, passer `input_boolean.jarvis_mode_reactif` à **on**. (Mickael a l'UI ouverte, 2 clics.)

### D.2 Envoyer un mail test depuis HA

Appeler le script HA de test `script.jarvis_test_fire_ban_event` (créé S24) ou utiliser `notify.might57290_gmail_com` directement :

```
Via mcp__home-assistant__ha_call_service, appeler notify.might57290_gmail_com avec :
- message = "test S31 — mail dry-run bascule CLI"
- title = "[JARVIS-ALERT] ban_ip | medium | 198.51.100.42"
- target = ["might57290+jarvis@gmail.com"]
```

Attendre 30-60 s que Gmail applique le filtre → label `Jarvis-Alert` appliqué.

### D.3 Lancer la skill manuellement depuis Claude Code CLI

**Prompt à coller** :

```
Exécuter la skill check-jarvis-alert selon .claude/skills/check-jarvis-alert/SKILL.md. Mode interactif OK (je valide les actions). Après traitement, afficher : nombre de mails trouvés, actions décidées, états HA post-run (lire counter.jarvis_alertes_jour + input_text.jarvis_derniere_alerte + input_number.jarvis_alertes_attente), et confirmer l'archivage Gmail du mail test (search_emails label:Jarvis-Alert -label:Jarvis-Alert/Traité doit renvoyer 0).
```

**Résultats attendus** :

| Vérification | Valeur attendue |
|---|---|
| `counter.jarvis_alertes_jour` | 1 (était 0 après reset) |
| `input_text.jarvis_derniere_alerte` | `HH:MM \| ban_ip \| medium \| 198.51.100.42 \| signaler` (niveau 3 → propose → mais on a mis medium donc selon reactif_events.yaml pour ban_ip c'est toujours `debanish_auto`. L'action peut être `SKIPPED debanish_auto cli_unavailable` si la skill `debannissement-ip` ne tourne pas en CLI) |
| `input_number.jarvis_alertes_attente` | 0 si action n'est pas `propose`, 1 si `propose` |
| `memory/historique_reactif/2026-04-22.md` | Nouvelle ligne avec tous les champs |
| Gmail label | Mail test déplacé de `Jarvis-Alert` vers `Jarvis-Alert/Traité` |

Si tous les résultats sont OK → **dry-run validé**, passer à l'étape E.

---

## Étape E — V1 réel (laisser le Task Scheduler tourner)

### E.1 Vérifier que la Task Scheduler tourne

Attendre la prochaine demi-heure pleine + quelques secondes (ex : 00:00 → 00:30). Vérifier dans `taskschd.msc` que `Jarvis-CheckAlert` passe à `Running` puis retourne à `Prêt` en quelques secondes.

### E.2 Contrôler le log launcher

Fichier : `memory\historique_reactif\launcher_logs\launcher_<timestamp>.log`

Doit contenir :
```
[INFO] Démarrage check-jarvis-alert-launcher
[INFO] Âge credentials.json : X.XX jours (limite : 6)
[INFO] CWD : D:\Might\IA\Projets Cowork\Jarvis - Home Assistant
[INFO] Lancement claude -p (log de sortie : ...)
[INFO] Run check-jarvis-alert terminé avec succès
```

### E.3 Contrôler le log mémoire du jour

Fichier : `memory\historique_reactif\2026-04-22.md`

Doit contenir la nouvelle ligne "Fin de run" sans aucun mail traité (RAS, car le dry-run D aura archivé le seul mail test).

### E.4 Envoyer un 2e mail test pour valider le retraitement

Répéter l'étape D.2 avec un 2e mail test. Attendre le run auto suivant (max 30 min). Vérifier que le 2e mail est traité ET archivé comme le 1er.

**Critère de succès V1** : après 2 runs auto consécutifs avec le même mail dans la boîte, le compteur HA n'a été incrémenté **qu'une seule fois** — pas de boucle infinie (bug S31 résolu).

---

## Étape F — Cleanup Cowork scheduled

**But** : supprimer la scheduled task Cowork `check-jarvis-alert` devenue obsolète, garder `rapport-journalier-reactif` en Cowork (Q2=a).

**Depuis Cowork** (je peux le faire après validation V1) :

```
Désactiver définitivement la scheduled task Cowork "check-jarvis-alert" via mcp__scheduled-tasks__update_scheduled_task (taskId="check-jarvis-alert", enabled=false).

Optionnel : la supprimer complètement si un tool delete est disponible. Sinon laisser en enabled=false avec note dans la description "REMPLACEE par Task Scheduler Windows S31, voir scripts/jarvis-checkalert.xml".
```

---

## Résumé des fichiers livrés S31 (côté Cowork)

| Fichier | Rôle |
|---|---|
| `.claude/skills/check-jarvis-alert/SKILL.md` | Skill refondue CLI, 9 étapes, règles sécu |
| `.claude/settings.local.json` | Allowlist étendue (ha_get_state, memory/historique_reactif, TASKS.md), denylist maintenu |
| `scripts/check-jarvis-alert-launcher.ps1` | Launcher PowerShell (pré-filtre credentials + claude -p headless) |
| `scripts/jarvis-checkalert.xml` | Task Scheduler XML UTF-16 LE BOM (Mickael importe via schtasks) |
| `scripts/jarvis-checkalert.xml.utf8` | Source UTF-8 lisible du XML (non importé, pour Git) |
| Script HA `script.jarvis_reactif_log_alerte` | Point d'entrée unique écriture HA (mitigation moindre privilège) |

---

## En cas de souci

- `gmail-mcp-local` renvoie `invalid_grant` → relancer `npm run auth` dans `Runtime/Gmail-MCP-Server`, le nouveau `credentials.json` remettra le compteur d'âge à 0.
- `claude -p` prompt d'approbation → vérifier que `settings.local.json` est bien chargé (`claude /config` depuis le CLI affiche l'allowlist).
- Task Scheduler ne se déclenche pas → vérifier que le PC n'est pas en veille profonde et que `WakeToRun` est `false` (normal, on ne veut pas réveiller le PC).
- Boucle infinie observée à nouveau → vérifier que l'archivage Gmail a bien eu lieu (`search_emails label:Jarvis-Alert -label:Jarvis-Alert/Traité`) ; si les mails ne bougent pas, vérifier que `settings.local.json` autorise bien `mcp__gmail-mcp-local__modify_email`.
