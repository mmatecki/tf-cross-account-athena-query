locals {
  filename = "${path.module}/function/function.zip"
}


resource "aws_lambda_function" "this" {
  filename      = local.filename
  function_name = var.function_name
  handler       = "heracles.lambda.handler"
  role          = aws_iam_role.this.arn
  runtime       = "python3.8"
  description   = format("Allows Amazon Athena to query an AWS Glue Data Catalog in a %s account", var.target_account_id)
  memory_size   = 1024

  environment {
    variables = {
      TARGET_ACCOUNT_ID = var.target_account_id
      CATALOG_NAME      = var.target_catalog_name
      CATALOG_REGION    = var.target_catalog_region
      S3_SPILL_LOCATION = aws_s3_bucket.lambda_spill_bucket.bucket_regional_domain_name
      S3_SPILL_TTL      = var.s3_spill_ttl
    }
  }
}