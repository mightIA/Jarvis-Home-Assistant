---
title: Vault Migration S63 — projet de reprise
created: 2026-04-27
session_origine: S67
status: en-cours
phase: 1-sur-2
---

# Vault Migration S63

Projet de migration des connaissances Jarvis vers le vault Obsidian
(`Wiki/`), basé sur l'audit S63 (T#1) livré sur Google Drive.

## Contexte

Mickael a décidé en S67 (27/04/2026) de migrer les connaissances réutilisables
du projet vers le vault Obsidian, après audit complet de 4 zones (155 fichiers,
~6 MB bruts → ~1,6 MB net transférable).

Pattern adopté : **copie-only stricte**, aucun fichier source modifié, création
pure dans `Wiki/`.

## Livrables

- **Rapport audit Drive** : [Jarvis_Audit_Vault_S63_2026-04-27.md](https://drive.google.com/file/d/1Tt08MOw9lNmJCaKqbPHQ-AHkrqbVPVIb/view)
- **Plan de reprise** : `Plan_Reprise.md` (ce dossier)

## Avancement (S67)

| Domaine | Task | Statut | Fichiers créés |
|---|---|---|---|
| ADR (accepted + rejected) | T#8 | ✅ | 13 |
| Réseau & Sécurité | T#2 | ✅ | 8 |
| Veille tech | T#9 | ✅ | 7 |
| Procédures rares | T#6 | ✅ | 8 |
| Skills Jarvis | T#5 | ✅ | 7 |
| Vie perso | T#10 | ✅ | 6 |
| Inventaire physique | T#7 | ✅ | 11 (coquilles) |
| **Hardware** | **T#3** | **❌ ÉCHEC quota agent** | **0** |
| Hermès Agent | T#4 | ⏳ pending (à valider Mickael) | 0 |
| **Total** | — | **7/9** | **60 fichiers, ~206 KB** |

## À faire pour clôturer

1. **T#3 Hardware** — relancer après reset quota Anthropic 5h Paris OU en lecture/écriture directe sans sub-agent
2. **T#4 Hermès Agent** — décision Mickael (collision conv parallèle théorique mais conv fermée S67)
3. **T#12 vérification post-migration** — audit qualité des 60 fichiers créés
4. **T#13 MOC AI_Prompt_Design** — créer pointeur Wiki/20_Projets/AI_Prompt_Design/INDEX.md
5. **T#11 remédiation données sensibles** — décision sur secret_path ha-mcp + vérif sk-or-v1-148...1a1 (S55) + entry_id 01KPJ... (S20)

## Liens

- Audit complet : [Drive](https://drive.google.com/file/d/1Tt08MOw9lNmJCaKqbPHQ-AHkrqbVPVIb/view)
- Plan de reprise : `Plan_Reprise.md`
- Vault cible : `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Wiki\`
