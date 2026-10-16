variable "subscription_id" {
  description = "ID de l'abonnement Azure (az account show --query id -o tsv)."
  type        = string
}

variable "location" {
  description = "Région Azure."
  type        = string
  default     = "francecentral"
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources."
  type        = string
  default     = "RG-SAP-MAQUETTE"
}

variable "vnet_address_space" {
  description = "Plage du réseau virtuel Azure."
  type        = string
  default     = "10.100.0.0/16"
}

variable "servers_subnet_prefix" {
  description = "Sous-réseau des VM (SNET-SERVEURS)."
  type        = string
  default     = "10.100.1.0/24"
}

variable "gateway_subnet_prefix" {
  description = "Sous-réseau réservé à la passerelle VPN (GatewaySubnet)."
  type        = string
  default     = "10.100.255.0/27"
}

variable "create_vpn" {
  description = "true = crée la passerelle VPN, son IP publique et la connexion (payant à l'heure). false = les supprime en gardant le reste."
  type        = bool
  default     = true
}

variable "vpn_gateway_sku" {
  description = "SKU de la passerelle VPN : Basic (la moins chère) ou VpnGw1AZ si Basic est refusée."
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "VpnGw1", "VpnGw1AZ"], var.vpn_gateway_sku)
    error_message = "Valeurs possibles : Basic, VpnGw1, VpnGw1AZ."
  }
}

variable "pfsense_public_ip" {
  description = "IP publique de la box derrière laquelle tourne pfSense-LILLE (voir « quel est mon IP »)."
  type        = string
}

variable "onprem_address_prefixes" {
  description = "Réseaux de la maquette joignables par le tunnel (Lille et Paris)."
  type        = list(string)
  default     = ["10.1.0.0/16", "10.2.0.0/16"]
}

variable "vpn_shared_key" {
  description = "Clé partagée IPsec, la même que dans pfSense. Ne jamais la mettre sur GitHub."
  type        = string
  sensitive   = true
}

variable "create_vm" {
  description = "true = crée la VM de test VM-AZ01."
  type        = bool
  default     = true
}

variable "vm_size" {
  description = "Taille de la VM de test."
  type        = string
  default     = "Standard_B1s"
}

variable "vm_private_ip" {
  description = "IP privée fixe de la VM de test."
  type        = string
  default     = "10.100.1.4"
}

variable "vm_admin_username" {
  description = "Compte administrateur de la VM."
  type        = string
  default     = "azureuser"
}

variable "vm_ssh_public_key_path" {
  description = "Chemin de la clé SSH publique pour la VM (ssh-keygen la crée)."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
