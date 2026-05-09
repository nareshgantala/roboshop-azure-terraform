output "private_ip" {
  value = azurerm_linux_virtual_machine.main.private_ip_address
}

output "mysql_ip" {
  value = azurerm_linux_virtual_machine.main[mysql].private_ip_address
}