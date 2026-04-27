# ====================================================================
# Audit Securite S68 - Bloc F (autonome PS, pas admin requis)
# Enumeration DNS publique de might.ovh + check HIBP des 4 boites email.
# Lecture seule, requetes DNS et HTTP publiques.
# ====================================================================

$ErrorActionPreference = 'Continue'

function Section($title) {
    Write-Host ""
    Write-Host ("=== " + $title + " ===") -ForegroundColor Cyan
}

# ==============================================================
# F.1 - DNS records principaux de might.ovh (via Cloudflare 1.1.1.1)
# ==============================================================

Section "F.1 might.ovh - records DNS principaux"
$resolver = '1.1.1.1'
foreach ($t in 'A','AAAA','MX','TXT','NS','SOA','CAA') {
    Write-Host ""
    Write-Host ("  --- $t ---")
    try {
        Resolve-DnsName -Name 'might.ovh' -Type $t -Server $resolver -ErrorAction Stop |
            Select-Object Name, Type, Section, IPAddress, NameExchange, Strings, NameHost, PrimaryServer |
            Format-Table -AutoSize
    } catch {
        Write-Host ("    (echec : " + $_.Exception.Message + ")")
    }
}

# ==============================================================
# F.2 - Brute-force sous-domaines courants
# ==============================================================

Section "F.2 might.ovh - brute force sous-domaines (resolution publique uniquement)"
$subdomains = @(
    'www','mail','smtp','imap','pop','webmail','autodiscover','autoconfig','mta-sts',
    'ha','homeassistant','home','mqtt','z2m','z2m-ha','frigate',
    'mcp','api','mcp1','mcp2','mcp-ha','mcp-internal',
    'admin','admin1','adminer','dashboard','panel','portal','gw','gateway','router','router1',
    'vpn','vpn1','vpn2','wg','wireguard','openvpn','tailscale','zerotier',
    'cloud','drive','nextcloud','owncloud','seafile',
    'git','gitlab','gitea','code','dev',
    'monitoring','grafana','prometheus','uptime','status','metrics',
    'plex','jellyfin','emby','navidrome','immich','photoprism',
    'smb','samba','nas','dsm','synology','qnap',
    'cam','cameras','rtsp','onvif','dahua','dahua1','dvr','nvr','blueiris',
    'proxmox','pve','pve1','pve2','docker','portainer','homarr','dashy','heimdall','homer',
    'pi','rpi','raspberrypi','pihole','adguard',
    'wiki','docs','obsidian','knowledge','blog','hugo',
    'login','sso','oauth','keycloak','authelia','authentik',
    'public','private','internal','intranet','extranet',
    'cf','cloudflare','tunnel','proxy','reverse',
    'tv','tvbox','firetv','chromecast',
    'office','calendar','tasks','todo','notion',
    'ai','llm','ollama','sd','comfy','open-webui','openwebui','hermes',
    'mqttbridge','homebridge','homekit','matter','thread',
    'bridge','controller','hub','core',
    'old','legacy','test','staging','prod','beta','dev2','tmp','backup',
    'mickael','might','m'
)
$found = @()
foreach ($s in $subdomains) {
    $name = "$s.might.ovh"
    try {
        $r = Resolve-DnsName -Name $name -Type A -Server $resolver -ErrorAction Stop -DnsOnly
        $ips = ($r | Where-Object { $_.IPAddress } | Select-Object -ExpandProperty IPAddress) -join ','
        $cname = ($r | Where-Object { $_.Type -eq 'CNAME' } | Select-Object -ExpandProperty NameHost) -join ','
        $info = if ($cname) { "CNAME -> $cname" } else { "A: $ips" }
        Write-Host ("  [HIT] {0,-35} -> {1}" -f $name, $info)
        $found += [pscustomobject]@{ Name = $name; Info = $info }
    } catch {
        # NXDOMAIN ou DNS error - silencieux
    }
}
Write-Host ""
Write-Host ("Total sous-domaines trouves : " + $found.Count)

# ==============================================================
# F.3 - SPF / DKIM / DMARC sur might.ovh
# ==============================================================

Section "F.3 SPF / DKIM / DMARC pour might.ovh (anti-phishing email)"

Write-Host "--- SPF (TXT might.ovh contenant 'v=spf1') ---"
try {
    $spf = (Resolve-DnsName -Name 'might.ovh' -Type TXT -Server $resolver -ErrorAction Stop).Strings | Where-Object { $_ -like 'v=spf1*' }
    if ($spf) { Write-Host ("  " + $spf) } else { Write-Host "  (PAS de SPF defini)" }
} catch { Write-Host ("  (lookup echec : " + $_.Exception.Message + ")") }

