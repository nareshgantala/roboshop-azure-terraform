locals {
  project = "roboshop"
  name_prefix = "local.project-${var.env}-${each.key}"
  common_tags = {
    name = local.name_prefix
    env = var.env
  }
}