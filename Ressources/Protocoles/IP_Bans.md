# Protocole — Suppression des bans IP

> Procédure de débannissement IP sur Home Assistant.
> Remplace l'ancien PDF `Supprimer_IP_bans_FINAL.pdf` du projet.
> Source de référence : `02_Competences/Home_Assistant.md` section 2.

---

## RÈGLES AVANT DE SUPPRIMER UN BAN

- **Règle 1 :** Vérifier l'heure du ban — si plus de 30 minutes, prévenir Mickael
- **Règle 2 :** Vérifier le nombre d'IPs bannies — si plusieurs, prévenir Mickael
- **Règle 3 :** Après débannissement, toujours tester la connexion locale

Si c'est le **premier ban de la session** : proposer à Mickael de désactiver temporairement le bannissement d'IP le temps de la session, et rappeler de le réactiver à la fin (ou le faire automatiquement si possible).

---

## MÉTHODE 1 (PRIORITÉ) — Terminal SSH local via Brave

À utiliser en premier. Fonctionne sur le réseau local. **Procédure testée et validée depuis PC. À retester depuis Dispatch/iPhone (voir TASKS.md #17).**

### Étape 1 — Ouvrir cette URL dans Brave
```
http://192.168.1.11:2096/hassio/addon/core_ssh/info
```

### Étape 2 — Cliquer sur le bouton bleu « Ouvrir l'interface utilisateur Web »

### Étape 3 — Dans le terminal, taper cette commande
```bash
cat /homeassistant/ip_bans.yaml 2>/dev/null && rm -f /homeassistant/ip_bans.yaml && ha core restart || echo 'Pas de ban IP actif'
```

### Étape 4 — Attendre 30 secondes puis tester
```
http://192.168.1.11:2096
```

---

## MÉTHODE 2 — File Editor via URL distante

À utiliser si la connexion locale est impossible.

- Ouvrir : `https://ha.might.ovh/hassio/addon/core_configurator/info`
- Naviguer dans les fichiers, chercher `ip_bans.yaml` dans `homeassistant/`
- Si absent = aucun ban actif. Sinon, **supprimer le fichier**.

---

## MÉTHODE 3 (MCP fallback) — `shell_command.ha_clear_all_ip_bans`

**Ajoutée session 18 (20/04/2026).** Utile quand Claude in Chrome est bloqué (policy org) ou que Mickael pilote depuis iPhone sans accès visuel au Terminal SSH.

### Pré-requis (déjà en place)

Bloc ajouté dans `configuration.yaml` (session 18) :

```yaml
shell_command:
  # ... autres commandes existantes ...
  ha_clear_all_ip_bans: "truncate -s 0 /config/ip_bans.yaml"
```

Service validable via : `ha_list_services(domain="shell_command")` — doit renvoyer `shell_command.ha_clear_all_ip_bans`.

### Procédure Jarvis (via MCP ha-mcp)

1. **Exécuter** : `ha_call_service("shell_command", "ha_clear_all_ip_bans", return_response=true)`
   - Attendu : `returncode: 0`, `stderr: ""`.
2. **Redémarrer** : `ha_restart(confirm=true)` pour que HA relise le fichier `ip_bans.yaml` vidé.
3. **Attendre** 1-3 min, puis `ha_get_overview(detail_level="minimal")` → confirmer `state: RUNNING`.
4. **Tester** la connexion : `ha_get_state("light.ampoule_chambre")` doit répondre 200.

### Limites et sécurité

- Cette méthode **vide TOUS les bans** d'un coup (pas d'IP ciblée). Les bans légitimes se reformeront naturellement après `login_attempts_threshold: 3` tentatives échouées.
- **NE PAS** ajouter de `shell_command` paramétré type `sed -i '/{{ ip }}/d'` — risque d'injection shell si un token HA est compromis (décision prise session 18).
- Pour retirer une **IP précise**, rester sur Méthode 1 (SSH) ou 2 (File Editor).

---

## RÈGLES DE DÉTECTION

- Si **2-3 erreurs 401/403 consécutives** : **STOP** — vérifier si l'IP est bannie
- Ne pas répéter les appels API qui échouent
- Après débannissement : toujours tester `http://192.168.1.11:2096` et basculer en local

---

*Procédure extraite de Competence_Home_Assistant.pdf section 2 — 18 avril 2026*
