# jarvis-cli.ps1
# Lance une session interactive Claude Code CLI dans le dossier projet Jarvis.
#
# Usage :
#   Option 1 — Clic droit sur ce fichier > Executer avec PowerShell
#   Option 2 — Dans PowerShell : .\scripts\jarvis-cli.ps1
#   Option 3 — Double-clic sur le .bat (scripts\jarvis-cli.bat)
#
# Ce que fait le script :
#   1. Verifie que claude est dans le PATH
#   2. Se place dans le dossier projet Jarvis
#   3. Lance `claude` (mode interactif, charge CLAUDE.md + skills + MCP gmail/HA)
#
# Creation : session 27 (22/04/2026)

$ErrorActionPreference = 'Stop'
$ProjectRoot = 'D:\Might\IA\Projets Cowork\Jarvis - Home Assistant'

Write-Host ''
Write-Host '=== Lancement Jarvis CLI ===' -ForegroundColor Cyan
Write-Host ''

# Verif claude dans le PATH
$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
if (-not $claudeCmd) {
    Write-Host '[ERREUR] Commande claude introuvable dans le PATH.' -ForegroundColor Red
    Write-Host "Verifie que C:\Users\$env:USERNAME\.local\bin est dans ton PATH utilisateur." -ForegroundColor Yellow
    Write-Host "Ou lance scripts\install-claude-code.ps1 pour reinstaller proprement." -ForegroundColor Yellow
    Read-Host 'Appuie sur Entree pour quitter'
    exit 1
}

Write-Host "claude trouve : $($claudeCmd.Source)" -ForegroundColor Green

# cd dans le projet
try {
    Set-Location -Path $ProjectRoot
    Write-Host "Dossier : $ProjectRoot" -ForegroundColor Green
} catch {
    Write-Host "[ERREUR] Dossier projet introuvable : $ProjectRoot" -ForegroundColor Red
    Read-Host 'Appuie sur Entree pour quitter'
    exit 1
}

Write-Host ''
Write-Host 'Lancement de claude (tape /exit pour quitter)...' -ForegroundColor Cyan
Write-Host ''

# Lance claude en interactif
claude
