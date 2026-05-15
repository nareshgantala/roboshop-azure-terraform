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
      img_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshop-catalogue"
    }
    user = {
      size = "Standard_B1s"
      port = 8001
      img_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshop-user"
    }
    cart = {
      size = "Standard_B1s"
      port = 8003
      img_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshop-cart"
    }
    shipping = {
      size = "Standard_B1s"
      port = 8004
      img_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshop-shipping"
    }
    payment = {
      size = "Standard_B1s"
      port = 8005
      img_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshop-payment"
    }
    orders = {
      size = "Standard_B1s"
      port = 8007
      img_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshop-orders"
    }
    ratings = {
      size = "Standard_B1s"
      port = 8006
      img_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshop-ratings"
    }
  }
}

variable "ui" {
  default = {
    frontend = {
     size = "Standard_B1s"
     port = 80
     img_id = "/subscriptions/9be9bd1a-817e-486f-9b33-1b1f79ed3727/resourceGroups/denmark-east/providers/Microsoft.Compute/galleries/roboshopGallery/images/roboshop-frontend"
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