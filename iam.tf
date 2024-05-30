
resource "aws_iam_policy" "s3writeread" {
  name        = "AllowWriteReadS3"
  description = "Allow write and read access to S3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:Put0bject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${aws_s3_bucket.test.id}/*"
      }
    ]
  })
}

module "iam_eks_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "rick-sa-role"

  role_policy_arns = {
    policy = aws_iam_policy.s3writeread.arn
  }

  oidc_providers = {
    one = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["default:rick"]
    }
  }
}
