---
id: 88
title: "Debug Companion App iOS — notifications push reçues mais payload vide"
status: open
priority: P3
session_opened: S84
tags: [ios, companion-app, push, notify, debug]
source: "Session 84 / Test script.jarvis_voice — notifs notify.mobile_app_might_iphone arrivent vides"
---

# T#88 — Debug push iPhone HA Companion App

## Contexte

Lors du test de `script.jarvis_voice` en S84 (T#53), comportement constaté :

- Le service `notify.mobile_app_might_iphone` s'exécute sans erreur (return success).
- L'iPhone reçoit bien la notification (badge, son, vibration).
- **Mais le payload est vide** : pas de titre, pas de message visible.
- Reproduit en appel direct (hors script) avec `data: { message: "TEST", title: "Test" }`.
- Reproduit en hardcodé dans le script (sans Jinja).
- iPhone déverrouillé, app HA Companion autorisée à notifier, "Show Previews" ON.

→ Le souci n'est ni dans le script ni dans le moteur Jinja, **c'est le push iOS lui-même qui arrive sans contenu**.

## Causes probables

1. **Push notification ID désynchronisé** (le plus fréquent) — la clé de chiffrement push iPhone ↔ HA est cassée.
2. Bug version Companion App iOS récente.
3. Si Mickael n'a pas Nabu Casa Cloud → push relay communautaire peut être mal configuré.
4. Token APNs Apple expiré côté HA backend.

## Plan de résolution

1. **Reset Push notification ID** :
   - App HA iPhone → onglet Paramètres (en bas) → Companion App → Notifications
   - Bouton « Réinitialiser l'identifiant push » ou « Reset push notification ID »
   - Re-test envoi notif via Developer Tools HA
2. Si KO → **Reconnecter compte HA** dans l'app Companion (déconnexion + reconnexion).
3. Si KO → vérifier version HA Companion App (mise à jour App Store).
4. Si KO → **logs serveur HA** : `ha_get_logs` source `error_log` filtre `mobile_app|notify`.
5. Si KO → vérifier configuration `notify` dans HA core (peut-être un override mauvais).

## Bénéfice

Sans push iPhone fonctionnel :
- Pas de notif tri Gmail terminé (skill `tri-email-gmail`)
- Pas de notif rapport journalier Mode Réactif quand Mickael est absent
- Pas de fallback push pour `script.jarvis_voice` (le script lui-même fonctionne, mais le canal push est cassé)

## Lien T#89

T#89 (intégration `script.jarvis_voice` aux 3 workflows) **dépend** de T#88 résolu pour la partie push. La partie vocale HomePod fonctionne déjà sans dépendance.

## Suivi S91 (03/05/2026)

Bug **reconfirmé** S91 lors du Test 0 `script.jarvis_voice` (T#89) : push iPhone reçu avec **titre OK** mais **message vide**. Comportement identique à S84/S85 → reset Push notification ID toujours pas effectué.

**Découverte additionnelle S91** : un **VPN actif sur iPhone** bloque totalement les notifs HA Companion (silence complet — pas de titre, pas de message, pas de badge). Cas **distinct** de T#88. Voir `memory/feedback_iphone_vpn_bloque_ha.md`.

→ Avant tout debug T#88, toujours vérifier que le VPN iPhone est désactivé (sinon symptôme masqué).

## Statut

🟢 `open` — P3, à traiter quand Mickael sera chez lui (calibration person.mickael possible en parallèle). Bug reproduit 3 sessions consécutives (S84, S85, S91).
