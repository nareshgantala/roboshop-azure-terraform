module "networking" { 
  for_each = var.components
  source = "./modules/networking"
  component_name = each.key
  resource_group_name = data.azurerm_resource_group.rsg.name
  location = data.azurerm_resource_group.rsg.location  
}

module "db" {
  for_each = var.db   
  source = "./modules/vm"
  component_name =each.key 
  resource_group_name = data.azurerm_resource_group.rsg.name
  location = data.azurerm_resource_group.rsg.location
  size = each.value 
  nic_id = module.networking[each.key].nid
}

module "app" {
  depends_on = [ module.db ]
  for_each = var.app   
  source = "./modules/vm"
  component_name =each.key 
  resource_group_name = data.azurerm_resource_group.rsg.name
  location = data.azurerm_resource_group.rsg.location
  size = each.value 
  nic_id = module.networking[each.key].nid
}

module "ui" {
  depends_on = [ module.app ]
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
