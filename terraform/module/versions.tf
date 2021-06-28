terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    onelogin = {
      source = "onelogin/onelogin"
    }
  }
  required_version = ">= 0.13"
}
