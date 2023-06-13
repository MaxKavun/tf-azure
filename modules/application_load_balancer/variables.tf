variable "location" {
  type        = string
  description = "The Azure location"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "app_lb_subnet_id" {
  type        = string
  description = "Subnet id for application load balancer"
}
