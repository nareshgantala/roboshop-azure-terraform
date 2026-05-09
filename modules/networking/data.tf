data "azurerm_network_security_group" "nsg" {
  name                = "allow-all"
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "default_subnet" {
  name                 = "default"
  virtual_network_name = "test-virtual-network"
  resource_group_name  = var.resource_group_name
}