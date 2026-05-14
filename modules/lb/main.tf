resource "azurerm_public_ip" "lb_pip" {
  count = var.component_type == "ui" ? 1: 0
  name                =  "${var.component_name}-${var.env}-lb_ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_lb" "main_ui" {
  count = var.component_type == "ui" ? 1: 0
  name                = "${var.component_name}-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location

  frontend_ip_configuration {
    name = "${var.component_name}-${var.env}"
    public_ip_address_id = azurerm_public_ip.lb_pip[count.index].id

  }
}

resource "azurerm_lb_backend_address_pool" "ui_pool" {
  count = var.component_type == "ui" ? 1: 0
  loadbalancer_id = azurerm_lb.main_ui[count.index].id
  name            = "${var.component_name}-${var.env}"
}

resource "azurerm_lb_rule" "ui_rule" {
  count = var.component_type == "ui" ? 1: 0
  loadbalancer_id                = azurerm_lb.main_ui[count.index].id
  name                           = "${var.component_name}-${var.env}"
  protocol                       = "Tcp"
  frontend_port                  = var.port
  backend_port                   = var.port
  frontend_ip_configuration_name = "${var.component_name}-${var.env}"
}

resource "azurerm_lb" "main_app" {
  count = var.component_type == "app" ? 1: 0
  name                = "${var.component_name}-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location

  frontend_ip_configuration {
    name = "${var.component_name}-${var.env}"
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "app_pool" {
  count = var.component_type == "app" ? 1: 0
  loadbalancer_id = azurerm_lb.main_app[count.index].id
  name            = "${var.component_name}-${var.env}"
}

resource "azurerm_lb_rule" "app_rule" {
  count = var.component_type == "app" ? 1: 0
  loadbalancer_id                = azurerm_lb.main_app[count.index].id
  name                           = "${var.component_name}-${var.env}"
  protocol                       = "Tcp"
  frontend_port                  = var.port
  backend_port                   = var.port
  frontend_ip_configuration_name = "${var.component_name}-${var.env}"
}

resource "azurerm_network_interface_backend_address_pool_association" "ui" {
  count = var.component_type == "ui" ? 1: 0
  network_interface_id    = nic_id
  ip_configuration_name   = "${var.component_name}-${var.env}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ui_pool[count.index].id
}

resource "azurerm_network_interface_backend_address_pool_association" "app" {
  count = var.component_type == "app" ? 1: 0
  network_interface_id    = var.nic_id
  ip_configuration_name   = "${var.component_name}-${var.env}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.app_pool[count.index].id
}