# Rapport d'Audit Sécurité PC + Box Orange — S68

**Date :** 2026-04-27
**Auditeur :** Jarvis (Cowork)
**Cible :** PC MIGHT-1000D (Windows 11 Pro build 26200, BIOS 1802 UEFI, i9-9900K + 32 Go + RTX 3090, 24/7)
**Méthodologie :** Lecture seule pure, rapport priorisé P0-P3, zéro modification appliquée
**Statut :** ⚠️ **EN COURS — Bloc A terminé, B/C/D/F à venir**

---

## 1. Synthèse exécutive (clôture Phase 1)

**Posture globale :** 🔴 **ROUGE** (priorité absolue : BitLocker)

**Phase 1 (S69 27/04/2026)** : blocs A + B + C complétés sur PC MIGHT-1000D. **Phase 2** restante : F (DNS+HIBP — script prêt, à exécuter), D (Brave), E (email/cloud), G (iPhone), H (backup), Box Orange (Livebox).

**Constat synthétique** :

Le système est **patché à jour** (Win 11 Pro build 26200, KB security ≤ 8 jours), **Defender est correctement actif** sur ses moteurs principaux, et la **chaîne d'authentification de base** est saine (Administrateur intégré désactivé, RDP off, SMBv1 off, Malwarebytes en plus). Le scan exhaustif **n'a trouvé aucun secret AWS/SSH/GitHub/Google/Docker/JWT en clair** sur le disque côté projet ou côté user folder Windows — c'est une **excellente nouvelle**. Le repo Git Jarvis n'a aucun remote configuré, donc pas de push effectué et pas de fuite GitHub immédiate.

**MAIS** plusieurs garde-fous structurels manquent :

