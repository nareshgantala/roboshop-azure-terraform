data "azurerm_resource_group" "rsg" {
  name = var.resource_group_name
}

data "azurerm_subnet" "default_subnet" {
  name                 = "default"
  virtual_network_name = "test-virtual-network"
  resource_group_name  = var.resource_group_name
}

# 1. Fetch your existing Azure Container Registry details
data "azurerm_container_registry" "acr" {
  name                = "nareshroboshop" # Extracted from nareshroboshop.azurecr.io
  resource_group_name = data.azurerm_resource_group.rsg.name 
}