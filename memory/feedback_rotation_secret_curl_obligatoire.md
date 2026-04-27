---
name: Rotation secret = preuve curl OBLIGATOIRE
description: Toute rotation de secret (ha-mcp secret_path, OpenRouter key, MCP token, etc.) DOIT inclure une vérification curl HTTP côté serveur AVANT de propager les patches sur les fichiers locaux. Sinon risque de doc fictive (3 fois pour ha-mcp en S48/S53/S69).
type: feedback
---

Toute opération de rotation de secret (ha-mcp `secret_path`, clé API, token bearer, etc.) doit inclure une **vérification curl HTTP** côté serveur **avant** de patcher les fichiers locaux. Sinon le risque = documenter une rotation qui n'a jamais été effectivement appliquée côté serveur (cas observé 3 fois pour `ha-mcp` : S48 → S53 → S69, finalement appliquée S70).

**Why:** Sans preuve curl, on documente une rotation qui peut n'avoir jamais été appliquée. Pattern observé sur `ha-mcp` :
- S48 (25/04/2026) : doc rotation `private_OR...` → `private_Q4...`, 21 surfaces patchées localement, **mais SAVE jamais cliqué dans HA UI**. Découvert S53 par accident lors d'un test connecteur Cowork.
- S53 (26/04/2026) : régression S48 confirmée (curl HTTP 405 sur ancien secret + HTTP 404 sur nouveau prouvent que l'add-on n'a jamais accepté la rotation). Auto-memory `feedback_secret_path_s48_jamais_applique` créée. Rotation reportée.
- S69 (27/04/2026 matin) : T#88 prétend faire la "vraie rotation" — footer narrative dit "Phase 1 SAVE HA UI + Stop+Start + curl test → HTTP 405 ✅". **En réalité : la session a écrit le récit mais l'opération n'a pas été appliquée côté add-on**. Détecté en S70 quand `NEW_SECRET` copié depuis HA UI = ancien secret historique `private_PfjEvJTqhCdo9ELRqCPADlzo`.
- S70 (27/04/2026 soir) : **vraie rotation appliquée pour de vrai**, prouvée par 2 curl :
  - `curl https://mcp.might.ovh/<NOUVEAU>` → HTTP 405 ✅
  - `curl https://mcp.might.ovh/<ANCIEN>` → HTTP 404 ✅
  + test `ha_get_state` via nouveau connecteur Cowork → état correct.

**How to apply:**
1. **Avant rotation** : noter l'ancien secret/token quelque part (variable shell sécurisée, .secret_temp.txt avec `.gitignore`).
2. **Rotation côté serveur** : Mickael fait l'action (Règle 0 : génération + injection HA UI/console provider + SAVE explicite).
3. **VÉRIF POST CURL OBLIGATOIRE** :
   - `curl -s -o /dev/null -w "%{http_code}\n" "<URL_NOUVEAU>"` → doit retourner code attendu (ex. 405 pour ha-mcp = endpoint répond, GET non supporté)
   - `curl -s -o /dev/null -w "%{http_code}\n" "<URL_ANCIEN>"` → doit retourner 404 (preuve que ancien neutralisé)
   - **Si l'un des 2 ne donne pas le résultat attendu, STOP** → ne pas propager les patches locaux. Reprendre la rotation côté serveur.
4. **Patches locaux** : seulement après preuve curl OK. Sed/Edit sur les fichiers (config, `.env`, `.mcp.json`, auto-memories, TASKS, etc.).
5. **VÉRIF POST PATCH** : grep ancien=0 + grep préfixe nouveau (ancre 4-12 chars) = présent partout.
6. **Connecteur Cowork** : si concerné, supprimer + recréer (UI ne permet pas l'édition d'URL custom). Test final via MCP appelant.
7. **Caviardage fichiers vivants** : remplacer mentions ancien secret par `[REDACTED-OLD-SECRET-S<NN>]` dans CLAUDE.md / TASKS.md / METRIQUES.md (l'historique Git reste à traiter via filter-branch séparément).

**Pièges S48-S70 capitalisés:**
- (P1 S69) Bug PS 5.1 `[System.Security.Cryptography.RandomNumberGenerator]::Fill()` absent sur .NET Framework 4.8 → utiliser `Create().GetBytes()` à la place.
- (P2 S69) Auto-link Cowork chat corrompt blocs PS au paste (`.Method()`, URLs) → bascule script `.ps1` posé dans `Projets/<chantier>/` + `powershell -ExecutionPolicy Bypass -File <path>`.
- (P3 S69) Presse-papier instable écrasé entre `Set-Clipboard` et utilisation Ctrl+V (sélection terminal) → persistance temporaire `.secret_temp.txt` dans dossier projet avec `.gitignore` immédiat.
- (P4 S70) **Sed paraît marcher mais NEW_SECRET = ancien secret par accident** → vérifier l'ancre préfixe AVANT et APRÈS sed (chaîne booléenne `[ "$NEW" = "$OLD" ]`). Test sed sur stdin avec masquage long (24 chars min, pas 6).
- (P5 S70) **Doc footer prétend "FAIT" sans preuve curl** → règle d'or : pas de "FAIT" sans HTTP 405/200 + HTTP 404 dans la même session.
