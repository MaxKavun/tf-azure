variable "location" {
  type        = string
  description = "The Azure location"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "virtual_network_id" {
  type        = string
  description = "Virtual network id for backend pool"
}

variable "private_ip_address" {
  type        = string
  description = "Private ip address of virtual machine for backend pool"
}
