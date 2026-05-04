---
id: 53
title: "Donner une vraie voix à Jarvis pour qu'il puisse parler à travers HA (annonce..."
status: done
priority: P2
session_opened: S35
session_closed: S84
tags: [gmail, mode-reactif, tts, piper]
source: "Session 35 / Demande Mickael"
---

# T#53 — Donner une vraie voix à Jarvis pour qu'il puisse parler à travers HA (annonce...

## Description

**[NOUVELLE session 35 — voix Jarvis TTS]** Donner une vraie voix à Jarvis pour qu'il puisse parler à travers HA (annonces, rapports matinaux, alertes `[JARVIS-ALERT]`). **Solutions à comparer en session dédiée** : (A) **ElevenLabs** — qualité broadcast, payant ~5-22$/mois, intégration HA via HACS, le service TTS s'appelle `tts.elevenlabs_say` ; (B) **Piper TTS** — open source, **100% local**, déjà intégré HA officiellement, qualité très correcte pour du gratuit, offline ; (C) **OpenAI TTS** — via HACS, payant à la requête, voix modernes ; (D) **Home Assistant Cloud (Nabu Casa)** — TTS inclus dans l'abonnement Nabu Casa existant/futur, basé sur Azure ; (E) **Microsoft Edge TTS** — gratuit via intégration HA communautaire, voix Neural Azure sans clé API. **Attendus** : (1) recherche web tendances 2026 (la com ElevenLabs, Piper Neon v2, Nabu Casa Cloud TTS), (2) tableau comparatif {qualité voix / coût / offline ou cloud / facilité install HA / intégration Jarvis `[JARVIS-ALERT]`}, (3) une démo rapide de 2-3 voix sur la même phrase "Bonjour Mickael, il est 7 heures, voici votre briefing du matin", (4) recommandation finale + plan d'installation. **Cas d'usage immédiats** : rapport journalier 23h30 annoncé vocalement, alertes Mode Réactif, notification "tri Gmail terminé" 05h00, lecture du topic du jour. **Contraintes** : pas de données sensibles dans les phrases prononcées (Règle 0), si ElevenLabs retenu garder la clé API en `secrets.yaml` HA + ACL NTFS. **Durée estimée** : 45-60 min session dédiée.

## Source / Échéance

Session 35 / Demande Mickael

## Statut

✅ **Done — S84 (02/05/2026)**.

## Résolution

### Audit comparatif (Mickael : « ia local » + « pas nabu casa ou autre payant »)

| Solution | Local ? | Gratuit ? | Verdict |
|----------|---------|-----------|---------|
| ElevenLabs | ❌ Cloud | ❌ Free=10k chars/mois insuffisant | Éliminé |
| **Piper TTS** | ✅ **100% local** | ✅ **Gratuit** | 🏆 **Retenu** |
| OpenAI TTS | ❌ Cloud | ❌ Payant ($15/M chars) | Éliminé |
| Nabu Casa Cloud | ❌ Cloud | ❌ Subscription ~6.5 €/mois | Éliminé |
| Edge TTS | ❌ Cloud Microsoft | ✅ Mais cloud | Éliminé (critère local) |

### Découverte S84 — Piper était déjà installé

Audit MCP HA → `core_piper` v2.2.2 **déjà installé + démarré + configuré** sur RPi5 :
- Voix : `fr_FR-gilles-low` (masculine grave française)
- Whisper STT bonus aussi actif (`core_whisper` v3.1.0)
- Entité HA : `tts.piper`
- Dernière utilisation entité avant S84 : 2025-09-27

**T#53 était donc 80% faite sans qu'on s'en aperçoive**. Conséquence : le scope est passé de « install Piper » à « créer infrastructure de pilotage + intégration workflows ».

### Test live S84 — voix validée

- Phrase test : « Bonjour Mickael, voici Jarvis. Test de la voix Piper française gilles low, en local sur ton Raspberry Pi cinq. »
- Génération audio OK via MCP `tts.speak`.
- Mickael était en distant → URL TTS récupérée et ouverte dans Brave via `https://ha.might.ovh/api/tts_proxy/<hash>.mp3`.
- ✅ **Voix gilles-low validée** : audible, compréhensible, qualité acceptable pour annonces Jarvis.

### Livrable principal — `script.jarvis_voice`

Script HA créé via MCP `ha_config_set_script` (S84), architecture :

```yaml
script.jarvis_voice:
  fields:
    message:  # required, texte à annoncer
    title:    # optional, default 'Jarvis'
  sequence:
    - notify.mobile_app_might_iphone (push toujours, fallback distance)
    - if person.mickael == home then:
        tts.speak entity_id=tts.piper
        media_player_entity_id=[salle_de_bain, samsung_q80_series_65]
```

Validations :
- ✅ Script créé et exécuté (state on→off propre dans logbook)
- ✅ TTS Piper diffuse sur HomePod salle de bain (`media_player.salle_de_bain` state `playing`, volume 84%)
- ⚠️ Push iPhone arrive vide (notif reçue mais payload vide) → bug Companion App iOS, **pas dans T#53**, transféré à T#88

### Tâches dérivées

- **T#88 (P3)** — Debug push iPhone Companion App (notif vide, hors scope T#53)
- **T#89 (P3)** — Intégration `script.jarvis_voice` aux 3 workflows (rapport 23h30, alertes Jarvis-Alert, tri Gmail). Bloquée partiellement par T#88 (push), mais partie vocale HomePod indépendante.

### Pièges constatés à mémoriser

1. **MCP `ha_call_service` pour script** : passer `entity_id: "script.NAME"` **dans `data`** (pas dans target), avec les paramètres du script à côté. Sinon erreur 500.
2. **TTS URL locale vs distante** : HA renvoie `http://192.168.1.11:2096/api/tts_proxy/<hash>.mp3` même en distant. Browser Mod côté navigateur ne peut pas joindre cette IP locale. À corriger via config `external_url` HA, ou patch côté Browser Mod (sujet à creuser dans T#89).
3. **`person.mickael == home` faux positif** : le tracker iPhone ne s'est pas mis à jour, état resté `home` alors que Mickael était absent. Conséquence : annonces vocales déclenchées dans une maison vide. À recalibrer (sous-tâche de T#88 ou nouvelle).
4. **Browser Mod pas chargé par défaut** : intégration HACS installée mais pas configurée → pas de `media_player.browser_*`. Activé en S84 sur PC Mickael (Browser ID `browser_mod_0cebbadf_47dcab57`).

### Cleanup à prévoir (hors session)

- Désactiver intégration `tts.openai_tts_2` (présente mais inutile vu décision « pas de payant »).
- Skill `redaction-email` : retirer mentions résiduelles `bascule-conversation`/`guidage-photo-etape` si encore présentes.
