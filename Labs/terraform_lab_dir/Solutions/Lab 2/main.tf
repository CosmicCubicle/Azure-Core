provider "azurerm" {
  skip_provider_registration = true
  features {
  }
}

data "azurerm_resource_group" "main" {
  name = var.rg_name
}

resource "azurerm_public_ip" "vm" {
  name                = "mypip"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  depends_on          = [data.azurerm_resource_group.main]

  tags = {
    environment = "dev"
  }
}
