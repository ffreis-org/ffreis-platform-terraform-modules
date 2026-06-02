terraform {
  # >= 1.9.0: this module's variable validations reference OTHER variables
  # (e.g. consumer_lambda_arn -> consumer_mode), which Terraform only permits
  # from 1.9.0 onward. Below that, `terraform validate` rejects the module.
  required_version = ">= 1.9.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
