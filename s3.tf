resource "aws_s3_bucket" "test" {
  bucket        = "lemontech-test-bucket"
  force_destroy = true
}
