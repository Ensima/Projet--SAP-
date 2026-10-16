# Azure : la partie cloud de la maquette

Ce dossier explique à toute l'équipe, **à grands traits**, ce qu'on fait sur Azure et dans quel ordre. Le pas-à-pas technique complet (commandes, paramètres IPsec, dépannage) est tenu par Ernest, qui porte la brique Pare-feu et Azure.

## Pourquoi Azure dans la maquette

Notre solution est **hybride** : les données de santé partent chez un hébergeur cloud certifié HDS, et les sites gardent un réseau local. Azure (certifié HDS en France) joue cet hébergeur. La démo doit prouver deux choses :
1. un poste de la maquette atteint un serveur Azure **en adresse privée**, à travers un **tunnel chiffré** ;
2. les comptes créés dans notre **Active Directory** apparaissent dans le cloud (**Entra ID**), avec le **MFA**.

## Ce qu'on crée sur Azure

| Élément | Rôle dans la démo | Adresse |
|---|---|---|
| Groupe de ressources `RG-SAP-MAQUETTE` | La « boîte » qui contient tout, pour tout supprimer d'un coup | région France Central |
| Réseau virtuel `VNET-SAP` | Le réseau de l'hébergeur | 10.100.0.0/16 |
| VM `VM-AZ01` (petite Linux) | Le serveur « hébergé HDS » | 10.100.1.4 |
| Passerelle VPN `VPNGW-SAP` | L'entrée du tunnel côté Azure | sous-réseau 10.100.255.0/27 |
| Passerelle de réseau local `LNG-LILLE` | Décrit notre site : IP publique de la box + réseaux 10.1.0.0/16 et 10.2.0.0/16 | |
| Connexion `CNX-LILLE-AZURE` | Le tunnel IPsec entre pfSense-LILLE et Azure | |
| Entra ID (notre tenant) | Les comptes cloud, synchronisés depuis SRV-AD01 | |

## Les étapes, dans l'ordre

1. **Le compte** : Azure for Students (environ 100 $ de crédit, sans carte bancaire), avec l'adresse de l'école. On vérifie tout de suite qu'on peut être **administrateur d'un tenant Entra ID** : l'annuaire de l'école ne le permet pas, il faudra sans doute un tenant à nous.
2. **Le réseau** : le groupe de ressources, le VNet et ses deux sous-réseaux (serveurs, et `GatewaySubnet` pour la passerelle).
3. **La VM de test** : une petite Linux sans IP publique, joignable seulement par le tunnel.
4. **La passerelle VPN** : sa création prend **environ 45 minutes**, et elle est **payée à l'heure** tant qu'elle existe.
5. **Le tunnel** : on déclare notre site dans Azure, puis on configure le tunnel IPsec sur **pfSense-LILLE** avec la même clé et des algorithmes compatibles.
6. **Les comptes** : un agent de synchronisation sur SRV-AD01 envoie les utilisateurs de l'AD vers Entra ID ; on active le MFA.
7. **Les tests** : ping de PC-LILLE vers 10.100.1.4, tunnel « Connected » des deux côtés, utilisateur synchronisé, connexion avec MFA. On fait des captures pour la soutenance.
8. **Le ménage** : après chaque séance, on supprime la passerelle VPN et son IP publique, et on arrête la VM depuis le portail. À la fin du projet, on supprime tout le groupe de ressources.

## Qui fait quoi

| Qui | Sur Azure |
|---|---|
| **Ernest** (Pare-feu et Azure) | Crée le compte et le tenant, le réseau, la passerelle et le tunnel ; configure pfSense ; suit le coût |
| **Rôle 3** (Serveurs Windows) | Installe l'agent de synchronisation sur SRV-AD01, crée les utilisateurs de test |
| **Rôle 1** (Réseau GNS3) | S'assure que la maquette sort bien sur Internet (R-FAI, nœud NAT) |
| **Rôle 4** (Services) | Facultatif : sauvegarde de test vers Azure, supervision de la VM Azure dans Zabbix |
| **Tout le monde** | Ne lance rien sur Azure sans prévenir Ernest (le crédit est commun) |

## Les règles pour ne pas brûler le crédit

- **Tout dans `RG-SAP-MAQUETTE`**, rien ailleurs.
- **La passerelle VPN coûte même quand personne ne s'en sert** : on la crée le matin de la séance (45 min) et on la supprime le soir.
- **Une VM arrêtée depuis Linux reste payée** : il faut l'arrêter depuis le portail (statut « libérée »).
- **Aucun mot de passe ni clé de tunnel dans GitHub.**
- **Aucune vraie donnée** : uniquement des comptes et fichiers fictifs.

## Si le tunnel ne monte pas

Le tunnel traverse plusieurs NAT (GNS3, puis la box). Si l'IPsec bloque après une demi-journée, le **plan B** est un tunnel **WireGuard** vers une petite VM Azure, qui passe beaucoup mieux les NAT. Dernier recours : faire la démo depuis le réseau de l'école.

Voir aussi : [la topologie de la maquette](../proposition_logiciel_maquette/TOPOLOGIE.md) et [les rôles du projet](../gestion_projet/ROLES_PROJET.md).
