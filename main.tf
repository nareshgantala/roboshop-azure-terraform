provider "azurerm" {
  features {}
  # Configuration options
}

resource "azurerm_network_interface" "main" {
  for_each = var.component
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  

  ip_configuration {
    name                          = "each.key"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "frontend_nic_nsg" {
  network_interface_id      = azurerm_network_interface.each.key.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "each.key"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "each.value"
  network_interface_ids = [
    azurerm_network_interface.frontend.id,
  ]

  admin_username = "devops"
  admin_password = "Devops@12345"
  disable_password_authentication = false
  vtpm_enabled = true
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshopImage"

}

resource "azurerm_dns_a_record" "frontend" {
  name                = "frontend-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.main.private_ip_address ]
}


