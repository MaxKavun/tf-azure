output "subnet_id" {
  value = azurerm_subnet.clusternodes.id
}

output "virtual_network_id" {
  value = azurerm_virtual_network.this.id
}

output "app_lb_subnet_id" {
  value = azurerm_subnet.applicationgateway.id
}
