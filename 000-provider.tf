terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.19.0"
    }
  }
}

provider "aws" {
  region = var.region
}
