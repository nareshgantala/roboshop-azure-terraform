output "ui_pool_id" {
  value = azurerm_lb_backend_address_pool.ui_pool.id
}

output "app_pool_id" {
  value = azurerm_lb_backend_address_pool.app_pool.id
}

output "lb_public_ip" {
  value = azurerm_public_ip.lb_pip.ip_address

}

output "app_lb_privateIP" {
  value = azurerm_lb.main_app.private_ip_address
}