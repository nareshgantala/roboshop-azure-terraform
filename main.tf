provider "azurerm" {
  features {}
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

resource "azurerm_network_interface_security_group_association" "frontend_nic_nsg" {
  network_interface_id      = azurerm_network_interface.frontend.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "frontend" {
  name                = "frontend"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_B1s"
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
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.frontend.private_ip_address ]
}


resource "azurerm_network_interface" "mysql" {
  name                = "mysql-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east"
  

  ip_configuration {
    name                          = "mysql"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface_security_group_association" "nysql_nic_nsg" {
  network_interface_id      = azurerm_network_interface.mysql.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "mysql" {
  name                = "mysql"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.mysql.id,
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

resource "azurerm_dns_a_record" "mysql" {
  name                = "mysql-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.mysql.private_ip_address ]
}


resource "azurerm_network_interface" "catalogue" {
  name                = "catalogue-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east"
  

  ip_configuration {
    name                          = "catalogue"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"
   
  }
}

resource "azurerm_network_interface_security_group_association" "catalogue_nic_nsg" {
  network_interface_id      = azurerm_network_interface.catalogue.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "catalogue" {
  name                = "catalogue"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.catalogue.id,
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

resource "azurerm_dns_a_record" "catalogue" {
  name                = "catalogue-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.catalogue.private_ip_address ]
}

resource "azurerm_network_interface" "mongodb" {
  name                = "mongodb-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east"
  

  ip_configuration {
    name                          = "mongodb"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface_security_group_association" "mongodb_nic_nsg" {
  network_interface_id      = azurerm_network_interface.mongodb.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "mongodb" {
  name                = "mongodb"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.mongodb.id,
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

resource "azurerm_dns_a_record" "mongodb" {
  name                = "mongodb-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.mongodb.private_ip_address ]
}

resource "azurerm_network_interface" "user" {
  name                = "user-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east"
  

  ip_configuration {
    name                          = "user"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface_security_group_association" "user_nic_nsg" {
  network_interface_id      = azurerm_network_interface.user.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "user" {
  name                = "user"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.user.id,
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

resource "azurerm_dns_a_record" "user" {
  name                = "user-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.frontend.private_ip_address ]
}

resource "azurerm_network_interface" "valkey" {
  name                = "valkey-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east"
  

  ip_configuration {
    name                          = "valkey"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface_security_group_association" "valkey_nic_nsg" {
  network_interface_id      = azurerm_network_interface.valkey.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "valkey" {
  name                = "valkey"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.valkey.id,
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

resource "azurerm_dns_a_record" "valkey" {
  name                = "valkey-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.valkey.private_ip_address ]
}

resource "azurerm_network_interface" "cart" {
  name                = "cart-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east"
  

  ip_configuration {
    name                          = "cart"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface_security_group_association" "cart_nic_nsg" {
  network_interface_id      = azurerm_network_interface.cart.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "cart" {
  name                = "cart"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.cart.id,
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

resource "azurerm_dns_a_record" "cart" {
  name                = "cart-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.cart.private_ip_address ]
}

resource "azurerm_network_interface" "shipping" {
  name                = "shipping-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east"
  

  ip_configuration {
    name                          = "shipping"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface_security_group_association" "shipping_nic_nsg" {
  network_interface_id      = azurerm_network_interface.shipping.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "shipping" {
  name                = "shipping"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.shipping.id,
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

resource "azurerm_dns_a_record" "shipping" {
  name                = "shipping-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.shipping.private_ip_address ]
}

resource "azurerm_network_interface" "rabbitmq" {
  name                = "rabbitmq-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east"
  

  ip_configuration {
    name                          = "rabbitmq"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface_security_group_association" "rabbitmq_nic_nsg" {
  network_interface_id      = azurerm_network_interface.rabbitmq.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "rabbitmq" {
  name                = "rabbitmq"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.rabbitmq.id,
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

resource "azurerm_dns_a_record" "rabbitmq" {
  name                = "rabbitmq-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.rabbitmq.private_ip_address ]
}

resource "azurerm_network_interface" "payment" {
  name                = "payment-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east"
  

  ip_configuration {
    name                          = "payment"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface_security_group_association" "payment_nic_nsg" {
  network_interface_id      = azurerm_network_interface.payment.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "payment" {
  name                = "payment"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.payment.id,
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

resource "azurerm_dns_a_record" "payment" {
  name                = "payment-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.payment.private_ip_address ]
}

resource "azurerm_network_interface" "orders" {
  name                = "orders-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east"
  

  ip_configuration {
    name                          = "orders"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface_security_group_association" "orders_nic_nsg" {
  network_interface_id      = azurerm_network_interface.orders.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "orders" {
  name                = "orders"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.orders.id,
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

resource "azurerm_dns_a_record" "orders" {
  name                = "orders-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.orders.private_ip_address ]
}

resource "azurerm_network_interface" "ratings" {
  name                = "ratings-nic"
  location            = "Denmark East"
  resource_group_name = "denmark-east"
  

  ip_configuration {
    name                          = "ratings"
    subnet_id                     = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/virtualNetworks/test-virtual-network/subnets/default"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface_security_group_association" "ratings_nic_nsg" {
  network_interface_id      = azurerm_network_interface.ratings.id
  network_security_group_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Network/networkSecurityGroups/allow-all"
}

resource "azurerm_linux_virtual_machine" "ratings" {
  name                = "ratings"
  resource_group_name = "denmark-east"
  location            = "Denmark East"
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.ratings.id,
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

resource "azurerm_dns_a_record" "ratings" {
  name                = "ratings-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = "denmark-east"
  ttl                 = 300
  records             = [ azurerm_linux_virtual_machine.ratings.private_ip_address ]
}