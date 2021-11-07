terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  # required_version = decide based on child modules
}

variable "aws_region" {
  type = string
  default = "ca-central-1"
}

provider "aws" {
  region  = var.aws_region
  default_tags {
    tags = var.meta.project_tags
  }
}

data "terraform_remote_state" "app" {
  backend = "s3"
  config = {
    bucket = "my-tfstate-bucket"
    key    = "tfstates/${var.meta.project_slug}.tfstate"
    region = var.aws_region
    encrypt = true
  }
}

## Networking
module "vpc" {
  source = "../modules/vpc"

  vpc_config = var.vpc_config
  meta = var.meta
}

## APPS
module "app" {
  source = "../modules/app"

  provisioned_vpc = module.vpc
  app_config = var.app_config
  meta = var.meta
}
