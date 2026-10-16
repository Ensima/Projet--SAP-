# Proposition : logiciels pour la maquette

Ce dossier présente aux membres du groupe les logiciels possibles pour la maquette du projet SAP, avec leurs avantages et inconvénients, et la façon de tester la partie cloud sur Azure. Le but est de **choisir ensemble** une combinaison avant de commencer la partie 2 (déployer).

> Prix et conditions des offres indicatifs : à vérifier sur les sites officiels avant de décider.

## En bref

- La maquette doit montrer deux choses : **le réseau** (VLAN, routage, VPN entre les 5 sites) et **les serveurs** (AD, DNS, DHCP, supervision), plus si possible **le lien hybride avec le cloud**.
- **Aucun outil ne fait tout bien.** Packet Tracer est simple mais ne fait ni vrais serveurs ni cloud. GNS3 et EVE-NG font tout, mais sont lourds.
- **Proposition par défaut :** Packet Tracer pour la topologie des 5 sites, des VM (VirtualBox ou VMware) pour les serveurs, et un pfSense/OPNsense en VM relié à Azure for Students pour démontrer l'hybride. À valider par le groupe : voir la section 3.

**Répartition des rôles (qui fait quoi, difficulté, quoi installer, planning) :** voir [`gestion_projet/ROLES_PROJET.md`](../gestion_projet/ROLES_PROJET.md).

**Topologie détaillée de la maquette (GNS3 + VM + Azure), plan d'adressage et pas-à-pas :** voir [`TOPOLOGIE.md`](TOPOLOGIE.md).

## Ce qu'on doit décider ensemble

1. Quel outil réseau (Packet Tracer, GNS3 ou EVE-NG) ?
2. Quel hyperviseur pour les serveurs, selon les PC de chacun (RAM, Windows Famille ou Pro) ?
3. Est-ce qu'on fait la démo Azure, et qui crée le compte Azure for Students ?

## 1. Outils de maquette réseau

### Cisco Packet Tracer
- **Avantages** : gratuit (compte Cisco Networking Academy), très léger, tourne sur n'importe quel PC. Connu des jurys CESI. Mode simulation pour montrer le trajet des paquets. Couvre VLAN, trunk, STP, inter-VLAN, OSPF/EIGRP, HSRP, ACL, NAT, DHCP, VPN IPsec site à site (routeurs ISR), ASA 5506, Wi-Fi avec WLC.
- **Inconvénients** : c'est un simulateur, pas un émulateur : les commandes sont incomplètes et certaines fonctions « existent » sans vraiment marcher comme en vrai. Matériel Cisco uniquement. Serveurs très simplifiés (pas d'AD, pas de GPO, pas de Linux). Aucune connexion possible vers Internet ou Azure.

### GNS3
- **Avantages** : gratuit et open source. Fait tourner de vrais systèmes (routeurs, pare-feu, VM Linux/Windows) dans une même topologie. Le nœud « Cloud » le relie à la carte réseau du PC, donc à Internet et à Azure. Multi-constructeur : VyOS, MikroTik CHR, pfSense/OPNsense, Fortinet en VM d'évaluation, Arista vEOS.
- **Inconvénients** : installation plus technique (GNS3 VM + client, virtualisation imbriquée à activer). Gourmand en RAM : il faut 16 Go minimum, 32 Go c'est mieux. Les images Cisco (IOSv, IOU) ne sont pas fournies et demandent une licence (Cisco Modeling Labs). Moins stable, et le projet est difficile à partager dans le groupe (images à redistribuer).

### EVE-NG
- **Avantages** : même principe que GNS3 mais tout dans le navigateur. Bon pour travailler à plusieurs sur un même serveur. Très utilisé en entreprise et pour les certifications. Supporte de nombreuses images.
- **Inconvénients** : la version Community est gratuite mais limitée. La version Pro (multi-utilisateurs, fonctions avancées) est payante. Il lui faut un serveur ou une grosse VM dédiée. Les images constructeur posent les mêmes questions de licence que GNS3.

### Cisco Modeling Labs (CML)
- **Avantages** : l'outil officiel Cisco, avec de vraies images IOS-XE, IOS-XR, NX-OS et ASAv incluses et légales. Une version gratuite existe, limitée à quelques nœuds.
- **Inconvénients** : la version gratuite est trop petite pour 5 sites. La version personnelle est payante (abonnement annuel). Gourmand en ressources. Cisco uniquement.

### Containerlab
- **Avantages** : gratuit, topologies décrites dans un fichier texte, très léger (conteneurs).
- **Inconvénients** : Linux et Docker obligatoires, en ligne de commande. Peu d'images Cisco/Fortinet en conteneur. Courbe d'apprentissage. Peu connu des jurys.

## 2. Outils pour les serveurs (AD, DNS, DHCP, supervision…)

### Oracle VirtualBox
- **Avantages** : gratuit, simple, sur Windows/macOS/Linux, réseaux internes faciles à créer.
- **Inconvénients** : performances moyennes avec beaucoup de VM. Cohabitation parfois difficile avec Hyper-V/WSL sous Windows.

### VMware Workstation Pro
- **Avantages** : gratuit depuis 2024, plus performant et plus stable que VirtualBox, bon éditeur de réseaux virtuels.
- **Inconvénients** : compte Broadcom obligatoire pour le télécharger (procédure pénible). Windows et Linux uniquement (Fusion sur Mac).

