# Plan de Reprise — Audit Sécurité PC S68/S69 — Phase 2

**Statut au 2026-04-27 (clôture conversation Phase 1)** :
Phase 1 partiellement terminée — Blocs A + B + C complets, Bloc F préparé mais non exécuté, Blocs D + E + G + H + Box Orange à venir.

---

## Phrase d'amorce — à coller dans la nouvelle conv Cowork

> Salut Jarvis, on reprend l'audit sécurité PC. Lis :
> 1. `Projets/Audit_Securite_PC_S68_2026-04-27/Rapport_Audit_PC_S68.md`
> 2. `Projets/Audit_Securite_PC_S68_2026-04-27/Reprise_Phase2/Plan_Reprise.md`
>
> Démarre par exécuter le **Bloc F** (script déjà prêt : `Run_BlocF.cmd` à double-cliquer), puis enchaîne avec le Bloc D (Brave) en autonome via lecture des Preferences JSON.

---

## État précis à la clôture

### Blocs terminés ✅

- **Bloc A** (Windows système) — `outputs_powershell/BlocA.txt` lu et analysé
- **Bloc B** (secrets stockés disque côté projet + côté Windows user folder + Credential Manager) — `outputs_powershell/BlocBC.txt` lu et analysé
- **Bloc C** (logiciels supply chain + autostart + tâches planifiées + services + RDP + SMB) — partagé avec BlocBC.txt

### À reprendre

- **Bloc F** (DNS might.ovh + HIBP 4 boîtes) — script `BlocF_DNS_HIBP.ps1` prêt + lanceur `Run_BlocF.cmd` prêt. Mickael double-clique → produit `outputs_powershell/BlocF.txt`. **À ANALYSER en début de Phase 2**.

- **Bloc D** (Brave navigateur — extensions, sync, profils, count mots de passe) — autonome possible : Read sur `C:\Users\Might\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Preferences` (JSON) + `Local State` + Extensions/. Pas besoin de Mickael.

- **Bloc E** (Email & cloud — 4 boîtes 2FA + OAuth grants Google/MS + partages publics Drive/OneDrive) — interactif via Brave en pas-à-pas, Mickael navigue, je commente.

- **Bloc G** (iPhone + Apple ID — 2FA, appareils, app permissions, partage localisation) — interactif via captures iPhone.

- **Bloc H** (Backup 3-2-1 + scénario ransomware) — atelier réflexion, pas de PowerShell.

- **Box Orange (Livebox)** — interactif via `192.168.1.1` ou `livebox.home`, captures par Mickael (admin password = sensible, Règle 0).

- **Livrable final** : `Plan_Action.md` checklist actionnable + bump fichiers vivants (CLAUDE.md, TASKS.md, METRIQUES.md, MEMORY.md) + archive memory/historique/.

---

## Synthèse provisoire des findings (à fin de Phase 1)

### P0 (critique) — 2 findings

1. **P0-1** Port UDP 2177 exposé sur IPv6 GUA Orange (`2a01:cb11:506:9100:*`) — exposition Internet potentielle si Livebox laisse passer IPv6 entrant. **À valider Phase 2 Box Orange.**
2. **P0-2** ⚠️ **BitLocker DÉSACTIVÉ sur les 4 disques** (C: 953 Go OS / D: 932 Go data Jarvis / E: 932 Go save / F: 1863 Go téléchargement). 0% chiffré, 4.7 To de données accessibles en clair en cas de vol/perte du PC.

### P1 (haute) — 8 findings

1. **P1-1** Defender Tamper Protection OFF (`IsTamperProtected: False`)
2. **P1-2** Cloud Defender (MAPS) OFF (`MAPSReporting: 0`, `CloudBlockLevel: 0`)
3. **P1-3** Aucune règle ASR configurée (0 sur ~16 disponibles)
4. **P1-4** Compte Microsoft `might@live.fr` = admin local sans backup admin local
5. **P1-5** Port SMB 445 exposé en IPv6 (`[::]:445`)
6. **P1-6** `secret_path` HA-MCP en clair dans 11 fichiers tracked Git + rotation S48 jamais appliquée + 2 backups décongestion S51 tracked
7. **P1-7** Service écoutant sur UDP/53 en 0.0.0.0 (svchost PID 7688) — à investiguer
8. **P1-8** SMB partages admin par défaut tous actifs (ADMIN$, C$, D$, E$, F$, IPC$)

