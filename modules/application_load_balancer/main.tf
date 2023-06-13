resource "azurerm_public_ip" "this" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "network" {
  name                = "example-appgateway"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "aks-app-lb"
    subnet_id = var.app_lb_subnet_id
  }

  frontend_port {
    name = "aks-frontend"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "aks-frontend-conf"
    public_ip_address_id = azurerm_public_ip.this.id
  }

  backend_address_pool {
    name = "aks-backend-pool"
  }

  backend_http_settings {
    name                  = "aks-backend-settings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "aks-listener"
    frontend_ip_configuration_name = "aks-frontend-conf"
    frontend_port_name             = "aks-frontend"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "aks-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "aks-listener"
    backend_address_pool_name  = "aks-backend-pool"
    backend_http_settings_name = "aks-backend-settings"
    priority                   = "20000"
  }
}
