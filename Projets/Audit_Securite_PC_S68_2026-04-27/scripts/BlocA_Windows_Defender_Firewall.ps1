# =============================================================
# Audit Securite S68 - Bloc A (systeme + Defender + Firewall)
# Lecture seule, aucune modification appliquee.
# Encodage : UTF-8 sans BOM (compatible PS 5.1+ et PS 7+)
# =============================================================

$ErrorActionPreference = 'Continue'
$OutputEncoding = [System.Text.Encoding]::UTF8

function Section($title) {
    Write-Host ""
    Write-Host ("=== " + $title + " ===") -ForegroundColor Cyan
}

# --- A1 - Identite OS + build ---
Section "A1.1 Identite OS"
Get-CimInstance Win32_OperatingSystem |
    Select-Object Caption, Version, BuildNumber, OSArchitecture, InstallDate, LastBootUpTime, RegisteredUser, SystemDirectory |
    Format-List

Section "A1.2 Hotfix installes (30 dernieres)"
Get-HotFix | Sort-Object InstalledOn -Descending |
    Select-Object -First 30 HotFixID, Description, InstalledOn |
    Format-Table -AutoSize

Section "A1.3 Etat Windows Update (KB en attente)"
try {
    $wuSession = New-Object -ComObject Microsoft.Update.Session
    $wuSearcher = $wuSession.CreateUpdateSearcher()
    $wuResult = $wuSearcher.Search('IsInstalled=0 and IsHidden=0')
    Write-Host ('KB en attente : ' + $wuResult.Updates.Count)
    foreach ($u in $wuResult.Updates) { Write-Host (' - ' + $u.Title) }
} catch {
    Write-Host ('(API Windows Update indisponible : ' + $_.Exception.Message + ')')
}

Section "A1.4 BitLocker - chiffrement des volumes"
try {
    Get-BitLockerVolume |
        Select-Object MountPoint, VolumeType, ProtectionStatus, EncryptionPercentage, EncryptionMethod, LockStatus |
        Format-Table -AutoSize
} catch {
    Write-Host ('(Get-BitLockerVolume indisponible : ' + $_.Exception.Message + ')')
}

Section "A1.5 Comptes locaux"
Get-LocalUser |
    Select-Object Name, Enabled, LastLogon, PasswordRequired, PasswordLastSet, AccountExpires, Description |
    Format-Table -AutoSize

Section "A1.6 Membres du groupe Administrateurs"
$adminGroup = $null
foreach ($g in 'Administrateurs','Administrators') {
    try {
        $adminGroup = Get-LocalGroupMember -Group $g -ErrorAction Stop
        Write-Host ('Groupe trouve : ' + $g)
        $adminGroup | Format-Table -AutoSize
        break
    } catch {}
}
if (-not $adminGroup) { Write-Host '(Impossible de lister les administrateurs)' }

Section "A1.7 Politique de mot de passe locale (net accounts)"
net accounts

Section "A1.8 UAC"
$uacKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
if (Test-Path $uacKey) {
    Get-ItemProperty -Path $uacKey |
        Select-Object EnableLUA, ConsentPromptBehaviorAdmin, PromptOnSecureDesktop, FilterAdministratorToken |
        Format-List
} else {
    Write-Host '(cle UAC absente)'
}

Section "A1.9 AzureAD / Domaine join"
Get-CimInstance Win32_ComputerSystem |
    Select-Object Name, Domain, PartOfDomain, Workgroup, UserName |
    Format-List
$dsreg = dsregcmd /status 2>&1 | Out-String
$dsreg -split "`n" | Where-Object { $_ -match 'AzureAdJoined|EnterpriseJoined|DomainJoined|TenantName|WorkplaceJoined' } | ForEach-Object { Write-Host $_.Trim() }

