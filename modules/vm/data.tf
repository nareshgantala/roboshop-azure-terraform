data "azurerm_shared_image_version" "img" {
  name                = "1.0.0"
  image_name          = "roboshopImage"
  gallery_name        = "roboshopGallery"
  resource_group_name = var.resource_group_name
}