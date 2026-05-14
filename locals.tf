locals {
  project = "roboshop"
  common_tags = {
    name = local.project
    env = var.env
  }
}