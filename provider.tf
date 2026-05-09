provider "azurerm" {
  features {}
  # Configuration options
}

terraform {
  backend "azurerm" {
  # Can also be set via `ARM_CLIENT_ID` environment variable.
    storage_account_name = "roboshop"                              # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstates"                               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "terraform.tfstate"                # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}
