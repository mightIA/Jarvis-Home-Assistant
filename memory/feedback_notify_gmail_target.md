---
name: notify.might57290_gmail_com requires target param
description: HA notify service for gmail self-mail requires data.target list, otherwise 500 ValueError "recipient address required"
type: feedback
---

Le service HA `notify.might57290_gmail_com` (intégration `google_mail`) **exige** le champ `data.target` = `["might57290@gmail.com"]`. Sans ce champ, l'appel retourne **HTTP 500** avec `ValueError: recipient address required` dans le log HA.

**Why:** découvert session 27 lors du premier V1 réel de la skill `tri-email-gmail` (22/04/2026). Les 2 premiers appels `ha_call_service` avec seulement title+message ont échoué en 500, y compris sur payload minimal. La stack trace dans `components/google_mail/notify.py:84` révèle la contrainte. Bug non documenté avant ce run.

**How to apply:** Toute skill ou automation qui envoie un mail auto-envoi via `notify.might57290_gmail_com` (tri-email-gmail, tri-email-outlook, rapport-journalier-reactif, etc.) doit inclure `target: ["might57290@gmail.com"]` dans le `data`. Les autres services notify (mobile_app_*) ne semblent pas concernés — cette contrainte est spécifique à l'intégration `google_mail`.

Corollaire : le HTML dans `message` n'est pas encore validé sur cette intégration — les 2 premiers essais incluaient du HTML ET oubliaient `target`. Le run réussi était en texte brut. Tester le HTML séparément avant de re-basculer en rich format.
