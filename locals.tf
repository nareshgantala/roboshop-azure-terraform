locals {
  project = "roboshop"
  name_prefix = "local.project-${var.env}-${var.components}"
  common_tags = {
    name = local.name_prefix
    env = var.env
  }
}