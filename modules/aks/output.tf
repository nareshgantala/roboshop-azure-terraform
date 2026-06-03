output "fqdn" {
  value = azurerm_kubernetes_cluster.main.fqdn
}

output "principal_id" {
  value = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

output "kubelet_principal_id" {
  # Change this line to target the kubelet identity object_id
  value = azurerm_kubernetes_cluster.your_cluster_resource_name.kubelet_identity[0].object_id
}