resource "azurerm_kubernetes_cluster" "this" {
  name                = "main"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "k8s"

  network_profile {
    network_plugin = "azure"
    network_mode   = "transparent"
    network_policy = "azure"
  }

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Test"
  }
}
