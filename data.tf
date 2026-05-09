data "azurerm_resource_group" "rsg" {
  name = var.resource_group_name
}

data "azurerm_subnet" "default_subnet" {
  name                 = "default"
  virtual_network_name = "test-virtual-network"
  resource_group_name  = var.resource_group_name
}