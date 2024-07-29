terraform {
  backend "s3" {
    bucket = "lemontech-devops-sandbox-state"
    key    = "test.tfstate"
    region = "us-east-1"
  }
}
