---
title: Rédaction email
created: 2026-04-25
updated: 2026-04-28
tags: [atome, email, email/redaction, domaine/email]
status: wip
parent: "[[_Index]]"
source_skill: .claude/skills/redaction-email/SKILL.md
---

# Rédaction email

Skill `redaction-email` : rédaction d'emails (Gmail, Outlook, autres) avec
adaptation automatique du **ton** selon le destinataire et création de
**brouillon** pour validation Mickael avant envoi.

> ⚠️ **Skill en attente de refonte (tâche #46)**. Sa version actuelle prévoit
> `gmail.create_draft` via MCP, mais le scope OAuth `gmail.compose` est
> volontairement absent depuis S27 (voir [[Gmail MCP custom]]). Le workflow
> réel passe **exclusivement par le navigateur** Brave + Claude in Chrome
> en attendant la refonte.

## Déclencheurs

- « rédige un mail à ... », « réponds à ce message », « écris un mail pour ... ».
- Réponse à un email reçu (après approbation explicite Mickael).
- Demande explicite « écris-moi un mail comme si j'étais ... » (mode adapté).

## Workflow actuel (navigateur)

1. Mickael donne **destinataire**, **objet** et **grandes lignes** du message.
2. Jarvis rédige le brouillon en respectant le ton (voir tableau ci-dessous).
3. Jarvis ouvre le brouillon dans Gmail / Outlook via Claude in Chrome
   (`navigate`, `form_input`, `find`).
4. **Screenshot** présenté à Mickael pour validation.
5. **Envoi UNIQUEMENT après validation explicite** par Mickael (clic Envoyer
   par Mickael lui-même, ou via Claude in Chrome après accord).

## Adaptation du ton

| Type de destinataire        | Ton                 | Ouverture           | Fermeture                                    |
|-----------------------------|---------------------|---------------------|----------------------------------------------|
| Professionnel / Fournisseur | Formel, courtois    | `Bonjour [Prénom],` | `Cordialement, Mickael Rubino`               |
| Service client / SAV        | Poli mais ferme     | `Bonjour,`          | `Dans l'attente de votre retour, cordialement` |
| Administration / Impôts     | Très formel         | `Madame, Monsieur,` | `Salutations distinguées`                    |
| Proche / Ami                | Décontracté         | `Salut [Prénom],`   | `À bientôt !`                                |
| Association / Don           | Chaleureux          | `Bonjour,`          | `Bien cordialement, Mickael`                 |
| Auto-envoi (à soi-même)     | Note rapide         | (pas de formule)    | (pas de formule)                             |

## Règles générales

- **Langue** : français par défaut, anglais si destinataire anglophone.
- **Longueur** : concis et direct, pas de blabla.
- **Signature** : `Mickael Rubino` (formel) ou `Mickael` (décontracté).
- **Jamais** de pièces jointes suspectes sans vérification de la source.
- **Jamais** envoyer un email sans validation explicite Mickael (cf. Règle 0
  pour tout ce qui touche à des données sensibles).

## Sécurité

- **TOUJOURS** demander confirmation avant de cliquer Envoyer.
- **TOUJOURS** présenter un screenshot du mail prêt à Mickael.
- **JAMAIS** envoyer un email sans instruction explicite de Mickael.
- **JAMAIS** répondre à un email sans instruction.
- Si l'email touche à des données sensibles (RIB, NIR, identifiants),
  appliquer la **Règle 0** `CLAUDE.md` section 0 avant rédaction.

## Refonte prévue (tâche #46)

Décidée S27 quand la PHASE 4 a été retirée du protocole `tri-email-gmail`
(voir `Ressources/Protocoles/Gmail.md` section PHASE 4 hors scope).

**Pourquoi refondre** :

- `create_draft` MCP renvoie **403** (scope `gmail.compose` absent).
- L'envoi MCP renvoie **403** aussi (scope `gmail.send` absent).
- Le seul canal d'envoi technique est `notify.might57290_gmail_com`
  (voir [[Envoi via Home Assistant]]) — mais il est limité à un destinataire
  fixe configurable côté HA, pas à un destinataire dynamique.

**Pistes pour la refonte** :

- **Option A** — Refonte navigateur stricte : la skill ne crée plus de
  brouillon MCP, elle prépare le texte + ouvre Gmail Web via Claude in Chrome
  + colle le contenu + screenshot + Mickael envoie.
- **Option B** — Création d'un service HA `notify.gmail_dynamique` qui
  accepte un destinataire arbitraire (changements config HA + scope OAuth à
  rouvrir côté Google → discussion Règle 0 nécessaire).
- **Option C** — Re-grant temporaire du scope `gmail.compose` (PAS `gmail.send`)
  pour autoriser uniquement la création de brouillons côté Gmail, l'envoi
  restant manuel par Mickael.

Décision attendue lors de la session #46.

## Liens

- Skill : `.claude/skills/redaction-email/SKILL.md`
- Référence longue : `Ressources/Competences/Gestion_Emails.md` section 5
- MCP Gmail : [[Gmail MCP custom]]
- Service envoi : [[Envoi via Home Assistant]]
- Macros clavier (raccourcis composition) : [[10_Domaines/ViePerso/Macros clavier|Macros clavier]]
- Tâche refonte 