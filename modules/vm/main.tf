resource "azurerm_linux_virtual_machine" "main" {
  name                = var.component_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  network_interface_ids = [ var.nic_id ]

  admin_username = "devops"
  admin_password = "Devops@12345"
  disable_password_authentication = false
  vtpm_enabled = true
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_id = data.azurerm_images.image.id

}