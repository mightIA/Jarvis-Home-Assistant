---
title: Reactivation Cowork Apres Reboot
created: 2026-04-27
tags: [procedure, cowork, windows]
status: actif
domaine: Procedures
sources: [T#44]
---

# Reactivation Cowork apres reboot Windows

## Quand utiliser

- PC Mickael (MIGHT-1000D) a redemarre (Windows Update, coupure courant,
  reboot manuel).
- Cowork Desktop ne se lance pas automatiquement et la fenetre n'est pas
  presente dans la barre des taches.
- Apres une scheduled task qui dependait de Cowork tournant en arriere-plan
  (tri Gmail, rapport reactif).

## Pourquoi

Le PC Mickael est **allume 24h/24** et Cowork Desktop est concu pour tourner
en tache de fond afin que les scheduled tasks (tri Gmail 5h + 14h, rapport
reactif 23h30) puissent s'enchainer sans intervention. Si Cowork ne se relance
pas automatiquement apres un reboot, **les scheduled tasks echouent
silencieusement** jusqu'a ce que Mickael remarque l'absence de rapport mail.

## Vue d'ensemble

### Verification rapide

1. Ouvrir le **Gestionnaire des taches** (`Ctrl+Shift+Esc`) -> onglet
   **Demarrage** -> chercher `Claude` ou `Cowork`.
2. Statut doit etre `Active`. Si `Desactive` -> clic droit -> Activer.

### Si entree absente

Ajouter un raccourci `Cowork.lnk` dans le dossier `shell:startup` :

1. `Win + R` -> taper `shell:startup` -> Entree.
2. Ouvre `C:\Users\Might\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`.
3. Glisser un raccourci vers l'executable Cowork Desktop dans ce dossier.
4. Au prochain reboot, Cowork demarre automatiquement.

### Verification post-reboot

- Verifier qu'une scheduled task fonctionne :
  `schtasks /Query /TN "tri-gmail-quotidien" /V /FO LIST` -> derniere
  execution recente + `Last Run Result: 0x0` (succes).
- Si dernier run a echoue (`0x1` ou autre) : relancer manuellement la task,
  consulter le log dans `memory/historique_tri_gmail/run_*.json`.

## Pieges connus

- **Cowork ne charge PAS les MCP stdio** (auto-memory `feedback_cowork_no_stdio`) :
  donc une scheduled task qui exige `gmail-mcp-local` doit lancer
  `claude -p` headless **CLI**, pas Cowork Desktop. Cowork Desktop ne
  remplace pas Claude Code CLI pour ces tasks.
- **PowerShell 5.1 vs 7** : nombreux pieges sur les .ps1 lances par Task
  Scheduler (BOM UTF-8 obligatoire `feedback_ps51_bom_utf8`, pas de
  `Tee-Object -Encoding`, etc.).
- **Plan Max forfait** : les tokens consommes par `claude -p` headless
  comptent dans le quota Max (auto-memory `reference_plan_max_includes_cli`).
  Planifier les runs en heures creuses (4h du matin) pour preserver le quota
  interactif.
- **Cowork demande son auth a chaque reboot** si non persistee : verifier
  que la session OAuth est sauvegardee (cookies / token store local).
- **Sandbox Cowork** : capacite "sortie reseau" doit etre OFF par defaut
  (auto-memory `reference_cowork_capacites`), mais artefacts/visuels/code ON.

## Detail executable

Pas de protocole dedie. Reference :

- TASKS.md tache **#44** ("verifier autostart Cowork apres reboot").
- Auto-memories : `reference_cowork_capacites`, `feedback_cowork_no_stdio`,
  `reference_plan_max_includes_cli`, `feedback_ps51_bom_utf8`,
  `feedback_ps51_tee_object_encoding`.

## Sources

- TASKS.md #44
- Auto-memories listees ci-dessus
