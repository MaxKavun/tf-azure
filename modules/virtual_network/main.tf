resource "azurerm_virtual_network" "this" {
  name                = "main"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "this" {
  name                 = "subnetA"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}
/*
** It's not recommended to keep 2 NSG on subnet and VM level **
** I choose VM level since it reduces blast radius of incorrect configuration **
** but possible to implement public/private NSG with different rules for both **
resource "azurerm_network_security_group" "this" {
  name                = "beta"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "nsg_inbound_ssh" {
  name                        = "beta"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}
*/

/*
** https://learn.microsoft.com/en-us/azure/nat-gateway/nat-gateway-resource **
** In the presence of other outbound configurations within a virtual network, such as Load balancer or instance-level public IPs (IL PIPs), NAT gateway takes precedence for outbound connectivity. **
** All new outbound initiated and return traffic starts using NAT gateway **
** There is no custom route table but Azure creates Azure-managed route table transparently **
*/
resource "azurerm_nat_gateway" "this" {
  name                    = "gateway"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  #zones                   = ["1"]
}

resource "azurerm_public_ip" "this" {
  name                = "nat-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.this.id
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  subnet_id      = azurerm_subnet.this.id
  nat_gateway_id = azurerm_nat_gateway.this.id
}
