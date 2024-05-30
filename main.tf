terraform {
  backend "s3" {
    bucket = "lemontech-devops-test-state"
    key    = "test.tfstate"
    region = "us-east-1"
  }
}
