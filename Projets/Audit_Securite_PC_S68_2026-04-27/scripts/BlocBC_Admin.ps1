# ====================================================================
# Audit Securite S68 - Bloc B + C (admin)
# Lecture seule, AUCUN contenu de secret affiche (Regle 0).
# Ce script doit etre lance EN TANT QU'ADMINISTRATEUR.
# ====================================================================

$ErrorActionPreference = 'Continue'

# Verification admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[!] Ce script n'est PAS lance en admin. Certaines sections seront degradees." -ForegroundColor Yellow
} else {
    Write-Host "[OK] Lance en mode admin." -ForegroundColor Green
}

function Section($title) {
    Write-Host ""
    Write-Host ("=== " + $title + " ===") -ForegroundColor Cyan
}

# ==============================================================
# BLOC B - Inventaire fichiers de secrets cote Windows user folder
# ==============================================================

$userHome = $env:USERPROFILE
Write-Host ""
Write-Host ("User home : " + $userHome) -ForegroundColor Yellow

# Liste des paths sensibles a auditer (existence + taille + mtime + ACL summary, JAMAIS le contenu)
$sensitivePaths = @(
    "$userHome\.ssh",
    "$userHome\.ssh\id_rsa",
    "$userHome\.ssh\id_rsa.pub",
    "$userHome\.ssh\id_ed25519",
    "$userHome\.ssh\id_ed25519.pub",
    "$userHome\.ssh\id_ecdsa",
    "$userHome\.ssh\known_hosts",
    "$userHome\.ssh\authorized_keys",
    "$userHome\.ssh\config",
    "$userHome\.gitconfig",
    "$userHome\.git-credentials",
    "$userHome\.aws",
    "$userHome\.aws\credentials",
    "$userHome\.aws\config",
    "$userHome\.azure",
    "$userHome\.kube",
    "$userHome\.kube\config",
    "$userHome\.docker",
    "$userHome\.docker\config.json",
    "$userHome\.npmrc",
    "$userHome\.pypirc",
    "$userHome\.netrc",
    "$userHome\.config\gh\hosts.yml",
    "$userHome\.config\gh\config.yml",
    "$userHome\AppData\Local\google-cloud-sdk",
    "$userHome\AppData\Roaming\gcloud",
    "$userHome\AppData\Roaming\.config\heroku",
    "$userHome\AppData\Roaming\Code\User\globalStorage",
    "$userHome\AppData\Local\Anthropic",
    "$userHome\.claude",
    "$userHome\.claude\settings.json",
    "$userHome\.claude\.credentials.json",
    "$userHome\.openai",
    "$userHome\.anthropic"
)

Section "B.1 Existence des fichiers/dossiers de secrets (sans contenu)"
foreach ($p in $sensitivePaths) {
    if (Test-Path $p) {
        $item = Get-Item $p -Force -ErrorAction SilentlyContinue
        if ($item) {
            $type = if ($item.PSIsContainer) { 'DIR ' } else { 'FILE' }
            $size = if ($item.PSIsContainer) {
                try { (Get-ChildItem $p -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum } catch { 0 }
            } else { $item.Length }
            $sizeStr = if ($size -ge 1MB) { ('{0:N1} MB' -f ($size / 1MB)) }
                       elseif ($size -ge 1KB) { ('{0:N1} KB' -f ($size / 1KB)) }
                       else { ('{0} B' -f $size) }
            $mtime = $item.LastWriteTime.ToString('yyyy-MM-dd HH:mm')
            Write-Host ("  [{0}] {1,-60} {2,12}  mtime={3}" -f $type, $p, $sizeStr, $mtime)
        }
    }
}

Section "B.2 Permissions ACL des dossiers/fichiers cles (heritage + acces)"
$keyPaths = @(
    "$userHome\.ssh",
    "$userHome\.gitconfig",
    "$userHome\.aws",
    "$userHome\.docker\config.json",
    "$userHome\.config\gh"
)
foreach ($p in $keyPaths) {
    if (Test-Path $p) {
        Write-Host ""
        Write-Host ("  PATH : " + $p)
        try {
            $acl = Get-Acl $p
            Write-Host ("  Owner : " + $acl.Owner)
            Write-Host ("  Heritage active : " + (-not $acl.AreAccessRulesProtected))
            Write-Host "  Regles d'acces :"
            foreach ($r in $acl.Access) {
                Write-Host ("    - " + $r.IdentityReference + " : " + $r.FileSystemRights + " (" + $r.AccessControlType + ")")
            }
        } catch { Write-Host ("  (Get-Acl echec : " + $_.Exception.Message + ")") }
    }
}

Section "B.3 Lister les fichiers .ssh\* (juste la liste, pas le contenu)"
if (Test-Path "$userHome\.ssh") {
    Get-ChildItem "$userHome\.ssh" -Force | Select-Object Name, Length, LastWriteTime, Attributes | Format-Table -AutoSize
}

Section "B.4 Windows Credential Manager (cmdkey /list - sans afficher les passwords)"
cmdkey /list 2>&1 | Where-Object { $_ -match 'Cible|Target|Type|Utilisateur|User' }

Section "B.5 WSL2 distros installees"
try {
    wsl --list --verbose 2>&1
} catch { Write-Host "(wsl indisponible ou pas de distro)" }

Section "B.6 Audit du dossier .claude (Claude Code CLI cred ?)"
if (Test-Path "$userHome\.claude") {
    Get-ChildItem "$userHome\.claude" -Force -ErrorAction SilentlyContinue |
        Select-Object Name, Length, LastWriteTime, Attributes | Format-Table -AutoSize
}

# ==============================================================
# BLOC C-admin - Logiciels & supply chain (admin requis pour certains)
# ==============================================================

Section "C.1 BitLocker - re-test en admin"
try {
    Get-BitLockerVolume -ErrorAction Stop |
        Select-Object MountPoint, VolumeType, ProtectionStatus, EncryptionPercentage, EncryptionMethod, LockStatus, AutoUnlockEnabled |
        Format-Table -AutoSize
} catch {
    Write-Host ("(Get-BitLockerVolume KO : " + $_.Exception.Message + ")")
}

Section "C.2 BitLocker - manage-bde -status (alternative)"
try { manage-bde -status 2>&1 | Out-String -Width 200 } catch { Write-Host "(manage-bde indisponible)" }

Section "C.3 Defender exclusions (necessite admin)"
try {
    $mp = Get-MpPreference -ErrorAction Stop
    Write-Host "ExclusionPath:"
    if ($mp.ExclusionPath) { $mp.ExclusionPath | ForEach-Object { Write-Host ("  - " + $_) } } else { Write-Host "  (aucune)" }
    Write-Host "ExclusionExtension:"
    if ($mp.ExclusionExtension) { $mp.ExclusionExtension | ForEach-Object { Write-Host ("  - " + $_) } } else { Write-Host "  (aucune)" }
    Write-Host "ExclusionProcess:"
    if ($mp.ExclusionProcess) { $mp.ExclusionProcess | ForEach-Object { Write-Host ("  - " + $_) } } else { Write-Host "  (aucune)" }
} catch { Write-Host ("(Get-MpPreference KO : " + $_.Exception.Message + ")") }

Section "C.4 winget - applications installees (formate, nb)"
try {
    $wingetList = winget list --accept-source-agreements 2>&1 | Out-String
    $lineCount = ($wingetList -split "`n").Count
    Write-Host ("Nombre de lignes : " + $lineCount)
    Write-Host $wingetList
} catch { Write-Host ("(winget KO : " + $_.Exception.Message + ")") }

Section "C.5 Autostart - HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
$keys = @(
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run',
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run',
    'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce',
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce'
)
foreach ($k in $keys) {
    Write-Host ""
    Write-Host ("  KEY : " + $k)
    if (Test-Path $k) {
        try {
            $vals = Get-ItemProperty -Path $k -ErrorAction Stop
            $vals.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' } | ForEach-Object {
                Write-Host ("    " + $_.Name + " = " + $_.Value)
            }
        } catch { Write-Host "    (lecture KO)" }
    } else { Write-Host "    (cle absente)" }
}

