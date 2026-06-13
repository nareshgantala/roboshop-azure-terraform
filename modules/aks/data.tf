data "azurerm_key_vault_secret" "ClientID" {
  name         = "externalDnsClientID"
  key_vault_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.KeyVault/vaults/roboshop"
}

data "azurerm_key_vault_secret" "ClientPassword" {
  name         = "ExternalDnsClientPassword"
  key_vault_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.KeyVault/vaults/roboshop"
}

data "azurerm_key_vault_secret" "PrometheusClientID" {
  name         = "PrometheusClientID"
  key_vault_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.KeyVault/vaults/roboshop"
}

data "azurerm_key_vault_secret" "PrometheusClientPassword" {
  name         = "PrometheusClientPassword"
  key_vault_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.KeyVault/vaults/roboshop"
}
