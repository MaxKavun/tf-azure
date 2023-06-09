resource "azurerm_kubernetes_cluster" "this" {
  name                = "main"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "k8s"

  network_profile {
    network_plugin     = "azure"
    network_mode       = "transparent"
    network_policy     = "azure"
    service_cidr       = "10.1.0.0/24"   # ip range for kubernetes services
    dns_service_ip     = "10.1.0.10"     # ip address of dns service within service cidr
    docker_bridge_cidr = "172.17.0.1/16" # needs to be added to support docker build scenarious within AKS cluster 
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
