# terraform-aws-panos-firewall

![CI/CD](https://github.com/mrichardson03/terraform-aws-panos-firewall/workflows/CI/CD/badge.svg?branch=develop)

Terraform Module: PAN-OS firewall connecting two AWS subnets.

This Terraform module creates a PAN-OS firewall between a public and a private subnet in an AWS VPC.  The configuration is based off of the [AWS Deployment Guide - Single VPC Model](https://www.paloaltonetworks.com/apps/pan/public/downloadResource?pagePath=/content/pan/en_US/resources/guides/aws-deployment-guide-single-resource) reference architecture.

## Usage

Include in a Terraform plan (see [PaloAltoNetworks/terraform-aws-panos-bootstrap](https://github.com/PaloAltoNetworks/terraform-aws-panos-bootstrap) for easy bootstrapping):

```terraform
module "firewall" {
  source  = "mrichardson03/panos-firewall/aws"

  vpc_id   = module.vpc.vpc_id
  key_name = var.key_name

  mgmt_subnet_id = module.vpc.mgmt_a_id
  mgmt_sg_id     = module.vpc.mgmt_sg_id
  mgmt_ip        = "10.1.9.21"

  eth1_subnet_id = module.vpc.public_a_id
  eth1_sg_id     = module.vpc.public_sg_id
  eth1_ip        = "10.1.10.10"

  eth2_subnet_id = module.vpc.web_a_id
  eth2_sg_id     = module.vpc.internal_sg_id
  eth2_ip        = "10.1.1.10"

  iam_instance_profile = module.bootstrap.instance_profile_name
  bootstrap_bucket     = module.bootstrap.bucket_name
}
```