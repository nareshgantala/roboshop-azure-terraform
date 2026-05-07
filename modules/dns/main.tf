resource "azurerm_dns_a_record" "main" {
  name                = "${var.component_name}-dev"
  zone_name           = "naresh-training.com"
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [ var.record ]
}

