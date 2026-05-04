# =====================================================================
# push_standard.ps1 -- Push GitHub repo Jarvis S87 (rattrapage S71->S86)
# =====================================================================
# Genere par Jarvis en S87 (02/05/2026) depuis Cowork sur Might-KT.
# A executer sur Might-1000D au retour Mickael (Git CLI absent sur KT).
#
# Procedure B (push standard) - skill .claude/skills/git-github-push/.
# Couvre les 5 pieges S69 documentes.
#
# Mode interactif : affiche etat + demande confirmation avant push.
# =====================================================================

$ErrorActionPreference = "Stop"
$RepoPath = "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"
$Noreply = "278813549+mightIA@users.noreply.github.com"
$ExpectedAuthor = "Mickael"

Set-Location $RepoPath

# ----- Etape 1 : Pre-flight (locks orphelins + verif user.email) -----
Write-Host ""
Write-Host "=== ETAPE 1 / Pre-flight ===" -ForegroundColor Cyan

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
Write-Host "  Locks orphelins : OK"

# Verif user.email noreply (Piege P2 GH007)
$currentEmail = git config user.email
if ($currentEmail -ne $Noreply) {
    Write-Host "  ERREUR : user.email = $currentEmail" -ForegroundColor Red
    Write-Host "  Attendu : $Noreply" -ForegroundColor Red
    Write-Host "  STOP avant push pour eviter GH007. Reconfigurer :" -ForegroundColor Red
    Write-Host "    git config user.email '$Noreply'" -ForegroundColor Red
    exit 1
}
Write-Host "  user.email noreply mightIA : OK"

# ----- Etape 2 : Etat repo -----
Write-Host ""
Write-Host "=== ETAPE 2 / Etat repo ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "--- git status -sb ---"
git status -sb
Write-Host ""
Write-Host "--- 5 derniers commits ---"
git log --pretty=format:"%h %ad %s" --date=short -5
Write-Host ""
Write-Host ""
Write-Host "--- Stats vs HEAD ---"
git diff --stat HEAD | Select-Object -Last 1

# ----- Etape 3 : Confirmation + add + commit -----
Write-Host ""
Write-Host "=== ETAPE 3 / Add + commit ===" -ForegroundColor Cyan
Write-Host ""
$confirm = Read-Host "Tout ajouter (git add .) et commit S87 ? (o/n)"
if ($confirm -ne "o") {
    Write-Host "  ANNULE par utilisateur. Aucune modification." -ForegroundColor Yellow
    exit 0
}

git add .
if ($LASTEXITCODE -ne 0) { Write-Host "  ECHEC git add" -ForegroundColor Red; exit 1 }
Write-Host "  git add . : OK"

# Verif anti-secrets cote stage (Piege bonus skill)
$secretMatches = git diff --cached | Select-String -Pattern "(private_[a-zA-Z0-9]{15,}|sk-or-v1-[a-zA-Z0-9]{30,}|Bearer\s+ey[a-zA-Z0-9])"
if ($secretMatches) {
    $newOnly = $secretMatches | Where-Object { $_.Line -match "^\+" }
    if ($newOnly) {
        Write-Host ""
        Write-Host "  ATTENTION : motifs de secrets detectes en AJOUT staged :" -ForegroundColor Yellow
        $newOnly | Select-Object -First 5 | ForEach-Object { Write-Host "    $($_.Line.Substring(0, [Math]::Min(120, $_.Line.Length)))" }
        Write-Host ""
        $confirmSec = Read-Host "  Continuer quand meme ? (o/n)"
        if ($confirmSec -ne "o") {
            Write-Host "  STOP. Annuler le stage : git reset HEAD" -ForegroundColor Red
            exit 1
        }
    }
}

# Commit message multi-lignes
$msgTitle = "chore(s71-s86): refonte architecture + vault epure + hub Domotique"
$msgBody = @"
16 sessions cumulees (S70->S86, dernier push S70 commit 2dc2aa6).

Structurel :
- Sub-agents P3 (3 agents .claude/agents/, CLI-only confirme S75)
- Refonte CLAUDE.md option C (S75, footer externalise)
- Skills enrichies S76 (13 SKILL.md sur 4 criteres, 30 actives post-S84)
- Decongestion fichiers vivants (~42K tokens/tour liberes)
- Hooks PreToolUse check-secrets P2 (S72b)
- Audit structure fichiers vivants S74 (7 anomalies P0+P1)

Vault Wiki/ :
- Epuration S81 (-37%, 6->3 dossiers, ADR-A004 connaissance pure)
- Hub Domotique finalise S79+S80+S86 (5 fiches : Prises HomeKit, EcoFlow River 2 Pro, Imprimante 3D Creality, HomePod, Samsung Q80)
- Audit correctif S80 (chemins + tags tripartite)
- Decisions D1+D2 option C documentees S86

Process :
- Refonte instructions Mode Chat + Cowork + CONTEXTE.md v2.0 (S82)
- Menage P1+P2+P3 taches S82-S84 (11 closes)
- T#49 audit Brave->MCP + regle CLAUDE.md S4 MCP>Brave (S84)
- T#53 Piper TTS done + script.jarvis_voice (S84)
- Format tasks/task_NNN.md + skill regen-tasks-index (S71)

Tooling .gitignore :
- Ajout *.bak.*, *.previous, /cleanup_*.ps1, _patches_*/

Stats : ~190 fichiers tracked modifies + ~134 untracked nouveaux.
"@

git commit -m $msgTitle -m $msgBody
if ($LASTEXITCODE -ne 0) { Write-Host "  ECHEC git commit" -ForegroundColor Red; exit 1 }
Write-Host "  Commit cree : OK"
Write-Host ""
git log --pretty=format:"%h %s" -1
Write-Host ""

# ----- Etape 4 : Push -----
Write-Host ""
Write-Host "=== ETAPE 4 / Push origin main ===" -ForegroundColor Cyan
Write-Host ""
$confirmPush = Read-Host "Pousser vers origin/main ? (o/n)"
if ($confirmPush -ne "o") {
    Write-Host "  Push reporte. Commit cree localement, pas pousse." -ForegroundColor Yellow
    Write-Host "  Pour pousser plus tard : git push origin main" -ForegroundColor Yellow
    exit 0
}

git push origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "  ECHEC push." -ForegroundColor Red
    Write-Host "  Si GH007 (email prive) : skill section reecriture filter-branch." -ForegroundColor Red
    Write-Host "  Si OAuth / popup Brave manquant : relancer git push origin main." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== PUSH OK ===" -ForegroundColor Green
Write-Host ""
git log --pretty=format:"%h %ad %s" --date=short -3
Write-Host ""
Write-Host ""
Write-Host "Verifier visuellement : https://github.com/mightIA/Jarvis-Home-Assistant" -ForegroundColor Cyan
Write-Host ""
