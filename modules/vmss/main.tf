resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "devops"
  admin_password      = "Devops@12345"


  source_image_id     = var.img_id

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      subnet_id = azurerm_subnet.internal.id
      load_balancer_backend_address_pool_ids = var.app_pool_id
    }
  }
}