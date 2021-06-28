variable "saml_provider_name" {
  type = string
}

variable "aws_role_name" {
  type = string
}

variable "aws_role_policy_name" {
  type = string
}

variable "max_session_duration" {
  type    = number
  default = 43200 # 12h
}

variable "onelogin_app_name" {
  type = string
}

variable "onelogin_subdomain" {
  type = string
}

variable "onelogin_app_description" {
  type = string
}

locals {
  saml_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/${var.saml_provider_name}"
  role_arn          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.aws_role_name}"
  cert_id           = replace(onelogin_saml_apps.aws_saml.sso.issuer, "https://app.onelogin.com/saml/metadata/", "")
}
