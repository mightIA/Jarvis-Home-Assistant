# ============================================================================
# install-claude-code.ps1 — Installation automatisee environnement Claude Code
# ============================================================================
# Jarvis - Home Assistant / Mickael
# Usage  : clic droit sur ce fichier -> "Executer avec PowerShell"
#          OU en terminal PowerShell : .\scripts\install-claude-code.ps1
#
# Ce script :
#  - Verifie la presence de node, git, python, claude
#  - Installe Claude Code CLI (methode native) si manquant
#  - Ajoute automatiquement C:\Users\<user>\.local\bin au PATH utilisateur
#  - Verifie l'ExecutionPolicy PowerShell
#  - Affiche la checklist post-install (PATH, premier lancement, MCP, OAuth)
#
# Le script NE modifie PAS le dossier Jarvis. Il n'installe QUE les outils
# systeme (Node/Git/Python/Claude Code CLI) et configure le PATH utilisateur.
#
# Reference : .claude/skills/install-claude-code-windows/SKILL.md
# ============================================================================

$ErrorActionPreference = "Stop"
$ScriptVersion = "1.0.0 (2026-04-20, session 17)"

# --- Helpers ---------------------------------------------------------------

function Write-Header {
    param([string]$Title)
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host " $Title" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
}

function Write-Step {
    param([string]$Msg)
    Write-Host ""
    Write-Host ">>> $Msg" -ForegroundColor Yellow
}

function Write-Ok {
    param([string]$Msg)
    Write-Host "  [OK] $Msg" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Msg)
    Write-Host "  [!!] $Msg" -ForegroundColor DarkYellow
}

function Write-Err {
    param([string]$Msg)
    Write-Host "  [KO] $Msg" -ForegroundColor Red
}

function Test-Command {
    param([string]$Name)
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    return $null -ne $cmd
}

function Get-Version {
    param([string]$Cmd, [string]$Arg = "--version")
    try {
        $out = & $Cmd $Arg 2>&1 | Select-Object -First 1
        return $out.ToString().Trim()
    }
    catch {
        return "inconnue"
    }
}

function Ask-YesNo {
    param([string]$Question, [string]$Default = "O")
    $prompt = if ($Default -eq "O") { "$Question [O/n] " } else { "$Question [o/N] " }
    $resp = Read-Host $prompt
    if ([string]::IsNullOrWhiteSpace($resp)) { $resp = $Default }
    return ($resp -match "^[oOyY]")
}

# --- Debut du script -------------------------------------------------------

Write-Header "Install Claude Code CLI — Jarvis ($ScriptVersion)"

Write-Host ""
Write-Host "Ce script va verifier et installer ce qui manque pour que"
Write-Host "Claude Code CLI soit operationnel dans le dossier Jarvis :"
Write-Host "  D:\Might\IA\Projets Cowork\Jarvis - Home Assistant"
Write-Host ""

$continue = Ask-YesNo "Continuer ?" "O"
if (-not $continue) {
    Write-Host "Abandon." -ForegroundColor Gray
    exit 0
}

# --- 1. Detection outils existants ----------------------------------------

Write-Header "1. Detection outils existants"

$tools = @{
    "node"   = @{ Required = $false; Present = (Test-Command "node");   Version = "" }
    "npm"    = @{ Required = $false; Present = (Test-Command "npm");    Version = "" }
    "git"    = @{ Required = $true;  Present = (Test-Command "git");    Version = "" }
    "python" = @{ Required = $false; Present = (Test-Command "python"); Version = "" }
    "claude" = @{ Required = $true;  Present = (Test-Command "claude"); Version = "" }
}

foreach ($name in $tools.Keys) {
    $info = $tools[$name]
    if ($info.Present) {
        $info.Version = Get-Version -Cmd $name
        Write-Ok ("{0,-8} : {1}" -f $name, $info.Version)
    }
    else {
        if ($info.Required) {
            Write-Err ("{0,-8} : MANQUANT (requis)" -f $name)
        }
        else {
            Write-Warn ("{0,-8} : manquant (optionnel)" -f $name)
        }
    }
}

# --- 2. ExecutionPolicy ----------------------------------------------------

Write-Header "2. ExecutionPolicy PowerShell (utilisateur)"

$currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
Write-Host "  Policy actuelle (CurrentUser) : $currentPolicy"

if ($currentPolicy -in @("Restricted", "AllSigned", "Undefined")) {
    Write-Warn "Policy trop stricte pour npm et scripts de validation."
    if (Ask-YesNo "Basculer sur RemoteSigned ?" "O") {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Ok "ExecutionPolicy = RemoteSigned"
    }
    else {
        Write-Warn "Policy laissee telle quelle — certains scripts pourraient echouer."
    }
}
else {
    Write-Ok "Policy OK ($currentPolicy)"
}

# --- 3. Installation Claude Code (methode native) -------------------------

Write-Header "3. Claude Code CLI"

