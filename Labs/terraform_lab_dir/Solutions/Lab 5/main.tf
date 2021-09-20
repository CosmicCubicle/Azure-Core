terraform {
  backend "azurerm" {
    storage_account_name = "msclassc2e21e6cdee401d5"
    container_name       = "terraformstate"
  }
}

provider "azurerm" {
}



locals {
  vm = {
    computer_name = "vm1"
    user_name     = "admin1234"
  }
}
