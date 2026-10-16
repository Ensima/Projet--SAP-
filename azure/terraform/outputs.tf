output "vpn_gateway_public_ip" {
  description = "IP publique Azure à mettre dans pfSense (Remote Gateway de la phase 1)."
  value       = var.create_vpn ? azurerm_public_ip.vpngw[0].ip_address : null
}

output "vm_private_ip" {
  description = "IP de la VM de test, à pinger depuis PC-LILLE."
  value       = var.create_vm ? var.vm_private_ip : null
}

output "check_vpn_command" {
  description = "Commande pour voir si le tunnel est monté."
  value       = "az network vpn-connection show -g ${azurerm_resource_group.sap.name} -n CNX-LILLE-AZURE --query connectionStatus -o tsv"
}
