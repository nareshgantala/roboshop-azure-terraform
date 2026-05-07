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
  source_image_id = data.azurerm_shared_image_version.img.id

}


resource "null_resource" "name" {
  connection {
      type = "ssh"
      user = "devops"
      password = "DevOps@123456"
      host = azurerm_linux_virtual_machine.main.private_ip_address
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
    inline = [
      "sudo dnf install python3-pip -y",
      "sudo pip3.12 install ansible",
      "ansible-pull -i localhost, -U https://github.com/nareshgantala/roboshop-azure-ansible.git site.yml -e component_name=${var.component_name} -e env=dev",      
    ]
  }
}