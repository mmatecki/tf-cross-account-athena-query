resource "aws_cloudformation_stack" "this" {
  name = "cross-account-ds-data-source"
  parameters = {
    CatalogName = var.local_catalog_name
    LambdaARN   = var.cross_account_lambda_arn
  }
  template_body = <<STACK
{
  "Parameters" : {
    "CatalogName" : {
      "Type" : "String"
    },
    "LambdaARN" : {
      "Type" : "String"
    }
  },
  "Resources" : {
    "CrossAccountDataCatalog": {
      "Type" : "AWS::Athena::DataCatalog",
      "Properties" : {
        "Name": {"Ref":"CatalogName"},
        "Type":"HIVE",
        "Description" : "Hive metastore catalog allowing cross-account requests to data AWS account",
        "Parameters" : {
            "metadata-function": {"Ref":"LambdaARN"}
        }
      }
    }
  }
}
STACK

}