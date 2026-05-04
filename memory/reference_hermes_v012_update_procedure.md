---
name: Procédure update Hermès Agent (v0.11 → v0.12)
description: S93 — Procédure éprouvée pour mettre à jour Hermès Agent. Drop le stash auto (lockfiles npm cosmétiques) sans hésiter. Pattern réutilisable pour les futures updates.
type: reference
---

# Procédure update Hermès Agent

## Contexte

Hermès Agent (Nous Research, MIT, sortie 02/2026) est en développement
intense (~40 commits/jour observés). Updates fréquentes recommandées
pour récupérer les fixes critiques (cf. S63 où l'update v0.11.0 ingéré
131 commits a débloqué 5 modèles KO via le fix `has_reasoning guard`).

Procédure validée S93 (03/05/2026) lors du saut v0.11.0 → **v0.12.0**
(978 commits ingérés en une fois — projet en dev très actif).

## Procédure pas-à-pas

### 1. Quitter Hermès si actif

```bash
# Dans Hermès chat
/quit
```
Ou Ctrl+D pour fermer la TUI.

### 2. Lancer l'update

```bash
hermes update
```

Sortie typique :
- `→ Fetching updates...`
- Si modifs locales détectées : `→ Local changes detected — stashing before update...`
- `→ Found N new commit(s)` (978 sur S93)
- `→ Pulling updates...`
- Si stash fait : prompt `Restore local changes now? [Y/n]`

### 3. Décision sur le stash auto

⚠️ **Toujours répondre `n`** (Don't restore) sauf si on a un patch
fonctionnel volontaire à conserver. Le stash contient quasi
systématiquement uniquement des **lockfiles npm cosmétiques** régénérés
par les rebuilds précédents (suppression du flag `peer: true` sur
quelques entrées, ajout de nouvelles deps optionnelles type
`@emnapi/core`). Restaurer dégrade le lockfile au lieu de l'améliorer.

```bash
# Au prompt
n
```

### 4. Laisser l'update terminer

L'update va :
- Pull upstream sur `~/.hermes/hermes-agent/`
- Sync les bundled skills (S93 : +15 nouvelles + 71 mises à jour)
- Rebuild Web UI (npm install dans `web/` et `ui-tui/`)
- Vérifier la config (`✓ Configuration is up to date`)
- Afficher `✓ Update complete!`

Durée S93 : ~3-5 min pour 978 commits + rebuild.

### 5. Inspection post-update du stash droppé

```bash
cd ~/.hermes/hermes-agent && git stash list
git stash show -p stash@{0}
```

Si confirmation cosmétique (lockfile only) :
```bash
git stash drop stash@{0}
```

### 6. Nettoyage workdir (si modifs npm install résiduelles)

```bash
# Si ui-tui/package-lock.json modifié par le rebuild update
git checkout -- ui-tui/package-lock.json

# Si fichiers fantômes de copier-coller bash mal collés
# (noms entre quotes pour échapper espaces et caractères spéciaux)
rm -- ': {' 'tash drop stash@{0}'  # exemples S93

git status  # → "nothing to commit, working tree clean"
```

### 7. Relancer Hermès et vérifier

```bash
hermes
```

Attendu dans la bannière :
- Numéro de version bumped (S93 : v0.11.0 → v0.12.0)
- Hash upstream matché
- Plus de warning `N commits behind`
- Agent par défaut chargé (S93 : qwen35-agent · Nous Research)
- MCP servers reconnectés (ha-mcp 87 tool(s) sur la config qwen35
  enable_tool_search OFF — cf.
  `reference_ha_enable_tool_search_qwen35.md`)

### 8. Test fonctionnel rapide

Reproduire le Test A S63 (write HA via MCP, 1 tool call, latence ~5 min) :

```
Crée une notification persistante dans Home Assistant avec le titre
"Test post-update Hermès vX.Y.Z" et le message "Si tu vois ça,
le tool calling HA fonctionne après l'update du JJ/MM/AAAA."
```

Attendu : 1 appel `ha_call_service` réussi, notif visible dans HA UI.
Si OK → Hermès opérationnel.

## Pièges connus

1. **Bandeau "N commits behind"** dans la bannière Hermès = update
   recommandée. Au-delà de 200-300 commits, faire impérativement
   l'update (probable fix critique).

2. **Stash auto-créé** par `hermes update` : ne PAS restaurer
   aveuglément (cf. étape 3). Toujours inspecter `git stash show -p`
   avant de décider.

3. **Lockfiles npm modifiés post-rebuild** : normal, attendu à chaque
   update. `git checkout` pour revenir au lockfile upstream propre si
   on veut une install vraiment propre.

4. **Skills bundled ajoutées** : nouveaux toolsets visibles dans la
   bannière (S93 : `kanban-orchestrator`, `kanban-worker`,
   `debugging-hermes-tui-commands`, `airtable`, etc.). Pas d'action
   requise mais bon à savoir pour explorer plus tard.

5. **Config user `~/.hermes/config.yaml`** : pas touchée par update.
   Tes overrides (provider, modèle par défaut, `auxiliary.compression.model`,
   etc.) sont conservés.

## Why

Update régulière essentielle car projet en dev intense. Le coût
marginal de l'update (~5 min) est asymétrique vs le gain potentiel
(débloquer un bug bloquant comme S63 reasoning_content).

## How to apply

- Programmer une update **mensuelle minimum** (peut être intégrée à
  T#91 veille hebdo : si Hermès > 200 commits behind → notif veille)
- Avant tout debug Hermès "ça marche pas" : commencer par
  `hermes --version` et vérifier le retard upstream (cf. méthodologie
  audit niveau 2 dans le Cookbook Hermès RTX 3090)

## Lien

- Cookbook Hermès : `Projets/Cookbook_Hermes_RTX3090/` (publié S64)
- Journey S57-S63 : `Projets/Cookbook_Hermes_RTX3090/docs/journey-s57-s63.md`
- Archive session S93 : `memory/historique/2026-05-03_session_93_hermes_v012_p1_p2_tts_pause.md`
