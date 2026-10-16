# Mêmes ressources que dans azure/README.md, mais décrites en Terraform.

resource "azurerm_resource_group" "sap" {
  name     = var.resource_group_name
  location = var.location
}

# ---------- Réseau ----------

resource "azurerm_virtual_network" "sap" {
  name                = "VNET-SAP"
  resource_group_name = azurerm_resource_group.sap.name
  location            = azurerm_resource_group.sap.location
  address_space       = [var.vnet_address_space]
}

resource "azurerm_subnet" "serveurs" {
  name                 = "SNET-SERVEURS"
  resource_group_name  = azurerm_resource_group.sap.name
  virtual_network_name = azurerm_virtual_network.sap.name
  address_prefixes     = [var.servers_subnet_prefix]
}

# Le nom "GatewaySubnet" est imposé par Azure. Aucune VM dedans.
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.sap.name
  virtual_network_name = azurerm_virtual_network.sap.name
  address_prefixes     = [var.gateway_subnet_prefix]
}

# ---------- VPN site à site vers pfSense-LILLE ----------

resource "azurerm_public_ip" "vpngw" {
  count               = var.create_vpn ? 1 : 0
  name                = "PIP-VPNGW"
  resource_group_name = azurerm_resource_group.sap.name
  location            = azurerm_resource_group.sap.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

# Création longue : souvent 45 min ou plus.
resource "azurerm_virtual_network_gateway" "sap" {
  count               = var.create_vpn ? 1 : 0
  name                = "VPNGW-SAP"
  resource_group_name = azurerm_resource_group.sap.name
  location            = azurerm_resource_group.sap.location
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = var.vpn_gateway_sku
  active_active       = false
  enable_bgp          = false

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpngw[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }
}

# "Le site d'en face" : la box d'Ernest et les réseaux de la maquette.
resource "azurerm_local_network_gateway" "lille" {
  name                = "LNG-LILLE"
  resource_group_name = azurerm_resource_group.sap.name
  location            = azurerm_resource_group.sap.location
  gateway_address     = var.pfsense_public_ip
  address_space       = var.onprem_address_prefixes
}

# Politique IPsec par défaut d'Azure (la SKU Basic n'accepte pas de politique perso).
resource "azurerm_virtual_network_gateway_connection" "lille" {
  count                      = var.create_vpn ? 1 : 0
  name                       = "CNX-LILLE-AZURE"
  resource_group_name        = azurerm_resource_group.sap.name
  location                   = azurerm_resource_group.sap.location
  type                       = "IPsec"
  connection_protocol        = "IKEv2"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.sap[0].id
  local_network_gateway_id   = azurerm_local_network_gateway.lille.id
  shared_key                 = var.vpn_shared_key
}

# ---------- VM de test, sans IP publique ----------

resource "azurerm_network_interface" "vm" {
  count               = var.create_vm ? 1 : 0
  name                = "NIC-VM-AZ01"
  resource_group_name = azurerm_resource_group.sap.name
  location            = azurerm_resource_group.sap.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.serveurs.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_private_ip
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  count                 = var.create_vm ? 1 : 0
  name                  = "VM-AZ01"
  resource_group_name   = azurerm_resource_group.sap.name
  location              = azurerm_resource_group.sap.location
  size                  = var.vm_size
  admin_username        = var.vm_admin_username
  network_interface_ids = [azurerm_network_interface.vm[0].id]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file(pathexpand(var.vm_ssh_public_key_path))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
