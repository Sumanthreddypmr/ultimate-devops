provider "aws" {
  region = var.aws_region
}

resource "aws_secretsmanager_secret" "aws_creds" {
  name        = "devops/github-actions/aws-creds"
  description = "AWS creds for GitHub Actions CI/CD"
}

resource "aws_secretsmanager_secret_version" "aws_creds_version" {
  secret_id     = aws_secretsmanager_secret.aws_creds.id
  secret_string = jsonencode({
    AWS_ACCESS_KEY_ID     = var.aws_access_key
    AWS_SECRET_ACCESS_KEY = var.aws_secret_key
    AWS_REGION            = var.aws_region
  })
}