# --- A2 - Defender + Pare-feu ---
Section "A2.1 Etat Windows Defender (MpComputerStatus)"
try {
    Get-MpComputerStatus |
        Select-Object AMServiceEnabled, AntispywareEnabled, AntivirusEnabled, RealTimeProtectionEnabled,
            BehaviorMonitorEnabled, IoavProtectionEnabled, OnAccessProtectionEnabled,
            NISEnabled, AMEngineVersion, AntispywareSignatureVersion, AntivirusSignatureVersion,
            QuickScanEndTime, FullScanEndTime, TamperProtectionSource, IsTamperProtected,
            DefenderSignaturesOutOfDate |
        Format-List
} catch {
    Write-Host ('(MpComputerStatus indisponible : ' + $_.Exception.Message + ')')
}

Section "A2.2 Defender preferences (cle settings)"
try {
    Get-MpPreference |
        Select-Object DisableRealtimeMonitoring, DisableBehaviorMonitoring, DisableIOAVProtection,
            DisableScriptScanning, MAPSReporting, SubmitSamplesConsent, CloudBlockLevel,
            CloudExtendedTimeout, PUAProtection, ExclusionPath, ExclusionExtension, ExclusionProcess |
        Format-List
} catch {
    Write-Host ('(MpPreference indisponible : ' + $_.Exception.Message + ')')
}

Section "A2.3 Defender ASR (Attack Surface Reduction) rules"
try {
    $asrIds = (Get-MpPreference).AttackSurfaceReductionRules_Ids
    $asrAct = (Get-MpPreference).AttackSurfaceReductionRules_Actions
    if ($asrIds) {
        for ($i=0; $i -lt $asrIds.Count; $i++) {
            Write-Host (' - ' + $asrIds[$i] + ' = ' + $asrAct[$i])
        }
    } else {
        Write-Host '(aucune regle ASR configuree)'
    }
} catch {}

Section "A2.4 Threats detectees recemment"
try {
    Get-MpThreatDetection -ErrorAction Stop |
        Select-Object DetectionID, ThreatID, InitialDetectionTime, Resources |
        Format-Table -AutoSize
} catch {
    Write-Host '(aucune detection ou Get-MpThreatDetection indisponible)'
}

Section "A2.5 Pare-feu Windows - profils"
Get-NetFirewallProfile |
    Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction, AllowInboundRules, NotifyOnListen, LogAllowed, LogBlocked, LogFileName |
    Format-Table -AutoSize

Section "A2.6 Pare-feu - regles entrantes ALLOW non-built-in (top 50)"
try {
    Get-NetFirewallRule -Direction Inbound -Action Allow -Enabled True |
        Where-Object { $_.PolicyStoreSourceType -ne 'Hardcoded' } |
        Select-Object DisplayName, DisplayGroup, Profile, Direction, Action, Enabled, PolicyStoreSourceType |
        Sort-Object DisplayGroup, DisplayName |
        Select-Object -First 50 |
        Format-Table -AutoSize
} catch {
    Write-Host ('(Get-NetFirewallRule indisponible : ' + $_.Exception.Message + ')')
}

Section "A2.7 Ports en ecoute (TCP) - tous"
try {
    Get-NetTCPConnection -State Listen |
        Select-Object LocalAddress, LocalPort, OwningProcess,
            @{n='Process';e={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).Name}} |
        Sort-Object LocalPort |
        Format-Table -AutoSize
} catch {
    Write-Host ('(Get-NetTCPConnection indisponible : ' + $_.Exception.Message + ')')
}

Section "A2.8 Ports UDP en ecoute"
try {
    Get-NetUDPEndpoint |
        Select-Object LocalAddress, LocalPort, OwningProcess,
            @{n='Process';e={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).Name}} |
        Sort-Object LocalPort |
        Format-Table -AutoSize
} catch {
    Write-Host ('(Get-NetUDPEndpoint indisponible : ' + $_.Exception.Message + ')')
}

Write-Host ""
Write-Host "=== FIN BLOC A (systeme + Defender + firewall) ===" -ForegroundColor Green
Write-Host ("Genere : " + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
