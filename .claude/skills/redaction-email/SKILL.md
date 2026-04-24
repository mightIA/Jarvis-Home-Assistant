---
name: redaction-email
description: Redaction d'emails (Gmail, Outlook, autres) avec adaptation automatique du ton selon le destinataire (professionnel, SAV, administration, proche, association, auto-envoi). Cree des brouillons via MCP Gmail (preference) ou via le navigateur. Toujours demander confirmation avant envoi avec screenshot.
---

# Skill : Redaction d'emails

## Quand cette skill est declenchee

- Demande de Mickael de rediger un email a quelqu'un.
- Demande de reponse a un email.
- Reponse a un email recu (apres approbation explicite).

## Methode preferee

1. **Brouillon via MCP Gmail** : pour les emails Gmail, utiliser
   `gmail.create_draft` (cree directement le brouillon sans navigateur).
2. **Navigateur (Brave + Claude in Chrome)** : pour Outlook ou pour la
   verification finale avant envoi.

## Procedure

1. Mickael donne le destinataire, l'objet et les grandes lignes du message.
2. Jarvis redige selon les regles de ton (tableau ci-dessous).
3. Jarvis cree le brouillon (MCP `create_draft` pour Gmail).
4. Mickael valide ou demande des modifications.
5. Envoi final via le navigateur (bouton Envoyer) **apres validation
   explicite avec screenshot**.

## Adaptation du ton

| Type de destinataire        | Ton                 | Formule d'ouverture     | Formule de fermeture                      |
|-----------------------------|---------------------|-------------------------|-------------------------------------------|
| Professionnel / Fournisseur | Formel, courtois    | Bonjour [Prenom],       | Cordialement, Mickael Rubino              |
| Service client / SAV        | Poli mais ferme     | Bonjour,                | Dans l'attente de votre retour, cordialement |
| Administration / Impots     | Tres formel         | Madame, Monsieur,       | Salutations distinguees                   |
| Proche / Ami                | Decontracte         | Salut [Prenom],         | A bientot !                               |
| Association / Don           | Chaleureux          | Bonjour,                | Bien cordialement, Mickael                |
| Auto-envoi (a soi-meme)     | Note rapide         | Pas de formule          | Pas de formule                            |

## Regles generales

- **Langue** : toujours en francais sauf si destinataire anglophone.
- **Longueur** : concis et direct, pas de blabla inutile.
- **Signature** : "Mickael Rubino" (formel) ou "Mickael" (decontracte).
- **Pas de pieces jointes suspectes** sans verification de la source.

## Securite

- TOUJOURS demander confirmation avant de cliquer Envoyer.
- TOUJOURS envoyer un screenshot du mail pret a Mickael pour validation.
- JAMAIS envoyer un email sans instruction explicite de Mickael.
- JAMAIS repondre a un email sans instruction.

## Reference longue

Voir `Ressources/Competences/Gestion_Emails.md` section 5.
