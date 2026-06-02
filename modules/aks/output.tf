output "fqdn" {
  value = azurerm_kubernetes_cluster.main.fqdn
}

output "principal_id" {
  value = azurerm_kubernetes_cluster.main.identity[0].principal_id
}