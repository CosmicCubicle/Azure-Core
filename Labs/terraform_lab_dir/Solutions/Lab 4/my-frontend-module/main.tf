resource "azurerm_public_ip" "vm" {
  name                = "${var.environment}-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"

  tags = {
    environment = var.environment
  }
}

