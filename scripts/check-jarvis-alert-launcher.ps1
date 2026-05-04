# check-jarvis-alert-launcher.ps1
# Pré-filtre + lanceur Mode Réactif Jarvis — traite les alertes [JARVIS-ALERT]
# en attente dans le label Gmail Jarvis-Alert toutes les 30 minutes.
#
# Création : session 31 — 22 avril 2026 (bascule Option A CLI complet)
# Référence : .claude/skills/check-jarvis-alert/SKILL.md + Ressources/Competences/Mode_Reactif.md
#
# Usage : appelé par Windows Task Scheduler (tâche "Jarvis-CheckAlert") toutes les 30 min.
#         Peut aussi être lancé manuellement depuis PowerShell pour tester.
#
# Ce que fait le script :
#   1. Vérifie que credentials.json gmail-mcp existe dans C:\Users\<user>\.gmail-mcp\
#   2. Vérifie que le token n'est pas trop vieux (âge < 6 jours, marge OAuth Consent Testing)
#   3. Vérifie que claude est dans le PATH
#   4. Crée memory/historique_reactif/ si absent
#   5. Lance `claude -p` headless avec le prompt de traitement des alertes
#   6. Redirige stdout vers un fichier log horodaté
#   7. Exit code 0 si tout OK, 1 si pré-filtre échoue, 2 si claude échoue
#
# Coût estimé par run (headless, post-S88) : ~10-15k tokens via Haiku 4.5
#   (--model claude-haiku-4-5). Cadence 1 run/jour 04h00 (CLAUDE.md).

$ErrorActionPreference = 'Stop'

# ═══════════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════════

$ProjectRoot     = 'D:\Might\IA\Projets Cowork\Jarvis - Home Assistant'
$CredsPath       = Join-Path $env:USERPROFILE '.gmail-mcp\credentials.json'
$TokenMaxAgeDays = 6
$LogDir          = Join-Path $ProjectRoot 'memory\historique_reactif\launcher_logs'
$HaWebhookUrl    = 'http://192.168.1.11:2096/api/webhook/jarvis_gmail_token_alert'
$Timestamp       = Get-Date -Format 'yyyy-MM-dd_HHmmss'
$LogFile         = Join-Path $LogDir "run_$Timestamp.json"
$LauncherLog     = Join-Path $LogDir "launcher_$Timestamp.log"

