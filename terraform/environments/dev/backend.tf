terraform {
  backend "s3" {
    bucket         = "sumanth-buckert9123"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "sumanth-tablee9123"
    encrypt        = true
  }
}
