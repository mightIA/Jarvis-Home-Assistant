# rapport-journalier-reactif-launcher.ps1
# Lanceur Mode Reactif Jarvis - genere le rapport PDF quotidien
# des evenements traites + envoi mail via notify HA.
#
# Creation : session 32 - 23 avril 2026 (bascule Option A CLI complet, cf. tache #50)
# Reference : .claude/skills/rapport-journalier-reactif/SKILL.md + Ressources/Competences/Mode_Reactif.md
#
# Usage : appele par Windows Task Scheduler (tache "Jarvis-RapportJournalier")
#         chaque jour a 23h30. Peut aussi etre lance manuellement pour tester.
#
# Ce que fait le script :
#   1. Verifie que claude est dans le PATH
#   2. Cree memory/historique_reactif/ + rapports/journalier/ si absents
#   3. Lance `claude -p` headless avec le prompt de generation du rapport
#   4. Redirige stdout vers un fichier log horodate
#   5. Exit code 0 si OK (y compris cas "RAS"), 1 si pre-filtre echoue, 2 si claude echoue
#
# Cout estime par run (headless) :
#   - Cas RAS (pas d'evenement) : ~3-5k tokens
#   - Cas "journee active" (5-20 events) : ~20-40k tokens (parsing log + generation PDF)
# Cadence 1 run/jour 23h30 -> impact forfait Max negligeable.

$ErrorActionPreference = 'Stop'

# ===========================================================================
# Configuration
# ===========================================================================

$ProjectRoot  = 'D:\Might\IA\Projets Cowork\Jarvis - Home Assistant'
$LogDir       = Join-Path $ProjectRoot 'memory\historique_reactif\launcher_logs'
$ReportsDir   = Join-Path $ProjectRoot 'rapports\journalier'
$HaWebhookUrl = 'http://192.168.1.11:2096/api/webhook/jarvis_gmail_token_alert'
$Timestamp    = Get-Date -Format 'yyyy-MM-dd_HHmmss'
$LogFile      = Join-Path $LogDir "rapport_run_$Timestamp.json"
$LauncherLog  = Join-Path $LogDir "rapport_launcher_$Timestamp.log"

# ===========================================================================
# Helpers
# ===========================================================================

function Write-LauncherLog {
    param([string]$Level, [string]$Message)
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [$Level] $Message"
    Write-Host $line
    try {
        Add-Content -Path $LauncherLog -Value $line -Encoding UTF8 -ErrorAction SilentlyContinue
    } catch {}
}

function Send-HaWebhookAlert {
    param([string]$Reason, [string]$Detail)
    try {
        $body = @{ reason = $Reason; detail = $Detail; timestamp = $Timestamp; source = 'rapport-journalier-reactif-launcher' } | ConvertTo-Json -Compress
        Invoke-RestMethod -Uri $HaWebhookUrl -Method Post -ContentType 'application/json' -Body $body -TimeoutSec 5 | Out-Null
        Write-LauncherLog 'INFO' "Alerte HA envoyee via webhook ($Reason)"
    } catch {
        Write-LauncherLog 'WARN' "Webhook HA indisponible, alerte non envoyee : $($_.Exception.Message)"
    }
}

# ===========================================================================
# Etape 0 - Preparer les dossiers
# ===========================================================================

foreach ($dir in @($LogDir, $ReportsDir)) {
    if (-not (Test-Path $dir)) {
        try {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-LauncherLog 'INFO' "Dossier $dir cree"
        } catch {
            Write-Host "[ERREUR] Impossible de creer $dir : $_"
            exit 1
        }
    }
}

Write-LauncherLog 'INFO' 'Demarrage rapport-journalier-reactif-launcher'

# ===========================================================================
# Etape 1 - Se placer dans le projet
# ===========================================================================

