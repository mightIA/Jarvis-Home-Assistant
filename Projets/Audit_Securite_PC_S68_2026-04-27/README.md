# Audit Sécurité PC + Box Orange — Session S68

**Date :** 2026-04-27
**Périmètre :** PC MIGHT-1000D (Windows 11) + Box Orange (Livebox) + comptes cloud + iPhone + surface publique might.ovh
**Méthodologie :** Lecture seule pure (cf. S66 HA), zéro modification appliquée pendant l'audit
**Mode d'exécution :** Cowork Desktop, mode normal forfait Max

---

## Plan général en 2 phases

### Phase 1 — Cette session (S68)
Blocs réalisables en autonome ou via PowerShell read-only que Mickael colle :
- **A** Windows système (Defender, BitLocker, firewall, comptes, services, RDP, SMB)
- **B** Inventaire secrets stockés (existence des fichiers uniquement, Règle 0)
- **C** Logiciels & supply chain (winget, autostart, scheduled tasks)
- **D** Brave (extensions, sync, profils, count mots de passe)
- **F** Surface might.ovh + OSINT + HIBP 4 boîtes (autonome)

### Phase 2 — Sessions suivantes (interactif pas-à-pas)
- **E** Email & cloud (2FA, OAuth grants, partages publics) via Brave
- **G** iPhone + Apple ID via captures
- **Box Orange** Livebox via 192.168.1.1
- **H** Backup 3-2-1 + scénario ransomware (atelier réflexion)
- Remédiation findings P0/P1

---

## Fichiers livrés

- `README.md` — ce fichier (index + plan)
- `Rapport_Audit_PC_S68.md` — rapport complet priorisé P0/P1/P2/P3
- `Plan_Action.md` — checklist actionnable post-audit
- `outputs_powershell/` — outputs bruts collés par Mickael, organisés par bloc

---

## Règle 0 — Données sensibles

Avant tout accès à un mot de passe, token, clé API, ou donnée sensible : ARRÊT systématique, description de ce qui serait vu, demande d'accord explicite à Mickael.

**Exceptions confirmées par les sessions précédentes :**
- `ip_bans.yaml` HA = non sensible

**Périmètre du présent audit :**
- INVENTAIRE existence des fichiers de secrets = OK sans accord (taille, perms, mtime)
- LECTURE du contenu d'un fichier de secret = STOP, demander accord avant
- AUDIT 2FA / nombre de mots de passe stockés = OK (juste le compteur)
- LECTURE d'un mot de passe = STOP

---

## Phrase d'amorce reprise conv (Phase 2)

> Salut Jarvis, on reprend l'audit S68 — Phase 2. Lis le rapport `Projets/Audit_Securite_PC_S68_2026-04-27/Rapport_Audit_PC_S68.md` puis on attaque la Box Orange en pas-à-pas.

---

*Créé en S68 — 2026-04-27*
