---
name: Caviardage email no-reply GitHub
description: Garde-fou anti-fuite email Mickael sur repos publics GitHub mightIA — git config user.email = noreply + toggle "Block command line pushes that expose my email" ON.
type: feedback
---

# Caviardage email no-reply pour repos publics GitHub mightIA

**Règle** : tous les commits Git destinés à un repo public mightIA doivent utiliser l'email no-reply `278813549+mightIA@users.noreply.github.com`, **pas** `might57290@gmail.com`.

**Why** : sans ce garde-fou, l'email Gmail principal de Mickaël fuit dans les commits publics (visible via `git log` côté repo et via l'API GitHub `/users/mightIA/events`). L'email devient récupérable par n'importe quel scraper et utilisable pour spam, phishing, ou recoupement d'identité avec d'autres traces publiques.

**How to apply** :

1. **Config Git locale** (poste Mickaël) — fait une fois en S64 :

   ```bash
   git config --global user.email "278813549+mightIA@users.noreply.github.com"
   git config --global user.name "mightIA"
   ```

   Vérif : `git config --global --get user.email` doit retourner le no-reply.

2. **Toggle GitHub serveur** : Settings → Emails → cocher « Block command line pushes that expose my email » (**ON depuis S64**).
   Effet : GitHub rejette automatiquement tout `git push` qui exposerait un email non-noreply, **même si la config locale est mauvaise**. Garde-fou serveur, complète le client (défense en profondeur).

3. **Récupération de l'email no-reply** par compte : [github.com/settings/emails](https://github.com/settings/emails). Format : `<id>+<username>@users.noreply.github.com` où `<id>` = identifiant numérique du compte (visible dans la même page).

## Edge cases

- **Commit accidentel avec might57290@gmail.com avant push** : `git push` rejeté par le toggle serveur (erreur GH007). Soit `git commit --amend --reset-author` après reconfig locale (si un seul commit), soit `git filter-branch --env-filter` pour réécrire l'historique sur plusieurs commits — pattern S69 piège P5 documenté dans la skill `git-github-push`.
- **Repos PRIVÉS mightIA** : la règle s'applique aussi par défaut (cohérence + pivot futur public possible sans réécriture d'historique).
- **Repos perso non-mightIA** (compte personnel séparé) : règle à dupliquer avec l'email no-reply du compte concerné.

## Source

S64 (26/04/2026) — découverte lors de la publication initiale du repo `mightIA/hermes-agent-rtx3090-cookbook`. Pattern réaffirmé S69 lors du push initial du repo Jarvis (skill `git-github-push` créée S69 capitalise le piège P2 « GH007 email privé »).

Voir aussi : `memory/historique/2026-04-26_session_64_repo_cookbook_publie.md` (Décisions D7-S64 + D8-S64), et la skill `.claude/skills/git-github-push/SKILL.md`.
