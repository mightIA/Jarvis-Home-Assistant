# Rotation secret_path ha-mcp — generation aleatoire 24 chars URL-safe
# Compatible PS 5.1 (.NET Framework 4.8) + PS 7+

$bytes = New-Object byte[] 18
$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
$rng.GetBytes($bytes)
$rng.Dispose()

$base = [Convert]::ToBase64String($bytes)
$urlsafe = $base.Replace('+','-').Replace('/','_').TrimEnd('=')
$secret = "private_" + $urlsafe

$secret | Set-Clipboard

# Persistance temporaire (anti-ecrasement presse-papier) — a supprimer en fin de chantier
$tempFile = Join-Path $PSScriptRoot ".secret_temp.txt"
[System.IO.File]::WriteAllText($tempFile, $secret)

Write-Host ""
Write-Host "Secret 32 chars copie dans le presse-papier OK" -ForegroundColor Green
Write-Host "Sauvegarde locale temporaire : $tempFile" -ForegroundColor DarkGray
Write-Host "(a supprimer en fin de chantier rotation)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Longueur totale : $($secret.Length)"
Write-Host "Format : private_<24 chars URL-safe>"
Write-Host ""
Write-Host "Prefixe a transmettre a Jarvis (12 premiers chars) :" -ForegroundColor Yellow
Write-Host $secret.Substring(0, 12) -ForegroundColor Cyan
Write-Host ""
Write-Host "(Le reste du secret reste sur ton poste, Jarvis n'en a pas besoin)"
Write-Host ""
