terraform {
  backend "s3" {
    bucket         = "demo-terraform-states-backend-ref"
    key            = "ec2/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "demo-terraform-states-backend-ref"
    encrypt        = true
  }
}
locals {
  deployment_prefix = "demo-terraform"
}
provider "aws" {
  region = "eu-north-1"
  default_tags {
    tags = {
      "TerminationDate"  = "Permanent",
      "Environment"      = "Development",
      "Team"             = "DevOps",
      "DeployedBy"       = "Terraform",
      "OwnerEmail"       = "devops@example.com"
      "DeploymentPrefix" = local.deployment_prefix
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "demo-terraform-states-backend-ref"
    key    = "vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}
data "terraform_remote_state" "sg" {
  backend = "s3"
  config = {
    bucket = "demo-terraform-states-backend-ref"
    key    = "sg/terraform.tfstate"
    region = "eu-north-1"
  }
}
module "ec2" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "5.6.1"
  name                   = "${local.deployment_prefix}-bastion-host"
  instance_type          = "t2.micro"
  ami                    = "ami-023adaba598e661ac"
  vpc_security_group_ids = [data.terraform_remote_state.sg.outputs.sg_id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  tags = {
    Name = "${local.deployment_prefix}-bastion-host"
  }
}
