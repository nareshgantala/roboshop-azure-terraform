module "networking" { 
  for_each = var.components
  source = "./modules/networking"
  subnet_id      = data.azurerm_subnet.default_subnet.id
  component_name = each.key
  resource_group_name = data.azurerm_resource_group.rsg.name
  location = data.azurerm_resource_group.rsg.location  
  public_ip_enabled = each.key == "frontend"
  env = var.env
}

module "db_mysql" {
  for_each = var.mysql   
  depends_on = [ module.networking ]
  source = "./modules/vm"
  component_name =each.key 
  tags = merge(local.common_tags, {Name = "${local.project}-${var.env}-${each.key}"})
  resource_group_name = data.azurerm_resource_group.rsg.name
  location = data.azurerm_resource_group.rsg.location
  size = each.value 
  nic_id = module.networking[each.key].nid
  env = var.env
}

module "db" {
  for_each = var.db   
  depends_on = [ module.networking ]
  source = "./modules/vm"
  component_name =each.key 
  tags = merge(local.common_tags, {Name = "${local.project}-${var.env}-${each.key}"})
  resource_group_name = data.azurerm_resource_group.rsg.name
  location = data.azurerm_resource_group.rsg.location
  size = each.value 
  nic_id = module.networking[each.key].nid
  env = var.env
}

module "dns_mysql" {
  for_each = var.mysql
  source = "./modules/dns"
  resource_group_name = data.azurerm_resource_group.rsg.name
  component_name = each.key 
  record = module.db_mysql[each.key].private_ip
  env = var.env
}

module "dns_db" {
  for_each = var.db
  source = "./modules/dns"
  resource_group_name = data.azurerm_resource_group.rsg.name
  component_name = each.key 
  record = module.db[each.key].private_ip
  env = var.env
}


module "dns_ui" {
  for_each = var.ui
  source = "./modules/dns"
  resource_group_name = data.azurerm_resource_group.rsg.name
  component_name = each.key 
  record = module.aks.fqdn
  env = var.env
}

module "aks" {
  source = "./modules/aks"
  rg_name = data.azurerm_resource_group.rsg.name
  project = local.project
  subnet_id = data.azurerm_subnet.default_subnet.id
  location = data.azurerm_resource_group.rsg.location
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
# 1. Create the Public IP for the NAT Gateway
resource "azurerm_public_ip" "nat_pip" {
  name                = "nat-gateway-pip"
  location            = data.azurerm_resource_group.rsg.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard" # Must be Standard to work with NAT Gateway
}

# 2. Associate the Public IP with the NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "nat_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

resource "null_resource" "file" {
    provisioner "file" {
    source      = "./requirements.yml"
    destination = "/home/devops/requirements.yml"

    connection {
        type     = "ssh"
        user     = "devops"
        password = "Devops@12345"
        host     = module.db_mysql["mysql"].private_ip
    }
    }
}

resource "null_resource" "null_db_mysql" {
  for_each = var.mysql
  depends_on = [ null_resource.file, module.dns_db, azurerm_subnet_nat_gateway_association.example, azurerm_nat_gateway_public_ip_association.nat_assoc ]
    # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    cluster_instance_ids = module.db_mysql[each.key].private_ip
  }
  connection {
      type = "ssh"
      user = "devops"
      password = "Devops@12345"
      host = module.db_mysql["mysql"].private_ip
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
inline = [
  "set -e",
  "sudo dnf install ansible-core git python3-pip -y",
  "sudo python3 -m pip install PyMySQL",
  "ansible-galaxy collection install -r /home/devops/requirements.yml",
  "ansible-pull -i localhost, -U https://github.com/nareshgantala/roboshop-azure-ansible.git site.yml -e component_name=${each.key} -e env=${var.env}"
]
  }
}

