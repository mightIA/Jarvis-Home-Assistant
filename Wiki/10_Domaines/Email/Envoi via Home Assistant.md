---
title: Envoi via Home Assistant
created: 2026-04-25
updated: 2026-04-28
tags: [atome, email, email/envoi, email/ha, domaine/email]
status: actif
parent: "[[_Index]]"
---

# Envoi via Home Assistant

Tout envoi de mail depuis Jarvis passe par le service Home Assistant
`notify.might57290_gmail_com`. Le scope OAuth `gmail.send` étant volontairement
absent côté Gmail MCP custom (voir [[Gmail MCP custom]]), c'est le **seul
canal d'envoi** disponible.

## Service HA

| Champ              | Valeur                                                           |
|--------------------|------------------------------------------------------------------|
| Service            | `notify.might57290_gmail_com`                                    |
| Intégration        | `google_mail` (Home Assistant core)                              |
| Compte source      | `might57290@gmail.com`                                           |
| Compte destinataire | `might57290@gmail.com` (auto-envoi par défaut)                  |
| Pièces jointes     | Non supportées de manière fiable — éviter                        |

## Appel minimal validé (S27)

```yaml
service: notify.might57290_gmail_com
data:
  target: ["might57290@gmail.com"]   # OBLIGATOIRE
  title: "[Jarvis] Rapport tri emails — 2026-04-22"
  message: "Corps du rapport en texte brut"
```

## ⚠️ Piège `data.target` obligatoire

**Sans `data.target`**, l'intégration `google_mail` lève
`ValueError: recipient address required` dans
`components/google_mail/notify.py:84` → HTTP 500.

**Toujours** fournir `data.target` sous forme de **liste** même pour un seul
destinataire :

```yaml
data:
  target: ["destinataire@example.com"]
```

Cette contrainte s'applique à **toute skill** qui envoie un mail via ce
service (`tri-email-gmail`, `tri-email-outlook`,
`rapport-journalier-reactif`, etc.).

Auto-memory : `feedback_notify_gmail_target` (créée S27).

## Cas d'usage

| Skill / Contexte                  | Sujet                                          | Notes                                  |
|-----------------------------------|------------------------------------------------|----------------------------------------|
| `tri-email-gmail` (5h + 14h)      | `[Jarvis] Rapport tri emails — YYYY-MM-DD HH:MM` | Auto-archivé par filtre Gmail `Jarvis-RapportTri`. |
| `tri-email-outlook` (auto)        | `[Jarvis] Rapport tri Outlook — YYYY-MM-DD`    | Même mécanisme.                       |
| `rapport-journalier-reactif` (23h30) | `[Jarvis] Rapport journalier Mode Réactif`   | Texte brut, pas de PJ — chemins en clair vers archive locale. |
| Alertes `check-jarvis-alert`      | `[Jarvis] Alerte traitée niveau N — type`      | Quand Mode Réactif déclenche une action. |
| Erreurs critiques                 | `[Jarvis] ERREUR — pré-filtre OAuth expiré`    | Quand le pré-filtre PowerShell échoue. |

## Format du corps

- **Texte brut** par défaut. HTML supporté **partiellement** via `data.html: true`,
  pas validé de manière exhaustive sur l'intégration `google_mail` actuelle
  (à tester séparément avant re-bascule).
- Pas d'images inline ni de PJ binaires fiables.
- Pour archive PDF → écrire le PDF en local sur OneDrive
  (`memory/historique_tri_gmail/...` ou `rapports/journalier/`) et inclure
  le **chemin** dans le mail. Mickael le suit OneDrive sur mobile.

## Filtre Gmail auto-archivage

Pour ne pas polluer l'INBOX avec les rapports auto-envoyés, un filtre Gmail
natif (créé via `create_filter` MCP) applique :

- **Critère** : `from:me subject:"[Jarvis] Rapport tri emails"`
- **Actions** : addLabel `Jarvis-RapportTri` + removeLabel `INBOX`

Les rapports sont consultables d'un clic via le label `Jarvis-RapportTri`.

## Sécurité

- Le service `notify.might57290_gmail_com` est **le seul service HA autorisé
  en écriture** depuis les skills CLI Mode Réactif (voir Mode_Reactif.md
  section 11).
- Toute skill qui envoie un mail via `ha_call_service` doit cibler **uniquement**
  ce service — pas de free-form sur d'autres `notify.*`.
- Restriction du blast radius : Jarvis ne peut pas envoyer un mail à un
  destinataire arbitraire sauf si Mickael ajoute manuellement un autre
  service `notify.*` configuré côté HA.

## Liens

- Stack MCP Gmail : [[Gmail MCP custom]]
- Pipeline tri Gmail : [[Tri Gmail automatise]]
- Mode Réactif : [[10_Domaines/HomeAssistant/Mode Réactif - Pipeline alertes|Mode Réactif — Pipeline alertes]]
- Auto-memory clé : `feedback_notify_gmail_target.md`

---

*Atome créé S44. Servi