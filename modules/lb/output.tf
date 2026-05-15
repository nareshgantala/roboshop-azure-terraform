output "ui_pool_id" {
  value = azurerm_lb_backend_address_pool.ui_pool.id
}

output "app_pool_id" {
  value = azurerm_lb_backend_address_pool.app_pool.id
}