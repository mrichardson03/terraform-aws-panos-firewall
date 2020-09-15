terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "Firewall-VPC"
  cidr = "10.0.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0]]
  public_subnets  = ["10.0.0.0/24"]
  private_subnets = ["10.0.1.0/24"]

  tags = {
    "Name" = "Firewall"
  }
}

module "firewall" {
  source = "./.."

  vpc_id   = module.vpc.vpc_id
  key_name = var.key_name

  panos_license_type = var.panos_license
  panos_version      = var.panos_version

  mgmt_subnet_id = module.vpc.public_subnets[0]
  mgmt_sg_id     = module.sg_default.this_security_group_id
  mgmt_ip        = "10.0.0.5"

  eth1_subnet_id = module.vpc.public_subnets[0]
  eth1_sg_id     = module.sg_public.this_security_group_id
  eth1_ip        = "10.0.0.10"

  eth2_subnet_id = module.vpc.private_subnets[0]
  eth2_sg_id     = module.sg_internal.this_security_group_id
  eth2_ip        = "10.0.1.10"
}

module "sg_default" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "Default"
  description = "Allow default management ports"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "https-443-tcp"]

  egress_rules = ["all-all"]
}

module "sg_public" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "Public"
  description = "Allow all to external interface of firewall"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]

  egress_rules = ["all-all"]
}

module "sg_internal" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "Internal"
  description = "Allow all traffic within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules       = ["all-all"]

  egress_rules = ["all-all"]
}
