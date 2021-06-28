terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.35.0"
    }
    onelogin = {
      source  = "onelogin/onelogin"
      version = "0.1.23"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "onelogin" {}