# ═══════════════════════════════════════════════════════════════════════════
# Helpers
# ═══════════════════════════════════════════════════════════════════════════

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
        $body = @{ reason = $Reason; detail = $Detail; timestamp = $Timestamp; source = 'check-jarvis-alert-launcher' } | ConvertTo-Json -Compress
        Invoke-RestMethod -Uri $HaWebhookUrl -Method Post -ContentType 'application/json' -Body $body -TimeoutSec 5 | Out-Null
        Write-LauncherLog 'INFO' "Alerte HA envoyée via webhook ($Reason)"
    } catch {
        Write-LauncherLog 'WARN' "Webhook HA indisponible, alerte non envoyée : $($_.Exception.Message)"
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# Étape 0 — Préparer le dossier de logs
# ═══════════════════════════════════════════════════════════════════════════

if (-not (Test-Path $LogDir)) {
    try {
        New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
        Write-LauncherLog 'INFO' "Dossier $LogDir créé"
    } catch {
        Write-Host "[ERREUR] Impossible de créer $LogDir : $_"
        exit 1
    }
}

Write-LauncherLog 'INFO' 'Démarrage check-jarvis-alert-launcher'

# ═══════════════════════════════════════════════════════════════════════════
# Étape 1 — Vérifier credentials.json Gmail MCP existe
# ═══════════════════════════════════════════════════════════════════════════

if (-not (Test-Path $CredsPath)) {
    Write-LauncherLog 'ERROR' "credentials.json absent : $CredsPath"
    Send-HaWebhookAlert -Reason 'credentials_missing' -Detail "Fichier attendu : $CredsPath — relancer npm run auth dans Projets/Gmail-MCP-Server"
    exit 1
}

# ═══════════════════════════════════════════════════════════════════════════
# Étape 2 — Vérifier âge du token (< 6 jours, marge OAuth Consent Testing 7j)
# ═══════════════════════════════════════════════════════════════════════════

$credsFile = Get-Item $CredsPath
$ageDays   = ((Get-Date) - $credsFile.LastWriteTime).TotalDays
$ageDaysRounded = [math]::Round($ageDays, 2)

Write-LauncherLog 'INFO' "Âge credentials.json : $ageDaysRounded jours (limite : $TokenMaxAgeDays)"

if ($ageDays -ge $TokenMaxAgeDays) {
    Write-LauncherLog 'ERROR' "Token trop vieux ($ageDaysRounded jours >= $TokenMaxAgeDays). Risque invalid_grant."
    Send-HaWebhookAlert -Reason 'token_too_old' -Detail "Âge : $ageDaysRounded jours. Relancer npm run auth dans Projets/Gmail-MCP-Server."
    exit 1
}

# ═══════════════════════════════════════════════════════════════════════════
# Étape 3 — Se placer dans le projet
# ═══════════════════════════════════════════════════════════════════════════

try {
    Set-Location -Path $ProjectRoot
    Write-LauncherLog 'INFO' "CWD : $ProjectRoot"
} catch {
    Write-LauncherLog 'ERROR' "Impossible de cd vers $ProjectRoot : $_"
    Send-HaWebhookAlert -Reason 'project_root_missing' -Detail "$ProjectRoot introuvable"
    exit 1
}

# ═══════════════════════════════════════════════════════════════════════════
# Étape 4 — Vérifier que claude est dans le PATH
# ═══════════════════════════════════════════════════════════════════════════

$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
if (-not $claudeCmd) {
    Write-LauncherLog 'ERROR' 'Commande claude introuvable dans le PATH'
    Send-HaWebhookAlert -Reason 'claude_not_in_path' -Detail 'Vérifier que ~/.local/bin est dans le PATH utilisateur (voir install-claude-code.ps1)'
    exit 1
}

# ═══════════════════════════════════════════════════════════════════════════
# Étape 5 — Lancer claude -p en mode headless
# ═══════════════════════════════════════════════════════════════════════════

$prompt = @"
Exécute la skill check-jarvis-alert selon .claude/skills/check-jarvis-alert/SKILL.md.
Mode non-interactif : pas de validation humaine attendue ce run.

Consignes strictes :
- Étape 0 : vérifier label Jarvis-Alert/Traité (créer si absent) + fichier log du jour
- Étape 1 : lire kill switch + niveau + compteur via ha_get_state — stop propre si off ou niveau 1
- Étape 2 : search_emails query 'label:Jarvis-Alert -label:Jarvis-Alert/Traité' maxResults 50 — stop propre si 0
- Étape 3 à 9 : workflow SKILL.md (pour chaque thread : contrôle expéditeur, parse sujet, check event YAML, flag HA, garde-fou, action, script HA dédié, archive label, log mémoire)

Règles sécu NON négociables :
- Expéditeur autorisé UNIQUEMENT : might57290+jarvis@gmail.com (rejeter les autres avec log ERROR spoof_attempt, pas d'archivage)
- Écritures HA UNIQUEMENT via ha_call_service domain=script service=turn_on entity_id=script.jarvis_reactif_log_alerte (PAS de ha_call_service free-form sur counter/input_text/input_number directement)
- Archivage = modify_email avec addLabelIds=[Jarvis-Alert/Traité] + removeLabelIds=[Jarvis-Alert] — JAMAIS addLabelIds=[TRASH]
- Pas d'envoi de mail (send_email et draft_email sont en deny, ne pas essayer)
- Règle 0 : ne jamais logger de token/mdp/cookie aperçu dans le corps d'un mail

Fin de run : écrire la ligne de synthèse dans memory/historique_reactif/AAAA-MM-JJ.md (mails trouvés / traités / erreurs / sorties propres).
Utiliser les outils de la liste allow dans .claude/settings.local.json, pas d'approbation demandée.
"@

Write-LauncherLog 'INFO' "Lancement claude -p (log de sortie : $LogFile)"

try {
    claude -p $prompt --model claude-haiku-4-5 --output-format json 2>&1 | Tee-Object -FilePath $LogFile

    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        Write-LauncherLog 'ERROR' "claude exit code $exitCode — voir $LogFile"
        Send-HaWebhookAlert -Reason 'claude_nonzero_exit' -Detail "Exit code $exitCode. Voir $LogFile"
        exit 2
    }

    Write-LauncherLog 'INFO' "Run check-jarvis-alert terminé avec succès — log : $LogFile"
    exit 0

} catch {
    Write-LauncherLog 'ERROR' "Exception pendant claude -p : $($_.Exception.Message)"
    Send-HaWebhookAlert -Reason 'claude_exception' -Detail $_.Exception.Message
    exit 2
}
            