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
  depends_on = [ azurerm_linux_virtual_machine.main ]
    # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    cluster_instance_ids = timestamp()
  }
  connection {
      type = "ssh"
      user = "devops"
      password = "Devops@12345"
      host = azurerm_linux_virtual_machine.main.private_ip_address
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
  inline = [
  "echo STARTED",
  "sudo dnf install git python3-pip -y",
  "echo GIT_DONE",
  "python3 -m pip install ansible",
  "echo ANSIBLE_DONE",
  "ansible-pull -i localhost, -U https://github.com/nareshgantala/roboshop-azure-ansible.git site.yml -e component_name=${var.component_name} -e env=dev",
  "echo PULL_DONE"
]
  }
}