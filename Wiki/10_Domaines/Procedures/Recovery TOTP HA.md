---
title: Recovery TOTP HA
created: 2026-04-27
tags: [procedure, securite, ha, mfa]
status: actif
domaine: Procedures
sources: [S19]
---

# Recovery TOTP Home Assistant

## Quand utiliser

- **Telephone perdu / vole / casse** alors que Google Authenticator (ou autre
  app TOTP) etait la seule source du code 2FA HA.
- **Reinstallation OS telephone** sans avoir exporte le secret TOTP.
- **Changement de telephone** sans transfert prealable des codes Authenticator.

## Pourquoi

Home Assistant **n'a PAS** de module "codes de secours" (backup codes)
contrairement a Google ou GitHub. Voir auto-memory
`feedback_ha_totp_no_backup_codes.md`. Si Mickael perd la source TOTP sans
avoir conserve la **chaine base32 brute** affichee sous le QR a la creation,
le seul recours est la **desactivation MFA via fichier config** depuis un
acces local privilegie (SSH ou Terminal add-on).

## Vue d'ensemble

### Prevention (a faire AU MOMENT de la creation TOTP) :

1. Au moment d'ajouter HA dans Authenticator, le QR affiche **aussi** une
   chaine `base32` (ex. `JBSWY3DPEHPK3PXP...`).
2. **Sauvegarder cette chaine** dans un coffre-fort (Bitwarden, KeePass,
   note chiffree). C'est elle qui sert si le telephone est perdu : la
   re-saisir dans une nouvelle app TOTP regenere les memes codes a 6 chiffres.
3. Sauvegarder aussi la chaine **par compte HA** (admin + utilisateurs).

### Recovery (telephone perdu) :

1. **Si chaine base32 sauvegardee** : ajouter manuellement dans une nouvelle
   app TOTP (Authenticator -> "Saisir une cle" -> coller la chaine + nom du
   compte HA). Les codes a 6 chiffres redeviennent valides immediatement.
2. **Si chaine perdue** : passer par acces local privilegie.
   - SSH local ou Terminal add-on `core_ssh` via `http://192.168.1.11:2096`.
   - Editer `/config/.storage/auth_mfa_module.totp` : retirer l'entree
     correspondant a l'utilisateur (ou vider le fichier).
   - `ha core restart`.
   - Au prochain login, MFA = desactive. Reactiver immediatement avec un
     nouveau QR + sauvegarder la nouvelle chaine base32.

## Pieges connus

- **HA n'affiche PAS la chaine base32 a posteriori** — uniquement au moment
  de la creation initiale. Si non sauvegardee = perdue definitivement.
- **Authenticator Google ne propose pas d'export iCloud** historiquement —
  utiliser plutot **Bitwarden** ou **2FAS** qui synchronisent avec backup chiffre.
- **Acces local SSH requis** pour le reset : si Mickael est en deplacement
  sans VPN ni acces local, il faut attendre le retour PC + reseau LAN.
- **Tester la nouvelle chaine** avant de jeter l'ancien telephone (si encore
  fonctionnel partiellement).
- **Documenter** la chaine base32 cote `CONTEXTE.md` ou coffre-fort, jamais
  en clair dans le repo public ou OneDrive non chiffre.

## Detail executable

Pas de protocole dedie pour le moment (pas de declenchement reel). A
formaliser en `Ressources/Protocoles/Recovery_TOTP_HA.md` lors du prochain
changement de telephone.

## Sources

- `memory/historique/2026-04-20_session_19_cloture_migration_mobilite.md`
- Auto-memory : `feedback_ha_totp_no_backup_codes`
- Regle 0 du `CLAUDE.md` (donnees sensibles : chaine base32 = secret type credential)