Section "C.6 Autostart - dossiers Startup"
$startupFolders = @(
    "$userHome\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup",
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
)
foreach ($f in $startupFolders) {
    Write-Host ""
    Write-Host ("  FOLDER : " + $f)
    if (Test-Path $f) {
        Get-ChildItem $f -Force -ErrorAction SilentlyContinue | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize
    }
}

Section "C.7 Taches planifiees - utilisateur cree (path \User\... ou hors Microsoft)"
try {
    Get-ScheduledTask | Where-Object { $_.TaskPath -notlike '\Microsoft\*' -and $_.TaskPath -ne '\' } |
        Select-Object TaskPath, TaskName, State, Author |
        Sort-Object TaskPath, TaskName |
        Format-Table -AutoSize
} catch { Write-Host ("(Get-ScheduledTask KO : " + $_.Exception.Message + ")") }

Section "C.8 Services en mode Automatic - non Microsoft (vendors)"
try {
    Get-CimInstance Win32_Service |
        Where-Object { $_.StartMode -eq 'Auto' -and $_.PathName -notmatch '\\Windows\\System32' } |
        Select-Object Name, DisplayName, StartName, State, PathName |
        Sort-Object Name |
        Format-Table -AutoSize -Wrap
} catch { Write-Host ("(Win32_Service KO : " + $_.Exception.Message + ")") }

Section "C.9 Drivers signes par editeur (top vendors hors Microsoft)"
try {
    pnputil /enum-drivers 2>&1 |
        Select-String -Pattern 'Provider Name|Nom du fournisseur' |
        Group-Object |
        Sort-Object Count -Descending |
        Select-Object -First 15 Count, Name |
        Format-Table -AutoSize
} catch { Write-Host "(pnputil indisponible)" }

Section "C.10 RDP active ? (HKLM)"
try {
    $rdpDeny = (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -ErrorAction Stop).fDenyTSConnections
    if ($rdpDeny -eq 1) { Write-Host "  RDP : DESACTIVE (fDenyTSConnections=1)" } else { Write-Host "  RDP : ACTIVE (fDenyTSConnections=$rdpDeny)" }
} catch { Write-Host ("(lecture RDP KO : " + $_.Exception.Message + ")") }

Section "C.11 SMB - protocoles supportes (SMBv1 doit etre OFF)"
try {
    Get-SmbServerConfiguration -ErrorAction Stop |
        Select-Object EnableSMB1Protocol, EnableSMB2Protocol, RequireSecuritySignature, EnableSecuritySignature, RestrictNamedPipeAccessViaQuic, EncryptData |
        Format-List
    Write-Host ""
    Write-Host "Partages SMB locaux :"
    Get-SmbShare -ErrorAction SilentlyContinue | Select-Object Name, Path, Description, ScopeName | Format-Table -AutoSize
} catch { Write-Host ("(Get-SmbServerConfiguration KO : " + $_.Exception.Message + ")") }

Write-Host ""
Write-Host "=== FIN BLOC B+C admin ===" -ForegroundColor Green
Write-Host ("Genere : " + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
