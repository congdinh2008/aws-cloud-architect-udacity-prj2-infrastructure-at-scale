# TODO: Designate a cloud provider, region, and credentials
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

locals {
  name   = "udacitypr2"
  region = var.region
  azs    = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-rds"
  }
}

################################################################################
# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
################################################################################
resource "aws_key_pair" "ec2-t2-keypair" {
  key_name   = "ec2-t2-keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "t2_instance" {
  count                  = 4
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_t2_instance_type
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.ec2-t2-keypair.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  tags = {
    Name = var.ec2_t2_name
  }
}

################################################################################
# TODO: provision 2 m4.large EC2 instances named Udacity M4
################################################################################
resource "aws_key_pair" "ec2-m4-keypair" {
  key_name   = "ec2-m4-keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}

# resource "aws_instance" "m4_instance" {
#   count                  = 2
#   ami                    = data.aws_ami.amazon_linux.id
#   instance_type          = var.ec2_m4_instance_type
#   subnet_id              = var.subnet_id
#   key_name               = aws_key_pair.ec2-m4-keypair.key_name
#   vpc_security_group_ids = var.vpc_security_group_ids
#   tags = {
#     Name = var.ec2_m4_name
#   }
# }
