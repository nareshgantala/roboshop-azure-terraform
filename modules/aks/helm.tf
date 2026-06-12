resource "null_resource" "kube-config" {

  depends_on = [ azurerm_kubernetes_cluster_node_pool.pool1 ]
  provisioner "local-exec" {
    command = "az aks get-credentials --name ${var.project}-${var.env} --resource-group denmark-east --overwrite-existing"
  }
}


resource "helm_release" "traefik_ingress" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
}
