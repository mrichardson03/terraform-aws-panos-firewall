variable "vpc_id" {
  description = "VPC to create firewall instance in."
}

variable "key_name" {
  description = "Key pair name to provision instances with."
}

variable "mgmt_subnet_id" {
  description = "Subnet ID for firewall management interface."
}

variable "mgmt_ip" {
  description = "Internal IP address for firewall management interface."
}

variable "mgmt_sg_id" {
  description = "Security group ID for firewall management interface."
}

variable "eth1_subnet_id" {
  description = "Subnet ID for firewall ethernet1/1 interface."
}

variable "eth1_ip" {
  description = "Internal IP address for firewall ethernet1/1 interface."
}

variable "eth1_sg_id" {
  description = "Security group ID for firewall ethernet1/1 interface."
}

variable "eth2_subnet_id" {
  description = "Subnet ID for firewall ethernet1/2 interface."
}

variable "eth2_ip" {
  description = "Internal IP address for firewall ethernet1/2 interface."
}

variable "eth2_sg_id" {
  description = "Security group ID for firewall ethernet1/2 interface."
}

# Optional variables

variable "ami" {
  description = "Firewall AMI in specified region.  Default is 9.0.3.xfr BYOL."
  default     = "ami-0ec2529b60a7fff22"
}

variable "instance_type" {
  description = "Instance type for firewall."
  default     = "m4.xlarge"
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile used to bootstrap firewall."
  default     = ""
}

variable "bootstrap_bucket" {
  description = "S3 bucket containing bootstrap configuration."
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources."
  default     = {}
}
