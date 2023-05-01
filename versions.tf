terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.54.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "1-5f1dbe88-playground-sandbox"
    storage_account_name = "az900mk"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}