### Microsoft Hyper-V
- **Avantages** : inclus dans Windows Pro/Éducation, cohérent avec un environnement Windows Server.
- **Inconvénients** : pas disponible sur Windows Famille. Gestion réseau moins intuitive. Peut gêner VirtualBox/VMware.

### Proxmox VE
- **Avantages** : gratuit, c'est un vrai hyperviseur de production (cohérent avec le cluster proposé à Lille). Interface web, clusters, snapshots, sauvegarde.
- **Inconvénients** : demande une machine dédiée (vieux PC, serveur de l'école) ou une installation imbriquée. Un peu plus long à prendre en main.

## 3. Combinaisons possibles

| Combinaison | Réalisme | Difficulté | Matériel nécessaire |
|---|---|---|---|
| Packet Tracer seul | Faible côté serveurs | Faible | N'importe quel PC |
| Packet Tracer (réseau) + VirtualBox/VMware (serveurs), deux maquettes séparées | Moyen | Faible à moyenne | PC 16 Go |
| GNS3 ou EVE-NG avec les VM serveurs dedans, une seule maquette | Élevé | Élevée | PC 32 Go ou serveur |
| Proxmox avec routeurs/pare-feu virtuels (pfSense, OPNsense, VyOS) + VM | Élevé, proche de la cible | Moyenne à élevée | Machine dédiée |
| L'une des solutions ci-dessus + Azure pour la partie cloud | Le seul cas où l'hybride est démontré | + | Compte Azure |

Point clé : **Packet Tracer ne peut pas parler à Azure.** Pour montrer un vrai lien hybride, il faut au moins un routeur ou pare-feu virtuel réel (pfSense/OPNsense dans VirtualBox, GNS3 ou Proxmox).

## 4. Tester Azure concrètement

### Quel compte
- **Azure for Students** : environ 100 $ de crédit, sans carte bancaire, avec l'adresse mail de l'école. Renouvelable chaque année tant que tu es étudiant. C'est le choix logique.
- **Compte gratuit Azure** : crédit plus élevé mais valable seulement 30 jours, et carte bancaire demandée. Plus des services gratuits pendant 12 mois (dont une petite VM B1s).
- Région conseillée : **France Central** (Azure est certifié HDS en France, ce qui sert ton argumentaire).

### Quoi déployer pour simuler l'hybride (du moins cher au plus cher)
1. **Entra ID** (gratuit, fourni avec l'abonnement) : créer des utilisateurs et des groupes, activer le MFA.
2. **Synchroniser l'AD de la maquette** : un Windows Server en VM chez toi (AD DS), puis Entra Connect ou Entra Cloud Sync vers ton tenant. Ça passe par Internet, pas besoin de VPN. C'est la démo hybride la plus parlante et elle ne coûte rien.
3. **Un réseau virtuel (VNet) + une VM B1s** (Linux), qui joue un serveur « hébergé HDS ».
4. **Le lien site à site** entre ta maquette et Azure, deux façons :
   - **Azure VPN Gateway** : la vraie solution Microsoft, mais facturée à l'heure même quand elle ne sert pas. Le plus petit modèle reste cher sur 100 $ de crédit, et sa création prend 30 à 45 minutes. À créer seulement pour la démo, puis à supprimer.
   - **Moins cher : un pfSense/OPNsense ou un Linux strongSwan/WireGuard dans une petite VM Azure**, relié au pfSense de ta maquette. Même démonstration de tunnel IPsec, pour quelques euros.
5. Options si le crédit le permet : **Azure Backup** (sauvegarder une VM, à montrer pour le PRA), **Azure Monitor / Log Analytics** (supervision), **Azure Arc** (gérer tes VM locales depuis le portail Azure).
6. **Microsoft 365** : un essai de 30 jours (Business Premium, carte demandée) pour montrer Intune et Teams. Le programme développeur Microsoft 365 n'est plus ouvert à tout le monde.

### Pièges à éviter
- **Le coût qui tourne** : une VM « arrêtée » depuis l'OS est encore facturée. Il faut cliquer « Arrêter » dans le portail (statut « libérée »). La passerelle VPN et les IP publiques se paient même à l'arrêt : supprime-les après la démo.
- **Mettre un budget avec alerte** dans *Cost Management* dès le premier jour (par exemple une alerte à 20 $).
- **Tout mettre dans un seul groupe de ressources**, pour pouvoir tout supprimer d'un clic.
- **Le tunnel depuis chez toi** : il faut que ta box laisse passer l'IPsec (UDP 500 et 4500) vers ton pfSense. Si ton opérateur te met derrière du CGNAT (IP partagée), le VPN site à site ne montera pas. Dans ce cas, utilise WireGuard initié depuis chez toi, ou le réseau de l'école.
- **Ne jamais mettre de vraies données** : uniquement des comptes et des fichiers fictifs.
- **Les crédits étudiants ne couvrent pas tout** : certains services ou modèles de VM sont bloqués sur Azure for Students.

### Démo type pour la soutenance (≈ 10 min)
1. Montrer la topologie (Packet Tracer ou GNS3) et le schéma draw.io.
2. Un utilisateur créé dans l'AD local apparaît dans Entra ID (synchronisation).
3. Le tunnel IPsec est « up » des deux côtés ; ping de la VM Azure depuis un poste de la maquette.
4. Connexion avec MFA, puis accès à une ressource cloud.
5. Montrer le budget Azure consommé : argument « coût maîtrisé ».
