resource "azurerm_public_ip" "this" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "this" {
  name                = "webapp"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.this.id
  }
}

resource "azurerm_lb_backend_address_pool" "this" {
  loadbalancer_id = azurerm_lb.this.id
  name            = "NginxAppPool"
}

resource "azurerm_lb_backend_address_pool_address" "this" {
  name                    = "main"
  backend_address_pool_id = azurerm_lb_backend_address_pool.this.id
  virtual_network_id      = var.virtual_network_id
  ip_address              = var.private_ip_address
}

resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.this.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this.id]
}
