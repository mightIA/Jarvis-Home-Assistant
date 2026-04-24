# tri-gmail-launcher.ps1
# Pré-filtre + lanceur du tri email Gmail quotidien (Phase 5 Gmail MCP custom)
#
# Création : session 27 — 22 avril 2026
# Référence : Ressources/Protocoles/Gmail.md v3.0 + Ressources/Competences/Gmail_MCP_Custom.md
#
# Usage : appelé par Windows Task Scheduler (tâche "Jarvis-TriGmail-Quotidien") à 5h et 14h.
#         Peut aussi être lancé manuellement depuis PowerShell pour tester.
#
# Ce que fait le script :
#   1. Vérifie que credentials.json existe dans C:\Users\<user>\.gmail-mcp\
#   2. Vérifie que le token n'est pas trop vieux (âge < 6 jours, marge OAuth Consent Testing)
#   3. Crée le dossier memory/historique_tri_gmail/ si absent
#   4. Lance `claude -p` headless avec le prompt de tri + --output-format json
#   5. Redirige stdout vers un fichier log horodaté
#   6. Exit code 0 si tout OK, 1 si pré-filtre échoue, 2 si claude échoue
#
# En cas d'échec pré-filtre : essaie d'alerter Mickael via webhook HA
# (webhook optionnel à créer côté HA : jarvis_gmail_token_alert).

$ErrorActionPreference = 'Stop'

# ═══════════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════════

$ProjectRoot    = 'D:\Might\IA\Projets Cowork\Jarvis - Home Assistant'
$CredsPath      = Join-Path $env:USERPROFILE '.gmail-mcp\credentials.json'
$TokenMaxAgeDays = 6
$LogDir         = Join-Path $ProjectRoot 'memory\historique_tri_gmail'
$HaWebhookUrl   = 'http://192.168.1.11:2096/api/webhook/jarvis_gmail_token_alert'
$Timestamp      = Get-Date -Format 'yyyy-MM-dd_HHmmss'
$LogFile        = Join-Path $LogDir "run_$Timestamp.json"
$LauncherLog    = Join-Path $LogDir "launcher_$Timestamp.log"

# ═══════════════════════════════════════════════════════════════════════════
# Helpers
# ═══════════════════════════════════════════════════════════════════════════

function Write-LauncherLog {
    param([string]$Level, [string]$Message)
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [$Level] $Message"
    Write-Host $line
    # Append aussi dans le fichier launcher log (créé à la volée)
    try {
        Add-Content -Path $LauncherLog -Value $line -Encoding UTF8 -ErrorAction SilentlyContinue
    } catch {}
}

function Send-HaWebhookAlert {
    param([string]$Reason, [string]$Detail)
    try {
        $body = @{ reason = $Reason; detail = $Detail; timestamp = $Timestamp } | ConvertTo-Json -Compress
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

Write-LauncherLog 'INFO' 'Démarrage tri-gmail-launcher'

# ═══════════════════════════════════════════════════════════════════════════
# Étape 1 — Vérifier credentials.json existe
# ═══════════════════════════════════════════════════════════════════════════

if (-not (Test-Path $CredsPath)) {
    Write-LauncherLog 'ERROR' "credentials.json absent : $CredsPath"
    Send-HaWebhookAlert -Reason 'credentials_missing' -Detail "Fichier attendu : $CredsPath — relancer npm run auth dans Runtime/Gmail-MCP-Server"
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
    Send-HaWebhookAlert -Reason 'token_too_old' -Detail "Âge : $ageDaysRounded jours. Relancer npm run auth dans Runtime/Gmail-MCP-Server pour rafraîchir le token."
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
Exécute la skill tri-email-gmail selon le protocole Ressources/Protocoles/Gmail.md v3.0.
Mode non-interactif : pas de validation humaine attendue ce run.
Consignes :
- Étape 1 : scan in:inbox -label:Jarvis-Alert -label:Jarvis-RapportTri
- Étapes 3-4 : nettoyage auto spam + suppression score >= 90 via batch_modify_emails lots de 50
- Étape 5 : envoi rapport via notify.might57290_gmail_com (title [Jarvis] Rapport tri emails - $Timestamp)
- Étapes 6-7 : skip (pas de validation possible en headless) — les 70-89 restent en inbox avec label 'IA suppression'
- Étape 8 : mise à jour patterns automatique
- Étape 9 : confirmer stats + écrire log JSON résumé
Pas de demande d'approbation — utiliser les outils de la liste allow dans .claude/settings.local.json.
"@

Write-LauncherLog 'INFO' "Lancement claude -p (log de sortie : $LogFile)"

try {
    # --output-format json pour logs parsables
    # stderr redirigé aussi vers le log pour garder trace des warnings/erreurs
    claude -p $prompt --output-format json 2>&1 | Tee-Object -FilePath $LogFile

    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        Write-LauncherLog 'ERROR' "claude exit code $exitCode — voir $LogFile"
        Send-HaWebhookAlert -Reason 'claude_nonzero_exit' -Detail "Exit code $exitCode. Voir $LogFile"
        exit 2
    }

    Write-LauncherLog 'INFO' "Tri terminé avec succès — log : $LogFile"
    exit 0

} catch {
    Write-LauncherLog 'ERROR' "Exception pendant claude -p : $($_.Exception.Message)"
    Send-HaWebhookAlert -Reason 'claude_exception' -Detail $_.Exception.Message
    exit 2
}
