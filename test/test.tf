data "aws_availability_zones" "azs" {}

variable account {}

variable "name" {
  default = "security-group-acme"
}

provider "aws" {
  allowed_account_ids = [
    "${var.account}"
  ]
}

module "vpc" {
  source = "git::https://bitbucket.org/credibilit/terraform-vpc-blueprint.git?ref=0.1.1"

  account                   = "${var.account}"
  name                      = "${var.name}"
  cidr_block                = "10.0.0.0/16"
  domain_name               = "${var.name}.local"
  hosted_zone_comment       = "An internal hosted zone for testing a security group"
  azs                       = "${data.aws_availability_zones.azs.names}"
  az_count                  = 1
  public_subnets_cidr_block = [
    "10.0.0.0/24",
  ]
}

module "security_group_1" {
  source      = "../"

  name        = "${var.name}-1"
  description = "A test security group"
  vpc         = "${module.vpc.vpc}"
}

module "security_group_2" {
  source      = "../"

  name        = "${var.name}-2"
  description = "Another test security group"
  vpc         = "${module.vpc.vpc}"
  ingress_from_security_group = [
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      source_security_group_id = "${module.security_group_1.security_group["id"]}"
    }
  ]
  ingress_from_security_group_count = 1
}

output "security_group_1" {
  value = "${module.security_group_1.security_group}"
}

output "security_group_2" {
  value = "${module.security_group_2.security_group}"
}
