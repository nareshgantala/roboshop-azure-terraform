provider "azurerm" {
  features {}
  # Configuration options
}

terraform {
  backend "azurerm" {
  # Can also be set via `ARM_CLIENT_ID` environment variable.
    # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}
