---
name: git-github-push
description: Procedure complete pour pousser un repo Git Jarvis vers GitHub mightIA (creation repo + push initial + push standard). Couvre les 5 pieges connus depuis S69 (27/04/2026) — locks orphelins sandbox bash Cowork, GH007 email prive, cache index Windows autocrlf, auto-link Cowork chat sur emails, hashes commits qui changent apres filter-branch. Toujours executer depuis PowerShell cote PC (sandbox bash Cowork ne peut pas ecrire dans .git/). Pattern brain/hands obligatoire pour tout bloc PS contenant un email (auto-link Cowork chat corrompt le paste). Inclut deux templates .ps1 reutilisables (push initial + push standard).
---

# Skill : Git GitHub Push (Jarvis)

## Quand cette skill est declenchee

- Mickael demande de pousser le repo Jarvis sur GitHub (« push », « pousser », « envoyer sur GitHub »).
- Mickael cree un nouveau repo public/prive sur le compte `mightIA`.
- Mickael veut versionner un changement et le synchroniser avec le distant.
- Verification de l'etat du remote / commits non pousses (« GitHub a jour ? »).

## Compte de reference

- GitHub : **mightIA** (compte versionning Jarvis et autres projets perso).
- Email noreply : `278813549+mightIA@users.noreply.github.com` (public, sans risque).
- Email perso a NE PAS exposer dans les commits : `might57290@gmail.com`.
- Authentification : Git Credential Manager + popup OAuth Brave (premier push uniquement).
- Repo Jarvis : `https://github.com/mightIA/Jarvis-Home-Assistant` (prive, cree S69 27/04/2026).

## Regle 0 (sensible)

- L'email noreply n'est PAS sensible (visible publiquement sur tous les commits mightIA).
- Le PAT GitHub (token classique) EST sensible — ne JAMAIS demander a Mickael de coller un token. Toujours utiliser `gh auth login` (OAuth) ou Git Credential Manager.
- Tout `.mcp.json` ou config contenant un secret HA / OpenRouter / Cloudflare doit etre VERIFIE avant push (grep `private_*`, `sk-or-*`, `Bearer`, etc.) ou neutralise via `.gitignore` + version `.template` versionnee.

## Pre-flight checks (avant TOUT push)

### Check 1 — Locks orphelins sandbox bash Cowork

Si Cowork a fait des commandes Git en lecture (meme `git status`), un `.git/index.lock` peut etre reste en place car le sandbox Linux ne peut pas l'unlink (Operation not permitted cross-OS).

```powershell
# Verifier
Test-Path "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant\.git\index.lock"
Test-Path "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant\Projets\Cookbook_Hermes_RTX3090\.git\index.lock"

# Supprimer si presents
Remove-Item "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant\.git\index.lock" -Force -ErrorAction SilentlyContinue
Remove-Item "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant\Projets\Cookbook_Hermes_RTX3090\.git\index.lock" -Force -ErrorAction SilentlyContinue
```

### Check 2 — User.email NON Gmail

```powershell
git config user.email
# Doit afficher : 278813549+mightIA@users.noreply.github.com
# Si affiche might57290@gmail.com -> reconfigurer + filter-branch (cf. section reecriture)
```

### Check 3 — Working tree clean (ou modifs intentionnelles)

```powershell
git status -sb
```

Si conversions EOL CRLF/LF parasites detectees (verif via `git diff -w -b --stat <fichier>` qui revient vide), revert :

```powershell
git checkout HEAD -- <fichier>
```

### Check 4 — Pas de secret en clair dans les nouveaux fichiers

```powershell
# Avant commit :
git diff --cached | Select-String -Pattern "(private_[a-zA-Z0-9]{15,}|sk-or-v1-[a-zA-Z0-9]{30,}|Bearer\s+ey[a-zA-Z0-9])"
# Doit etre vide. Sinon STOP, neutraliser, recommencer.
```

## Procedure A — Push initial (premier push d'un repo nouveau)

A utiliser quand on cree un nouveau repo sur `mightIA` et qu'on veut pousser l'historique local.

### Etape 1 — Creer le repo sur GitHub (cote Mickael, Brave)

