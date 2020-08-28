terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "mrichardson03/vpc/aws"

  cidr_block = "10.0.0.0/16"
  azs = [
    data.aws_availability_zones.available.names[0]
  ]
  mgmt_subnet_cidrs    = ["10.0.0.0/24"]
  public_subnet_cidrs  = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24"]
  private_subnet_names = ["Trust"]
  allowed_mgmt_cidr    = "0.0.0.0/0"

  tags = {
    "Name"        = "My-App",
    "Environment" = "Prod"
  }
}

module "firewall" {
  source = "./.."

  vpc_id   = module.vpc.vpc_id
  key_name = var.key_name

  mgmt_subnet_id = module.vpc.mgmt_subnet_ids[0]
  mgmt_sg_id     = module.vpc.mgmt_sg_id
  mgmt_ip        = "10.0.0.5"

  eth1_subnet_id = module.vpc.public_subnet_ids[0]
  eth1_sg_id     = module.vpc.public_sg_id
  eth1_ip        = "10.0.1.5"

  eth2_subnet_id = module.vpc.private_subnet_ids[0]
  eth2_sg_id     = module.vpc.internal_sg_id
  eth2_ip        = "10.0.10.5"
}
