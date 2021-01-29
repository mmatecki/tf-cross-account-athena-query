variable "function_name" {
  type    = string
  default = "cross-account-ds-athena"
}

variable "target_account_id" {
  type = string
}

variable "local_catalog_name" {
  type    = string
  default = "ds"
}

variable "target_catalog_name" {
  type    = string
  default = "AwsDataCatalog"
}

variable "target_catalog_region" {
  type    = string
  default = "eu-west-1"
}

variable "s3_spill_ttl" {
  type    = number
  default = 0
}