if (-not $tools["claude"].Present) {
    Write-Warn "Claude Code CLI non detecte dans le PATH."
    Write-Host ""
    Write-Host "  Methode recommandee : installation native via install.ps1"
    Write-Host "  (pas besoin de Node.js pour cette methode)"
    Write-Host ""

    if (Ask-YesNo "Installer Claude Code CLI maintenant (native) ?" "O") {
        Write-Step "Telechargement et execution install.ps1..."
        try {
            Invoke-RestMethod -Uri "https://claude.ai/install.ps1" | Invoke-Expression
            Write-Ok "Installation native terminee."
        }
        catch {
            Write-Err "Echec de l'installation native : $_"
            Write-Host ""
            Write-Host "  Fallback npm : necessite Node.js."
            if ($tools["npm"].Present) {
                if (Ask-YesNo "Essayer via npm install -g @anthropic-ai/claude-code ?" "O") {
                    npm install -g @anthropic-ai/claude-code
                }
            }
            else {
                Write-Warn "npm non present. Installe Node.js LTS depuis https://nodejs.org puis relance ce script."
            }
        }
    }
}
else {
    Write-Ok "Claude Code CLI deja present : $($tools['claude'].Version)"
}

# --- 4. PATH utilisateur (si install native) -------------------------------

Write-Header "4. PATH utilisateur (C:\Users\<user>\.local\bin)"

$claudeNativePath = "$env:USERPROFILE\.local\bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")

if (Test-Path $claudeNativePath) {
    if ($userPath -like "*$claudeNativePath*") {
        Write-Ok "PATH utilisateur contient deja $claudeNativePath"
    }
    else {
        Write-Warn "PATH utilisateur ne contient PAS $claudeNativePath"
        if (Ask-YesNo "Ajouter au PATH utilisateur automatiquement ?" "O") {
            $newPath = if ([string]::IsNullOrEmpty($userPath)) { $claudeNativePath } else { "$userPath;$claudeNativePath" }
            [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
            Write-Ok "PATH utilisateur mis a jour."
            Write-Warn "Ferme et rouvre PowerShell pour que le changement prenne effet."
        }
    }
}
else {
    Write-Host "  (Pas d'install native detectee — rien a faire ici.)"
}

# --- 5. Git (requis pour claude) -------------------------------------------

Write-Header "5. Git pour Windows"

if (-not $tools["git"].Present) {
    Write-Err "Git non detecte. Claude Code l'exige (git-bash requis sur Windows)."
    Write-Host ""
    Write-Host "  Ouverture de la page de download..."
    if (Ask-YesNo "Ouvrir https://git-scm.com/downloads/win dans le navigateur ?" "O") {
        Start-Process "https://git-scm.com/downloads/win"
        Write-Warn "Installe Git (cocher 'Git from command line and also from 3rd-party software' option 2) puis relance ce script."
    }
}
else {
    Write-Ok "Git present : $($tools['git'].Version)"
}

# --- 6. Python (optionnel, pour scripts skills) ---------------------------

Write-Header "6. Python 3.12+ (optionnel)"

if (-not $tools["python"].Present) {
    Write-Warn "Python non detecte (necessaire pour certains scripts de validation skills)."
    if (Ask-YesNo "Ouvrir https://www.python.org/downloads/ dans le navigateur ?" "N") {
        Start-Process "https://www.python.org/downloads/"
        Write-Warn "IMPORTANT : cocher 'Add Python to PATH' lors de l'install."
    }
}
else {
    Write-Ok "Python present : $($tools['python'].Version)"
    # Verifie pyyaml
    try {
        python -c "import yaml" 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Ok "PyYAML installe"
        }
        else {
            Write-Warn "PyYAML non installe — necessaire pour skill homeassistant-config"
            if (Ask-YesNo "Installer PyYAML via pip ?" "O") {
                pip install pyyaml
            }
        }
    }
    catch {
        Write-Warn "Impossible de verifier PyYAML"
    }
}

# --- 7. Checklist post-install --------------------------------------------

Write-Header "7. Checklist post-install — prochaines etapes"

$jarvisDir = "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant"
$jarvisExists = Test-Path $jarvisDir

Write-Host ""
Write-Host "  [ ] 1. Fermer et rouvrir PowerShell (recharger PATH)"
Write-Host "  [ ] 2. Verifier : claude --version"

if ($jarvisExists) {
    Write-Host "  [ ] 3. cd `"$jarvisDir`""
}
else {
    Write-Host "  [ ] 3. Restaurer le dossier Jarvis depuis backup cloud :"
    Write-Host "         cible : $jarvisDir"
}

Write-Host "  [ ] 4. claude --continue"
Write-Host "  [ ] 5. Premier message : `"salut, lis CLAUDE.md et fais-moi le bilan de la session`""
Write-Host "  [ ] 6. Si MCP home-assistant : approuver le trust prompt + flow OAuth DCR"
Write-Host "  [ ] 7. Test : `"statut de light.ampoule_chambre`" (ou entite connue)"
Write-Host ""
Write-Host "  Reference complete : .claude/skills/install-claude-code-windows/SKILL.md"
Write-Host ""

Write-Header "Installation terminee."
Write-Host ""
