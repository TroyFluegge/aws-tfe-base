# AWS region and AZs in which to deploy
variable "aws_region" {
  default = "us-east-1"
}

variable "availability_zones" {
 default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# All resources will be tagged with this
variable "environment_name" {
  default = "tfe-install"
}

variable "tfe_server_names" {
  description = "Names of the TFE node"
  type        = list(string)
  default     = ["tfe_1"]
}

variable "tfe_server_private_ips" {
  description = "The private ips of the tfe nodes that will join the cluster"
  # @see https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
  type    = list(string)
  default = ["10.0.1.10"]
}

# Instance size
variable "instance_type" {
  default = "t2.medium"
}

# Standand Resources Tags
variable "default_base_tags" {
  description = "Required tags for the environment"
  type        = map(string)
}

variable "dbusername" {
  description = "Default database username"
  default        = "root"
}

variable "airgap_file" {
  description = "Airgap Filename"
  default        = "tfe.airgap"
}