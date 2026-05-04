---
name: Procédure init repo public mightIA
description: 4 étapes réutilisables pour créer un nouveau repo public GitHub mightIA caviardé (web UI vide + git config no-reply + init/add/commit/remote/push + GCM OAuth).
type: reference
---

# Procédure init repo public mightIA (S64, 26/04/2026)

Procédure validée S64 lors de la publication de `github.com/mightIA/hermes-agent-rtx3090-cookbook` (commit `de7e268`). Réutilisable pour tout futur repo public mightIA.

## 4 étapes

1. **Création repo VIDE via web UI** sur [github.com/new](https://github.com/new)
   - Owner = `mightIA`
   - Visibility = Public (ou Privé si data sensible)
   - **NE PAS cocher** « Add README », « .gitignore », « License » (sinon `git push -u origin main` rejeté pour divergence d'historique).

2. **Config Git globale** (une seule fois par poste, valable tous repos perso)

   ```bash
   git config --global user.name "mightIA"
   git config --global user.email "278813549+mightIA@users.noreply.github.com"
   git config --global init.defaultBranch main
   ```

   L'email no-reply se récupère via [github.com/settings/emails](https://github.com/settings/emails) (compte mightIA spécifique). Format : `<id>+<username>@users.noreply.github.com`.

3. **Init local + premier commit** (depuis le dossier `Projets/<nom>/`)

   ```bash
   git init
   git add .
   git status                          # vérif liste fichiers
   git diff --cached --stat            # vérif lignes ajoutées
   git commit -m "<msg>"
   git remote add origin https://github.com/mightIA/<repo>.git
   ```

4. **Push initial** (déclenche l'auth OAuth navigateur)

   ```bash
   git push -u origin main
   ```

   Au premier push : popup **Git Credential Manager** → « Sign in with your browser » → OAuth Brave → Authorize. Le push se fait silencieusement après auth. Vérif obligatoire :

   ```bash
   git log -1                          # hash local
   git log origin/main -1              # hash distant — doit être identique
   git status                          # working tree clean
   ```

## Garde-fous obligatoires (cf. `feedback_github_noreply_email.md`)

- Toggle GitHub « Block command line pushes that expose my email » → **ON** (Settings → Emails → Keep my email addresses private).
- `.gitignore` strict AVANT `git add .` — pas de `**/<domaine_sensible>*` qui paradoxalement exposerait le domaine ; préférer un pattern générique type `**/secret_*`.
- Triple `grep -rn -E` multi-pattern avant push pour tout repo public.

## Source

Capitalisation S64 (26/04/2026) — repo `mightIA/hermes-agent-rtx3090-cookbook` publié.
Voir `memory/historique/2026-04-26_session_64_repo_cookbook_publie.md` Phase 5 + Décisions D1→D10.

Skill associée : `.claude/skills/git-github-push/SKILL.md` (créée S69 — couvre push standard + 5 pièges S69 documentés).
