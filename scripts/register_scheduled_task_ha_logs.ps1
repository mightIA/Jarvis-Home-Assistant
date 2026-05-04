# ============================================================
#  register_scheduled_task_ha_logs.ps1
#  Cree la scheduled task Jarvis-HA-Logs-Archive-Quotidien
#  Source : T#34 / Skill ha-logs-archive v2 (S91)
#
#  USAGE :
#    powershell -ExecutionPolicy Bypass -File .\register_scheduled_task_ha_logs.ps1
#  (a lancer en PowerShell ADMIN)
#
#  Verification post-install :
#    schtasks /Query /TN "Jarvis-HA-Logs-Archive-Quotidien" /V /FO LIST
# ============================================================

$TaskName    = "Jarvis-HA-Logs-Archive-Quotidien"
$BatPath     = "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\scripts\ha_logs_archive_run.bat"
$Description = "Archive quotidienne des logs Home Assistant (skill ha-logs-archive v2). Tourne chaque nuit a 02h00. Voir Archives\ha_logs\_run_logs\ pour les logs d'execution."

# Verifier que le .bat existe
if (-not (Test-Path $BatPath)) {
    Write-Host "ERREUR : .bat introuvable a $BatPath" -ForegroundColor Red
    exit 1
}

# Supprimer la tache si elle existe deja (idempotent)
$Existing = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($Existing) {
    Write-Host "Tache existante detectee, suppression avant recreation..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

# Trigger : chaque jour a 02h00
$Trigger = New-ScheduledTaskTrigger -Daily -At "02:00"

# Action : lancer le .bat
$Action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$BatPath`""

# Settings : catch-up si manquee, ne pas demarrer si batterie (laptop), exiger PC allume
$Settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -DontStopOnIdleEnd `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 15) `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 5)

# Principal : tourner sous compte Mickael (pas SYSTEM, pour acces D:\)
$Principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Limited

# Creer la tache
Register-ScheduledTask `
    -TaskName $TaskName `
    -Trigger $Trigger `
    -Action $Action `
    -Settings $Settings `
    -Principal $Principal `
    -Description $Description

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "OK : Scheduled task creee :" -ForegroundColor Green
Write-Host "  Nom         : $TaskName" -ForegroundColor Green
Write-Host "  Trigger     : Chaque jour a 02h00" -ForegroundColor Green
Write-Host "  Action      : $BatPath" -ForegroundColor Green
Write-Host "  Login       : $env:USERDOMAIN\$env:USERNAME (Interactive)" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Verification recommandee :" -ForegroundColor Cyan
Write-Host "  schtasks /Query /TN `"$TaskName`" /V /FO LIST" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pour tester immediatement (sans attendre 02h00) :" -ForegroundColor Cyan
Write-Host "  schtasks /Run /TN `"$TaskName`"" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pour supprimer la tache :" -ForegroundColor Cyan
Write-Host "  schtasks /Delete /TN `"$TaskName`" /F" -ForegroundColor Cyan
