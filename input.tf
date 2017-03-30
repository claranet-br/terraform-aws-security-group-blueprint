variable "name" {
  description = "The security group name"
  type = "string"
}

variable "description" {
  type = "string"
}

variable "vpc" {
  type = "string"
}

variable "ingress_from_security_group" {
  type = "list"
  default = []
}

variable "ingress_from_security_group_count" {
  type = "string"
  default = 0
}

variable "ingress_from_cidr_blocks" {
  type = "list"
  default = []
}

variable "ingress_from_cidr_blocks_count" {
  type = "string"
  default = 0
}