### P2 (moyenne) — 14 findings

P2-1 à P2-14 (cf. rapport complet). Highlights :
- Mot de passe Mickael inchangé depuis 04/05/2024 (~24 mois)
- Politique mot de passe locale : longueur min 0, historique aucun
- Defender FullScan jamais exécuté
- NetBIOS over TCP/IP actif (137-139)
- Mobile Mouse 4 ports exposés en 0.0.0.0
- LLMNR actif (5355)
- SMB sans signature ni chiffrement transport
- Free Download Manager (incident supply chain 2023)
- LogMeIn legacy + 3 services autostart
- Suite Wondershare PUP-like
- 3 versions UltiMaker Cura cohabitent
- WebSocketServer23450 dans `webrec\Torch\` à valider

### P3 (faible) — 11 findings

P3-1 à P3-11 (cf. rapport complet). Highlights :
- 3 drivers Intel en attente
- ~10 apps en retard de version (winget upgrade)
- EaseUS Partition Master + service en Auto
- GameSDK Service (Crytek legacy)
- Embark Pioneer PAT dans Credential Manager

### Bonnes pratiques confirmées (à conserver)

- Win 11 Pro build 26200 + KB security ≤ 8 jours
- Defender real-time + behavior + IOAV + NIS + PUA tous actifs
- UAC actif niveau standard
- Pare-feu Windows actif sur les 3 profils
- Comptes Administrateur/Invité/DefaultAccount/WDAGUtilityAccount désactivés
- Pas de domain join / Azure AD
- 0 menace détectée
- **Aucun secret AWS/SSH/GitHub/Google/Docker en clair sur disque** ✅
- **Aucune exclusion Defender** ✅
- RDP désactivé ✅
- SMBv1 désactivé ✅
- Malwarebytes en plus de Defender (defense in depth)
- Repo Git **sans remote configuré** (pas de push GitHub effectué) ✅

---

## Ordre suggéré pour Phase 2

1. **Bloc F** : double-clic `Run_BlocF.cmd` → analyse `BlocF.txt` (15 min)
2. **Bloc D** Brave : Read autonome des Preferences/Local State (15 min)
3. **Box Orange** : pas-à-pas guidage `192.168.1.1` (30-45 min)
4. **Bloc E** Email & cloud : pas-à-pas Brave (45 min)
5. **Bloc G** iPhone Apple ID : pas-à-pas captures (30 min)
6. **Bloc H** Backup 3-2-1 + ransomware : atelier réflexion (30 min)
7. **Livrable final** : `Plan_Action.md` + bumps + archive memory (20 min)

**Effort total Phase 2 estimé : ~3h** étalable sur 1-2 sessions.

---

## Fichiers livrables actuels

```
Projets/Audit_Securite_PC_S68_2026-04-27/
├── README.md                          (plan général + Règle 0)
├── Rapport_Audit_PC_S68.md            (rapport en cours, ~30 KB)
├── Reprise_Phase2/
│   └── Plan_Reprise.md                (ce fichier)
├── outputs_powershell/
│   ├── README.md
│   ├── BlocA.txt                      (output Bloc A — système Windows)
│   └── BlocBC.txt                     (output Bloc B+C — secrets + supply chain)
└── scripts/
    ├── BlocA_Windows_Defender_Firewall.ps1
    ├── Run_BlocA.cmd
    ├── BlocBC_Admin.ps1
    ├── Run_BlocBC_Admin.cmd
    ├── BlocF_DNS_HIBP.ps1
    └── Run_BlocF.cmd
```

---

## Notes méthodologiques pour la suite

- **Méthode .ps1 + .cmd** confirmée robuste (auto-memory `feedback_cowork_chat_markdown_pscode.md` créée S69 26/04/2026)
- Pour les prochains scripts PS, **toujours** passer par fichier .ps1 + .cmd lanceur, jamais par bloc inline si > 5 lignes ou contient `.Method()` / email / URL
- Règle 0 strictement respectée pour Bloc B (existence + taille + ACL uniquement, jamais le contenu)
- Pour Bloc D (Brave) : nombre de mots de passe stockés OK à compter, mais JAMAIS lire le contenu (Règle 0)

---

*Plan de reprise créé le 2026-04-27 en clôture de conversation Phase 1.*
