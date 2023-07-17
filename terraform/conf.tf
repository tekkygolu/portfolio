terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "terraform-backend-<<AWS_ACCOUNT_ID>>"
    key    = "aws_stuff/projects/anjalis_portfolio/terraform"
    region = "us-east-1"
    profile = "AdministratorAccess-<<AWS_ACCOUNT_ID>>"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "AdministratorAccess-<<AWS_ACCOUNT_ID>>"
}