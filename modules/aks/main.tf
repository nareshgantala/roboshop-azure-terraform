resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.project}-${var.env}"
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

