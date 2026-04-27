# Push initial Jarvis -> GitHub mightIA avec reecriture noreply
# Session 69 - 27/04/2026 - Voie A noreply
#
# Reecrit les 5 commits locaux pour remplacer might57290@gmail.com
# par le noreply GitHub mightIA, puis push vers origin.
#
# Prerequis : remote origin deja configure (Etape 3a OK), repo propre.

$ErrorActionPreference = "Stop"

$RepoPath = "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant"
$Noreply = "278813549+mightIA@users.noreply.github.com"
$AuthorName = "Mickael"

Set-Location $RepoPath

Write-Host ""
Write-Host "=== Suppression locks orphelins (sandbox Linux ne peut pas les unlink) ===" -ForegroundColor Cyan
$locks = @(
    "$RepoPath\.git\index.lock",
    "$RepoPath\Projets\Cookbook_Hermes_RTX3090\.git\index.lock"
)
foreach ($lock in $locks) {
    if (Test-Path $lock) {
        Remove-Item $lock -Force
        Write-Host "  Supprime : $lock" -ForegroundColor Yellow
    }
}
Write-Host ""

Write-Host "=== Etat initial des commits ===" -ForegroundColor Cyan
git log --pretty=format:"%h %an <%ae>" -5
Write-Host ""
Write-Host ""

Write-Host "=== Reconfig user.email LOCAL au repo (pas global) ===" -ForegroundColor Cyan
git config user.email $Noreply
git config user.name $AuthorName
Write-Host ("user.email = " + (git config user.email))
Write-Host ("user.name  = " + (git config user.name))
Write-Host ""

Write-Host "=== Pre-clean working tree (refresh index + checkout HEAD) ===" -ForegroundColor Cyan
git update-index --refresh | Out-Null
# Si Git voit encore du dirty (cache CRLF), force checkout HEAD sur tous les fichiers trackes
$dirty = git diff-index --quiet HEAD --; $dirtyCode = $LASTEXITCODE
if ($dirtyCode -ne 0) {
    Write-Host "  Index dirty detecte -> git checkout HEAD -- ." -ForegroundColor Yellow
    git checkout HEAD -- .
} else {
    Write-Host "  Working tree clean (les untracked Projets/Push_GitHub_S69/ ne bloquent pas filter-branch)" -ForegroundColor Green
}
Write-Host ""

Write-Host "=== Reecriture des 5 commits avec noreply ===" -ForegroundColor Cyan
$env:FILTER_BRANCH_SQUELCH_WARNING = "1"
$envFilter = "GIT_AUTHOR_EMAIL='$Noreply'; GIT_COMMITTER_EMAIL='$Noreply'"
git filter-branch -f --env-filter $envFilter -- --all
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ECHEC filter-branch. STOP avant push pour eviter de re-rejeter." -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "=== Verification post-reecriture ===" -ForegroundColor Cyan
git log --pretty=format:"%h %an <%ae>" -5
Write-Host ""
Write-Host ""

Write-Host "=== Push vers GitHub ===" -ForegroundColor Cyan
git push -u origin main
Write-Host ""

Write-Host "=== Termine ===" -ForegroundColor Green
