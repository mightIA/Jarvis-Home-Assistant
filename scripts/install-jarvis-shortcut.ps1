# install-jarvis-shortcut.ps1
# Cree un raccourci "Jarvis CLI" sur le Bureau avec l'icone Claude Code.
# A lancer UNE FOIS pour installer le raccourci.
#
# Usage :
#   Clic droit sur ce fichier > Executer avec PowerShell
#   Ou en CLI : .\scripts\install-jarvis-shortcut.ps1
#
# Ce que fait le script :
#   1. Cree un raccourci Windows (.lnk) sur ton Bureau
#   2. Cible : jarvis-cli.bat (lance claude CLI dans le dossier projet)
#   3. Icone : scripts\icons\claude-code.ico (pixel art Claude Code)
#   4. Description tooltip : "Jarvis - Assistant Home Assistant"
#
# Creation : session 27 (22/04/2026)

$ErrorActionPreference = 'Stop'

$ProjectRoot  = 'D:\Might\IA\Projets Cowork\Jarvis - Home Assistant'
$TargetBat    = Join-Path $ProjectRoot 'scripts\jarvis-cli.bat'
$IconPath     = Join-Path $ProjectRoot 'scripts\icons\claude-code.ico'
$ShortcutPath = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Jarvis CLI.lnk'

Write-Host ''
Write-Host '=== Installation du raccourci Jarvis CLI ===' -ForegroundColor Cyan
Write-Host ''

# Verifications prealables
if (-not (Test-Path $TargetBat)) {
    Write-Host "[ERREUR] Fichier cible introuvable : $TargetBat" -ForegroundColor Red
    Read-Host 'Appuie sur Entree pour quitter'
    exit 1
}

if (-not (Test-Path $IconPath)) {
    Write-Host "[ERREUR] Icone introuvable : $IconPath" -ForegroundColor Red
    Read-Host 'Appuie sur Entree pour quitter'
    exit 1
}

# Creation du raccourci via COM WScript.Shell
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath       = $TargetBat
    $Shortcut.WorkingDirectory = $ProjectRoot
    $Shortcut.IconLocation     = $IconPath
    $Shortcut.Description      = 'Jarvis - Assistant Home Assistant (Claude Code CLI)'
    $Shortcut.WindowStyle      = 1  # 1 = fenetre normale
    $Shortcut.Save()

    Write-Host "Raccourci cree : $ShortcutPath" -ForegroundColor Green
    Write-Host "  -> cible   : $TargetBat"
    Write-Host "  -> icone   : $IconPath"
    Write-Host "  -> desc    : Jarvis - Assistant Home Assistant"
    Write-Host ''
    Write-Host 'Tu peux maintenant double-cliquer sur le raccourci Bureau pour lancer Jarvis CLI.' -ForegroundColor Green
    Write-Host 'Pour epingler a la barre des taches : clic droit sur le raccourci > Epingler a la barre des taches.' -ForegroundColor Yellow
    Write-Host ''

} catch {
    Write-Host "[ERREUR] Impossible de creer le raccourci : $($_.Exception.Message)" -ForegroundColor Red
    Read-Host 'Appuie sur Entree pour quitter'
    exit 1
}

Read-Host 'Appuie sur Entree pour terminer'
