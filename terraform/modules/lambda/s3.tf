locals {
  s3_spill_bucket = format("%s-%s-spill", var.function_name, data.aws_region.region.name)
}

resource "aws_s3_bucket" "lambda_spill_bucket" {
  bucket = local.s3_spill_bucket
  versioning {
    enabled = false
  }
  acl           = "private"
  force_destroy = true
}