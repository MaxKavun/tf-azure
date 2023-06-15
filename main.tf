provider "azurerm" {
  features {}

  skip_provider_registration = true
}

data "azurerm_resource_group" "this" {
  name = "capital-one"
}

module "network" {
  source = "./modules/virtual_network"

  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
}
/*
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
}*/

module "app_lb" {
  source = "./modules/application_load_balancer"

  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  app_lb_subnet_id    = module.network.app_lb_subnet_id
}

module "aks" {
  source = "./modules/aks"

  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  app_lb_id           = module.app_lb.id
  app_lb_subnet_id    = module.network.app_lb_subnet_id
  subnet_id           = module.network.subnet_id
}
