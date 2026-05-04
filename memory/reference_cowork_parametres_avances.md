---
name: Cowork Desktop — Paramètres avancés (au-delà Capacités/Connecteurs)
description: Référence des paramètres Cowork Desktop hors Capacités/Connecteurs (Général, Claude Code, Cowork, Application bureau Général/Extensions/Développeur) — config Mickael S83 + posture sécurité recommandée
type: reference
---

# Cowork Desktop — Paramètres avancés (revue T#56 S83)

Compagnon de [`reference_cowork_capacites.md`](reference_cowork_capacites.md) (qui couvre les 4 toggles "Capacités"). Cette référence couvre **toutes les autres sections** des paramètres Cowork Desktop pertinentes pour Jarvis.

## Section "Général"

| Paramètre | État Mickael (S83) | Recommandation |
|---|---|---|
| Instructions pour Claude (chats + Cowork global) | Vide | Vide ✅ — instructions sont par projet via `CLAUDE.md`, pas globalement |
| Apparence | Système/auto | Choix perso |
| Police de discussion | Anthropic Serif | Choix perso |
| Notifications — Complétions de réponse | ON | ON ✅ — cohérent PC 24h/24 |
| Notifications — Notifications de code | ON | ON ✅ |
| Notifications — E-mails de Claude Code sur le web | ON | ON ✅ |
| Notifications — Envoyer des messages (push Dispatch) | ON | ON ✅ — pilotage iPhone |

## Section "Claude Code"

| Paramètre | État Mickael (S83) | Recommandation |
|---|---|---|
| Mode contournement des autorisations (YOLO) | OFF | **OFF impératif** — risque sécurité majeur |
| Mode autorisations automatiques | OFF | **OFF** — préserve contrôle utilisateur |
| Attirer l'attention sur les notifications | OFF | À toi (rebondit dock quand Claude attend) |
| Emplacement arbre de travail | `Inside project (.claude/wo...)` | OK ✅ — convention par défaut |
| Préfixe de branche | `claude` | OK ✅ — convention git |
| Aperçu (servers de dev + screenshots) | ON | OK ✅ |
| Conserver sessions de prévisualisation | OFF | **OFF impératif** — pas de cookies persistants |
| **Sous-section "Claude Code sur le Web"** | | |
| Créer PR auto | OFF | OFF ✅ |
| Correction PR auto | OFF | OFF ✅ |
| Archivage auto post-PR | OFF | OFF ✅ |

## Section "Cowork"

| Paramètre | État Mickael (S83) | Recommandation |
|---|---|---|
| Répartition (Beta) — pilotage iPhone via PC | ON | ON ✅ **indispensable** — Dispatch ne fonctionne pas sans |
| Instructions globales (sessions Cowork uniquement) | Vide | Vide ✅ — gestion par projet via `CLAUDE.md` |

## Section "Application bureau → Général"

| Paramètre | État Mickael (S83) | Recommandation |
|---|---|---|
| Lancer au démarrage | ON | ON ✅ — cohérent PC 24h/24 |
| Raccourci saisie rapide | `Ctrl+Alt+Space` | Choix perso |
| Zone de notification (system tray) | ON | ON ✅ |
| **Maintenir l'ordinateur actif** | OFF → **ON (modifié S83)** | **ON** ✅ — assure tâches planifiées nocturnes (T#52) |
| Autoriser toutes les actions du navigateur | OFF | **OFF impératif** — risque injection prompt |
| Navigateurs connectés | Brave (Browser 1, ID 04320257) | ✅ détecté |
| **Utilisation de l'ordinateur (Beta)** — Computer Use souris/clavier | OFF | **OFF impératif** — accès souris/clavier toute app |
| Réafficher applications quand Claude termine | ON | ON ✅ |
| Applications refusées | (vide) | OK — seulement utile si Computer Use ON |
| Accessibilité / Enregistrement d'écran | Non pris en charge | Grisés tant que Computer Use OFF |

## Section "Application bureau → Extensions"

État S83 : **0 extension installée**. Marketplace exploré, T#86 créée pour exploration future à tête reposée. Ne rien installer impulsivement.

## Section "Application bureau → Développeur"

État S83 : **0 serveur MCP local**. Cohérent : Cowork Desktop ne charge pas les MCP stdio (limite connue, voir `reference_cowork_imports_non_supportes.md`). Tous les MCP Jarvis sont en distant (HTTP/OAuth) ou via Claude Code CLI uniquement.

## Sections non parcourues (Règle 0)

Compte / Confidentialité / Facturation / Utilisation : non parcourues volontairement S83 (données personnelles + financières). À couvrir uniquement si question/problème spécifique émerge.

## Modifications appliquées S83

1. **Maintenir l'ordinateur actif** : OFF → **ON** (Application bureau → Général). Justification : assure que les tâches planifiées nocturnes (T#52 tri auto 04h15) ne soient pas bloquées par une mise en veille système.

## Origine

Documentation produite S83 (01/05/2026) en clôture T#56 (ouverte S35 23/04/2026). Capture UI faite avec Mickael en interactif. Compagnon `reference_cowork_capacites.md`.

## Mise à jour recommandée

Si Anthropic publie de nouveaux toggles ou réorganise l'UI Cowork Desktop, mettre à jour ce fichier + signaler dans `MEMORY.md`.