resource "null_resource" "null_db" {
  for_each = var.db
  depends_on = [ module.dns_db, azurerm_subnet_nat_gateway_association.example, azurerm_nat_gateway_public_ip_association.nat_assoc ]
    # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    cluster_instance_ids = module.db[each.key].private_ip
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

#Moved to Kubernetes, no need seperate dns entries as coreDNS in kubernetes help resolve with service IPs
# module "dns_app" {
#   for_each = var.app
#   source = "./modules/dns"
#   resource_group_name = data.azurerm_resource_group.rsg.name
#   component_name = each.key 
#   record = module.lb_app[each.key].app_lb_privateIP
#   env = var.env
# }


#Moved to Kubernetes ingress controller
#module "lb_app" {
#   for_each = var.app
#   source = "./modules/lb"
#   subnet_id = data.azurerm_subnet.default_subnet.id
#   resource_group_name = data.azurerm_resource_group.rsg.name
#   component_name = each.key
#   env = var.env
#   location = data.azurerm_resource_group.rsg.location
#   component_type = "app"
#   port = each.value["port"]
#   nic_id = module.networking[each.key].nid
# }

# module "lb_ui" {
#   for_each = var.ui
#   source = "./modules/lb"
#   subnet_id = data.azurerm_subnet.default_subnet.id
#   resource_group_name = data.azurerm_resource_group.rsg.name
#   component_name = each.key
#   env = var.env
#   location = data.azurerm_resource_group.rsg.location
#   component_type = "ui"
#   port = each.value["port"]
#   nic_id = module.networking[each.key].nid
# }


# Moving to vmss for auto scaling
# module "app" {
#   depends_on = [ module.db, module.networking ]
#   for_each = var.app   
#   source = "./modules/vm"
#   component_name =each.key 
#   tags = merge(local.common_tags, {Name = "${local.project}-${var.env}-${each.key}"})
#   resource_group_name = data.azurerm_resource_group.rsg.name
#   location = data.azurerm_resource_group.rsg.location
#   size = each.value["size"] 
#   nic_id = module.networking[each.key].nid
#   env = var.env
# }


# Moving to vmss for auto scaling
# module "ui" {
#   depends_on = [ module.app, module.networking ]
#   for_each = var.ui   
#   source = "./modules/vm"
#   component_name =each.key 
#   tags = merge(local.common_tags, {Name = "${local.project}-${var.env}-${each.key}"})
#   resource_group_name = data.azurerm_resource_group.rsg.name
#   location = data.azurerm_resource_group.rsg.location
#   size = each.value["size"]
#   nic_id = module.networking[each.key].nid
#   env = var.env
# }


# Moving to kubernets
# module "vmss" {
#   depends_on = [ null_resource.null_db, null_resource.file, null_resource.null_db_mysql ]
#   for_each = var.app
#   source = "./modules/vmss"
#   component_name =each.key
#   env = var.env
#   resource_group_name = data.azurerm_resource_group.rsg.name
#   location = data.azurerm_resource_group.rsg.location
#   app_pool_id = module.lb_app[each.key].app_pool_id
#   subnet_id = data.azurerm_subnet.default_subnet.id
#   size = each.value["size"]
#   img_id = var.img_id
# }

# Moving to kubernets
# module "vmss_ui" {
#   depends_on = [ null_resource.null_db, null_resource.file, null_resource.null_db_mysql ]
#   for_each = var.ui
#   source = "./modules/vmss"
#   component_name =each.key
#   env = var.env
#   resource_group_name = data.azurerm_resource_group.rsg.name
#   location = data.azurerm_resource_group.rsg.location
#   app_pool_id = module.lb_ui[each.key].ui_pool_id
#   subnet_id = data.azurerm_subnet.default_subnet.id
#   size = each.value["size"]
#   img_id = var.img_id
# }





# resource "null_resource" "null_app" {
  
#   for_each = var.app
#   depends_on = [ null_resource.null_db_mysql, module.dns_app, module.dns_db, module.dns_ui, azurerm_subnet_nat_gateway_association.example, azurerm_nat_gateway_public_ip_association.nat_assoc ]
#     # Changes to any instance of the cluster requires re-provisioning
#   triggers = {
#     cluster_instance_ids = module.app[each.key].private_ip
#   }
#   connection {
#       type = "ssh"
#       user = "devops"
#       password = "Devops@12345"
#       host = module.app[each.key].private_ip
#   }

#   provisioner "remote-exec" {
#     # Bootstrap script called with private_ip of each node in the clutser
# inline = [
#   "set -e",
#   "sudo dnf install ansible-core git -y",
#   "ansible-pull -i localhost, -U https://github.com/nareshgantala/roboshop-azure-ansible.git site.yml -e component_name=${each.key} -e env=${var.env}"
# ]
#   }
# }

# resource "null_resource" "null_ui" {
#   for_each = var.ui
#   depends_on = [ module.dns_app, module.dns_db, module.dns_ui, azurerm_subnet_nat_gateway_association.example, azurerm_nat_gateway_public_ip_association.nat_assoc ]
#     # Changes to any instance of the cluster requires re-provisioning
#   triggers = {
#     cluster_instance_ids = module.ui[each.key].private_ip
#   }
#   connection {
#       type = "ssh"
#       user = "devops"
#       password = "Devops@12345"
#       host = module.ui[each.key].private_ip
#   }

#   provisioner "remote-exec" {
#     # Bootstrap script called with private_ip of each node in the clutser
# inline = [
#   "set -e",
#   "sudo dnf install ansible-core git -y",
#   "ansible-pull -i localhost, -U https://github.com/nareshgantala/roboshop-azure-ansible.git site.yml -e component_name=${each.key} -e env=${var.env}"
# ]
#   }
# }