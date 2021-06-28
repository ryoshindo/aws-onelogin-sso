data "aws_caller_identity" "current" {}

resource "aws_iam_saml_provider" "service_provider" {
  name                   = var.saml_provider_name
  saml_metadata_document = <<XML
<?xml version="1.0"?>
<EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata" entityID="${onelogin_saml_apps.aws_saml.sso.issuer}">
  <IDPSSODescriptor xmlns:ds="http://www.w3.org/2000/09/xmldsig#" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
    <KeyDescriptor use="signing">
      <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
        <ds:X509Data>
          <ds:X509Certificate>${replace(replace(onelogin_saml_apps.aws_saml.certificate.value, "-----BEGIN CERTIFICATE-----\n", ""), "-----END CERTIFICATE-----\n", "")}</ds:X509Certificate>
        </ds:X509Data>
      </ds:KeyInfo>
    </KeyDescriptor>
    <SingleLogoutService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="${onelogin_saml_apps.aws_saml.sso.sls_url}"/>
    
      <NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</NameIDFormat>
    
    <SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="https://${var.onelogin_subdomain}.onelogin.com/trust/saml2/http-redirect/sso/${local.cert_id}"/>
    <SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="${onelogin_saml_apps.aws_saml.sso.acs_url}"/>
    <SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:SOAP" Location="https://${var.onelogin_subdomain}.onelogin.com/trust/saml2/soap/sso/${local.cert_id}"/>
  </IDPSSODescriptor>
</EntityDescriptor>
XML
}

resource "aws_iam_role" "saml_sso_role" {
  name                 = var.aws_role_name
  max_session_duration = var.max_session_duration

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : local.saml_provider_arn
        },
        "Action" : "sts:AssumeRoleWithSAML",
        "Condition" : {
          "StringEquals" : {
            "SAML:aud" : "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
}

resource "onelogin_saml_apps" "aws_saml" {
  connector_id = 30319
  name         = var.onelogin_app_name
  description  = var.onelogin_app_description

  parameters {
    param_key_name             = "https://aws.amazon.com/SAML/Attributes/RoleSessionName"
    default_values             = null
    provisioned_entitlements   = false
    values                     = null
    label                      = "RoleSessionName"
    user_attribute_mappings    = "email"
    user_attribute_macros      = null
    skip_if_blank              = false
    attributes_transformations = ""
  }

  parameters {
    param_key_name             = "https://aws.amazon.com/SAML/Attributes/Role"
    default_values             = null
    provisioned_entitlements   = false
    values                     = null
    label                      = "Role"
    user_attribute_mappings    = "_macro_"
    user_attribute_macros      = "${local.role_arn},${local.saml_provider_arn}"
    skip_if_blank              = false
    attributes_transformations = null
  }

  parameters {
    param_key_name             = "saml_username"
    default_values             = null
    provisioned_entitlements   = false
    values                     = null
    label                      = "Amazon Username"
    user_attribute_mappings    = "email"
    user_attribute_macros      = null
    skip_if_blank              = false
    attributes_transformations = ""
  }

  configuration = {
    signature_algorithm = "SHA-1"
  }

}