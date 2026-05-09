

module "networking" { 
  for_each = var.components
  source = "./modules/networking"
  subnet_id      = data.azurerm_subnet.default_subnet.id
  component_name = each.key
  resource_group_name = data.azurerm_resource_group.rsg.name
  location = data.azurerm_resource_group.rsg.location  
  # public_ip_enabled = each.key == "frontend"
}

module "db" {
  for_each = var.db   
  depends_on = [ module.networking ]
  source = "./modules/vm"
  component_name =each.key 
  resource_group_name = data.azurerm_resource_group.rsg.name
  location = data.azurerm_resource_group.rsg.location
  size = each.value 
  nic_id = module.networking[each.key].nid
}

module "app" {
  depends_on = [ module.db, module.networking ]
  for_each = var.app   
  source = "./modules/vm"
  component_name =each.key 
  resource_group_name = data.azurerm_resource_group.rsg.name
  location = data.azurerm_resource_group.rsg.location
  size = each.value 
  nic_id = module.networking[each.key].nid
}

module "ui" {
  depends_on = [ module.app, module.networking ]
  for_each = var.ui   
  source = "./modules/vm"
  component_name =each.key 
  resource_group_name = data.azurerm_resource_group.rsg.name
  location = data.azurerm_resource_group.rsg.location
  size = each.value 
  nic_id = module.networking[each.key].nid
}

module "dns_db" {
  for_each = var.db
  source = "./modules/dns"
  resource_group_name = data.azurerm_resource_group.rsg.name
  component_name = each.key 
  record = module.db[each.key].private_ip
  env = var.env
}

module "dns_app" {
  for_each = var.app
  source = "./modules/dns"
  resource_group_name = data.azurerm_resource_group.rsg.name
  component_name = each.key 
  record = module.app[each.key].private_ip
  env = var.env
}

module "dns_ui" {
  for_each = var.ui
  source = "./modules/dns"
  resource_group_name = data.azurerm_resource_group.rsg.name
  component_name = each.key 
  record = module.ui[each.key].private_ip
  env = var.env
}

resource "azurerm_nat_gateway" "nat" {
  name                    = "nat-gateway"
  location                = data.azurerm_resource_group.rsg.location
  resource_group_name     = var.resource_group_name   
  sku_name                = "Standard"
}

resource "azurerm_subnet_nat_gateway_association" "example" {
  subnet_id      = data.azurerm_subnet.default_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

resource "null_resource" "null_db" {
  for_each = var.db
  depends_on = [ module.dns_app, module.dns_db, module.dns_ui, azurerm_subnet_nat_gateway_association.example ]
    # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    cluster_instance_ids = timestamp()
  }
  connection {
      type = "ssh"
      user = "devops"
      password = "Devops@12345"
      host = module.db[each.key].private_ip
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
inline = [
  "set -e",
  "sudo dnf install ansible-core git -y",
  "ansible-pull -i localhost, -U https://github.com/nareshgantala/roboshop-azure-ansible.git site.yml -e component_name=${each.key} -e env=${var.env}"
]
  }
}


resource "null_resource" "null_app" {
  
  for_each = var.app
  depends_on = [ module.dns_app, module.dns_db, module.dns_ui, azurerm_subnet_nat_gateway_association.example ]
    # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    cluster_instance_ids = timestamp()
  }
  connection {
      type = "ssh"
      user = "devops"
      password = "Devops@12345"
      host = module.app[each.key].private_ip
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
inline = [
  "set -e",
  "sudo dnf install ansible-core git -y",
  "ansible-pull -i localhost, -U https://github.com/nareshgantala/roboshop-azure-ansible.git site.yml -e component_name=${each.key} -e env=${var.env}"
]
  }
}

resource "null_resource" "null_ui" {
  for_each = var.ui
  depends_on = [ module.dns_app, module.dns_db, module.dns_ui, azurerm_subnet_nat_gateway_association.example ]
    # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    cluster_instance_ids = timestamp()
  }
  connection {
      type = "ssh"
      user = "devops"
      password = "Devops@12345"
      host = module.ui[each.key].private_ip
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
inline = [
  "set -e",
  "sudo dnf install ansible-core git -y",
  "ansible-pull -i localhost, -U https://github.com/nareshgantala/roboshop-azure-ansible.git site.yml -e component_name=${each.key} -e env=${var.env}"
]
  }
}