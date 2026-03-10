variable "resource_group_name" {
default = "Azuredevops"
}

variable "location" {
default = "West Europe"
}

variable "vm_count" {
default = 2
}

variable "admin_username" {
default = "azureuser"
}

variable "image_id" {}

variable "tags" {
type = map(string)
default = {
project = "udacity"
}
}

