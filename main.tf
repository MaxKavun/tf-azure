provider "azurerm" {
  features {}

  skip_provider_registration = true
}

data "azurerm_resource_group" "this" {
  name = "1-5f1dbe88-playground-sandbox"
}

module "network" {
  source = "./modules/virtual_network"

  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
}

module "virtual_machine" {
  source = "./modules/virtual_machine"

  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = module.network.subnet_id
}

module "load_balancer" {
  source = "./modules/load_balancer"

  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  virtual_network_id  = module.network.virtual_network_id
  private_ip_address  = module.virtual_machine.private_ip_address
}
