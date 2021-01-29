data "aws_region" "region" {}

module "cross-account-lambda" {
  source                = "./modules/lambda"
  function_name         = var.function_name
  s3_spill_ttl          = var.s3_spill_ttl
  target_account_id     = var.target_account_id
  target_catalog_name   = var.target_catalog_name
  target_catalog_region = var.target_catalog_region
}


module "cross-account-data-catalog" {
  source                   = "./modules/athena"
  local_catalog_name       = var.local_catalog_name
  cross_account_lambda_arn = module.cross-account-lambda.lambda_arn
}

output "cross-account-lambda-arn" {
  value = module.cross-account-lambda.role_arn
}

