# VPN actif iPhone bloque les notifs HA Companion

**Découvert S91 (03/05/2026)** — diagnostic test 0 `script.jarvis_voice` (T#89).

## Symptôme

Lors du premier ping direct de `script.jarvis_voice` en S91 :

- HomePod salle de bain ✅ message audible
- iPhone : **rien reçu** (ni titre, ni message, ni badge)

Mickael avait un **VPN actif** sur l'iPhone au moment du test, qui bloquait totalement le canal `notify.mobile_app_might_iphone` (HA Companion App).

## À distinguer de T#88

⚠️ Cas **différent** de T#88 :

| Situation | Symptôme iPhone |
|---|---|
| **VPN actif** (présent doc) | Aucune notif reçue (rien du tout) |
| **T#88** (push payload vide) | Notif reçue avec titre OK mais message vide |

Au 2e test S91 (sans VPN), reconfirmation T#88 : titre OK / message vide.

## Comment reconnaître

- Si Mickael utilise un VPN sur iPhone (ProtonVPN, NordVPN, Mullvad, WireGuard custom, etc.) → tester sans VPN d'abord.
- Test direct via Developer Tools HA → service `notify.mobile_app_might_iphone` :
  - Pas de notif du tout reçue → suspecter VPN
  - Notif reçue mais sans contenu → T#88

## Impact workflows Jarvis

- Mode Réactif (`check-jarvis-alert`) : si VPN allumé, alerte ratée (silence total).
- `tri-email-gmail` (étape 9bis annonce vocale) : push iPhone fallback distance ne fonctionne pas.
- `rapport-journalier-reactif` (étape 6b) : idem.

## Recommandations

1. Documenter dans `Ressources/Mode_Reactif.md` que le VPN doit être stoppé pendant les heures critiques (5h tri matin, 14h tri aprem, 23h30 rapport, alertes 24/7).
2. Si VPN nécessaire en permanence : configurer une **règle d'exception VPN par domaine** pour `ha.might.ovh` + IP `192.168.1.11` (split-tunnel).
3. Alternative : passer les notifs via SMS/email en cas d'absence prolongée (config notify HA secondaire).

## Lien

- T#89 (Intégration `script.jarvis_voice`) — `tasks/task_089.md` — découverte S91.
- T#88 (push iPhone payload vide) — `tasks/task_088.md` — reconfirmé S91.
