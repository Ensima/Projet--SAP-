# Partie Azure en Terraform

Ce dossier crée **les mêmes ressources** que `azure/README.md`, mais en une seule commande au lieu de taper les `az ...` une par une.

| Ressource | Nom | Valeur |
|---|---|---|
| Groupe de ressources | `RG-SAP-MAQUETTE` | France Central |
| Réseau virtuel | `VNET-SAP` | 10.100.0.0/16 |
| Sous-réseau des VM | `SNET-SERVEURS` | 10.100.1.0/24 |
| Sous-réseau passerelle | `GatewaySubnet` | 10.100.255.0/27 |
| IP publique | `PIP-VPNGW` | Standard, statique |
| Passerelle VPN | `VPNGW-SAP` | RouteBased, SKU Basic |
| Passerelle de réseau local | `LNG-LILLE` | IP de la box ; 10.1.0.0/16, 10.2.0.0/16 |
| Connexion | `CNX-LILLE-AZURE` | IPsec IKEv2, clé partagée |
| VM de test | `VM-AZ01` | Ubuntu 24.04, Standard_B1s, 10.100.1.4, sans IP publique |

Le pfSense de Lille se configure toujours à la main (voir `azure/README.md`).

## Fichiers

- `versions.tf` : version de Terraform et du fournisseur Azure.
- `variables.tf` : tous les réglages (noms, plages IP, SKU...).
- `main.tf` : les ressources.
- `outputs.tf` : ce qui s'affiche à la fin (IP publique Azure à mettre dans pfSense).
- `terraform.tfvars.example` : modèle des valeurs secrètes à remplir.

## Lancer

Le plus simple est le **Cloud Shell** du portail Azure (icône `>_`, choisir *Bash*) : Terraform et Azure CLI y sont déjà installés et connectés.

```bash
git clone https://github.com/Ensima/Projet--SAP-.git
cd Projet--SAP-
git checkout claude/partie-azure
cd azure/terraform

# 1. Une clé SSH pour la VM (si tu n'en as pas déjà une)
ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa

# 2. Les valeurs secrètes
cp terraform.tfvars.example terraform.tfvars
az account show --query id -o tsv   # => subscription_id
nano terraform.tfvars                # remplir subscription_id, pfsense_public_ip, vpn_shared_key

# 3. Créer
terraform init
terraform plan      # montre ce qui va être créé, sans rien créer
terraform apply     # tape "yes" ; la passerelle VPN prend souvent 45 min ou plus
```

À la fin, Terraform affiche `vpn_gateway_public_ip` : c'est le *Remote Gateway* à mettre dans la phase 1 de pfSense.

Vérifier le tunnel :
```bash
az network vpn-connection show -g RG-SAP-MAQUETTE -n CNX-LILLE-AZURE --query connectionStatus -o tsv
```

**Important :** le fichier `terraform.tfstate` créé dans le dossier contient la clé partagée en clair. Il est ignoré par Git (`.gitignore`), ne le pousse jamais. Garde aussi le dossier tel quel dans ton Cloud Shell : sans ce fichier, Terraform ne sait plus ce qu'il a créé.

## Économiser le crédit

La passerelle VPN est facturée **à l'heure tant qu'elle existe**, même sans trafic.

Fin de séance, on garde le réseau mais on supprime la passerelle, son IP et la connexion :
```bash
terraform apply -var="create_vpn=false"
az vm deallocate -g RG-SAP-MAQUETTE -n VM-AZ01   # la VM ne coûte plus rien une fois libérée
```

Le jour de la démo, on recrée tout (lance-le **le matin**, 45 min) :
```bash
terraform apply
az vm start -g RG-SAP-MAQUETTE -n VM-AZ01
```

Fin du projet, on supprime tout :
```bash
terraform destroy
```

## Si ça bloque

- **SKU Basic refusée** : mets `vpn_gateway_sku = "VpnGw1AZ"` dans `terraform.tfvars` (plus chère). Cette SKU accepte aussi une politique IPsec personnalisée.
- **Taille de VM refusée** : `az vm list-skus -l francecentral --size Standard_B -o table`, puis `vm_size = "..."` dans `terraform.tfvars`.
- **L'IP de ta box a changé** : modifie `pfsense_public_ip` puis `terraform apply`.
- **Erreur d'enregistrement de fournisseur (MissingSubscriptionRegistration)** : `az provider register -n Microsoft.Network` et `az provider register -n Microsoft.Compute`, puis relance.
