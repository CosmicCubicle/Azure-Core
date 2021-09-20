provider "azurerm" {
  skip_provider_registration = true
  features {
  }
}

data "azurerm_resource_group" "main" {
  name = var.rg_name
}

data "azurerm_client_config" "current" {

}