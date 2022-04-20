
//--------------------------------------------------------------------
// Network Resources - Creating public and private subnets.
// Using public subnets for TFE example.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "${var.environment_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.availability_zones
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = merge(var.default_base_tags, {
    Name = "${var.environment_name}-vpc"
  })
}

# Getting your public IP for the inbound security rules.
# This may not work depending on your egress
data "external" "myip" {
  program = ["curl", "http://ipinfo.io"]
}

resource "aws_security_group" "tfe-sg" {
  name        = "${var.environment_name}-sg"
  description = "SSH and Internal Traffic"
  vpc_id      = module.vpc.vpc_id

  tags = merge(var.default_base_tags, {
    Name = "${var.environment_name}-sg"
  })

  # SSH - Administrative
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.external.myip.result.ip}/32"]
  }

  # TFE Setup Web UI
  ingress {
    from_port   = 8800
    to_port     = 8800
    protocol    = "tcp"
    cidr_blocks = ["${data.external.myip.result.ip}/32"]
  }

  # TFE Console
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${data.external.myip.result.ip}/32"]
  }

  # PostgreSQL Connection
  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}