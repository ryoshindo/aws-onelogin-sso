resource "aws_iam_role_policy" "ec2_describe" {
  name = "ec2_describe_policy"
  role = aws_iam_role.saml_sso_role.id

  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Action" : [
          "ec2:Describe*",
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
    ]
  })
}