data "azurerm_network_security_group" "nsg" {
  name                = "allow-all"
  resource_group_name = var.resource_group_name
}

