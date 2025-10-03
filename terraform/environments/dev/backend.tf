terraform {
  backend "s3" {
    bucket         = "sumanth-buckert91231"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "sumanth-tablee91231"
    encrypt        = true
  }
}
