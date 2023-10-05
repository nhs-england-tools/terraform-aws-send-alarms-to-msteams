terraform {
  required_version = ">= 1.3.9"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.19"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}
