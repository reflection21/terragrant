terraform {
  backend "s3" {
    bucket         = "demo-terraform-states-backend-ref"
    key            = "tf-backend/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "demo-terraform-states-backend-ref"
    encrypt        = true
  }
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
      "DeploymentPrefix" = "demo-terraform"
    }
  }
}

module "tf_backend" {
  source         = "../../modules/tf-backend/"
  bucket_name    = "demo-terraform-states-backend-ref"
  dynamodb_table = "demo-terraform-states-backend-ref"
}
