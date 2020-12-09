terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.19.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.8.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "docker" {
}