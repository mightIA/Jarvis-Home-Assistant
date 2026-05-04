# Canal TTS TV Samsung Q80 via Music Assistant DLNA

**Découverte S91 (03/05/2026)** — résolution diag TV salon dans le cadre T#89 (Test 0 `script.jarvis_voice`).

## Contexte

Lors du test 0 ping direct de `script.jarvis_voice`, le HomePod salle de bain a parfaitement répondu mais la TV Samsung Q80 65" salon est restée muette malgré état `on`, joignable réseau, volume monté manuellement.

L'intégration **Samsung Smart TV WS** (Tizen) crée bien une entité `media_player.samsung_q80_series_65` avec `supported_features=24509` (PLAY_MEDIA inclus), mais elle **ne forwarde pas le `tts.speak`** au niveau audio TV. Bug fréquent / connu côté Samsung Tizen.

## Solution validée

HA expose **3 entités** pour la même TV Q80 via 3 intégrations parallèles (découvertes auto) :

| Entité | Intégration | Verdict |
|---|---|---|
| `media_player.samsung_q80_series_65` | Samsung Smart TV WS (Tizen) | ❌ TTS muet |
| `media_player.samsung_q80_series_65_2` | **Music Assistant** (`app_id: music_assistant`, `device_class: speaker`) | ✅ TTS OK via DLNA |
| `media_player.tv_samsung_q80_series_65` | Custom `[TV]` (intégration ?) | Non testée |

Le player Music Assistant `_2` expose **3 protocoles** : AIRPLAY, SENDSPIN, DLNA. Par défaut `Preferred Output Protocol = Auto-select` → choisit AirPlay → demande code de pairage à la TV (timeout, jamais validé).

## Procédure pas à pas (pattern réutilisable)

1. UI HA → sidebar **Music Assistant** → ⚙️ Paramètres → **Lecteurs**
2. Ligne du player Samsung TV concernée → ⋮ → **Configurer**
3. Section **Paramètres du protocole** :
   - Toggle **« Enable AirPlay support »** → **OFF** (gris)
   - Laisser « Enable Sendspin support » et « Enable DLNA support » en ON
   - (Optionnel : forcer `Preferred Output Protocol = DLNA` au lieu d'Auto-select)
4. **SAUVEGARDER** (vérifier que le bouton passe en bleu actif)
5. **Redémarrer l'add-on Music Assistant Server** (HA → Apps → Music Assistant Server → Redémarrer)
6. Tester via `tts.speak` ou `script.jarvis_voice` pointant sur l'entité `_2`

## Comportement attendu post-config

- Volume auto-monté à 75% pendant l'annonce (paramètres MA `Volume for Announcements: 85, Max: 75`)
- Ducking de la source en cours (radio TuneIn / Spotify / etc.)
- Chime de pré-annonce si activé
- Reprise de la source après annonce

## Dans `script.jarvis_voice` (T#89)

Modification chirurgicale appliquée S91 via `ha_config_set_script` python_transform :

```python
config['sequence'][1]['then'][0]['data']['media_player_entity_id'][1] = 'media_player.samsung_q80_series_65_2'
```

config_hash : `225de8656f5bc5ce` → `9fe50a97bd26ae01`.

Liste finale `media_player_entity_id` :

```yaml
- media_player.salle_de_bain          # HomePod (AirPlay HA natif, OK direct)
- media_player.samsung_q80_series_65_2  # TV Q80 (Music Assistant DLNA)
```

## Pattern transposable

Pattern applicable à toute TV Samsung Tizen exposée via Music Assistant en plus de l'intégration Samsung Smart TV WS native (Q60/Q70/Q80/Q90/Frame/etc. firmware 2018+). Si le TTS reste muet via l'entité `samsung_*` standard, vérifier la présence d'une entité `_2` Music Assistant et désactiver AirPlay support pour forcer DLNA.

## Lien

- T#89 (Intégration `script.jarvis_voice` aux 3 workflows) — `tasks/task_089.md` — section « Avancement S91 ».
- Auto-memory associée : `feedback_iphone_vpn_bloque_ha.md` (T#88 reconfirmé S91 dans la même session).