try {
    Set-Location -Path $ProjectRoot
    Write-LauncherLog 'INFO' "CWD : $ProjectRoot"
} catch {
    Write-LauncherLog 'ERROR' "Impossible de cd vers $ProjectRoot : $_"
    Send-HaWebhookAlert -Reason 'project_root_missing' -Detail "$ProjectRoot introuvable"
    exit 1
}

# ===========================================================================
# Etape 2 - Verifier que claude est dans le PATH
# ===========================================================================

$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
if (-not $claudeCmd) {
    Write-LauncherLog 'ERROR' 'Commande claude introuvable dans le PATH'
    Send-HaWebhookAlert -Reason 'claude_not_in_path' -Detail 'Verifier que ~/.local/bin est dans le PATH utilisateur (voir install-claude-code.ps1)'
    exit 1
}

# ===========================================================================
# Etape 3 - Lancer claude -p en mode headless
# ===========================================================================

$prompt = @"
Execute la skill rapport-journalier-reactif selon .claude/skills/rapport-journalier-reactif/SKILL.md.
Mode non-interactif : pas de validation humaine attendue ce run.

Consignes strictes (workflow 7 etapes du SKILL.md) :
- Etape 1 : determiner la date du jour (Europe/Paris), chemins log + PDF, creer rapports/journalier/ si absent
- Etape 2 : si log du jour absent OU ne contient que RAS/STOP -> ajouter ligne 'RAS - rapport journalier execute HH:MM:SS' au log, sortir propre (exit 0, pas de PDF, pas de mail)
- Etape 3 : lire config/autonomie.yaml + ha_get_state (kill switch + niveau + compteurs) + parser memory/historique_reactif/AAAA-MM-JJ.md (events traites, repartition type/gravite, actions auto, propositions, erreurs, spoof_attempts)
- Etape 4 : generer PDF rapports/journalier/AAAA-MM-JJ.pdf via skill pdf (4 sections : en-tete/etat, stats, chrono detaillee, propositions+anomalies). Suffixe _v2/_v3 si PDF existe deja
- Etape 5 : archiver local (OneDrive sync passif)
- Etape 6 : envoi mail via ha_call_service notify.might57290_gmail_com avec data.target=['might57290@gmail.com'] (OBLIGATOIRE sinon HTTP 500), sujet '[JARVIS] Rapport reactif AAAA-MM-JJ', corps texte seul + chemin OneDrive du PDF
- Etape 7 : fallback PDF echoue -> notify texte seul / fallback notify echoue -> exit 2

Regles secu NON negociables :
- Ecritures HA UNIQUEMENT via ha_call_service domain=notify service=might57290_gmail_com (aucun autre service)
- Pas de send_email/draft_email Gmail MCP (en deny, scope gmail.send absent)
- Pas de PJ dans le mail (notify HA Gmail ne les supporte pas fiablement) - seulement le chemin OneDrive
- Pas de suppression du log .md apres generation du PDF (conservation permanente)
- Pas d'ecrasement PDF existant (suffixe _v2/_v3)
- Regle 0 CLAUDE.md : ne jamais logger de token/mdp/cookie apercu dans le log ou le mail

Utiliser les outils de la liste allow dans .claude/settings.local.json, pas d'approbation demandee.
"@

Write-LauncherLog 'INFO' "Lancement claude -p (log de sortie : $LogFile)"

try {
    claude -p $prompt --output-format json 2>&1 | Tee-Object -FilePath $LogFile

    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        Write-LauncherLog 'ERROR' "claude exit code $exitCode - voir $LogFile"
        Send-HaWebhookAlert -Reason 'claude_nonzero_exit' -Detail "Exit code $exitCode. Voir $LogFile"
        exit 2
    }

    Write-LauncherLog 'INFO' "Run rapport-journalier-reactif termine avec succes - log : $LogFile"
    exit 0

} catch {
    Write-LauncherLog 'ERROR' "Exception pendant claude -p : $($_.Exception.Message)"
    Send-HaWebhookAlert -Reason 'claude_exception' -Detail $_.Exception.Message
    exit 2
}
