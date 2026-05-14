resource "azurerm_lb" "main" {
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