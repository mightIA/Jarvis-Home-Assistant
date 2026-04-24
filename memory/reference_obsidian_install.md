---
name: Obsidian install Desktop
description: Procédure install Obsidian Desktop "Juste pour moi" + activation mode communautaire, transposable à toute réinstall S41+
type: reference
---

# Install Obsidian Desktop — checklist

Validé S41 25/04/2026 sur Win 11 Pro 26200, Obsidian 1.12.7 français.

## 1. Source

[obsidian.md/download](https://obsidian.md/download) **uniquement**.
Pas Microsoft Store, pas portable, pas de fork.

## 2. Options install

| Option | Choix | Pourquoi |
|---|---|---|
| Cible | **"Juste pour moi (Might)"** | Install dans `%LOCALAPPDATA%\Programs\Obsidian\`, pas d'UAC à chaque MAJ |
| Démarrage auto Windows | Non | On lance manuellement |
| Obsidian Sync | Non | Service payant, on utilisera Obsidian Git + repo privé |

## 3. Chemin de l'exécutable

```
C:\Users\Might\AppData\Local\Programs\Obsidian\Obsidian.exe
```

## 4. Activation mode communautaire (post-install)

Settings (Ctrl+,) → **Modules complémentaires** :

⚠️ **Piège formulation FR Obsidian 1.12.7** : la phrase descriptive
indique l'état actuel ("Le mode restreint est désactivé"), le bouton
à droite propose l'action **inverse** ("Activer" = remettre en mode
restreint = bloquer plugins tiers).

État OK pour installer des plugins = **"Le mode restreint est désactivé"**.

Activer aussi le toggle **"Vérifier automatiquement les mises à jour
des modules"** (MAJ sécu auto).

## 5. Piège recherche plugins

Certains plugins sont nommés **sans le préfixe "Obsidian-"** dans le
catalogue. Exemple : "Obsidian Git" est listé comme **"Git"** tout court
(par Vinzent03). Si un plugin attendu n'apparaît pas, essayer :
1. Le nom court (sans "Obsidian-")
2. Le nom de l'auteur

## 6. Vault à ouvrir

Ne **jamais** ouvrir le dossier projet Jarvis racine — vault Wiki/
seulement, cf auto-memory `reference_obsidian_vault.md`.
