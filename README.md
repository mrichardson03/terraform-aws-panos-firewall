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

#### Requirements

No requirements.

#### Providers

| Name | Version |
|------|---------|
| aws | n/a |

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| ami | Specific firewall AMI to deploy.  If not specified, AMI will be looked up. | `string` | `""` |
| bootstrap\_bucket | S3 bucket containing bootstrap configuration. | `string` | `""` |
| create\_eth1\_eip | Create and assign elastic IP to ethernet1/1 interface. | `bool` | `true` |
| create\_mgmt\_eip | Create and assign elastic IP to management interface. | `bool` | `true` |
| eth1\_ip | Internal IP address for firewall ethernet1/1 interface. | `any` | n/a |
| eth1\_sg\_id | Security group ID for firewall ethernet1/1 interface. | `any` | n/a |
| eth1\_subnet\_id | Subnet ID for firewall ethernet1/1 interface. | `any` | n/a |
| eth2\_ip | Internal IP address for firewall ethernet1/2 interface. | `any` | n/a |
| eth2\_sg\_id | Security group ID for firewall ethernet1/2 interface. | `any` | n/a |
| eth2\_subnet\_id | Subnet ID for firewall ethernet1/2 interface. | `any` | n/a |
| iam\_instance\_profile | IAM Instance Profile used to bootstrap firewall. | `string` | `""` |
| instance\_type | Instance type for firewall. | `string` | `"m4.xlarge"` |
| key\_name | Key pair name to provision instances with. | `any` | n/a |
| license\_type\_map | Product codes for PAN-OS versions 9.1 and later. | `map(string)` | <pre>{<br>  "bundle1": "e9yfvyj3uag5uo5j2hjikv74n",<br>  "bundle2": "hd44w1chf26uv4p52cdynb2o",<br>  "byol": "6njl1pau431dv1qxipg63mvah"<br>}</pre> |
| license\_type\_map\_old | Product codes for PAN-OS versions before 9.1. | `map(string)` | <pre>{<br>  "bundle1": "6kxdw3bbmdeda3o6i1ggqt4km",<br>  "bundle2": "806j2of0qy5osgjjixq9gqc6g",<br>  "byol": "6njl1pau431dv1qxipg63mvah"<br>}</pre> |
| mgmt\_ip | Internal IP address for firewall management interface. | `any` | n/a |
| mgmt\_sg\_id | Security group ID for firewall management interface. | `any` | n/a |
| mgmt\_subnet\_id | Subnet ID for firewall management interface. | `any` | n/a |
| panos\_license\_type | PAN-OS license type.  Can be one of 'byol', 'bundle1', 'bundle2'. | `string` | `"byol"` |
| panos\_version | PAN-OS version to deploy (if AMI is not specified). | `string` | `"9.1"` |
| tags | A map of tags to add to all resources. | `map` | <pre>{<br>  "Name": "Firewall"<br>}</pre> |
| vpc\_id | VPC to create firewall instance in. | `any` | n/a |

#### Outputs

| Name | Description |
|------|-------------|
| eth1\_interface\_id | Interface ID of created firewall ethernet1/1 interface. |
| eth1\_public\_ip | Public IP address of firewall ethernet1/1 interface. |
| eth2\_interface\_id | Interface ID of created firewall ethernet1/2 interface. |
| instance\_id | Instance ID of created firewall. |
| mgmt\_interface\_id | Interface ID of created firewall management interface. |
| mgmt\_public\_ip | Public IP address of firewall management interface. |

