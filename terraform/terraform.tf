terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket         = "tfstate-reverseesper"
    region         = "eu-west-1"
    key            = "services/ewelink.tfstate"
    dynamodb_table = "terraform_locks"
  }
}

provider "aws" {
  region = "eu-west-1"
}