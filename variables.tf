variable "resource_group_name" {
  default = "denmark-east"
}

variable "location" {
  default = "Denmark East"
}

variable "component" {
  default = {
    frontend = Standard_B1s
    mysql = Standard_B1s
    catalogue = Standard_B1s
    mongodb = Standard_B1s
    user = Standard_B1s
    valkey = Standard_B1s
    cart = Standard_B1s
    shipping = Standard_B1s
    rabbitmq = Standard_B1s
    payment = Standard_B1s
    orders = Standard_B1s
    ratings = Standard_B1s
  }
}