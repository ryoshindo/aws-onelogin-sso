variable "onelogin_subdomain" {
  type = string
}

module "is_dev_ec2_describe" {
  source                   = "./module"
  max_session_duration     = 43200
  saml_provider_name       = "terraform_test"
  aws_role_name            = "terraform_test"
  aws_role_policy_name     = "terraform_test"
  onelogin_app_name        = "terraform_test"
  onelogin_app_description = "terraform_test"
  onelogin_subdomain       = var.onelogin_subdomain
}
