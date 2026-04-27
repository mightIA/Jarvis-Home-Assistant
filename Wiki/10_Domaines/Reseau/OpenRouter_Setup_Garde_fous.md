---
title: OpenRouter — setup avec garde-fous
created: 2026-04-27
tags: [reseau, securite, openrouter, llm, hermes]
status: actif
domaine: Reseau
sources: [S55, S60]
---

# OpenRouter — setup avec garde-fous

## Contexte

Compte OpenRouter créé S55 (26/04/2026) pour fournir une clé API à
Hermès Agent (alternative à Claude Max pour le LLM principal et
secondaires). Stratégie validée S36 : pay-as-you-go OpenRouter +
garde-fous explicites contre débit non contrôlé sur la CB.

Mickael avait rappelé en début de session : *"il faudra mettre en place
la limite dont on a parlé pour ne pas avoir un débit non contrôlé sur
mon compte bancaire"*.

## Configuration

### Compte

- Email : `might57290@gmail.com` (Google OAuth)
- URL : [openrouter.ai](https://openrouter.ai)
- Vérification email : OK (lien cliqué via Mail iPhone)
- Auto top-up natif : **Désactivé** (aucun moyen de paiement attaché)

### Crédit

- Mode paiement : **one-time** strict (toggle activé dans la popup)
- CB : **non sauvegardée** (pas de futur débit possible)
- Dépôt initial : **$20 USD** (~23 € débité Mickael)
- Total débité incluant frais : ~$25,32 USD (Service fees ~8% dégressif
  + VAT 20% France ≈ 27% surcoût total)

### Clé API `Hermes-Jarvis`

| Champ                 | Valeur                                      |
|-----------------------|---------------------------------------------|
| Name                  | `Hermes-Jarvis`                             |
| Préfixe (label public)| `[REDACTED-SECRET]`                         |
| Credit limit          | **$5 USD**                                  |
| Reset                 | **Monthly** (1er du mois calendaire 00h UTC)|
| Expiration            | No expiration                               |
| Stockage clé complète | Coffre Mickael (méthode personnelle)        |

### Injection dans Hermès (`~/.hermes/.env`)

- Fichier WSL2 : `/home/might/.hermes/.env` (perms 600)
- Variable : `OPENROUTER_API_KEY=[REDACTED-SECRET]`
- Backups disponibles : `.env.bak-20260426-112157` et `.bak-20260426-112233`

### Convention `~/.hermes/config.yaml` (S60)

OpenRouter est un **first-class provider** Hermès. Convention OFFICIELLE :

```yaml
provider: openrouter
```

⚠️ **Ne pas** utiliser `provider: custom` + `base_url` + `api_key`
(déclenche bug Issue #12146). Auto-memory
`reference_hermes_provider_openrouter_correct`.

### Endpoints monitoring

- `/auth/key` (gratuit) — vérifie cap, usage, expiration
- `/credits` (gratuit) — vérifie solde restant

Exemple réponse `/auth/key` post-S55 :

```json
{
  "data": {
    "label": "[REDACTED-SECRET]",
    "limit": 5,
    "limit_reset": "monthly",
    "limit_remaining": 5,
    "usage": 0,
    "is_free_tier": false,
    "expires_at": null
  }
}
```

## Garde-fous activés

| Niveau | Mécanisme              | Effet                                                 |
|--------|------------------------|-------------------------------------------------------|
| 1      | Mode one-time          | CB jamais sauvegardée, pas de débit auto              |
| 2      | Cap mensuel clé $5     | Reset 1er du mois 00h UTC, blocage clé au plafond     |
| 3      | Mur dur prépayé $20    | Solde épuisé → arrêt total (aucun nouveau débit)      |

**Test des 2 garde-fous** : cap mensuel atteint d'abord (4-5 jours
seulement avant 1er reset 1er mai), puis mur dur vers ~août selon usage.

## Pièges connus

- **Popup `Add a Payment Method` piège majeur** (P1-S55) : autoriserait
  débit récurrent par défaut. Toggle `Use one-time payment methods` en
  bas de la popup obligatoire pour passer en `Purchase Credits`.
  Auto-memory `feedback_openrouter_one_time_payment_toggle`.
- **Facturation USD + 30% France** (P2-S55) : Service fees 8%
  dégressif + VAT 20%. Toujours convertir EUR↔USD et expliciter le
  total débité avant validation. Auto-memory
  `feedback_openrouter_usd_eur_30pct_frais`.
- **WSL2 paste** (P3-S55) : Ctrl+V ne marche PAS dans Ubuntu Terminal.
  Utiliser Ctrl+Shift+V ou clic droit (auto-memory
  `feedback_wsl2_paste_ctrl_shift_v`).
- **Script `read -s`** (P4-S55) : utiliser `if/else` strict (pas juste
  `if [[ ... ]] ; then echo error`) pour ne PAS écrire la clé en cas
  d'erreur. Sinon ligne vide ajoutée au `.env`.
- **Convention provider Hermès** : `provider: openrouter` SEUL, jamais
  `custom` + `base_url` + `api_key` (bug Issue #12146). Cf S60 / auto-memory
  `reference_hermes_provider_openrouter_correct`.

## Reste à faire (TASKS)

- **T#62** : monitoring OpenRouter sur HA (rest sensor + Lovelace +
  alerte si crédit < $1) — partie cap budgétaire FAIT S55
- **T#69** : bascule Hermès → OpenRouter Claude Haiku 4.5 — modifier
  `~/.hermes/config.yaml` + tester écriture HA
- **T#71** : auditer `MISTRAL_API_KEY` dans `~/.hermes/.env`, révoquer
  côté `console.mistral.ai/api-keys` si valeur active
- **T#72** : configurer notifications email OpenRouter (alertes
  50/80/100% du cap) si l'option existe côté UI

## Liens internes

- [[../Outils/_Index|Outils Hermès]] (à venir)
- ADR à créer : OpenRouter prépayé one-time vs abonnement flat (Mammouth
  AI écarté)
- Auto-memory `reference_openrouter_setup_garde_fous`
- Auto-memory `reference_llm_subscriptions_comparison`
- Auto-memory `feedback_mammouth_vs_openrouter`

## Sources

- `memory/historique/2026-04-26_session_55_openrouter_setup_garde_fous.md`
- `memory/historique/2026-04-26_session_60_audit_bugs_haiku_partiel.md`
  (convention provider OpenRouter)
- Auto-memory `reference_openrouter_setup_garde_fous`,
  `reference_hermes_provider_openrouter_correct`,
  `feedback_openrouter_one_time_payment_toggle`,
  `feedback_openrouter_usd_eur_30pct_frais`,
  `feedback_wsl2_paste_ctrl_shift_v`
