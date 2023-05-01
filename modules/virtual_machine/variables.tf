variable "location" {
  type        = string
  description = "The Azure location"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "subnet_id" {
  type        = string
  description = "Subnet id for virtual machine"
}
