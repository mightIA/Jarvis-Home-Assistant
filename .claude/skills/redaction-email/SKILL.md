---
name: redaction-email
description: Rédaction d'emails (Gmail, Outlook, autres) avec adaptation auto du ton. DECLENCHEURS : 'écris un mail à X', 'rédige un email pour', 'réponds à ce mail', 'prépare un brouillon Gmail', 'réponse SAV', 'mail admin/impôts', 'mail asso', 'auto-envoi', 'note rapide à moi-même'. 6 tons (Pro/SAV/Admin/Proche/Asso/Auto-envoi). Brouillon via MCP Gmail (`create_draft`) ou navigateur Brave. Envoi auto-envoi via service HA `notify.might57290_gmail_com` (scopes `gmail.send`/`gmail.compose` absents OAuth GCP). Envoi à un tiers via navigateur Brave + Claude in Chrome. JAMAIS d'envoi sans validation explicite + screenshot. Sub-agent CLI dédié : `redacteur-email` (CLI-only, voir CLAUDE.md §5-bis).
---

# Skill : Rédaction d'emails

## Quand cette skill est déclenchée

- Demande de Mickael de rédiger un email à quelqu'un.
- Demande de réponse à un email reçu (après approbation explicite).
- Demande de note auto-envoi (rappel, courses, idée, etc.).

## ⚠ Contraintes OAuth Gmail (à connaître avant tout envoi)

Le Client OAuth `Gmail MCP` côté GCP ne porte **pas** les scopes
`gmail.send` ni `gmail.compose`. Conséquences :

- ❌ `send_email` → **HTTP 403**
- ❌ `draft_email` → **HTTP 403**
- ✅ `create_draft` (MCP Gmail Cowork "read + drafts + labels") → fonctionne pour créer le brouillon dans Gmail
- ✅ Lecture / labels / filters → fonctionnent

→ L'envoi effectif passe **toujours** par un autre canal (voir tableau ci-dessous).

## Méthode préférée — selon destinataire

