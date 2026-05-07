data "azurerm_image" "img" {
  name                = "roboshopImage"
  resource_group_name = var.resource_group_name
}