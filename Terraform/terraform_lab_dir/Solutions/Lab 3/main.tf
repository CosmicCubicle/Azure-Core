provider "azurerm" {
    skip_provider_registration = true
	features {
	}
   }

data "azurerm_resource_group" "main" {
  name     = var.rg_name
}

data "azurerm_client_config" "current" {

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

resource "azurerm_storage_account" "storage" {
  name                     = "msclass${lower(random_id.storage_account.hex)}"
  location                 = data.azurerm_resource_group.main.location
  resource_group_name      = data.azurerm_resource_group.main.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [data.azurerm_resource_group.main]
}

resource "random_id" "storage_account" {
  byte_length = 8
}

resource "azurerm_key_vault" "vault" {
  name                        = "kviac${lower(random_id.storage_account.hex)}"
  location                    = data.azurerm_resource_group.main.location
  resource_group_name         = data.azurerm_resource_group.main.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"                

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "eed74f2c-c1d5-4e58-99ae-b9a5e0915f9c"

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
      "delete",
      "list",
      "set",
    ]

    storage_permissions = [
      "get",
    ]
  }
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "terraform"
  value        = azurerm_storage_account.storage.primary_access_key
  key_vault_id = azurerm_key_vault.vault.id
  depends_on = [azurerm_storage_account.storage]
}

resource "azurerm_storage_container" "terraformstate" {
  name                  = "terraformstate"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
