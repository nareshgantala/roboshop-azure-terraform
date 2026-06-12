resource "null_resource" "kube-config" {

  depends_on = [ azurerm_kubernetes_cluster_node_pool.pool1 ]
  provisioner "local-exec" {
    command = "az aks get-credentials --name ${var.project}-${var.env} --resource-group denmark-east --overwrite-existing"
  }
}


resource "helm_release" "traefik_ingress" {
  depends_on = [ null_resource.kube-config ]
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
}

resource "helm_release" "prom_stack" {
  depends_on = [ null_resource.kube-config, helm_release.traefik_ingress ]
  name       = "pstack"
  repository = "oci://ghcr.io/prometheus-community/charts"
  chart      = "kube-prometheus-stack"
  values = [
    yamlencode({
      grafana = {
        ingress = {
          enabled          = true
          ingressClassName = "traefik"
          hosts            = ["grafana-${var.env}.naresh-training.online"]
          paths            = ["/"]
          pathType         = "Prefix"
        }
      }
      prometheus = {
        ingress = {
          enabled          = true
          ingressClassName = "traefik"
          hosts            = ["prometheus-${var.env}.naresh-training.online"]
          paths            = ["/"]
          pathType         = "Prefix"
        }
      }
    })
  ]
}


resource "helm_release" "external_dns" {
  depends_on = [ null_resource.kube-config, helm_release.traefik_ingress, helm_release.prom_stack ]
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
}