Write-Host ""
Write-Host "--- DMARC (TXT _dmarc.might.ovh) ---"
try {
    $dmarc = (Resolve-DnsName -Name '_dmarc.might.ovh' -Type TXT -Server $resolver -ErrorAction Stop).Strings
    if ($dmarc) { Write-Host ("  " + ($dmarc -join ' ')) } else { Write-Host "  (PAS de DMARC)" }
} catch { Write-Host "  (PAS de DMARC ou NXDOMAIN)" }

Write-Host ""
Write-Host "--- DKIM (selectors courants : default, google, k1, mail, selector1, selector2) ---"
foreach ($sel in 'default','google','k1','mail','selector1','selector2','dkim') {
    $domain = "$sel._domainkey.might.ovh"
    try {
        $r = Resolve-DnsName -Name $domain -Type TXT -Server $resolver -ErrorAction Stop
        Write-Host ("  [HIT] $domain")
    } catch {}
}

# ==============================================================
# F.4 - Reverse DNS sur l'IP publique might.ovh
# ==============================================================

Section "F.4 Reverse DNS"
try {
    $a = (Resolve-DnsName -Name 'might.ovh' -Type A -Server $resolver -ErrorAction Stop | Where-Object { $_.IPAddress }).IPAddress
    foreach ($ip in $a) {
        Write-Host ("  IP : $ip")
        try {
            $rev = Resolve-DnsName -Name $ip -Server $resolver -ErrorAction Stop
            $rev | Format-Table -AutoSize
        } catch { Write-Host ("    (PTR lookup echec : " + $_.Exception.Message + ")") }
    }
} catch { Write-Host ("  (echec lookup A : " + $_.Exception.Message + ")") }

# ==============================================================
# F.5 - HaveIBeenPwned via Mozilla Monitor public (sans cle API)
# ==============================================================

Section "F.5 HaveIBeenPwned API publique - 4 boites email"
$emails = @(
    'might57290@gmail.com',
    'mighthomeassistant@gmail.com',
    'mickael.rubino@gmail.com',
    'might@live.fr'
)

# HIBP API publique pour breaches (k-anonymity sur SHA1) - PSWD only
# Pour les emails, l'API breach v3 necessite une cle (~$4/mois). On utilise donc
# le check via la page publique. On va seulement tester l'existence cote HIBP via leur
# endpoint domain-search ou leur Range API. Pour simplicite, on appelle leur endpoint
# /api/breachedaccount/{email}?truncateResponse=true qui renvoie 404 ou la liste.

foreach ($email in $emails) {
    Write-Host ""
    Write-Host ("  Email : $email")
    try {
        $headers = @{ 'User-Agent' = 'JarvisAuditS68' }
        $url = "https://haveibeenpwned.com/api/v3/breachedaccount/$([uri]::EscapeDataString($email))?truncateResponse=true"
        $resp = Invoke-WebRequest -Uri $url -Headers $headers -ErrorAction Stop -TimeoutSec 10 -UseBasicParsing
        $breaches = ($resp.Content | ConvertFrom-Json) | Select-Object -ExpandProperty Name
        Write-Host ("    [PWNED] Breaches : " + ($breaches -join ', '))
    } catch {
        if ($_.Exception.Response.StatusCode.value__ -eq 404) {
            Write-Host "    [SAFE] Aucun breach trouve (HIBP)"
        } elseif ($_.Exception.Response.StatusCode.value__ -eq 401) {
            Write-Host "    (HIBP API exige une cle - check manuel sur https://haveibeenpwned.com/account/$email)"
        } else {
            Write-Host ("    (echec : " + $_.Exception.Message + ")")
        }
    }
    Start-Sleep -Milliseconds 2000  # rate limit HIBP
}

# ==============================================================
# F.6 - HaveIBeenPwned check pastes
# ==============================================================

Section "F.6 HIBP - pastes (collages publics potentiellement contenant les emails)"
foreach ($email in $emails) {
    Write-Host ""
    Write-Host ("  Email : $email")
    try {
        $headers = @{ 'User-Agent' = 'JarvisAuditS68' }
        $url = "https://haveibeenpwned.com/api/v3/pasteaccount/$([uri]::EscapeDataString($email))"
        $resp = Invoke-WebRequest -Uri $url -Headers $headers -ErrorAction Stop -TimeoutSec 10 -UseBasicParsing
        $pastes = ($resp.Content | ConvertFrom-Json) | Select-Object Source, Title
        $pastes | Format-Table -AutoSize
    } catch {
        if ($_.Exception.Response.StatusCode.value__ -eq 404) {
            Write-Host "    [SAFE] Aucun paste trouve"
        } else {
            Write-Host ("    (echec : " + $_.Exception.Message + ")")
        }
    }
    Start-Sleep -Milliseconds 2000
}

Write-Host ""
Write-Host "=== FIN BLOC F ===" -ForegroundColor Green
Write-Host ("Genere : " + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