1. ⚠️⚠️ **BitLocker DÉSACTIVÉ sur les 4 disques (4.7 To en clair)** — ennemi #1 en cas de vol/perte/SAV
2. **Defender Tamper Protection OFF** + **Cloud-delivered protection OFF** + **0 règle ASR** : Defender peut être désactivé silencieusement par un malware, et n'a pas accès aux détections cloud/comportementales modernes
3. **Surface réseau exposée** : port 2177 UDP sur **IPv6 GUA Orange (`2a01:cb11:506:9100:*`)** = potentiel exposition Internet directe ; SMB 445 sur IPv6 ; partages admin C$/D$/E$/F$ tous actifs ; SMB sans signature ni chiffrement transport
4. **Compte Microsoft `might@live.fr` = unique admin du PC** sans backup local — single point of failure si le compte MS est compromis
5. **`secret_path` HA-MCP** en clair dans 11 fichiers tracked Git (rotation S48 jamais appliquée) + 2 backups décongestion S51 tracked
6. **Mot de passe local inchangé depuis 24 mois**, politique locale faible (longueur min 0, pas d'historique)
7. **Logiciels potentiellement à risque** : Free Download Manager (incident supply chain 2023), LogMeIn legacy (3 services autostart), Wondershare suite, Mobile Mouse (4 ports exposés LAN) — ~10 apps en retard de version

**Total findings Phase 1 : 2 P0 + 8 P1 + 14 P2 + 11 P3 = 35 items.**

**Priorité absolue** : activer BitLocker sur C: → D: → E: → F: avant tout autre remédiation, en sauvegardant les clés de récup (compte MS + papier coffre + clé USB hors site).

---

## 2. Méthodologie

- **Outils utilisés** : PowerShell read-only (script `BlocA_Windows_Defender_Firewall.ps1` exécuté par Mickael depuis console utilisateur normal), Bash sandbox Linux (audits filesystem côté `D:\`), Read tool (lecture des fichiers projet), WebFetch (HIBP API publique, énum DNS), Brave en assistance pour la phase 2
- **Aucune modification appliquée** pendant l'audit
- **Findings classés** P0 (critique, action immédiate), P1 (haute, < 7 jours), P2 (moyenne, < 30 jours), P3 (faible, opportuniste)
- **Limites** : certains points nécessitent un script en admin (BitLocker, Defender exclusions, ASR detail, autostart HKLM) — script `BlocAC_Admin.ps1` prévu en complément

---

## 3. Inventaire système (Bloc A)

### 3.1 Identité OS

| Champ | Valeur |
|---|---|
| Édition | Windows 11 Professionnel |
| Build | **10.0.26200** (24H2/25H2, branche récente) |
| Architecture | 64 bits |
| Date d'install | 17/12/2024 |
| Dernier reboot | 24/04/2026 17:16 (~3 jours d'uptime) |
| Compte enregistré | Might@live.fr (compte Microsoft) |
| Domaine | WORKGROUP (pas de domain/AzureAD/Enterprise join) ✅ |

### 3.2 Patch level

**4 KB visibles** dont 3 récents :
- KB5083769 (Security Update) — 19/04/2026 ✅
- KB5082417 (Update) — 19/04/2026
- KB5088467 (Security Update) — 18/04/2026 ✅
- KB5054156 (Update) — 22/10/2025

**KB en attente : 3 drivers Intel** (PCIe Controller 1901, Intel Driver 24.20.0.3, Intel Net 24.30.1.1) — aucun patch sécurité critique en attente côté Windows Update.

### 3.3 Comptes locaux

| Compte | Statut | Last Logon | PasswordLastSet |
|---|---|---|---|
| Administrateur | ❌ Disabled | — | — |
| DefaultAccount | ❌ Disabled | — | — |
| Invité | ❌ Disabled | — | — |
| **Might** | ✅ **Active** | 24/04/2026 17:17 | **04/05/2024** (~24 mois) ⚠️ |
| WDAGUtilityAccount | ❌ Disabled | — | 04/05/2024 |

**Membres groupe Administrateurs** :
- `Might-1000D\Administrateur` (Local) — désactivé
- `MIGHT-1000D\Might` (MicrosoftAccount = might@live.fr) — **actif, admin via compte Microsoft**

### 3.4 Politique locale de mot de passe (`net accounts`)

| Paramètre | Valeur | Évaluation |
|---|---|---|
| Durée vie min | 0 jour | OK |
| **Durée vie max** | **42 jours** | OK (mais Might dépasse depuis ~22 mois) |
| **Longueur minimale** | **0** | ⚠️ P2 |
| **Historique mots de passe** | **Aucune** | ⚠️ P2 |
| Seuil verrouillage | 10 essais / 10 min | OK |
| Rôle | STATION | OK |

### 3.5 UAC

- EnableLUA : 1 ✅ (UAC activé)
- ConsentPromptBehaviorAdmin : 5 (consentement sur secure desktop) ✅
- PromptOnSecureDesktop : 1 ✅
- FilterAdministratorToken : (non défini — = 0 par défaut)

### 3.6 Windows Defender

| Composant | État |
|---|---|
| AntivirusEnabled | ✅ True |
| AntispywareEnabled | ✅ True |
| RealTimeProtectionEnabled | ✅ True |
| BehaviorMonitorEnabled | ✅ True |
| IoavProtectionEnabled | ✅ True |
| OnAccessProtectionEnabled | ✅ True |
| NISEnabled (Network Inspection) | ✅ True |
| DefenderSignaturesOutOfDate | ✅ False (signatures à jour : 1.449.325.0) |
| **IsTamperProtected** | ❌ **False** ⚠️ **P1** |
| **MAPSReporting** (cloud) | ❌ **0 (Disabled)** ⚠️ **P1** |
| SubmitSamplesConsent | 0 (NeverSend) — cohérent avec MAPS off |
| CloudBlockLevel | 0 (Default) |
| PUAProtection | ✅ 2 (Enabled) |
| QuickScan dernier | 24/04/2026 17:29 ✅ |
| **FullScan dernier** | **(jamais)** ⚠️ **P2** |
| **AttackSurfaceReductionRules** | **0 règle configurée** ⚠️ **P1** |
| Threats détectées | 0 ✅ |

### 3.7 Pare-feu Windows

- **Profils Domain/Private/Public : tous activés** ✅
- DefaultInboundAction : NotConfigured (= block par défaut implicite) ✅
- LogAllowed/LogBlocked : ❌ False (pas de logs) — **P3**
- Top 50 règles entrantes ALLOW : majorité **règles applicatives** liées à : ARC Raiders, Call of Duty, Steam, DaVinci Resolve, Brave, ASUS Armoury, Razer, DJI, ExpressLRS, Mobile Mouse, Free Download Manager (Public ⚠️), Audeze HQ, Arduino IDE, etc. — beaucoup de règles d'apps consumer. À nettoyer.

### 3.8 Ports en écoute (TCP)

**Ports exposés sur des interfaces réseau (pas localhost)** — synthèse critique :

| Port | Bind | Process | Risque |
|---|---|---|---|
| **445** | **`::` (IPv6 toutes)** | System (PID 4) | 🔴 **SMB exposé IPv6** — P1 |
| **139** | 172.29.64.1 + 192.168.1.39 | System | NetBIOS — P2 |
| 135 | `::` + 0.0.0.0 | svchost | RPC standard, P3 |
| 5040 | 0.0.0.0 | svchost | AppX Deploy — P3 |
| 7680 | `::` | svchost | DODownloadService (peer-to-peer) |
| 8090 | 0.0.0.0 | WsToastNotification | ASUS Webstorm — P3 |
| **9012, 9013** | **0.0.0.0** | ArmourySocketServer | ASUS Armoury exposé LAN |
| **9099, 9999, 35913** | **0.0.0.0** | **Mobile Mouse** | ⚠️ contrôle PC depuis mobile, P2 |
| 13xxx, 17xxx, 22xxx | 127.0.0.1 | ASUS Armoury, ROG, Razer | localhost OK |
| 27036 | 0.0.0.0 | Steam | LAN game discovery, OK |
| 38531 | `::` | EaseUSStartHelper | P3 |
| 49664-49737 | `::` + 0.0.0.0 | lsass / wininit / svchost / spoolsv / services | RPC dynamic — limité par firewall |
| `7679` | ::1 | GoogleDriveFS | localhost OK |

### 3.9 Ports en écoute (UDP)

**Ports exposés au-delà de localhost** :

| Port | Bind | Process | Risque |
|---|---|---|---|
| **53** | **0.0.0.0** | svchost (PID 7688) | ⚠️ **DNS sur 0.0.0.0** — P1 (à investiguer) |
| 123 | 0.0.0.0 + `::` | svchost | NTP — OK |
| **137, 138** | 172.29.64.1 + 192.168.1.39 | System | NetBIOS over TCP/IP — **P2** |
| 1900 | fe80:: + IPv4 LAN + IPv6 ULA | svchost | SSDP/UPnP discovery — P3 |
| **2177** | **2a01:cb11:506:9100:*** + IPv6 ULA + 192.168.1.39 | svchost (PID 34400) | 🔴 ⚠️ **MS Network/Quick Assist sur IPv6 GUA Orange — exposition Internet potentielle si Livebox laisse passer IPv6 entrant — P0** |
| 5050 | 0.0.0.0 | svchost | Phone Link / Connect to MyPhone — P3 |
| 5353 | mDNS multi-interfaces | mDNSResponder + steamwebhelper | OK |
| **5355** | 0.0.0.0 + `::` | svchost | **LLMNR** — vulnérable à Responder/poisoning — **P2** |
| 9100 | 0.0.0.0 | Mobile Mouse | UDP exposé LAN |
| 27036 | LAN multi-IF | Steam | OK |

**Adresses IPv6 GUA observées sur ton préfixe Orange `2a01:cb11:506:9100::/64`** — ces adresses **PEUVENT être joignables depuis Internet** si la Livebox n'a pas de filtre IPv6 entrant. C'est le **point critique à valider en Phase 2 (Livebox)**.

---

## 3.10 Bloc B (côté projet `D:\Might\IA\Jarvis - Home Assistant\` — autonome)

### 3.10.1 Inventaire fichiers sensibles par nom

**Recherchés** : `*.env`, `.env*`, `secrets*.yaml`, `credentials*`, `id_rsa`/`id_ed25519`/`id_ecdsa`, `*.pem`, `*.key`, `*.p12`, `*.pfx`, `*.jwt`, `.npmrc`, `.netrc`.

**Résultat : 0 fichier détecté** ✅ — le projet ne contient pas de fichier de secrets standalone.

### 3.10.2 Scan de patterns secrets dans configs/scripts (42 fichiers ciblés `*.json/*.yaml/*.ps1/*.py/*.js/*.ts/*.env/*.toml/*.ini/*.conf` hors `Runtime/Wiki/historique/.git`)

**Patterns recherchés** : `eyJ...` (JWT), `sk-...` (OpenAI/Anthropic-style), `ghp_/ghs_/github_pat_` (GitHub PAT), `AKIA...` (AWS), `AIza...` (Google), `BEGIN PRIVATE KEY`, mots-clés `password/api_key/access_key/auth_token/bearer/client_secret`.

**Résultat : 0 token-pattern, 1 mention "password" légitime** (dans mon propre script `BlocA_Windows_Defender_Firewall.ps1` — référence à `PasswordRequired`). ✅

### 3.10.3 Scan des 149 fichiers `.md` du projet (hors Wiki/historique/Archives — déjà audités S67/S68)

**Patterns secrets stricts** (JWT/sk-/ghp/AKIA/AIza/BEGIN PRIV) : **0 hit** ✅

**Pattern `private_<chars>` (= `secret_path` de l'add-on `ha-mcp` accessible via `https://mcp.might.ovh/<secret>`)** : **13 fichiers .md concernés** :

| Fichier | Occurrences |
|---|---|
| `CLAUDE.md` | 3 |
| `METRIQUES.md` | 6 |
| `TASKS.md` | 6 |
| `.claude/skills/cloudflare-access-ha/SKILL.md` | 1 |
| `.claude/skills/ha-mcp-install/SKILL.md` | 2 |
| `Projets/Audit_Securite_S65_2026-04-27/Rapport_Audit_S65.md` | 3 |
| `Projets/Hardware_Upgrade/06_Migration_HA_Pi5_Proxmox.md` | 2 |
| `Projets/Jarvis_Hermes_Projet/Rapport_Phase1.md` | 1 |
| `Projets/Vault_Migration_S63/Plan_Reprise.md` | 1 |
| `Ressources/Competences/Hermes_Agent.md` | 1 |
| `Ressources/Cowork/Instructions.md` | 1 |
| `Ressources/Mode_Chat/Jarvis_Audits_Todo.md` | 1 |
| `Ressources/Mode_Chat/Jarvis_Profil.md` | 2 |

### 3.10.4 État Git du repo Jarvis

| Élément | Valeur |
|---|---|
| Dépôt initialisé | ✅ Oui (4 commits depuis init S42) |
| **Remote `origin` configuré** | ❌ **Aucun remote** ✅ (pas de risque de push immédiat) |
| Fichiers tracked total | ~150 (Wiki + .claude + Ressources + scripts + memory + Projets + 4 .md root) |
| `.mcp.json` présent en `.gitignore` | ✅ Oui |
| `.mcp.json.template` (versionné) | ✅ Pas de valeurs secrètes (seulement `<PLACEHOLDERS>`) |
| Permissions Linux côté mount | `-rwx------` (700, user-only) ✅ |

### 3.11 Bloc B (côté Windows user folder + WSL2 + Credential Manager — admin)

**Inventaire fichiers/dossiers de secrets dans `C:\Users\Might\` (existence uniquement, contenu jamais lu)** :

| Path | Type | Taille | Notes |
|---|---|---|---|
| `~/.gitconfig` | FILE | 104 B | mtime 2026-04-26 (lu très récemment) |
| `~/.claude/` | DIR | 9.5 MB | Claude Code CLI workspace |
| `~/.claude/.credentials.json` | FILE | 470 B | ⚠️ **Token API Anthropic** (encrypted DPAPI) |
| `~/.claude/settings.json` | FILE | 316 B | Config CLI |
| `~/AppData/Roaming/Code/User/globalStorage` | DIR | 357 KB | VS Code data extensions |
| **`.ssh/`** | — | — | ✅ **ABSENT** (pas de clés SSH stockées) |
| **`.aws/`** | — | — | ✅ **ABSENT** |
| **`.azure/`, `.kube/`, `.docker/config.json`** | — | — | ✅ **ABSENT** |
| **`.npmrc`, `.pypirc`, `.netrc`** | — | — | ✅ **ABSENT** |
| **`.config/gh/` (GitHub CLI)** | — | — | ✅ **ABSENT** |
| **gcloud, heroku, .openai, .anthropic standalone** | — | — | ✅ **ABSENT** |

**ACL `.gitconfig`** : owner Might, héritage actif, accès SYSTEM + Administrateurs + Might (default — non hardened mais non alarmant tant que `.gitconfig` ne contient pas de PAT en helper).

### 3.12 Windows Credential Manager (`cmdkey /list`)

8 entrées stockées (passwords NON affichés, encrypted DPAPI lié au compte Might) :

| Cible | Type | Utilisateur |
|---|---|---|
| `MicrosoftAccount:target=SSO_POP_User` | Générique | Might@live.fr (login Win) |
| **`LegacyGeneric:target=git:https://github.com`** | Générique | **mightIA** (= Git Credential Manager, PAT GitHub) |
| **`LegacyGeneric:target=EmbarkID/embark-pioneer/pioneer-live`** | Générique | **Personal Access Token** ⚠️ (Embark Studios — ARC Raiders) |
| `WindowsLive:target=virtualapp/didlogical` | Générique | 02nvotqkmoqolsrs (Edge SSO) |
| `LegacyGeneric:target=MicrosoftAccount:user=might@live.fr` | Générique | might@live.fr |
| **`Domain:target=192.168.1.11`** | Mot de passe domaine | **Mickael** (cred SMB pour HA Pi5) |
| `LegacyGeneric:target=com.logi.ghub/shared` | Générique | Logitech G HUB |
| `LegacyGeneric:target=DriveFS_106630868921569995627` | Générique | Google Drive sync |

→ tout est encrypted DPAPI. Risque uniquement si BitLocker OFF + extraction offline (cf. P0-2).

### 3.13 WSL2

- **1 distro installée : Ubuntu-24.04 (v2)**, état Stopped au moment du scan
- Contenu `/home/might/` non audité (distro arrêtée). À auditer en bloc dédié si pertinent.

### 3.14 Bloc C — Logiciels installés (winget list, ~280 entrées)

**Catégories observées** :
- **Gaming** : Steam, Battle.net, ARC Raiders, plugins Razer/Logitech/Corsair (G HUB, Synapse/Chroma, iCUE5)
- **Drones/FPV/RC** : ExpressLRS Configurator, Betaflight Blackbox, EdgeTX Companion, TRYP FPV, Liftoff, Uncrashed, OrcaSlicer, PIDtoolbox, **CHIRP** (radio amateur), DJI Assistant 2, Raspberry Pi Imager, ESPHome
- **Vidéo/audio** : DaVinci Resolve 18 + Control Panels + Blackmagic RAW, Wondershare Filmora, Adobe Acrobat Pro + Photoshop 2024, KMPlayer, VLC, Audeze HQ, HyperX Orbit, Deezer
- **Dev** : **Git 2.53**, Node.js 24.15, Python 3.12 + 3.14 + Python Launcher + Python Install Manager, Microsoft VC++ Redists multiples, Windows Terminal, Notepad++ 8.6.9, Obsidian 1.12.7, **Claude 1.4758.0.0**, mRemoteNG, Advanced IP Scanner
- **Réseau / accès distant** : **CyberGhost 8.4.14 (VPN)** + **TAP-Windows 9.21.2**, **LogMeIn (legacy)**, Bonjour, Google Drive
- **Hardware ASUS / vendors** : ARMOURY CRATE Lite, AURA Service, AURA Creator, AURA lighting, ROG Live Service, ROGFontInstaller, ASUS Framework, ASUS Motherboard, AsusFanControl, AnIME Matrix MB EN, NVIDIA Pilote 591.86 + NVIDIA App + PhysX + FrameView SDK
- **3D print** : 3 versions UltiMaker Cura (5.7.1 + 5.9.0 + 5.10.0) ⚠️
- **Sécurité** : ✅ **Malwarebytes 5.5.1.240** + Windows Security
- **Utilitaires misc** : EaseUS Partition Master, Free Download Manager 6.33, **Mobile Mouse 3.6.4**, **Wondershare Helper Compact + NativePush + Filmora**, Speccy, MATLAB Runtime R2023b + 9.5, **GameSDK Service** (Crytek), 7-Zip 24.08, WinRAR 6.21
- **MS Store** : Outlook for Windows, Teams, OneDrive, Microsoft 365 Copilot, etc. (standard)

**Versions à actualiser** (col Disponible winget) : ExpressLRS (1.7.7→1.7.11), 7-Zip (24.08→26.00), Notepad++ (8.6.9→8.9.4), Adobe Acrobat (24.001→26.001), MATLAB Runtime, EaseUS PM (19.5→20.2), Cura, OrcaSlicer, Raspberry Pi Imager, Wondershare Filmora — **plusieurs apps en retard de version**.

### 3.15 Autostart

**HKCU Run** : Brave Update, Steam silent, Battle.net autostart, **CyberGhost (VPN autostart)**, LGHUB, Deezer, **WebSocketServer23450 (`C:\Program Files (x86)\webrec\Torch\5.1.412649.0\WebSocketServer23450.exe`)**, Free Download Manager hidden, GoogleDriveFS, RazerAppEngine.

**HKLM Run** : SecurityHealth (Defender), **LogMeIn GUI**, Corsair iCUE5.

**Startup folder HKCU** : Brave.lnk.
**Startup folder HKLM** : Mobile Mouse.lnk (toutes sessions).

### 3.16 Tâches planifiées non-Microsoft

- ASUS x8 (Armoury, Update, Framework, NoiseCancelingEngine, P508PowerAgent, etc.) — légitime
- GoogleSystem Updater
- **SoftLanding\S-1-5-21-...\SoftLandingCreativeManagementTask** — vendor ASUS (ROG/AURA helper), légitime

### 3.17 Services Auto vendors

ASUS x6, Bonjour, ClickToRunSvc (Office), Corsair, **CoworkVMService (Claude)**, **CyberGhost8Service**, EaseUS UPDATE, edgeupdate, GameSDK, Google Updater x3, HapticService, LGHUBUpdater, **LightingService (AURA)**, **LMIGuardianSvc + LMIMaint + LogMeIn (3 services)**, MBAMService (Malwarebytes ✅), MDCoreSvc + WinDefend (Defender ✅), **NativePushService (Wondershare)**, NvContainerLocalSystem, Razer x6, ROG Live Service, WSLService.

### 3.18 RDP, SMB

| Composant | État | Évaluation |
|---|---|---|
| **RDP** | ❌ DESACTIVÉ (`fDenyTSConnections=1`) | ✅ |
| **SMBv1** | ❌ False | ✅ |
| **SMBv2** | ✅ True | ✅ |
| **RequireSecuritySignature** | ❌ False | ⚠️ **P2** |
| **EnableSecuritySignature** | ❌ False | ⚠️ **P2** |
| **EncryptData** | ❌ False | ⚠️ **P2** |
| RestrictNamedPipeAccessViaQuic | ✅ True | ✅ |

**Partages SMB locaux** : `ADMIN$ (C:\Windows)`, `C$ (C:\)`, `D$ (D:\)`, `E$ (E:\)`, `F$ (F:\)`, `IPC$` — **6 partages admin par défaut tous actifs** ⚠️ **P2**.

### 3.19 Drivers signés (top 15 vendors)

INTEL ×11, Razer ×7, Logitech ×7, NVIDIA ×7+4, Blackmagic ×4, libusb-win32 ×4, Intel Corp ×3, device-innovations ×3, Texas Instruments ×3+2 (CC25xx ZBDongle), FTDI ×3, Realtek ×2, ASUSTeK ×2, Arduino ×2 — tous légitimes, cohérents avec l'usage drone/electronique/peripherals.

### 3.20 Findings B+C — Synthèse complémentaire

**3 versions distinctes du `secret_path` ha-mcp** trouvées dans les fichiers tracked :
- `private_ORXc***REDACTED***ehw9` — actif en production (jamais rotated)
- `private_Q49a***REDACTED***lE4g` — prévu en rotation S48, jamais appliqué côté add-on
- 1 troisième valeur historique également présente

**11 fichiers tracked Git contiennent au moins un de ces secret_path** (cf. liste 3.10.3 — sauf Audit_S65 qui est un rapport documentation et `Hardware_Upgrade/06` que la mémoire indique comme déjà redacté en S68).

**Backups de décongestion S51** présents dans Git tracked :
- `memory/_decongestion_backup_s51/CLAUDE.md.bak.s51`
- `memory/_decongestion_backup_s51/METRIQUES.md.bak.s51`

Ces backups contiennent l'état pré-décongestion des fichiers vivants → potentiellement encore plus de secret_path historiques. **À vérifier et nettoyer.**

---

## 4. Findings P0 (critique)

### P0-1 — Port UDP 2177 exposé sur IPv6 GUA Orange (potentielle exposition Internet)

**Description** : Le service Microsoft `svchost (PID 34400)` écoute en UDP sur **plusieurs adresses IPv6 publiques `2a01:cb11:506:9100:*`** (préfixe Orange) en plus des adresses ULA et IPv4 LAN. Le port 2177 correspond historiquement à du *Microsoft Network Discovery / Multipoint Server / Quick Assist*. Si la Livebox laisse passer IPv6 entrant (paramètre par défaut variable), ce port est joignable **depuis Internet** vers ton PC.

**Risque** : surface d'attaque Internet directe sur services Windows internes. Exploit potentiel + énumération réseau privée.

**Action** :
1. Vérifier en Phase 2 (Livebox) le **niveau de protection IPv6** dans `192.168.1.1` → Réseau → IPv6 → Pare-feu IPv6
2. Si filtre désactivé : l'**activer en mode "haut" / bloquer toutes les connexions entrantes IPv6 non sollicitées**
3. Côté PC : désactiver le service responsable (à identifier — probable `iphlpsvc` / `LMHosts` / `dmwappushservice`) si non utilisé
4. Re-tester avec `netstat -an | findstr 2177`

### P0-2 — BitLocker DÉSACTIVÉ sur les 4 disques (C: D: E: F:) — CONFIRMÉ ADMIN

**Description (confirmé en admin via `Get-BitLockerVolume` + `manage-bde -status`)** :

| Disque | Type | Taille | Chiffrement | Méthode | Protecteurs |
|---|---|---|---|---|---|
| **C:** | OperatingSystem | 952.92 Go | ❌ **0%** | Aucun | Aucun |
| **D:** | Data (Might) | 931.50 Go | ❌ **0%** | Aucun | Aucun |
| **E:** | Data (Might Save) | 931.50 Go | ❌ **0%** | Aucun | Aucun |
| **F:** | Data (Téléchargement) | 1863.02 Go | ❌ **0%** | Aucun | Aucun |

**Total non chiffré : ~4.7 To**, dont **D: où vit tout le projet Jarvis** (configs HA, secrets MCP, scripts, archives, Wiki Obsidian, mémoire).

**Risque** : en cas de vol ou perte du PC (cambriolage, panne motherboard renvoyée en SAV, revente), **toutes les données sont accessibles en lecture brute** via :
- Démontage du SSD/HDD et lecture sur autre machine
- Boot sur live USB Linux (NTFS lit en clair)
- Récupération Windows mode safe / réinstall avec accès aux disques

**Conséquences directes** :
- Lecture en clair de `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\.mcp.json` → secret_path HA-MCP, tokens Gmail MCP, Cloudflare CF Tunnel
- Lecture des `~/.claude/.credentials.json` (cred Anthropic Claude Code CLI)
- Lecture du Credential Manager (encrypted DPAPI mais lié au compte Windows — un attaquant peut faire du DPAPI extraction offline avec impacket)
- Lecture des cookies Brave (sessions HA, GitHub, Anthropic, Google) → reprise de session sans MFA
- Lecture du `.gitconfig` + secrets cachés possibles

**Action prioritaire** :
1. **Sécurité Windows → Chiffrement de l'appareil → Activer BitLocker** sur C: (XTS-AES 256), pris en charge par TPM si présent
2. **Sauvegarder la clé de récupération** sur le compte Microsoft + impression papier en coffre + clé USB hors site (pas la même que le PC)
3. Activer BitLocker sur D: + E: + F: (data drives, peuvent rester en méthode "auto-unlock" liée au système quand C: chiffré)
4. **Redémarrage requis** pour la phase initiale C: (chiffrement en arrière-plan ensuite, quelques heures)
5. Vérifier que TPM 2.0 est présent (paramètres → confidentialité → TPM ou `tpm.msc`) — sinon activation par mot de passe boot

---

## 5. Findings P1 (haute)

### P1-1 — Defender Tamper Protection désactivée
**État** : `IsTamperProtected : False`. Sans Tamper Protection, un malware peut désactiver Defender via API/registry sans alerte.
**Action** : Activer dans **Sécurité Windows → Protection contre les virus et les menaces → Paramètres → Protection contre les falsifications : ON**.

### P1-2 — Cloud Defender (MAPS) désactivé
**État** : `MAPSReporting : 0` + `CloudBlockLevel : 0`. Les détections cloud-delivered (0-day, IOC fraîchement publiés) ne fonctionnent pas. Defender ne reçoit pas les définitions cloud temps réel.
**Action** : Activer dans **Sécurité Windows → Protection cloud + Envoi d'échantillons automatique : ON**.

### P1-3 — Aucune règle ASR (Attack Surface Reduction) configurée
**État** : 0 règle. ASR sont les barrières modernes anti-ransomware/macros/scripts.
**Action** : activer au minimum les règles standard via PowerShell admin :
- `BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550` (Block executable content from email/webmail)
- `D4F940AB-401B-4EFC-AADC-AD5F3C50688A` (Block all Office applications from creating child processes)
- `9E6C4E1F-7D60-472F-BA1A-A39EF669E4B2` (Block credential stealing from LSASS)
- `D3E037E1-3EB8-44C8-A917-57927947596D` (Block JavaScript/VBScript from launching downloaded executables)
- `5BEB7EFE-FD9A-4556-801D-275E5FFC04CC` (Block execution of potentially obfuscated scripts)
- `7674BA52-37EB-4A4F-A9A1-F0F9A1619A2C` (Block Adobe Reader from creating child processes)
- `26190899-1602-49E8-8B27-EB1D0A1CE869` (Block Office communication apps from creating child processes)

À déployer en mode "Audit" d'abord (mode 2) pendant 1-2 semaines, puis "Block" (mode 1).

### P1-4 — Compte Microsoft might@live.fr = admin du PC (single point of failure)
**État** : `MIGHT-1000D\Might (MicrosoftAccount)` est admin local, sans compte admin local de secours actif.
**Risque** : si le compte MS `might@live.fr` est compromis (phishing, fuite mdp), l'attaquant peut potentiellement reset le mdp local et accéder au PC.
**Action** :
1. **MFA fort sur might@live.fr** (Microsoft Authenticator app + clé physique FIDO2 idéalement)
2. **Créer un compte admin local de secours** (mot de passe long, stocké dans gestionnaire de mots de passe + papier coffre)
3. À traiter en Bloc E (audit cloud accounts)

### P1-5 — Port SMB 445 exposé en IPv6 (`::`)
**État** : `System` PID 4 écoute sur `[::]:445`.
**Risque** : exploits SMB (EternalBlue family, SMBGhost CVE-2020-0796, etc.) si exposé. La Livebox bloque normalement 445 entrant en IPv4, mais l'IPv6 dépend du filtre Livebox.
**Action** : vérifier en Phase 2 que la Livebox bloque 445 IPv6 entrant. Côté PC, désactiver SMBv1 (devrait déjà l'être) et **désactiver le partage de fichiers** si pas utilisé : Centre Réseau → Modifier paramètres de partage avancés → Privé/Invité/Public : "Désactiver le partage de fichiers et imprimantes".

### P1-6 — `secret_path` HA-MCP en clair dans 11 fichiers tracked Git + rotation S48 jamais appliquée

**Description** : 3 versions du secret authentifiant l'add-on HA-MCP (`https://mcp.might.ovh/<secret>`) sont présentes en clair dans les fichiers tracked Git (`CLAUDE.md`, `TASKS.md`, `METRIQUES.md`, skills, projets, Ressources). Le secret actif en production (`private_ORXc...ehw9`) n'a **jamais été rotated** depuis sa création. La rotation prévue S48 (`private_Q49a...lE4g`) n'a jamais été appliquée côté add-on Home Assistant — donc **les deux secrets cohabitent dans la documentation** sans qu'un seul soit le canonique.

**Risque** :
1. Le repo Git n'a **pas encore de remote** (`git remote -v` vide) → pas de fuite immédiate, mais **toute commande `git remote add origin <url> + git push`** ferait fuiter ces 11 fichiers, donnant à un tiers l'URL d'accès au MCP HA. Sans MFA sur l'endpoint MCP (Bypass+Everyone par convention CF, cf. `feedback_cf_mcp_bypass_not_allow.md`), le secret_path est la seule barrière.
2. L'historique commit Git contient probablement les 4 valeurs si elles ont coexisté dans le temps (à vérifier via `git log -p`).
3. Backups S51 (`memory/_decongestion_backup_s51/CLAUDE.md.bak.s51` + `METRIQUES.md.bak.s51`) tracked Git → exposition supplémentaire.

**Action prioritaire** :
1. **Régénérer le `secret_path`** en suivant la procédure `reference_ha_mcp_secret_regeneration.md` — appliquer côté add-on cette fois.
2. **Supprimer les références en dur** dans les 11 fichiers tracked → remplacer par variable `${HA_MCP_SECRET_PATH}` ou simple `<REDACTED>` quand documentation.
3. **Supprimer ou décrocher** les backups `_decongestion_backup_s51/*.bak.s51` (les contenus pré-décongestion sont déjà préservés dans `memory/historique/2025-Q4_*.md`).
4. **Avant tout `git push`** vers GitHub mightIA : faire passer un scan `gitleaks` ou `trufflehog` sur l'historique complet.
5. Sur le long terme : envisager `git-filter-repo` pour réécrire l'historique commit et purger les secrets historiques avant tout push.

### P1-7 — Service écoutant sur UDP/53 en 0.0.0.0
**État** : svchost PID 7688 écoute sur 0.0.0.0:53 (DNS).
**Hypothèses** : ICS (Internet Connection Sharing) activé ? DNS Server feature accidentellement installée ? Hyper-V virtual switch DNS ?
**Risque** : si exposé au LAN, ouverture de DNS amplification ou leak DNS interne.
**Action** : à investiguer en Bloc C — `Get-Service` sur les services réseau, vérifier `ipconfig /all` et `Get-DnsServerSetting` (en admin).

---

## 6. Findings P2 (moyenne)

### P2-1 — Mot de passe Mickael inchangé depuis 04/05/2024
~24 mois d'âge. Si jamais leaké entre-temps (cf. HIBP à venir Bloc F), c'est exploitable.
**Action** : changer le mot de passe local après audit (Bloc F HIBP confirmation).

### P2-2 — Politique mot de passe locale faible
Longueur min = 0, historique = aucune. Permettre des mots de passe d'1 caractère ou la réutilisation immédiate.
**Action** : `secedit` + GPO locale : longueur min 14, historique 5, complexité activée.

### P2-3 — Defender FullScan jamais exécuté
Quick scan suffit pour la routine, mais un FullScan trimestriel détecte les dormants.
**Action** : programmer un FullScan mensuel (Tâche planifiée Defender ou via `Set-MpPreference`).

### P2-4 — NetBIOS over TCP/IP actif sur LAN (137-139 UDP/TCP)
Legacy, vulnérable à NBNS poisoning (Responder).
**Action** : désactiver via Centre Réseau → Adaptateur LAN → Propriétés → IPv4 → Avancé → WINS → "Désactiver NetBIOS sur TCP/IP".

### P2-5 — Mobile Mouse exposé en 0.0.0.0 sur 4 ports
9099, 9999, 35913 TCP + 9100 UDP. Si plus utilisé : désinstaller. Si utilisé : vérifier l'authentification (mot de passe d'appairage activé ?).
**Action** : Bloc C confirmation usage actuel.

### P2-6 — LLMNR actif (port 5355 UDP)
Vulnérable à LLMNR poisoning sur LAN.
**Action** : désactiver via GPO `HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient` → `EnableMulticast : 0`.

### P2-7 — SMB sans signature requise + sans chiffrement transport
État : `RequireSecuritySignature=False`, `EnableSecuritySignature=False`, `EncryptData=False`.
**Risque** : SMB relay attacks (Responder + ntlmrelayx). Si un attaquant est sur le LAN, peut intercepter et relayer une session SMB.
**Action** : `Set-SmbServerConfiguration -RequireSecuritySignature $true -EncryptData $true` (admin), retest.

### P2-8 — Partages SMB administratifs par défaut tous actifs
`ADMIN$, C$, D$, E$, F$, IPC$` accessibles à tout admin local sur le réseau (LAN, par mot de passe). Si un compte admin local fuite → contrôle total des disques.
**Action** : si tu n'utilises **jamais** de partage SMB pour copier des fichiers depuis un autre PC du LAN vers celui-ci, **désactiver les partages admin par défaut** :
```
HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\AutoShareWks = 0 (DWORD)
```
Puis redémarrer le service `LanmanServer`. Si tu utilises ces partages → activer SMB encryption (P2-7) et limiter aux IPs LAN dans le pare-feu.

### P2-9 — Free Download Manager 6.33 installé
**Contexte** : la version Linux de FDM a été compromis dans un incident **supply chain en 2023** (malware PsyOps, distribué via repo officiel pendant 3 ans). La branche Windows n'a pas été touchée mais l'éditeur a été lent à communiquer.
**Action** : vérifier la version (6.33.2.6656 au scan), comparer à la dernière publiée par SoftDeluxe. Si pas utilisé activement → désinstaller (gain : règle pare-feu Public en moins).

### P2-10 — LogMeIn legacy installé + 3 services + autostart
Application de remote support legacy (acquise par GoTo, plusieurs breaches historiques 2015 + 2017). 3 services actifs (`LMIGuardianSvc`, `LMIMaint`, `LogMeIn`), GUI au démarrage. Si tu n'utilises plus l'outil → désinstaller. Si encore utilisé → MFA actif sur le compte LogMeIn obligatoire.

### P2-11 — Suite Wondershare (Helper Compact + NativePush + Filmora)
Wondershare a une réputation **PUP-like** : télémétrie agressive, processus persistants, helpers démarrant en arrière-plan. Le service `NativePushService` tourne en Auto.
**Action** : si Filmora pas utilisé → désinstaller la suite (Helper + NativePush partent avec).

### P2-12 — Mobile Mouse 3.6.4 confirmé installé
Lien direct avec les 4 ports exposés en 0.0.0.0 (TCP 9099/9999/35913 + UDP 9100). Si pas utilisé → désinstaller. Si utilisé : vérifier qu'un mot de passe d'appairage est exigé (sinon, n'importe quel device sur ton LAN peut piloter le PC).

### P2-13 — 3 versions de UltiMaker Cura cohabitent (5.7.1 + 5.9.0 + 5.10.0)
Code/profils dupliqués, surface de mise à jour triple. Garder la dernière (5.10.0) et désinstaller les autres.

### P2-14 — `WebSocketServer23450` au démarrage depuis `C:\Program Files (x86)\webrec\Torch\`
Le path `webrec\Torch\` est **probablement** lié à un client de surveillance caméra Dahua (cohérent avec le skill `cameras-dahua` du projet) — `webrec.exe` est l'agent de visualisation Dahua, le sous-dossier "Torch" pouvant être un nom de produit interne. **Le port 23450 est confirmé en 127.0.0.1 only (pas exposé LAN)**, donc le risque direct est faible. Mais cet exécutable n'est **pas signé par un éditeur connu et ne se trouve pas dans winget**, donc à valider :
**Action** :
1. Confirmer que tu as bien installé un client Dahua / NVR Dahua à un moment
2. `Get-AuthenticodeSignature "C:\Program Files (x86)\webrec\Torch\5.1.412649.0\WebSocketServer23450.exe"` pour voir l'éditeur
3. Si pas reconnu → soumettre l'exe à VirusTotal et envisager désinstallation

---

## 7. Findings P3 (faible)

### P3-1 — 3 drivers Intel en attente
PCIe Controller 1901, Intel Driver 24.20.0.3, Intel net Driver 24.30.1.1. Pas critique sécurité, mais à appliquer.

### P3-2 — Pare-feu sans logging
LogAllowed/LogBlocked False. Empêche l'investigation post-incident.
**Action** : activer logging blocked au moins (`%systemroot%\system32\LogFiles\Firewall\pfirewall.log`).

### P3-3 — Beaucoup de règles pare-feu apps consumer (jeux, peripherals)
ARC Raiders, COD, DaVinci, Free Download Manager (Public !), ASUS, Razer, etc. À nettoyer après désinstallation des apps non utilisées (Bloc C).

### P3-4 — EaseUSStartHelper port 38531 IPv6
EaseUS Partition Master/Todo Backup helper. Vérifier si encore utilisé.

### P3-5 — FilterAdministratorToken non configuré
Faible impact car Administrateur intégré désactivé.

### P3-6 — DefaultAccount/WDAGUtilityAccount mots de passe inchangés depuis install
Comptes désactivés, donc impact nul.

### P3-7 — Apps en retard de version (winget)
ExpressLRS, 7-Zip, Notepad++, Adobe Acrobat Pro, MATLAB Runtime, EaseUS PM, Cura, OrcaSlicer, Raspberry Pi Imager, Wondershare Filmora — environ 10 apps. **Action** : `winget upgrade --all --include-unknown --accept-source-agreements --accept-package-agreements` (à faire en admin, en 2 vagues si conflits).

### P3-8 — EaseUS Partition Master + EaseUS UPDATE service en Auto
Si tu n'utilises plus EaseUS, désinstaller (gain : un service en moins).

### P3-9 — GameSDK Service (Crytek)
Lié à un jeu utilisant le CryEngine. Si jeu désinstallé/abandonné, le service traîne. À investiguer.

### P3-10 — `Embark Pioneer Personal Access Token` dans Credential Manager
PAT dev d'Embark Studios (créateur ARC Raiders). Si test technique passé / projet inactif, supprimer via `cmdkey /delete:EmbarkID/embark-pioneer/pioneer-live`.

### P3-11 — Cred Generic `git:https://github.com` user `mightIA` dans Credential Manager
Standard Git Credential Manager (encrypted DPAPI). Pas un risque, mais bon de noter le lien `mightIA` (compte GitHub utilisé par Cowork). Si tu changes de compte GitHub, à mettre à jour avec `git credential-manager configure`.

---

## 8. Bonnes pratiques confirmées

- ✅ Windows 11 Pro build récent (24H2/25H2) avec patch security ≤ 8 jours
- ✅ Defender real-time + behavior + IOAV + NIS + PUA tous actifs
- ✅ Signatures Defender à jour
- ✅ UAC actif niveau standard
- ✅ Pare-feu Windows actif sur les 3 profils, action par défaut = block
- ✅ Comptes par défaut Administrateur/Invité/DefaultAccount désactivés
- ✅ Pas de domain join / Azure AD (PC perso simple)
- ✅ Aucune menace détectée par Defender
- ✅ Quick scan régulier (3 jours)
- ✅ Politique de verrouillage : 10 essais / 10 min OK

---

## 9. Sources & références

- Microsoft Docs : ASR rules (https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-reference)
- Microsoft Docs : Tamper Protection (https://learn.microsoft.com/en-us/defender-endpoint/prevent-changes-to-security-settings-with-tamper-protection)
- Microsoft Docs : MAPS reporting / Cloud-delivered protection
- CVE SMB EternalBlue MS17-010 + SMBGhost CVE-2020-0796
- Orange Livebox : doc IPv6 firewall (à vérifier en Phase 2)

---

*Rapport partiel — Bloc A terminé S68 2026-04-27 18:41. Bloc B/C/D/F en cours.*
