resource "azurerm_kubernetes_cluster" "this" {
  name                = "main"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "k8s"
  kubernetes_version  = "1.25.6"

  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  local_account_disabled    = true # Azure AD is used for authentication and authorization

  azure_active_directory_role_based_access_control {
    managed            = true # Azure AD for authentication
    azure_rbac_enabled = true # Use azure AD for authorization as well
  }

  network_profile {
    network_plugin = "azure"
    network_mode   = "transparent"
    network_policy = "azure"
    service_cidr   = "10.1.0.0/24" # ip range for kubernetes services
    dns_service_ip = "10.1.0.10"   # ip address of dns service within service cidr
  }

  default_node_pool {
    name                         = "default"
    node_count                   = 1
    vm_size                      = "Standard_DS2_v2"
    vnet_subnet_id               = var.subnet_id
    only_critical_addons_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  ingress_application_gateway {
    gateway_id = var.app_lb_id
  }

  service_mesh_profile {
    mode = "Istio"
  }

  tags = {
    Environment = "Test"
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "free_spot" {
  name                  = "freeb1s"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = "Standard_D2_v2"
  mode                  = "User"
  os_sku                = "Ubuntu"
  priority              = "Spot"
  spot_max_price        = "-1"
  eviction_policy       = "Delete"
  enable_auto_scaling   = true
  node_count            = 1
  min_count             = 1
  max_count             = 3

  tags = {
    Environment = "Production"
  }
}
