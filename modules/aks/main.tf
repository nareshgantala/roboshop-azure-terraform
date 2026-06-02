resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.project}-${var.env}"
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = "${var.project}-${var.env}"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.env
  }
}

