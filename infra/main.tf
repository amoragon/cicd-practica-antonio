terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.3.0"
    }
  }

  backend "s3" {
    bucket = "kc-terraform-backend"
    key    = "backend"
    region = var.aws_region
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "kc_acme_storage" {
  bucket = lookup(var.bucket, var.environment)

  tags = {
    Name        = lookup(var.bucket, var.environment)
    Environment = var.environment
  }
}
