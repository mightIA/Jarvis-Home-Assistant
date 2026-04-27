# Z-Wave - Home Assistant

**Version : 2026.4.4**

---

## Getting started

Cette section explique comment configurer un réseau Z-Wave et comment ajouter un appareil Z-Wave terminal à ce réseau.

Un réseau Z-Wave dans Home Assistant comprend les éléments suivants :
- Un adaptateur Z-Wave (par exemple, **Home Assistant Connect ZWA-2**)
- Un serveur Z-Wave (par exemple, l'application **Z-Wave JS**)
- Cette intégration Z-Wave
- Des appareils terminaux Z-Wave

---

## Setting up a Z-Wave Server in Home Assistant

Cette section explique comment configurer un serveur Z-Wave en utilisant l'application **Z-Wave JS** dans Home Assistant.

### To set up a Z-Wave Server

1. Ouvrez l'interface utilisateur de Home Assistant.
2. Branchez l'adaptateur Z-Wave sur l'appareil exécutant Home Assistant.
   - Votre adaptateur sera probablement reconnu automatiquement.
   - Dans la boîte de dialogue, sélectionnez **Installation recommandée**.
   - Cela installera l'application Z-Wave JS sur le serveur Home Assistant.
   - Ajoutez l'appareil à une zone et sélectionnez **Terminer**.
   - *Dépannage* : Si votre adaptateur n'est pas reconnu, suivez ces étapes.
3. Attendez que l'installation soit terminée.
4. Selon votre version de Home Assistant, il se peut que vous soyez invité à entrer des clés de sécurité réseau.
   - Si vous utilisez Z-Wave pour la première fois, laissez tous les champs vides et sélectionnez **Soumettre**. Le système générera des clés de sécurité réseau pour vous.
   - Si cet adaptateur Z-Wave a déjà été appairé avec des appareils sécurisés, vous devez entrer la clé réseau utilisée précédemment comme clé réseau S0. Les clés de sécurité S2 seront générées automatiquement pour vous.
   - Assurez-vous de sauvegarder ces clés dans un endroit sûr au cas où vous devriez déplacer votre adaptateur Z-Wave vers un autre appareil. Copiez et collez-les quelque part en sécurité.

---

**Note**
Bien que votre maillage Z-Wave soit stocké en permanence sur votre adaptateur, les métadonnées supplémentaires ne le sont pas. Lorsque l'intégration Z-Wave démarre pour la première fois, elle interrogera l'ensemble de votre réseau Z-Wave. Selon le nombre d'appareils appairés avec l'adaptateur Z-Wave, cela peut prendre un certain temps. Vous pouvez accélérer ce processus en réveillant manuellement vos appareils fonctionnant sur batterie. La plupart du temps, il s'agit d'appuyer sur un bouton de ces appareils (voir leur manuel). Il n'est pas nécessaire d'exclure et de réinclure les appareils du maillage.

---

## Adding a New Device to the Z-Wave Network

1. Dans Home Assistant, allez dans **Paramètres > Z-Wave**.
2. Sélectionnez **Ajouter un appareil**.
   - L'adaptateur Z-Wave est maintenant en mode inclusion.
3. Vérifiez si votre appareil prend en charge SmartStart :
   - Sur l'emballage, recherchez l'étiquette SmartStart.
   - Trouvez le code QR. Il peut être sur l'emballage ou sur l'appareil lui-même.
4. Selon que votre appareil prend en charge SmartStart ou non, suivez les étapes de l'option 1 ou 2 :
   - **Option 1** : Votre appareil prend en charge SmartStart :
     - Assurez-vous que l'appareil est éteint.
     - [IMAGE: Schéma illustrant l'ajout d'un appareil SmartStart via un code QR]
     - Réseau maillé : Si vous avez déjà un réseau maillé. L'ajouter peut améliorer la couverture et la fiabilité de ce réseau.
     - Vous pouvez toujours supprimer et réappairer l'appareil pour passer à l'autre type de réseau.
     - Allumez l'appareil et mettez-le en mode inclusion.
     - S'il était déjà allumé, vous devrez peut-être le redémarrer.
   - **Option 2** : Votre appareil ne prend pas en charge SmartStart :
     - Mettez l'appareil en mode inclusion. Consultez le manuel de l'appareil pour savoir comment procéder.
     - Si votre appareil est inclus en utilisant la sécurité S2, il se peut que vous soyez invité à entrer un code PIN fourni avec votre appareil. Souvent, ce code PIN est fourni avec la documentation et est également imprimé sur l'appareil lui-même. Pour plus d'informations sur l'inclusion sécurisée, consultez cette section.
5. L'interface utilisateur doit confirmer que l'appareil a été ajouté. Après un court moment (de quelques secondes à quelques minutes), les entités doivent également être créées.
6. *Dépannage* : Si l'adaptateur ne parvient pas à ajouter/trouver votre appareil, annulez le processus d'inclusion.
   - Dans certains cas, il peut être utile de supprimer d'abord un appareil (exclusion) avant de l'ajouter, même si l'appareil n'a pas encore été ajouté à ce réseau Z-Wave.
   - Une autre approche consisterait à réinitialiser l'appareil aux paramètres d'usine. Consultez le manuel de l'appareil pour savoir comment procéder.

---

## Removing a Device from the Z-Wave Network

Faites cela avant d'utiliser l'appareil avec un autre adaptateur, ou lorsque vous n'utilisez plus l'appareil. Cela supprime l'appareil du réseau Z-Wave stocké sur l'adaptateur. Il supprime également l'appareil et toutes ses entités de Home Assistant. Vous ne pouvez pas joindre un appareil à un nouveau réseau s'il est toujours appairé avec un adaptateur.

1. Dans Home Assistant, allez dans **Paramètres > Appareils et services**.
2. Sélectionnez l'intégration Z-Wave. Puis, sélectionnez l'appareil que vous souhaitez supprimer.
3. Sous **Informations sur l'appareil**, sélectionnez le menu à trois points, puis sélectionnez **Supprimer**.
   - Cela ouvre une boîte de dialogue avec des options pour supprimer l'appareil.
4. Sélectionnez **Supprimer un appareil fonctionnel**.
   - L'adaptateur Z-Wave est maintenant en mode exclusion.
5. Mettez l'appareil que vous souhaitez supprimer en mode exclusion. Consultez son manuel pour savoir comment procéder.
6. L'interface utilisateur doit confirmer que l'appareil a été supprimé et l'appareil ainsi que ses entités seront supprimés de Home Assistant.

---

## Removing a Device from a Foreign Z-Wave Network

Faites cela lorsque vous avez un appareil qui est toujours appairé avec un adaptateur, mais que vous n'avez plus accès à cet adaptateur. Si l'appareil n'a pas été exclu de cet adaptateur, vous ne pouvez pas le joindre à un nouveau réseau. Ce processus supprime l'appareil du réseau de l'adaptateur précédent, vous permettant de l'appairer avec un nouvel adaptateur.

---

## Migrating a Z-Wave Network to a New Adapter

Faites cela si vous avez un réseau Z-Wave existant et que vous souhaitez remplacer son adaptateur par un nouvel adaptateur. L'intégration Z-Wave avec toutes ses entités restera dans Home Assistant. Le nouvel adaptateur est ajouté à Home Assistant et appairé avec le réseau existant.

### Prerequisites
- Droits d'administrateur dans Home Assistant

### Device-Specific Prerequisites

1. Dans Home Assistant, allez dans **Paramètres > Z-Wave**.
2. Sous **Migrer l'adaptateur**, sélectionnez **Migrer**.
3. Lorsque la boîte de dialogue **Déconnectez votre adaptateur** apparaît, débranchez votre ancien adaptateur.
   - Il est important de retirer l'ancien appareil maintenant, car il pourrait interférer avec le nouveau. Même s'il ne génère pas d'erreur immédiatement, il pourrait causer des problèmes.
4. Connectez le nouvel adaptateur.
5. Sélectionnez **Soumettre**.
6. Dans la boîte de dialogue **Sélectionnez votre appareil**, sélectionnez l'adaptateur Z-Wave que vous venez de connecter.
   - Généralement, vous pouvez sélectionner l'appareil que vous avez connecté à un port USB.
   - Pour vous connecter à un contrôleur Z-Wave que vous avez exposé ailleurs via TCP (comme **Portable Z-Wave**), sélectionnez l'option **Utiliser une prise**.
7. Sélectionnez **Soumettre**.
   - Le nouvel adaptateur est maintenant appairé avec votre réseau Z-Wave existant.
   - *Dépannage* : Si la migration échoue, cela peut être dû au fait que vous avez sélectionné **Utiliser une prise** par erreur. Si vous utilisiez un contrôleur basé sur USB, rebranchez l'ancien adaptateur et attendez que le réseau soit rechargé.
   - Une fois votre ancien adaptateur connecté et le réseau opérationnel, répétez les étapes de migration.
   - Assurez-vous de sélectionner le nouveau contrôleur cette fois-ci (au lieu de **Utiliser une prise**).

---

## Migrating from Z-Wave JS UI to the Z-Wave JS App

Si vous avez utilisé l'application Z-Wave JS UI, vous pouvez migrer vers l'application Z-Wave JS sans avoir à réappairer vos appareils. L'application Z-Wave JS est le successeur de l'application Z-Wave JS UI et offre une meilleure expérience et plus de fonctionnalités. Le processus de migration implique l'installation de l'application Z-Wave JS, qui prendra automatiquement le relais de l'application Z-Wave JS UI.

### Prerequisites
- Droits d'administrateur dans Home Assistant
- Votre réseau Z-Wave est actuellement géré par l'application Z-Wave JS UI

### Installing Necessary Apps

1. Dans Home Assistant, allez dans **Paramètres > Apps > Z-Wave JS**.
2. Installez l'application Z-Wave JS en sélectionnant **Installer**.
   - Ne démarrez pas encore l'application.
3. Installez les applications d'assistance nécessaires :
   - Installez l'application **Terminal & SSH** afin de pouvoir exécuter des commandes sur l'hôte Home Assistant.
   - Installez une application qui vous permet de télécharger et d'éditer des fichiers sur l'hôte Home Assistant, comme l'application **File Editor** ou **Studio Code Server**.

---

[IMAGE: Capture d'écran de l'interface de sauvegarde de l'application Z-Wave JS UI]

---

### Running the Migration Script

5. Téléchargez le fichier de sauvegarde et le script de migration dans un dossier temporaire, idéalement le dossier `/tmp`.
6. Ouvrez le terminal, puis utilisez `cd /tmp` pour naviguer vers le dossier `/tmp`.
7. Rendez le script exécutable en exécutant `chmod +x ./migrate_to_zwave_js_app.sh`.

---

### Reconfiguring the Z-Wave Integration to Use the Z-Wave JS App

1. Allez dans **Paramètres > Appareils et services**.
2. Sélectionnez le menu à trois points, puis choisissez **Reconfigurer**.

---

[IMAGE: Capture d'écran de l'interface de sélection de la méthode de connexion Z-Wave]

---

4. Selon la manière dont votre contrôleur est connecté, vous devrez peut-être cocher ou décocher la case **Utiliser l'application Z-Wave Supervisor**.
   - **Option 1** : Si vous utilisez un contrôleur basé sur USB ou TCP :
     - Cochez la case **Utiliser l'application Z-Wave Supervisor**.
     - À l'étape suivante, sélectionnez votre contrôleur et sélectionnez **Soumettre**.
   - **Option 2** : Si vous utilisez un module GPIO ou si votre contrôleur n'apparaît pas dans la liste :
     - Décochez la case **Utiliser l'application Z-Wave Supervisor**.
     - Entrez les détails de connexion pour votre application Z-Wave JS :
       - Dans le champ URL, entrez `ws://core-zwave-js:3000`.

---

## Overriding the Radio Frequency Region of the Adapter in the Z-Wave JS App

La fréquence utilisée par les appareils Z-Wave dépend de votre région. Pour les adaptateurs des séries 700 et 800, cette fréquence peut être modifiée. La fréquence des appareils terminaux ne peut pas l'être, il est donc important d'acheter des appareils spécifiques à votre région.

Si vous utilisez l'application Z-Wave JS, Home Assistant modifie automatiquement la région de fréquence radio pour correspondre à la région/pays dans lequel vous vous trouvez. Si nécessaire, vous pouvez remplacer ce paramètre.

### Prerequisites
- Droits d'administrateur dans Home Assistant
- Tous vos appareils Z-Wave doivent être spécifiés pour cette région
- *Note* : cette procédure ne s'applique que si votre adaptateur est configuré avec l'application Z-Wave JS

### To Override the Radio Frequency Region of Your Z-Wave Adapter

1. Allez dans **Paramètres > Apps > Z-Wave JS**.
2. Ouvrez l'onglet **Configuration**.
3. Sous **Radio Frequency Region**, sélectionnez votre région dans la liste déroulante.
   - Même avec l'option Long Range sélectionnée, vous pouvez toujours ajouter des appareils qui ne prennent pas en charge Long Range.
4. Pour appliquer vos modifications, sélectionnez **Enregistrer**.
   - Votre adaptateur Z-Wave est maintenant prêt à communiquer avec les appareils spécifiés pour votre région choisie.
5. Pour revenir au paramètre par défaut et utiliser la région définie par Home Assistant, sous **Radio Frequency Region**, choisissez **Automatique**.

---

## Backing up Your Z-Wave Network

Il est recommandé de créer une sauvegarde avant d'apporter des modifications majeures à votre réseau Z-Wave. Par exemple, avant de migrer d'un adaptateur à un autre, ou avant de réinitialiser votre adaptateur. La sauvegarde stocke la mémoire non volatile (NVM) de votre adaptateur Z-Wave, qui contient les informations de votre réseau, y compris les appareils appairés. Elle est stockée dans un fichier binaire que vous pouvez télécharger.

### Prerequisites
- Droits d'administrateur dans Home Assistant

### To Backup Your Z-Wave Network

1. Dans Home Assistant, allez dans **Paramètres > Z-Wave**.

---

## Restoring a Z-Wave Network from Backup

Vous pouvez restaurer votre réseau Z-Wave à partir d'une sauvegarde.

### Prerequisites
- Droits d'administrateur dans Home Assistant
- Avoir téléchargé une sauvegarde

### To Restore a Z-Wave Network from Backup

1. Dans Home Assistant, allez dans **Paramètres > Z-Wave**.
2. Sous **Restaurer à partir d'une sauvegarde**, sélectionnez **Restaurer**.
   - Sélectionnez la sauvegarde à partir de laquelle vous souhaitez restaurer.
   - Résultat : Le réseau Z-Wave est en cours de restauration et les appareils qui faisaient partie du réseau devraient réapparaître.

---

## Updating the Firmware of Your Z-Wave Device

Les adaptateurs et appareils dotés de la classe de commande Firmware Update Metadata permettent de mettre à jour le micrologiciel en téléchargeant un fichier de micrologiciel. Dans ces cas, vous pouvez démarrer la mise à jour du micrologiciel à partir de la page de l'appareil dans Home Assistant. Consultez la documentation du fabricant de l'appareil pour trouver le fichier de micrologiciel correspondant. Un exemple est la page de micrologiciel de Zooz.

**Note**
Les équipes Home Assistant et Z-Wave JS ne prennent aucune responsabilité pour les dommages causés à votre appareil à la suite de la mise à jour du micrologiciel et ne pourront pas vous aider si vous rendez votre appareil inutilisable en raison de la mise à jour du micrologiciel.

### Prerequisites
- Droits d'administrateur dans Home Assistant
- Téléchargement du fichier de micrologiciel depuis le site Web du fabricant

### To Update Firmware of a Z-Wave Device

1. Dans Home Assistant, allez dans **Paramètres > Z-Wave**.
2. Sélectionnez **Appareils**.
   - Puis sélectionnez l'appareil que vous souhaitez mettre à jour.
3. Sous **Informations sur l'appareil**, sélectionnez le menu à trois points, puis sélectionnez **Mettre à jour**.
4. Sélectionnez le fichier de micrologiciel que vous avez précédemment téléchargé sur votre ordinateur.
   - *Attention* : Risque de dommage pour l'appareil
   - Assurez-vous de sélectionner le bon fichier de micrologiciel.
   - Un fichier de micrologiciel incorrect peut endommager votre appareil.
   - Une fois que vous avez démarré le processus de mise à jour, vous devez attendre que la mise à jour soit terminée.
   - Une mise à jour interrompue peut endommager votre appareil.

---

## Resetting a Z-Wave Adapter

### Prerequisites
- Droits d'administrateur sur Home Assistant
- Sauvegardez votre réseau Z-Wave
- Supprimez tous les appareils appairés avec votre adaptateur du réseau.
   - La suppression peut être effectuée par n'importe quel adaptateur, pas seulement celui qui gérait initialement le réseau. En théorie, cela pourrait également être fait plus tard.

### To Reset a Z-Wave Adapter

1. Dans Home Assistant, allez dans **Paramètres > Appareils et services**.
2. Sélectionnez l'intégration Z-Wave. Puis, sélectionnez le contrôleur.
3. Sous **Informations sur l'appareil**, sélectionnez le menu à trois points, puis sélectionnez **Réinitialisation d'usine**.
4. Sur la page d'informations de l'appareil, vérifiez le panneau **Activité**. Lorsque vous voyez que l'entité de statut est devenue indisponible, le processus de réinitialisation est terminé.
   - Vous pouvez maintenant débrancher l'adaptateur et l'utiliser pour démarrer un nouveau réseau, ou le transmettre à quelqu'un d'autre.
5. Si vous n'avez plus besoin de l'intégration Z-Wave, vous pouvez la supprimer de Home Assistant.

---

## Special Z-Wave Entities

L'intégration Z-Wave fournit plusieurs entités spéciales, certaines disponibles pour chaque appareil Z-Wave, et d'autres conditionnelles en fonction de l'appareil.

### Entities Available for Every Z-Wave Device

1. **Capteur d'état du nœud** : Ce capteur affiche l'état du nœud pour un appareil Z-Wave donné. Le capteur est désactivé par défaut. Les états de nœud disponibles sont expliqués dans la documentation de Z-Wave JS. Ils peuvent être utilisés dans les automatismes de changement d'état. Par exemple, pour ping un appareil lorsqu'il est hors ligne, ou pour rafraîchir les valeurs lorsqu'il se réveille.

---

### Conditional Entities

1. **Bouton pour mettre manuellement les notifications en veille** : Toute valeur de classe de commande de notification (CC) sur un appareil qui a un état inactif obtiendra une entité de bouton correspondante. Cette entité de bouton peut être utilisée pour mettre manuellement une notification en veille lorsqu'elle ne se nettoie pas automatiquement. Un appareil peut avoir plusieurs valeurs CC de notification. Par exemple, une pour la détection de fumée et une pour la détection de monoxyde de carbone.

---

## Using Advanced Features (UI Only)

Bien que l'intégration vise à fournir autant de fonctionnalités que possible via les constructions existantes de Home Assistant (entités, états, automatismes, actions, etc.), certaines fonctionnalités ne sont disponibles que via l'interface utilisateur.

Toutes ces fonctionnalités peuvent être accessibles soit dans le panneau de configuration de l'intégration Z-Wave, soit dans le panneau d'un appareil Z-Wave de votre réseau.

---

### Integration Configuration Panel

Les fonctionnalités suivantes peuvent être accessibles depuis le panneau de configuration de l'intégration :

- **Ajouter un appareil** : Bouton en bas à droite. Permet de pré-provisionner un appareil SmartStart ou de démarrer le processus d'inclusion pour ajouter un nouvel appareil à votre réseau.
- La section **Mon réseau** vous donne accès aux listes d'appareils et d'entités pour votre réseau Z-Wave.
- **Afficher la carte** : Permet de voir une représentation visuelle de votre réseau Z-Wave, montrant les appareils et les routes entre eux. Cela peut être utile pour diagnostiquer les problèmes de votre réseau.
- **Options > Supprimer un appareil** : Démarre le processus d'exclusion pour supprimer un appareil étranger d'un réseau. Cela vous permet de supprimer un appareil qui est toujours appairé à un autre adaptateur Z-Wave.
- **Options > Découvrir et attribuer de nouvelles routes** : Découvre de nouvelles routes entre l'adaptateur et l'appareil. Cela est utile lorsque des appareils ou l'adaptateur ont des problèmes de communication RF.
- **Options > Activer la journalisation de télémétrie** : Active la journalisation de télémétrie pour votre réseau Z-Wave. Cette télémétrie est désactivée par défaut et doit être activée manuellement.
- **Informations sur le réseau** : Métadonnées sur votre réseau Z-Wave, telles que l'ID de la maison, la version du serveur ou l'URL du serveur. Ces informations peuvent être utiles pour diagnostiquer les problèmes de votre réseau ou pour contacter le support.
- **Télécharger une sauvegarde** : Crée et télécharge une sauvegarde de votre réseau Z-Wave. La sauvegarde contient la mémoire non volatile (NVM) de votre adaptateur Z-Wave, qui inclut tous les appareils appairés. Il est recommandé de créer une sauvegarde avant d'apporter des modifications majeures à votre réseau Z-Wave, comme la migration vers un nouvel adaptateur ou la réinitialisation de votre adaptateur.
- **Restaurer à partir d'une sauvegarde** : Restaure votre réseau Z-Wave à partir d'un fichier de sauvegarde que vous avez précédemment téléchargé. Cela peut être utile lorsque vous migrez vers un nouvel adaptateur, ou lorsque vous souhaitez restaurer votre réseau après avoir réinitialisé votre adaptateur.
- **Migrer l'adaptateur** : Permet de migrer votre réseau Z-Wave vers un nouvel adaptateur.

---

### About Network Information

La section **Informations sur le réseau** dans le panneau de configuration de l'intégration affiche les métadonnées concernant votre réseau Z-Wave et le logiciel qui l'exécute. Ces informations sont utiles pour diagnostiquer les problèmes ou pour contacter le support.

- **Home ID** : Un identifiant unique attribué à votre réseau Z-Wave. Chaque appareil appairé à votre réseau partage cet ID. Il peut être utilisé pour vérifier qu'un appareil appartient à votre réseau ou pour identifier votre réseau lorsque vous demandez de l'aide.

---

### Integration Menu

Certaines fonctionnalités peuvent être accessibles depuis le menu de l'intégration elle-même. Comme elles ne sont pas spécifiques à Z-Wave, elles ne sont pas décrites ici en détail.

- **Télécharger les diagnostics** : Exporte un fichier JSON décrivant les entités de tous les appareils enregistrés avec cette intégration.

---

### Network Devices

Les fonctionnalités suivantes peuvent être accessibles depuis le panneau de l'appareil de n'importe quel appareil Z-Wave de votre réseau, à l'exception de l'adaptateur :

- **Configurer** : Fournit un moyen facile de rechercher et de mettre à jour les paramètres de configuration de l'appareil. Bien qu'il existe une action pour définir les valeurs des paramètres de configuration, cette interface utilisateur peut parfois être plus rapide à utiliser pour des modifications ponctuelles.
- **Réinterviewer** : Force l'appareil à passer à nouveau par le processus d'interview afin que Z-Wave-JS puisse découvrir toutes ses capacités. Peut être utile si vous ne voyez pas toutes les entités attendues pour votre appareil.
- **Rebâtir les routes** : Découvre de nouvelles routes entre l'adaptateur et l'appareil. Utilisez cela si vous pensez rencontrer des retards inattendus ou des problèmes RF avec votre appareil. Votre appareil peut être moins réactif pendant ce processus.
- **Supprimer** : Ouvre une boîte de dialogue avec les options suivantes pour supprimer l'appareil :
  - Le supprimer du réseau en utilisant l'exclusion
  - Supprimer un appareil défaillant de l'adaptateur sans l'exclure du réseau
- **Statistiques** : Fournit des statistiques sur la communication entre cet appareil et l'adaptateur, vous permettant de diagnostiquer les problèmes RF avec l'appareil.
- **Mettre à jour** : Met à jour le micrologiciel d'un appareil à l'aide d'un fichier de micrologiciel téléchargé manuellement. Seuls certains appareils prennent en charge cette fonctionnalité (adaptateurs et appareils avec la classe de commande Firmware Update Metadata).
- **Télécharger les diagnostics** : Exporte un fichier JSON décrivant les entités de cet appareil spécifique.

---

## Actions

### Action: Set Config Parameter
   Attribut de données | Requis | Description |
 |---------------------|--------|-------------|
 | entity_id           | non    | Entité (ou liste d'entités) sur laquelle définir le paramètre de configuration. Au moins un entity_id, device_id ou area_id doit être fourni. |
 | device_id           | non    | ID de l'appareil (ou liste d'IDs d'appareils) sur lequel définir le paramètre de configuration. Au moins un entity_id, device_id ou area_id doit être fourni. |
 | area_id             | non    | ID de la zone (ou liste d'IDs de zones) pour les appareils/entités sur lesquels définir le paramètre de configuration. Au moins un entity_id, device_id ou area_id doit être fourni. |
 | parameter           | oui    | Le numéro du paramètre ou le nom de la propriété. Le nom de la propriété est sensible à la casse. |
 | bitmask             | non    | Le masque de bits pour un paramètre partiel en hexadécimal (0xff) ou en décimal (255). Si le nom du paramètre est fourni, cela n'est pas nécessaire. Ne peut pas être combiné avec value_size ou value_format. |
 | value               | oui    | La valeur cible pour le paramètre en tant que valeur entière ou l'étiquette d'état. L'étiquette d'état est sensible à la casse. |
 | value_size          | non    | La taille de la valeur du paramètre cible, soit 1, 2 ou 4. Utilisé en combinaison avec value_format lorsqu'un paramètre de configuration n'est pas défini dans le fichier de configuration de votre appareil. Ne peut pas être combiné avec bitmask. |
 | value_format        | non    | Le format de la valeur du paramètre cible, soit booléen, int ou bitfield. Utilisé en combinaison avec value_size lorsqu'un paramètre de configuration n'est pas défini dans le fichier de configuration de votre appareil. Ne peut pas être combiné avec bitmask. |

---

### Exemples

#### Exemple 1:
```txt
action: zwave_js.set_config_parameter
target:
  entity_id: switch.fan
data:
  parameter: 31
  bitmask: 0x01
  value: 1



Exemple 2:
txt
Copier

action: zwave_js.set_config_parameter
target:
  entity_id: switch.fan
data:
  parameter: 31
  bitmask: 1
  value: "Blink"



Exemple 3:
txt
Copier

action: zwave_js.set_config_parameter
target:
  entity_id: switch.fan
data:
  entity_id: switch.fan
  parameter: "LED 1 Blink Status (bottom)"
  value: "Blink"




Action: Bulk Set Partial Config Parameters


  
    
      Attribut de données
      Requis
      Description
    
  
  
    
      entity_id
      non
      Entité (ou liste d'entités) pour définir en masse les paramètres de configuration partiels. Au moins un entity_id, device_id ou area_id doit être fourni.
    
    
      device_id
      non
      ID de l'appareil (ou liste d'IDs d'appareils) pour définir en masse les paramètres de configuration partiels. Au moins un entity_id, device_id ou area_id doit être fourni.
    
    
      area_id
      non
      ID de la zone (ou liste d'IDs de zones) pour les appareils/entités pour définir en masse les paramètres de configuration partiels. Au moins un entity_id, device_id ou area_id doit être fourni.
    
    
      parameter
      oui
      Le numéro du paramètre ou le nom de la propriété. Le nom de la propriété est sensible à la casse.
    
    
      value
      oui
      Soit la valeur entière brute que vous souhaitez définir pour l'ensemble du paramètre, soit un dictionnaire où les clés sont soit les masques de bits (en format entier ou hexadécimal) ou le nom du paramètre partiel et les valeurs sont la valeur que vous souhaitez définir sur chaque partie (soit la valeur entière, soit un état nommé le cas échéant). Notez que lorsque vous utilisez un dictionnaire, les masques de bits qui ne sont pas fournis seront définis sur leurs valeurs actuellement mises en cache.
    
  



Exemples de définition en masse des valeurs de paramètres partiels
Utilisons le paramètre 21 pour cet appareil comme exemple pour montrer comment les paramètres partiels peuvent être définis en masse. Dans ce cas, nous voulons définir 0x0aˋ127,0x0 à 127, 0x0aˋ127,0x700 à 10, et $0x8000 à 1 (ou la valeur brute de 4735).
Exemple 1:
txt
Copier

action: zwave_js.bulk_set_partial_config_parameters
target:
  entity_id: switch.fan
data:
  parameter: 21
  value: 4735



Exemple 2:
txt
Copier

action: zwave_js.bulk_set_partial_config_parameters
target:
  entity_id: switch.fan
data:
  parameter: 21
  value:
    0xff: 127
    0x7f00: 10
    0x8000: 1



Exemple 3:
txt
Copier

action: zwave_js.bulk_set_partial_config_parameters
target:
  entity_id: switch.fan
data:
  parameter: 21
  value:
    255: 127
    32512: 10




Action: Refresh Value


  
    
      Attribut de données
      Requis
      Description
    
  
  
    
      entity_id
      oui
      Entité ou liste d'entités pour lesquelles rafraîchir les valeurs.
    
    
      refresh_all_values
      non
      Indique si toutes les valeurs doivent être rafraîchies. Si faux, seule la valeur principale sera rafraîchie. Si vrai, toutes les valeurs surveillées seront rafraîchies.
    
  



Action: Set Value


  
    
      Attribut de données
      Requis
      Description
    
  
  
    
      entity_id
      non
      Entité (ou liste d'entités) sur laquelle définir la valeur. Au moins un entity_id, device_id ou area_id doit être fourni.
    
    
      device_id
      non
      ID de l'appareil (ou liste d'IDs d'appareils) sur lequel définir la valeur. Au moins un entity_id, device_id ou area_id doit être fourni.
    
    
      area_id
      non
      ID de la zone (ou liste d'IDs de zones) pour les appareils/entités sur lesquels définir la valeur. Au moins un entity_id, device_id ou area_id doit être fourni.
    
    
      command_class
      oui
      ID de la classe de commande pour laquelle vous souhaitez définir la valeur.
    
    
      property
      oui
      ID de la propriété pour laquelle vous souhaitez définir la valeur.
    
    
      property_key
      non
      ID de la clé de propriété pour laquelle vous souhaitez définir la valeur.
    
    
      endpoint
      non
      ID du point de terminaison pour lequel vous souhaitez définir la valeur.
    
    
      value
      oui
      La nouvelle valeur que vous souhaitez définir.
    
    
      options
      non
      Carte des options de définition de valeur. Consultez la documentation Z-Wave JS pour plus d'informations sur les options qui peuvent être définies.
    
    
      wait_for_result
      non
      Booléen indiquant si vous souhaitez attendre une réponse du nœud. Si non inclus dans la charge utile, l'intégration décidera d'attendre ou non. Si défini sur vrai, notez que l'action peut prendre un certain temps si vous définissez une valeur sur un appareil fonctionnant sur batterie.
    
  



Action: Set Value via Multicast


  
    
      Attribut de données
      Requis
      Description
    
  
  
    
      entity_id
      non
      Entité (ou liste d'entités) sur laquelle définir la valeur via multicast. Au moins deux entity_id ou device_id doivent être résolus si la commande n'est pas diffusée.
    
    
      device_id
      non
      ID de l'appareil (ou liste d'IDs d'appareils) sur lequel définir la valeur via multicast. Au moins deux entity_id ou device_id doivent être résolus si la commande n'est pas diffusée.
    
    
      area_id
      non
      ID de la zone (ou liste d'IDs de zones) pour les appareils/entités sur lesquels définir la valeur via multicast. Au moins deux entity_id ou device_id doivent être résolus si la commande n'est pas diffusée.
    
    
      broadcast
      non
      Booléen indiquant si vous souhaitez que le message soit diffusé à tous les nœuds du réseau. Si vous n'avez configuré qu'un seul réseau Z-Wave, vous n'avez pas besoin de fournir un device_id ou entity_id lorsque cette option est définie sur vrai. Lorsque vous avez configuré plusieurs réseaux Z-Wave, vous DEVEZ fournir au moins un device_id ou entity_id afin que l'action sache quel réseau cibler.
    
    
      command_class
      oui
      ID de la classe de commande pour laquelle vous souhaitez définir la valeur.
    
    
      property
      oui
      ID de la propriété pour laquelle vous souhaitez définir la valeur.
    
    
      property_key
      non
      ID de la clé de propriété pour laquelle vous souhaitez définir la valeur.
    
  



Action: Invoke CC API
L'action zwave_js.invoke_cc_api utilise directement l'API de la classe de commande. Dans la plupart des cas, l'action zwave_js.set_value accomplira ce dont vous avez besoin, mais certaines classes de commande ont des commandes API qui ne peuvent pas être accessibles via cette action. Consultez la documentation Z-Wave JS Command Class pour les API disponibles et leurs arguments. Assurez-vous de savoir ce que vous faites lorsque vous appelez cette action.


  
    
      Attribut de données
      Requis
      Description
    
  
  
    
      entity_id
      non
      Entité (ou liste d'entités) à ping. Au moins un entity_id, device_id ou area_id doit être fourni. Si le point de terminaison est spécifié, ce point de terminaison sera utilisé pour effectuer l'appel CC API pour tous les appareils, sinon le point de terminaison principal sera utilisé pour chaque entité.
    
    
      device_id
      non
      ID de l'appareil (ou liste d'IDs d'appareils) à ping. Au moins un entity_id, device_id ou area_id doit être fourni. Si le point de terminaison est spécifié, ce point de terminaison sera utilisé pour effectuer l'appel CC API pour tous les appareils, sinon le point de terminaison racine (0) sera utilisé pour chaque appareil.
    
    
      area_id
      non
      ID de la zone (ou liste d'IDs de zones) pour les appareils/entités à ping. Au moins un entity_id, device_id ou area_id doit être fourni. Si le point de terminaison est spécifié, ce point de terminaison sera utilisé pour effectuer l'appel CC API pour tous les appareils, sinon le point de terminaison racine (0) sera utilisé pour chaque appareil Z-Wave dans la zone.
    
    
      command_class
      oui
      ID de la classe de commande pour laquelle vous souhaitez définir la valeur.
    
    
      endpoint
      non
      Le point de terminaison pour appeler l'API CC.
    
  



Action: Reset Meter
L'action zwave_js.reset_meter réinitialise les compteurs sur un appareil prenant en charge la classe de commande Meter.


  
    
      Attribut de données
      Requis
      Description
    
  
  
    
      entity_id
      oui
      Entité (ou liste d'entités) pour les compteurs que vous souhaitez réinitialiser.
    
    
      meter_type
      non
      Si pris en charge par l'appareil, indique le type de compteur à réinitialiser. Tous les appareils ne prennent pas en charge cette option.
    
  



Action: Set Lock Operation Mode


  
    
      Attribut de données
      Requis
      Description
    
  
  
    
      entity_id
      non
      Entité de verrouillage ou liste d'entités sur lesquelles définir le mode de verrouillage.
    
    
      operation_type
      oui
      Type d'opération de verrouillage, soit temporisé ou constant.
    
    
      lock_timeout
      non
      Secondes jusqu'à ce que le mode de verrouillage expire. Doit être utilisé uniquement si le type d'opération est temporisé.
    
    
      auto_relock_time
      non
      Durée en secondes jusqu'à ce que le verrou revienne à l'état sécurisé. Appliqué uniquement lorsque le type d'opération est constant.
    
    
      hold_and_release_time
      non
      Durée en secondes pendant laquelle le loquet reste rétracté.
    
    
      twist_assist
      non
      Activer l'assistance de torsion.
    
    
      block_to_block
      non
      Activer la fonctionnalité de bloc à bloc.
    
  



Action: Set Lock Usercode
L'action zwave_js.set_lock_usercode définit le code utilisateur d'un verrou à X dans l'emplacement de code Y. Les codes utilisateurs valides comportent au moins 4 chiffres.


  
    
      Attribut de données
      Requis
      Description
    
  
  
    
      entity_id
      non
      Entité de verrouillage ou liste d'entités sur lesquelles définir le code utilisateur.
    
    
      code_slot
      oui
      L'emplacement de code dans lequel définir le code utilisateur.
    
    
      usercode
      oui
      Le code à définir dans l'emplacement.
    
  



Action: Clear Lock Usercode

Action: Get Lock Usercode
L'action zwave_js.get_lock_usercode récupère les usercodes d'un verrou. Vous pouvez interroger un emplacement de code spécifique ou récupérer tous les emplacements de code à la fois. Retourne le code utilisateur et l'état d'utilisation pour chaque emplacement.


  
    
      Attribut de données
      Requis
      Description
    
  
  
    
      entity_id
      non
      Entité de verrouillage ou liste d'entités à partir desquelles obtenir les codes utilisateurs.
    
    
      code_slot
      non
      L'emplacement de code à récupérer. Si non spécifié, tous les emplacements de code sont retournés.
    
  



Events
Il existe deux types d'événements qui sont déclenchés : les événements de notification et les événements de notification de valeur. Vous pouvez tester les événements entrants en utilisant les outils de développement d'événements dans Home Assistant et en vous abonnant aux événements zwave_js_notification ou zwave_js_value_notification. Une fois que vous savez à quoi ressemblent les données de l'événement, vous pouvez utiliser cela pour créer des automatismes.

Node Events (Notification)
Consultez la documentation des événements de notification Z-Wave JS pour une explication des événements de notification.
txt
Copier

event_type: zwave_js_notification
event_data:
  node_id: 14
  event_label: "Keypad unlock operation"




Notification Command Class
Ce sont des événements de notification déclenchés par des appareils utilisant la classe de commande Notification. L'attribut (paramètres) dans l'exemple ci-dessous est facultatif, et lorsque celui-ci est inclus, les clés de l'attribut varieront en fonction de l'événement.
json
Copier

{
  "domain": "zwave_js",
  "node_id": 1,
  "endpoint": 0,
  "home_id": "974823419",
  "device_id": "ad8098fe80980974",
  "command_class": 113,
  "command_class_name": "Notification",
  "type": 6,
  "event": 5,
  "label": "Access Control",
  "event_label": "Keypad lock operation",
  "parameters": {"userId": 1}
}




Multilevel Switch Command Class
Ce sont des événements de notification déclenchés par des appareils utilisant la classe de commande Multilevel Switch. Il existe des événements pour le début et la fin du changement de niveau. Ceux-ci seraient typiquement utilisés dans un appareil comme l'Aeotec Nano Dimmer avec un interrupteur externe pour répondre aux pressions longues sur les boutons.
Start level change
json
Copier

{
  "domain": "zwave_js",
  "node_id": 8,
  "endpoint": 0,
  "home_id": 3803689189,
  "device_id": "2f44f0d4152be3123f7ad40cf3abd095",
  "command_class": 38,
  "command_class_name": "Multilevel Switch",
  "event_type": 5,
  "event_type_label": "label 2",
  "direction": "up"
}



Stop level change
json
Copier

{
  "domain": "zwave_js",
  "node_id": 8,
  "endpoint": 0,
  "home_id": 3803689189,
  "device_id": "2f44f0d4152be3123f7ad40cf3abd095",
  "command_class": 38,
  "command_class_name": "Multilevel Switch",
  "event_type": 5,
  "event_type_label": "label 2",
  "direction": null
}




Entry Control Command Class
Ce sont des événements de notification déclenchés par des appareils utilisant la classe de commande Entry Control.
json
Copier

{
  "domain": "zwave_js",
  "node_id": 1,
  "endpoint": 0,
  "home_id": "974823419",
  "device_id": "ad8098fe80980974",
  "command_class": 111,
  "command_class_name": "Entry Control",
  "event_type": 6,
  "event_type_label": "label 1",
  "data_type": 5,
  "data_type_label": "label 2"
}




Central Scene Command Class
json
Copier

{
  "domain": "zwave_js",
  "node_id": 1,
  "home_id": "974823419",
  "endpoint": 0,
  "device_id": "ad8098fe80980974",
  "command_class": 91,
  "command_class_name": "Central Scene",
  "label": "Event value",
  "property": "scene",
  "property_name": "scene",
  "property_key": "001",
  "property_key_name": "001",
  "value": "KeyPressed",
  "value_raw": 0
}




Value Updated Events
En raison du fait que certains appareils ne suivent pas la spécification Z-Wave, il existe des scénarios où un appareil envoie une mise à jour de valeur mais où un changement d'état n'est pas détecté dans Home Assistant. Pour combler cette lacune, l'événement zwave_js_value_updated peut être écouté pour capturer toute mise à jour de valeur reçue par une entité affectée. Cet événement est activé sur une base par appareil et par domaine d'entité, et les entités auront assumed_state défini sur true. Ce changement affectera l'apparence de l'interface utilisateur pour ces entités ; si vous souhaitez que l'interface utilisateur corresponde à d'autres entités du même type où assumed_state n'est pas défini sur true, vous pouvez remplacer le paramètre via la personnalisation de l'entité.
Les appareils suivants prennent actuellement en charge cet événement :
txt
Copier

Modèle | Domaine de l'entité




Exemple d'automatisation
yaml
Copier

triggers:
  - trigger: event
    event_type: zwave_js_value_updated
    event_data:
      entity_id: switch.in_wall_dual_relay_switch
actions:
  - action: zwave_js.refresh_value
    data:
      entity_id:
        - switch.in_wall_dual_relay_switch_2
        - switch.in_wall_dual_relay_switch_3




Automations
L'intégration Z-Wave fournit ses propres plateformes de déclenchement qui peuvent être utilisées dans les automatismes.
ZWAVE_JS.VALUE_UPDATED
txt
Copier

Au moins un `device_id` ou `entity_id` doit être fourni
device_id: 45d7d3230dbb7441473ec883dab294d4 # ID de l'appareil Garage Door Lock
entity_id:
  - lock.front_lock
  - lock.back_door
# `property` et `command_class` sont requis
command_class: 98 # Classe de commande Door Lock
property: "latchStatus"
# `property_key` et `endpoint` sont optionnels
property_key: null
endpoint: 0
# `from` et `to` accepteront tous deux des listes de valeurs et le déclencheur se déclenchera si la mise à jour de la valeur correspond à l'une des valeurs listées
from:
  - "closed"
  - "jammed"
to: "opened"




Available Trigger Data
En plus des données de déclenchement standard de l'automatisation, la plateforme de déclenchement zwave_js.value_updated dispose de données de déclenchement supplémentaires disponibles pour une utilisation.


  
    
      Variable de modèle
      Données
    
  
  
    
      trigger_device_id
      ID de l'appareil pour l'appareil dans le registre des appareils.
    
    
      trigger.node_id
      ID du nœud Z-Wave.
    
    
      trigger.command_class
      ID de la classe de commande.
    
    
      trigger.command_class_name
      Nom de la classe de commande.
    
    
      trigger.property
      Propriété de la valeur Z-Wave.
    
    
      trigger.current_value
      Valeur actuelle.
    
    
      trigger.current_value_raw
      Valeur actuelle brute.
    
  



ZWAVE_JS.EVENT
Cette plateforme de déclenchement peut être utilisée pour déclencher des automatismes sur tout événement de contrôleur, de pilote ou de nœud Z-Wave, y compris les événements qui peuvent ne pas être gérés automatiquement par Home Assistant. Consultez la documentation liée de Z-Wave JS pour en savoir plus sur les événements disponibles et les données qui sont envoyées avec eux.
Il existe une validation stricte en place basée sur tous les types d'événements connus, donc si vous rencontrez un type d'événement qui n'est pas pris en charge, veuillez ouvrir un problème GitHub dans le dépôt home-assistant/core.

Exemple de configuration de déclencheur d'automatisation
yaml
Copier

triggers:
  - trigger: zwave_js.event
    # Au moins un `device_id` ou `entity_id` doit être fourni pour les événements de nœud. Pour tout autre événement, un `config_entry_id` est nécessaire.
    device_id: 45d7d3230dbb7441473ec883dab294d4 # ID de l'appareil Garage Door Lock
    entity_id:
      - lock.front_lock
      - lock.back_door
    config_entry_id:
    args:
      isFinal: true
      partial_dict_match: true  # par défaut à false




Available Trigger Data
En plus des données de déclenchement standard de l'automatisation, la plateforme de déclenchement zwave_js.event dispose de données de déclenchement supplémentaires disponibles pour une utilisation.


  
    
      Variable de modèle
      Données
    
  
  
    
      trigger_device_id
      ID de l'appareil pour l'appareil dans le registre des appareils (uniquement inclus pour les événements de nœud).
    
    
      trigger.node_id
      ID du nœud Z-Wave (uniquement inclus pour les événements de nœud).
    
    
      trigger.event_source
      Source de l'événement (nœud, contrôleur ou pilote).
    
    
      trigger.event
      Nom de l'événement.
    
    
      trigger.event_data
      Toutes les données incluses dans l'événement.
    
  



Advanced Installation Instructions
Si vous utilisez Home Assistant Container ou si vous ne souhaitez pas utiliser l'application intégrée Z-Wave JS, vous devez exécuter vous-même le serveur Z-Wave JS, auquel l'intégration Z-Wave se connectera.

Running Z-Wave JS Server
Option 1: L'application officielle Z-Wave JS, comme décrit ci-dessus
Cette option n'est disponible que pour les installations Home Assistant Operating System (le type d'installation recommandé).
Cette application (anciennement connue sous le nom d'add-on) ne peut être configurée que via le panneau de contrôle Z-Wave intégré dans Home Assistant. Si vous avez suivi la procédure d'installation standard, c'est ainsi que vous exécutez le serveur Z-Wave JS.
Option 2: Le conteneur Docker Z-Wave JS UI
Cela est considéré comme un cas d'utilisation plus complexe. Dans ce cas, vous exécutez directement l'application NodeJS Z-Wave JS Server ou Z-Wave JS UI. L'installation et la maintenance de celle-ci sont hors du cadre de ce document. Consultez le dépôt GitHub du serveur Z-Wave JS ou de l'interface utilisateur Z-Wave JS pour plus d'informations.

Note

Adaptateur Z-Wave pris en charge. L'adaptateur Z-Wave doit être connecté au même hôte que celui sur lequel le serveur Z-Wave JS est en cours d'exécution. Dans la configuration du serveur Z-Wave JS, vous devez fournir le chemin vers cet adaptateur. Il est recommandé d'utiliser la version /dev/serial-by-id/yourdevice du chemin vers votre adaptateur, pour vous assurer que le chemin ne change pas après les redémarrages. Le chemin le plus couramment connu est /dev/serial/by-id/usb-0658_0200-if00.

Note

Les clés de réseau sont utilisées pour se connecter de manière sécurisée aux appareils compatibles. Les clés de réseau se composent de 32 caractères hexadécimaux, par exemple, 2232666D100F795E5BB17F0A1BB7A146 (ne pas utiliser celui-ci, choisissez-en un aléatoire). Sans les clés de réseau, la sécurité activée, les appareils ne peuvent pas être ajoutés de manière sécurisée et ne fonctionneront pas correctement. Vous devez fournir ces clés de réseau dans la partie configuration du serveur Z-Wave JS.
Pour les nouvelles installations, des clés par défaut uniques seront générées automatiquement pour vous.

Une fois que vous avez le serveur Z-Wave JS en cours d'exécution, vous devez installer et configurer l'intégration dans Home Assistant (comme décrit ci-dessus).
Si vous exécutez Home Assistant avec un superviseur, une boîte de dialogue vous demandera si vous souhaitez utiliser l'application Z-Wave JS Supervisor. Vous devez décocher cette case si vous exécutez le serveur Z-Wave JS de toute autre manière que l'application officielle Z-Wave JS, y compris l'utilisation de l'application Z-Wave JS UI.
Si vous n'exécutez pas le superviseur ou si vous avez décoché la case mentionnée ci-dessus, vous serez invité à entrer une URL WebSocket (par défaut ws://localhost:3000). Il est très important que vous remplissiez correctement l'IP/le nom d'hôte (Docker) ici. Par exemple, pour l'application Z-Wave JS UI, il s'agit de ws://a0d7b954-zwavejs2mqtt:3000.

FAQ: Supported Devices and Command Classes
Pour une liste des appareils pris en charge, consultez la base de données des appareils Z-Wave JS.
Bien qu'il existe un support pour les appareils les plus courants, certaines classes de commande ne sont pas encore (complètement) implémentées dans Z-Wave JS. Vous pouvez suivre l'état ici.
Vous pouvez également consulter la liste des classes de commande Z-Wave auxquelles Home Assistant répond lorsqu'elles sont interrogées vers la fin de cette page.
Vous pouvez également suivre la feuille de route pour l'intégration Z-Wave ici.

Why Was I (Not) Automatically Prompted to Install Z-Wave?
Certains adaptateurs Z-Wave peuvent être détectés automatiquement, ce qui peut simplifier le processus de configuration de Z-Wave. Les appareils suivants ont été testés avec la détection et offrent une expérience de configuration rapide ; cependant, ceux-ci ne sont pas tous les appareils pris en charge par Z-Wave :


  
    
      Appareil
      Identifiant
      Fournisseur
    
  
  
    
      Aeotec Z-Stick Gen5+
      0658:0200
      Aeotec
    
    
      Nortek HUSBZB-1
      10C4:8A2A
      Nortek Control
    
    
      Zooz ZST10
      10C4

      Zooz
    
    
      Z-WaveMe UZB
      0658:0200
      Z-WaveMe
    
  


D'autres appareils peuvent être détectables, mais seuls les appareils confirmés comme détectables sont répertoriés ci-dessus.

Should I Use Secure Inclusion?
Cela dépend. Il existe deux générations de chiffrement Z-Wave, Sécurité S0 et Sécurité S2. Les deux fournissent un chiffrement et permettent de détecter la corruption des paquets.
La sécurité S0 impose un trafic supplémentaire important sur votre maillage et n'est recommandée que pour les anciens appareils qui ne prennent pas en charge la sécurité S2 mais nécessitent un chiffrement pour fonctionner, comme les serrures de porte.
La sécurité S2 n'impose pas de trafic réseau supplémentaire et offre des avantages supplémentaires. Par exemple, les appareils terminaux utilisant S2 nécessitent que le hub signale s'il a reçu et compris leurs rapports.
Par défaut, Z-Wave préfère la sécurité S2, si elle est prise en charge. La sécurité S0 n'est utilisée que lorsque cela est absolument nécessaire.

Where Can I See the Security Keys in the Z-Wave JS App?
Après la configuration initiale de l'adaptateur Z-Wave, vous pouvez consulter les clés de sécurité dans l'application Z-Wave JS. Allez dans Paramètres > Apps > Z-Wave JS et ouvrez l'onglet Configuration. Vous pouvez maintenant voir les trois clés S2 et la clé S0. La clé de sécurité réseau est un paramètre de configuration hérité, identique à la clé S0.

My Z-Wave Adapter Isn't Recognized Automatically During Setup
Si votre adaptateur Z-Wave ne s'affiche pas automatiquement dans la section Découvert, essayez de l'ajouter manuellement :

Vérifiez le matériel :

Assurez-vous que l'adaptateur est sous tension.
Assurez-vous que le câble que vous utilisez prend en charge les données, et non uniquement l'alimentation.

Allez dans Paramètres > Appareils et services.
Dans le coin inférieur droit, sélectionnez le bouton Ajouter une intégration et sélectionnez Z-Wave.
Suivez les instructions à l'écran pour terminer la configuration.
Si l'adaptateur n'est toujours pas détecté, vérifiez les interférences.

I Have an Aeotec Gen5 Adapter. And It Isn't...

My Device Doesn't Automatically Update Its Status in HA If I Control It Manually
Votre appareil ne peut pas envoyer de mises à jour de statut automatiques à l'adaptateur. Bien que le meilleur conseil serait de passer à des appareils Z-Wave Plus récents, il existe une solution de contournement avec le polling actif (demander le statut).
Z-Wave ne sonde pas automatiquement les appareils à intervalles réguliers. Le polling peut rapidement entraîner une congestion du réseau et doit être utilisé avec parcimonie et uniquement lorsque cela est nécessaire.

Nous fournissons une action zwave_js.refresh_value pour sonder manuellement une valeur, par exemple à partir d'une automatisation qui ne sonde un appareil que lorsqu'il y a un mouvement dans la même pièce.
Z-Wave JS vous permet de configurer un polling planifié sur une base par valeur, que vous pouvez utiliser pour maintenir certaines valeurs à jour. Il vous permet également de sonder des valeurs individuelles à la demande depuis vos automatisations, ce qui doit être privilégié plutôt que de sonder aveuglément tout le temps si possible.

My Device Is Recognized as Unknown Manufacturer and/or Some Functions Don't Work with the Z-Wave Integration
Lorsque votre appareil n'a pas encore été complètement interrogé, ces informations ne seront pas encore présentes. Assurez-vous donc que votre appareil a été interrogé au moins une fois.
Si l'interview est complète, alors l'appareil n'a pas encore de fichier de configuration pour Z-Wave JS. Contrairement à d'autres pilotes Z-Wave, votre appareil peut très bien fonctionner comme prévu même sans un tel fichier. Si votre appareil n'est pas entièrement pris en charge, envisagez de contribuer au fichier de configuration de l'appareil.

How Do I Get a Dump of the Current Network State?
Lorsque vous essayez de déterminer pourquoi quelque chose ne fonctionne pas comme prévu, ou lorsque vous signalez un problème avec l'intégration, il est utile de connaître l'état actuel de votre réseau Z-Wave tel que vu par Z-Wave JS. Pour obtenir un dump de l'état actuel de votre réseau, suivez ces étapes :

Allez dans Paramètres > Appareils et services.
Sélectionnez l'intégration Z-Wave. Puis, sélectionnez le menu à trois points.
Dans le menu déroulant, sélectionnez Télécharger les diagnostics.

How Do I Address Interference Issues?

Allez dans le panneau d'intégration Z-Wave : AFFICHER L'INTÉGRATION SUR MON
Dans le coin supérieur droit, sélectionnez le menu à trois points et sélectionnez Activer la journalisation de débogage.

Résultat : Le niveau de journalisation sera défini sur débogage pour l'intégration, la bibliothèque et éventuellement le pilote (si le niveau de journalisation du pilote n'est pas déjà défini sur verbeux, débogage ou détaillé), et tous les journaux Z-Wave JS seront ajoutés aux journaux Home Assistant.

Si vous souhaitez modifier le niveau de journalisation, dans le panneau d'intégration Z-Wave : AFFICHER L'INTÉGRATION SUR MON, sélectionnez l'icône d'engrenage.

Sélectionnez l'onglet Journaux, puis sélectionnez le niveau de journalisation.


Désactiver la journalisation Z-Wave JS

Allez dans le panneau d'intégration Z-Wave : AFFICHER L'INTÉGRATION SUR MON
Dans le coin supérieur droit, sélectionnez le menu à trois points et sélectionnez Désactiver la journalisation de débogage.

Résultat : Le niveau de journalisation sera réinitialisé à sa valeur précédente pour l'intégration, la bibliothèque et le pilote, et le frontend Home Assistant vous enverra automatiquement les journaux Z-Wave générés pendant cette période pour téléchargement.


La méthode avancée
Activez manuellement la journalisation Z-Wave JS, ou via une automatisation.
Définissez le niveau de journalisation pour (zwave_js_server) à un niveau supérieur à (debug). Cela peut être fait soit dans votre fichier (configuration.yaml) dans la section (logger), soit en utilisant l'action (logger.set_level). Les journaux Z-Wave JS ne seront plus inclus dans les journaux Home Assistant, et si le niveau de journalisation de Z-Wave JS a été modifié par l'intégration, il reviendra automatiquement à son niveau d'origine.

Unsupported Functionality
Cette section répertorie les fonctionnalités disponibles dans Z-Wave mais qui ne sont pas actuellement prises en charge dans Home Assistant.

Setting the Adapter into Learn Mode to Receive Network Information
Dans Home Assistant, il n'est actuellement pas possible de mettre le contrôleur Z-Wave en mode apprentissage pour recevoir des informations réseau d'un autre contrôleur.

Including/Excluding a Adapter in an Existing Network Using Classic Inclusion
Un contrôleur Z-Wave qui gère un réseau vide peut également rejoindre un réseau différent et agir en tant que contrôleur secondaire. Cependant, avec Home Assistant, cela n'est pas possible. Home Assistant n'autorise pas le contrôleur Z-Wave à rejoindre un autre réseau, car Home Assistant agit en tant que hub central.

Identification via Z-Wave
D'autres appareils Z-Wave peuvent demander à une instance Home Assistant de s'identifier en envoyant la commande Z-Wave [Indicator Set] suivante (tous les octets sont en hexadécimal) :
text
Copier

87010003500308500403500506



Les octets soulignés avec ~ peuvent également avoir n'importe quelle autre valeur.
Lors de la réception d'une telle commande, Home Assistant affichera une notification dans sa barre latérale, mentionnant quel nœud a envoyé la commande.

Z-Wave Command Classes Home Assistant Responds to When Queried
Le tableau suivant répertorie les classes de commande avec la version implémentée et la classe de sécurité requise. Ce sont les classes de commande auxquelles Home Assistant répondra lorsqu'elles seront interrogées par d'autres appareils.


  
    
      Classe de commande
      Version
      Classe de sécurité
    
  
  
    
      Association
      4
      La plus élevée accordée
    
    
      Association Group Information
      3
      La plus élevée accordée
    
  



Note

Home Assistant et Z-Wave JS ne retourneront jamais un statut "Working" ou "Fail" pour une commande valide et prise en charge de la Supervision Command Class.

Z-Wave Terminology
Cette section explique certains termes et concepts Z-Wave que vous pourriez trouver dans la documentation des produits Z-Wave.

Classic Inclusion Versus SmartStart
Home Assistant prend en charge à la fois l'inclusion classique et SmartStart. L'inclusion classique signifie que vous mettez à la fois le hub et l'appareil en mode d'inclusion correspondant. L'alternative est SmartStart, où le hub écoute en permanence les demandes d'inclusion des appareils qui souhaitent rejoindre le réseau.

SmartStart
Les produits compatibles SmartStart peuvent être ajoutés à un réseau Z-Wave en scannant le code QR Z-Wave présent sur le produit avec un adaptateur prenant en charge l'inclusion SmartStart. Aucune autre action n'est requise et le produit SmartStart sera ajouté automatiquement dans les 10 minutes suivant sa mise sous tension à proximité du réseau. Tous les appareils ne prennent pas en charge SmartStart. Certains appareils nécessitent une inclusion classique. Pour la documentation sur l'ajout d'un appareil à Home Assistant, consultez la section sur l'ajout d'un nouvel appareil au réseau Z-Wave.

Terminology Mapping Table
Tout au long de cette documentation, la terminologie de Home Assistant est utilisée. Pour certains concepts, la terminologie ne correspond pas à celle utilisée dans la documentation Z-Wave. Le tableau ci-dessous fournit des équivalents pour certains de ces termes.


  
    
      Home Assistant
      Z-Wave
      Description
    
  
  
    
      exclusion
      remove
      Le processus de suppression d'un nœud du réseau Z-Wave
    
    
      inclusion
      add
      Le processus d'ajout d'un nœud au réseau Z-Wave
    
    
      multilevel switch
      représenté par différents types d'entités : lumière, ventilateur, etc.
      Le processus de copie
    
  



Removing Z-Wave JS from Home Assistant
Cela supprime tous les appareils Z-Wave appairés et leurs entités, l'application Z-Wave JS et l'intégration Z-Wave de Home Assistant.
To Remove Z-Wave JS from Home Assistant

Supprimez l'appareil de votre réseau Z-Wave.
Supprimez l'intégration Z-Wave.

Allez dans Paramètres > Appareils et services et sélectionnez la carte d'intégration.
À côté de l'entrée d'intégration, sélectionnez le menu à trois points.
Sélectionnez Supprimer.

Si elle n'a pas été supprimée automatiquement, supprimez l'application Z-Wave JS.

Allez dans Paramètres > Apps > Z-Wave JS.
Sélectionnez Désinstaller.
Décidez si vous souhaitez également supprimer les données liées à l'application ou si vous souhaitez les conserver.

Terminé. Z-Wave JS est maintenant complètement supprimé de votre serveur Home Assistant.

Vous pouvez maintenant utiliser vos appareils et adaptateur Z-Wave sur un nouveau serveur.


Related Topics

Autres adaptateurs Z-Wave

Help Us Improve Our Documentation
Proposez une modification à cette page, ou fournissez/affichez des commentaires pour cette page.

Integration Owners
Cette intégration est maintenue par le projet Home Assistant.

Categories

Capteur binaire
Bouton
Climatisation
Couverture
Événement
Ventilateur
Hub
Humidificateur
Lumière

Join Us and Contribute!

Dépôt GitHub
Portail des développeurs
Portail de design
Portail de science des données
Forum communautaire
Réseau des créateurs
Works With Home Assistant
Notre communauté
Signalement des problèmes

System Status

Alertes d'intégration
Alertes de sécurité
État du système

Companion Apps

iOS et appareils Apple
Android et Wear OS
...et plus encore !

Support Us

Boutique de goodies
Home Assistant Cloud

Governance

Avis de confidentialité
Accord de licence des contributeurs

undefined