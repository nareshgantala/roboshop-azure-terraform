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

  # ADD THIS BLOCK TO SOLVE THE OVERLAP
  network_profile {
    network_plugin     = "azure"
    load_balancer_sku  = "standard"
    
    # Internal cluster services IP range (must not overlap with 10.0.0.0/16)
    service_cidr       = "172.16.0.0/16"
    
    # Internal DNS server address (must be an IP inside the service_cidr range)
    dns_service_ip     = "172.16.0.10"
  }

  tags = {
    Environment = var.env
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "pool1" {
  name                  = "pool1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_D2s_v3"
  node_count            = 2
  vnet_subnet_id        = var.subnet_id

  lifecycle {
    ignore_changes = [upgrade_settings]
  }

}