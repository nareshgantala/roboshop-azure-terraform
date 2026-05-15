variable "resource_group_name" {
  default = "denmark-east"
}
variable "mysql" {
  default = {
    mysql = "Standard_B1s"
  }
}

variable "db" {
  default = {
    mongodb = "Standard_B1s"
    valkey = "Standard_B1s"
    rabbitmq = "Standard_B1s"
  }
}

variable "app" {
  default = {
    catalogue = {
      size = "Standard_B1s"
      port = 8002
    }
    user = {
      size = "Standard_B1s"
      port = 8001
    }
    cart = {
      size = "Standard_B1s"
      port = 8003
    }
    shipping = {
      size = "Standard_B1s"
      port = 8004
    }
    payment = {
      size = "Standard_B1s"
      port = 8005
    }
    orders = {
      size = "Standard_B1s"
      port = 8007
    }
    ratings = {
      size = "Standard_B1s"
      port = 8006
    }
  }
}

variable "ui" {
  default = {
    frontend = {
     size = "Standard_B1s"
     port = 80
    }
  }
}

variable "components" {
  default = {
    frontend = "Standard_B1s"
    catalogue = "Standard_B1s"
    user = "Standard_B1s"
    cart = "Standard_B1s"
    shipping = "Standard_B1s"
    payment = "Standard_B1s"
    orders = "Standard_B1s"
    ratings = "Standard_B1s"
    mysql = "Standard_B1s"
    mongodb = "Standard_B1s"
    valkey = "Standard_B1s"
    rabbitmq = "Standard_B1s"
  }
}

variable "env" {
  
}

variable "public_ip_enabled" {
  type    = bool
  default = false
}

# variable "component_type" {
#   default = null
# }

# variable "port" {
  
# }

variable "img_id" {
  default = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshopImage"
}