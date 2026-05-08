resource "azurerm_dns_a_record" "main" {
  name                = "${var.component_name}-${var.env}"
  zone_name           = "naresh-training.online"
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [ var.record ]
}