| Cas | Brouillon | Envoi |
|-----|-----------|-------|
| **Auto-envoi** (might57290@gmail.com → soi-même) | Pas de brouillon intermédiaire | `mcp__home-assistant__ha_call_service` → `notify.might57290_gmail_com` avec `data.target = ["might57290@gmail.com"]` |
| **Tiers Gmail** (SAV, impôts, asso, proche...) | `create_draft` MCP Gmail (préféré) ou navigateur Brave | Navigateur Brave + Claude in Chrome — clic "Envoyer" après validation explicite + screenshot |
| **Tiers Outlook** | Navigateur Brave (pas de MCP Outlook actif — voir T#48) | Navigateur Brave + Claude in Chrome — idem |

## Procédure auto-envoi (note à soi-même)

1. Rédiger le contenu (note rapide, format libre — pas de formule de politesse).
2. Appeler `mcp__home-assistant__ha_call_service` avec :

```yaml
service: notify.might57290_gmail_com
data:
  target: ["might57290@gmail.com"]   # OBLIGATOIRE — sinon HTTP 500
  title: "[Sujet rapide]"
  message: |
    Contenu texte brut (HTML pas encore validé sur cette intégration).
```

3. Confirmer le succès à Mickael (statut HA + heure d'envoi).
4. Pas de validation préalable nécessaire pour l'auto-envoi.

## Procédure envoi à un tiers

1. Mickael donne le destinataire, l'objet et les grandes lignes.
2. Jarvis rédige selon le tableau de ton ci-dessous.
3. Création du brouillon :
   - **Gmail** : `create_draft` via MCP Gmail (préféré, plus propre).
   - **Outlook ou autre** : ouvrir le navigateur Brave sur la boîte, cliquer "Nouveau message", remplir.
4. Jarvis envoie un **screenshot** du brouillon prêt à Mickael.
5. Mickael **valide explicitement** ou demande des modifications.
6. Envoi final : clic "Envoyer" dans Brave (Claude in Chrome) après validation.
7. Confirmer envoi à Mickael (heure + destinataire).

## Adaptation du ton

| Type de destinataire        | Ton                 | Formule d'ouverture     | Formule de fermeture                         |
|-----------------------------|---------------------|-------------------------|----------------------------------------------|
| Professionnel / Fournisseur | Formel, courtois    | Bonjour [Prénom],       | Cordialement, Mickael Rubino                 |
| Service client / SAV        | Poli mais ferme     | Bonjour,                | Dans l'attente de votre retour, cordialement |
| Administration / Impôts     | Très formel         | Madame, Monsieur,       | Je vous prie d'agréer mes salutations distinguées |
| Proche / Ami                | Décontracté         | Salut [Prénom],         | À bientôt !                                  |
| Association / Don           | Chaleureux          | Bonjour,                | Bien cordialement, Mickael                   |
| Auto-envoi (à soi-même)     | Note rapide         | Pas de formule          | Pas de formule                               |

## Règles générales

- **Langue** : toujours en français sauf si destinataire anglophone.
- **Longueur** : concis et direct, pas de blabla.
- **Signature** : "Mickael Rubino" (formel) ou "Mickael" (décontracté).
- **Pas de pièces jointes** sans confirmation et chemin explicite de Mickael.

## Sécurité

- **TOUJOURS** screenshot du brouillon prêt avant envoi à un tiers.
- **TOUJOURS** validation explicite de Mickael avant clic "Envoyer".
- **JAMAIS** envoyer un email à un tiers sans instruction explicite.
- **JAMAIS** répondre à un email sans instruction.
- **Auto-envoi** : pas de validation requise (Mickael s'écrit à lui-même).

## Exemples d'invocation utilisateur

- « Écris un mail au SAV Frisquet pour signaler la panne du 15 mars » → ton SAV, brouillon Gmail via `create_draft`, screenshot, validation, envoi via Brave.
- « Rédige un mail aux impôts pour demander un rdv » → ton très formel, brouillon Gmail, screenshot, validation, envoi via Brave.
- « Prépare une note auto-envoi avec la liste des courses » → format liste, **envoi direct via `notify.might57290_gmail_com`** (pas de brouillon intermédiaire).
- « Réponds au mail de l'asso CAUE pour confirmer ma présence » → ton chaleureux, brouillon Gmail, screenshot, validation, envoi via Brave.
- « Écris un mail à Vincent pour lui dire que je passe samedi » → ton décontracté, brouillon Gmail, screenshot, validation, envoi via Brave.

## Quand NE PAS utiliser

- Pour le **TRI / SUPPRESSION** d'emails — utiliser `tri-email-gmail` ou `tri-email-outlook[-priorites]`.
- Pour la **communication interne HA** (alertes, notifications domotique) — utiliser `notify.*` mobile_app dans HA, pas un mail.
- Si Mickael ne donne pas de brief : **DEMANDER** au moins destinataire + objet + 2-3 grandes lignes.

## Pièges connus

- **403 Gmail send/draft_email** : ne **jamais** appeler `send_email` ni `draft_email` — scopes OAuth absents (rotation scope GCP nécessaire pour les activer, hors scope skill).
- **`data.target` obligatoire** sur `notify.might57290_gmail_com` — sinon **HTTP 500** `ValueError: recipient address required` (auto-memory `feedback_notify_gmail_target.md`, S27).
- **HTML dans le message `notify`** : pas encore validé, rester en **texte brut**. Tester séparément avant rich format.
- **Envoi accidentel** (tiers) : ne **JAMAIS** cliquer "Envoyer" dans Brave sans validation Mickael + screenshot OBLIGATOIRE.
- **Pièces jointes** : ne pas attacher de fichiers automatiquement. Demander chemin explicite.
- **Adresse destinataire ambiguë** : si Mickael dit "Vincent" sans email, lister ses Vincent connus dans Gmail (`search_emails`) et demander lequel — ne pas deviner.
- **Reply-all vs Reply** : par défaut REPLY (pas reply-all). Demander explicitement si reply-all souhaité.
- **Signature** : "Mickael Rubino" formel, "Mickael" décontracté. Ne pas inventer poste/coordonnées.
- **Langue** : français par défaut. Si destinataire anglophone, basculer en anglais SANS DEMANDER (sauf doute).
- **Brouillon Gmail vs Outlook** : `create_draft` MCP marche pour Gmail. Pour Outlook, navigateur OBLIGATOIRE (T#48 = MCP Outlook à chercher).

## Référence longue

Voir `Ressources/Competences/Gestion_Emails.md` — Phase 4 (envoi tiers via Brave + auto-envoi via `notify` HA) et Phase 5 (règles de rédaction).
