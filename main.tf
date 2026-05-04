provider "azurerm" {
  # Configuration options
}

resource "azurerm_public_ip" "publicIp" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  allocation_method   = "Dynamic"

  tags = {
    environment = "devlopment"
  }
}

resource "azurerm_network_interface" "frontend" {
  name                = "frontend-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east"
  

  ip_configuration {
    name                          = "frontend"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicIp.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.frontend.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "frontend" {
  name                = "frontend"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_F2"
  network_interface_ids = [
    azurerm_network_interface.frontend.id,
  ]

  admin_username = "devops"
  admin_password = "Devops@12345"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshopImage"

}

resource "azurerm_dns_a_record" "example" {
  name                = "frontend-dev"
  zone_name           = naresh-training.com
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.frontend.private_ip_address ]
}