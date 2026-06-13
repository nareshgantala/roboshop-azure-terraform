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

resource "helm_release" "prometheus_stack" {

  depends_on = [null_resource.kube-config, helm_release.traefik_ingress, helm_release.external_dns]

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
          path             = "/"
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
        prometheusSpec = {
          additionalScrapeConfigs = [
            {
              job_name = "azure-vms"
              azure_sd_configs = [
                {
                  subscription_id = "9be9bd1a-817e-486f-9b33-1b1f79ed3727"
                  tenant_id       = "39327c73-7743-4d89-9607-d01ea0747b9d"
                  client_id       = data.azurerm_key_vault_secret.PrometheusClientID.value
                  client_secret   = data.azurerm_key_vault_secret.PrometheusClientPassword.value
                  port            = 9100
                  resource_group  = var.rg_name
                }
              ]
              relabel_configs = [
                {
                  source_labels = ["__meta_azure_machine_name"]
                  target_label  = "instance_name"
                },
                {
                  source_labels = ["__meta_azure_machine_resource_group"]
                  target_label  = "resource_group"
                },
                {
                  source_labels = ["__meta_azure_machine_location"]
                  target_label  = "region"
                }
              ]
            }
          ]
        }
      }
    })
  ]
}


# # 1. Create Service Principal for External DNS
# az ad sp create-for-rbac --name "ExternalDnsServicePrincipal" --skip-assignment
# az role assignment create --role "DNS Zone Contributor" \
#   --assignee "0f7f7c40-a5fd-43ac-9feb-0172b036ba65" \
#   --scope "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east"



## External DNS Helm chart secret
resource "null_resource" "external-dns-secret" {
  depends_on = [
    null_resource.kube-config
  ]

  provisioner "local-exec" {
    command = <<EOF
echo '{
  "tenantId": "39327c73-7743-4d89-9607-d01ea0747b9d",
  "subscriptionId": "9be9bd1a-817e-486f-9b33-1b1f79ed3727",
  "resourceGroup": "${var.rg_name}",
  "aadClientId": "${data.azurerm_key_vault_secret.ClientID.value}",
  "aadClientSecret": "${data.azurerm_key_vault_secret.ClientPassword.value}"
}' >/tmp/azure.json
kubectl create secret generic azure-config-file --from-file /tmp/azure.json
EOF
  }

}

resource "helm_release" "external_dns" {

  depends_on = [null_resource.external-dns-secret]

  chart      = "external-dns"
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns"

  values = [
    file("${path.module}/helm-values/external-dns.yml")
  ]

}


#checking yaml conversion
# resource "local_file" "prom-input" {
#   filename = "/tmp/prom.yml"
#   content = yamlencode({
#     grafana = {
#       ingress = {
#         enabled          = true
#         ingressClassName = "traefik"
#         hosts            = ["grafana-${var.env}.naresh-training.online"]
#         path             = "/"
#         pathType         = "Prefix"
#       }
#     }
#     prometheus = {
#       ingress = {
#         enabled          = true
#         ingressClassName = "traefik"
#         hosts            = ["prometheus-${var.env}.naresh-training.online"]
#         paths            = ["/"]
#         pathType         = "Prefix"
#       }
#       prometheusSpec = {
#         additionalScrapeConfigs = [
#           {
#             job_name = "azure-vms"
#             azure_sd_configs = [
#               {
#                 subscription_id = "9be9bd1a-817e-486f-9b33-1b1f79ed3727"
#                 tenant_id       = "39327c73-7743-4d89-9607-d01ea0747b9d"
#                 client_id       = data.azurerm_key_vault_secret.PrometheusClientID.value
#                 client_secret   = data.azurerm_key_vault_secret.PrometheusClientPassword.value
#                 port            = 9100
#                 resource_group  = var.rg_name
#               }
#             ]
#             relabel_configs = [
#               {
#                 source_labels = ["__meta_azure_machine_name"]
#                 target_label  = "instance_name"
#               },
#               {
#                 source_labels = ["__meta_azure_machine_resource_group"]
#                 target_label  = "resource_group"
#               },
#               {
#                 source_labels = ["__meta_azure_machine_location"]
#                 target_label  = "region"
#               }
#             ]
#           }
#         ]
#       }
#     }
#   })
# }