URL : [github.com/new](https://github.com/new)

Parametres :
- Owner : `mightIA`
- Repository name : `<nom-du-repo>` (ex. `Jarvis-Home-Assistant`)
- Description : courte, factuelle.
- Visibility : **Private** par defaut pour Jarvis (config HA, IPs, structure reseau).
- Initialize repo : **decocher tout** (pas README, pas .gitignore, pas license — on a deja l'historique local).

### Etape 2 — Configurer le remote `origin`

```powershell
cd "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"
git remote add origin https://github.com/mightIA/<nom-du-repo>.git
git remote -v
```

Si erreur `remote origin already exists`, faire `git remote set-url origin https://github.com/mightIA/<nom-du-repo>.git`.

### Etape 3 — Reconfigurer user.email LOCAL au repo (si Gmail detecte)

```powershell
git config user.email "278813549+mightIA@users.noreply.github.com"
git config user.name "Mickael"
git config user.email
git log --pretty=format:"%h %an <%ae>" -5
```

Si les commits existants ont encore l'email Gmail, passer a l'etape 4. Sinon, sauter directement a l'etape 5.

### Etape 4 — Reecrire les commits existants (filter-branch)

**TOUJOURS poser un script `.ps1`** plutot qu'un bloc inline (auto-link Cowork chat corrompt les emails dans les blocs PS).

Template a poser dans `Projets/Push_GitHub_<sessionXX>/rewrite_and_push.ps1` :

```powershell
$ErrorActionPreference = "Stop"
$RepoPath = "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"
$Noreply = "278813549+mightIA@users.noreply.github.com"
$AuthorName = "Mickael"

Set-Location $RepoPath

# Pre-flight : supprimer locks orphelins
$locks = @(
    "$RepoPath\.git\index.lock",
    "$RepoPath\Projets\Cookbook_Hermes_RTX3090\.git\index.lock"
)
foreach ($lock in $locks) {
    if (Test-Path $lock) {
        Remove-Item $lock -Force
        Write-Host "  Lock supprime : $lock" -ForegroundColor Yellow
    }
}

# Reconfig user.email LOCAL
git config user.email $Noreply
git config user.name $AuthorName

# Pre-clean working tree (cache index Windows autocrlf)
git update-index --refresh | Out-Null
git diff-index --quiet HEAD --
if ($LASTEXITCODE -ne 0) {
    Write-Host "Index dirty -> git checkout HEAD -- ." -ForegroundColor Yellow
    git checkout HEAD -- .
}

# Reecriture filter-branch
$env:FILTER_BRANCH_SQUELCH_WARNING = "1"
$envFilter = "GIT_AUTHOR_EMAIL='$Noreply'; GIT_COMMITTER_EMAIL='$Noreply'"
git filter-branch -f --env-filter $envFilter -- --all
if ($LASTEXITCODE -ne 0) {
    Write-Host "ECHEC filter-branch. STOP avant push." -ForegroundColor Red
    exit 1
}

# Verification
git log --pretty=format:"%h %an <%ae>" -5

# Push
git push -u origin main
```

Execution :

```powershell
powershell -ExecutionPolicy Bypass -File "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant\Projets\Push_GitHub_<sessionXX>\rewrite_and_push.ps1"
```

### Etape 5 — Push initial (si user.email deja noreply)

```powershell
cd "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"
git push -u origin main
```

Premier push : popup OAuth Brave si Git Credential Manager pas authentifie pour `mightIA`. Mickael clique « Authorize Git Credential Manager », push reprend.

### Etape 6 — Verifier le push

```powershell
git log --pretty=format:"%h %an <%ae>" -5
git remote show origin
```

Lien Brave : `https://github.com/mightIA/<nom-du-repo>` — verifier que les fichiers sont visibles.

## Procedure B — Push standard (commits + push regulier)

A utiliser pour les pushes apres le push initial (90% des cas).

### Etape 1 — Pre-flight

```powershell
cd "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"

# Locks orphelins
Remove-Item ".git\index.lock" -Force -ErrorAction SilentlyContinue
Remove-Item "Projets\Cookbook_Hermes_RTX3090\.git\index.lock" -Force -ErrorAction SilentlyContinue

# Etat
git status -sb
git log --pretty=format:"%h %an <%ae>" -5
```

### Etape 2 — Add + commit

```powershell
git add <fichiers>
# OU pour tout :
git add .

# Commit avec message court + scope
git commit -m "feat(<scope>): <action courte>" -m "Detail S<NN> : <contexte>"
```

Conventions Jarvis (cohere avec historique S42-S69) :
- `chore:` cleanup, dependances, config sans impact fonctionnel
- `feat:` nouvelle skill, nouvelle competence, nouveau fichier vault
- `docs:` MAJ TASKS.md, METRIQUES.md, CLAUDE.md, auto-memories
- `fix:` correction bug ou regression

### Etape 3 — Push

```powershell
git push origin main
```

## Pieges connus (S69 27/04/2026)

### P1 — Sandbox bash Cowork laisse `.git/index.lock` orphelins

**Symptome** : `fatal: Unable to create '...index.lock': File exists. Another git process seems to be running...`

**Cause** : sandbox Linux Cowork execute `git status` ou `git log`, cree le lock, mais ne peut pas l'unlink (cross-OS WSL/Windows = Operation not permitted).

**Fix** : `Remove-Item .git\index.lock -Force` cote PowerShell.

**Prevention** : ne jamais lancer de commande Git en ECRITURE depuis bash Cowork. Lecture pure OK (`git log`, `git show`, `git diff`, `git remote -v`), mais eviter `git status` qui peut refresh l'index. Si lock present, le supprimer en pre-flight.

### P2 — GH007 email prive bloque

**Symptome** : `remote: error: GH007: Your push would publish a private email address.` au push.

**Cause** : commits avec `user.email = might57290@gmail.com` (ou autre Gmail perso) + protection GitHub `Block command line pushes that expose my email` activee (recommandee, ne pas desactiver).

**Fix** : reconfigurer `git config user.email` avec le noreply mightIA + `git filter-branch` pour reecrire l'historique. Voir Etape 4 Procedure A.

**Prevention** : configurer le noreply en LOCAL au repo des le `git init`. Eventuellement en GLOBAL si plusieurs repos personnels.

### P3 — Cache index Windows autocrlf vs filter-branch

**Symptome** : `Cannot rewrite branches: You have unstaged changes.` alors que `git status` montre clean.

**Cause** : `core.autocrlf=true` (defaut Git for Windows) declare des fichiers comme dirty dans l'index sans qu'il y ait de vrai changement. filter-branch verifie l'index et refuse.

**Fix** : `git update-index --refresh` puis `git checkout HEAD -- .` pour reset trackes (les untracked ne bloquent pas filter-branch).

**Prevention** : avant filter-branch, toujours faire ces deux commandes en pre-flight (deja inclus dans le template `.ps1`).

### P4 — Auto-link Cowork chat corrompt blocs PS contenant emails

**Symptome** : un bloc PowerShell colle dans Cowork chat puis copie dans terminal voit l'email transforme en `[email@x.com](mailto:email@x.com)` -> syntaxe PS cassee.

**Cause** : Cowork chat applique un auto-link markdown sur les emails (et URLs) meme dans certains blocs code.

**Fix / prevention** : pour tout script PS contenant un email, URL longue, ou .Method() PowerShell -> POSER UN `.ps1` dans `Projets/<nom>/` via Write tool, puis appel via `powershell -ExecutionPolicy Bypass -File <path>`. JAMAIS de bloc inline pour ces cas. Voir auto-memory `feedback_cowork_chat_markdown_pscode.md`.

### P5 — Hashes commits changent apres filter-branch

**Symptome** : apres filter-branch, les hashes des 5 commits ne correspondent plus a ce qui est mentionne dans CLAUDE.md / memory/historique.

**Cause** : changer l'auteur d'un commit (email) modifie son SHA-1.

**Impact** : les memories/archives qui mentionnent les anciens hashes deviennent decorrelees du depot GitHub. Pas bloquant mais perte de tracabilite.

**Mitigation** :
- Documenter le mapping ancien -> nouveau dans le CLAUDE.md / archive de session lors du push initial.
- Dans les memories futures, citer l'auteur + le message du commit plutot que le hash quand possible.

## Backup post-filter-branch

`git filter-branch` cree des refs backup `refs/original/refs/heads/main`. Pour les nettoyer apres validation visuelle GitHub :

```powershell
git for-each-ref --format="%(refname)" refs/original/ | ForEach-Object { git update-ref -d $_ }
git reflog expire --expire=now --all
git gc --prune=now
```

Ne pas les nettoyer tant que le push n'est pas valide visuellement sur GitHub (rollback possible via `git reset --hard refs/original/refs/heads/main`).

## Mapping S69 — anciens hashes Gmail vs nouveaux noreply

Cinq commits du repo Jarvis ont ete reecrits le 27/04/2026 pour passer du Gmail perso au noreply mightIA :

| Ancien hash (Gmail local) | Nouveau hash (noreply GitHub) | Message |
|---|---|---|
| `30e9d17` | `0549e69` | S69: T#11 caviardage vault + T#88 rotation secret_path ha-mcp (40/52 occ.) |
| `1c054c7` | `0add81b` | docs(s51): MAJ Jarvis_Audits_Todo v2.1 - tache #61 FAIT |
| `15c37b3` | `43184c4` | chore(s51): decongestion CLAUDE.md + METRIQUES.md (-76.5%, ~42k tokens/tour liberes) |
| `c38a28f` | `30f38bf` | feat(wiki): hub Domotique alimente + patches S42 |
| `3a63421` | `601e0ec` | chore: init repo + .gitignore strict (session 42) |

Les anciens hashes apparaissent encore dans CLAUDE.md, METRIQUES.md, et memory/historique/ mais ne correspondent plus au depot GitHub.

## References

- Auto-memory `feedback_git_sandbox_cowork_bloque.md` — sandbox bash Cowork ne peut pas ecrire dans .git/.
- Auto-memory `feedback_cowork_chat_markdown_pscode.md` — auto-link Cowork chat corrompt les blocs PS.
- Auto-memory `reference_git_jarvis_repo.md` — historique du repo (decisions S42, push S69).
- Auto-memory `reference_compte_github_might.md` — compte GitHub `mightIA`.
- Archive `memory/historique/2026-04-27_session_69b_t11_t88_rotation_secret.md` — rotation secret S69.
- Script reference S69 : `Projets/Push_GitHub_S69/rewrite_and_push.ps1` — exemple complet de filter-branch + push.
