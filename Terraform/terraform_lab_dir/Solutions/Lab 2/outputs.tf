output "rg_main_output" {
  value = data.azurerm_resource_group.main
}

output "vmEndpoint" {
  value = azurerm_public_ip.vm
}
