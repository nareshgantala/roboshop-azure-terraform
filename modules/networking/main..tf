resource "azurerm_network_interface" "main" {
  name                = "${var.component_name}-${var.env}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  

  ip_configuration {
    name                          = "${var.component_name}-${var.env}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.public_ip_enabled ? azurerm_public_ip.main[0].id: null
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = data.azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "main" {
  count = var.public_ip_enabled ? 1 : 0

  name                = "${var.component_name}-${var.env}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
}

