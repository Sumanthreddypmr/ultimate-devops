output "secret_arn" {
  value = aws_secretsmanager_secret.aws_creds.arn
}
