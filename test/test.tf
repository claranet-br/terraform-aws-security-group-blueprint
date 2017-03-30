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

module "security_group" {
  source      = "../"

  name        = "${var.name}"
  description = "A test security group"
  vpc         = "${module.vpc.vpc}"
}

/*output "security_group" {
  value = "${module.security_group.security_group}"
}*/
