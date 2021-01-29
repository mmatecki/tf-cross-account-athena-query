data "aws_region" "region" {}
locals {
  role_name   = lower(format("%s-%s-lambda-exec-role", var.function_name, data.aws_region.region.name))
  policy_name = lower(format("%s-%s-lambda-cross-account-ds", var.function_name, data.aws_region.region.name))
}

data "template_file" "lambda_role" {
  template = file("${path.module}/templates/role.json")
}

data "template_file" "lambda_policy" {
  template = file("${path.module}/templates/policy.json")
  vars = {
    targetAccount = var.target_account_id
    spillBucket   = aws_s3_bucket.lambda_spill_bucket.arn
  }
}

resource "aws_iam_role" "this" {
  name               = local.role_name
  assume_role_policy = data.template_file.lambda_role.rendered
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = format("Allows access cross account access to Glue (in %s account) & Cloudwatch logging", var.target_account_id)
  policy      = data.template_file.lambda_policy.rendered
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
