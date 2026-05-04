# Push GitHub S87 — Rattrapage S71→S86

**Contexte** : préparé S87 (02/05/2026) depuis Cowork sur Might-KT (laptop, pas de Git CLI). À exécuter sur **Might-1000D** au retour Mickael.

**Objet** : push standard du repo Jarvis vers `mightIA/Jarvis-Home-Assistant`. Le dernier push remonte à S70 (27/04/2026, commit `2dc2aa6`), soit 16 sessions accumulées.

## État du repo (mesuré S87 depuis bash sandbox Cowork)

- **190 fichiers tracked modifiés** (3 965 insertions / 10 721 deletions — épuration vault S81 explique le delta)
- **134 fichiers untracked légitimes** après mise à jour `.gitignore` (57 archives tâches Q2 + 30 nouvelles tâches + 15 auto-memories + sub-agents `.claude/agents/` + hub Domotique + Audit Vault S72)
- **Aucun secret actif** détecté dans les fichiers à pousser (vérifié via grep transverse en S87)
- **`.gitignore` mis à jour** : ajout `*.bak.*`, `*.previous`, `/cleanup_*.ps1`, `_patches_*/`

## Préparation déjà effectuée S87

- `.gitignore` durci (5 backups locaux désormais exclus : `.mcp.json.bak.s70-rotation`, `TASKS.md.previous`, `cleanup_s84.ps1`, `_patches_s85/`, `SKILL.md.bak.s84`)
- Vérification absence du secret HA actuel dans tracked + untracked → OK
- Commit message rédigé et intégré dans le script

## Exécution sur Might-1000D

```powershell
powershell -ExecutionPolicy Bypass -File "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant\Projets\Push_GitHub_S87\push_standard.ps1"
```

Le script est **interactif** : il affiche l'état, te demande confirmation avant `git add .`, refait un check secrets sur le diff staged, te demande confirmation avant `git push`. Tu peux abandonner à n'importe quel point.

## Pièges anticipés

- **P1 lock orphelin** : géré (suppression au démarrage du script).
- **P2 GH007 email privé** : géré (vérif `user.email = noreply mightIA` avant tout, exit si KO).
- **P3 cache index Windows** : non concerné (pas de filter-branch).
- **P4 auto-link Cowork chat** : géré par construction (script posé, pas de bloc inline avec email).
- **P5 hashes filter-branch** : non concerné.

## Si push échoue

| Symptôme | Action |
|---|---|
| `GH007 email privé` | Skill section "Étape 4 — Réécrire les commits" (filter-branch) |
| Popup OAuth Brave non vu | Relancer `git push origin main` |
| Erreur réseau | Vérifier connexion, retry |
| Lock orphelin réapparu | `Remove-Item ".git\index.lock" -Force` puis relancer |

## Post-push

1. Vérifier visuellement sur https://github.com/mightIA/Jarvis-Home-Assistant
2. Mettre à jour `METRIQUES.md` : ajouter ligne "Date push GitHub S87 = 02/05/2026" + hash commit
3. Optionnel : archiver ce projet `Projets/Push_GitHub_S87/` après validation visuelle

## Référence

- Skill : [`.claude/skills/git-github-push/SKILL.md`](../../.claude/skills/git-github-push/SKILL.md)
- Précédent push : commit `2dc2aa6` S70 (27/04/2026)
- Précédent repo S69 : `Projets/Push_GitHub_S69/rewrite_and_push.ps1` (filter-branch, ne pas réutiliser ici)
