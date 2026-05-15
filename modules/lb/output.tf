output "ui_pool_id" {
  value = azurerm_lb_backend_address_pool.ui_pool[count.index].id
}

output "app_pool_id" {
  value = azurerm_lb_backend_address_pool.app_pool[count.index].id
}

output "lb_public_ip" {
  value = azurerm_public_ip.lb_pip[count.index].ip_address

}

output "app_lb_privateIP" {
  value = azurerm_lb.main_app[count.index].private_ip_address
}