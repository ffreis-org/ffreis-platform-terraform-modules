<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_sagemaker_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_domain) | resource |
| [aws_sagemaker_user_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_user_profile) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_network_access_type"></a> [app\_network\_access\_type](#input\_app\_network\_access\_type) | Network access type: 'PublicInternetOnly' or 'VpcOnly'. VpcOnly is recommended. | `string` | `"VpcOnly"` | no |
| <a name="input_auth_mode"></a> [auth\_mode](#input\_auth\_mode) | Authentication mode: 'IAM' or 'SSO'. | `string` | `"IAM"` | no |
| <a name="input_default_user_settings"></a> [default\_user\_settings](#input\_default\_user\_settings) | Default user settings for new Studio users. | <pre>object({<br/>    execution_role  = string # IAM role ARN used by Studio notebooks.<br/>    security_groups = optional(list(string), [])<br/>    sharing_settings = optional(object({<br/>      notebook_output_option = optional(string, "Disabled")<br/>      s3_kms_key_id          = optional(string, null)<br/>      s3_output_path         = optional(string, null)<br/>    }), null)<br/>  })</pre> | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | SageMaker Studio domain name. | `string` | n/a | yes |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ARN for encrypting SageMaker EFS and EBS volumes. | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs (private subnets recommended) for SageMaker Studio. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_user_profiles"></a> [user\_profiles](#input\_user\_profiles) | Map of user profile name → configuration. Each entry creates an aws\_sagemaker\_user\_profile. | <pre>map(object({<br/>    execution_role  = optional(string, null) # Override the domain default if needed.<br/>    security_groups = optional(list(string), [])<br/>    tags            = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for the SageMaker domain. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_arn"></a> [domain\_arn](#output\_domain\_arn) | SageMaker Studio domain ARN. |
| <a name="output_domain_id"></a> [domain\_id](#output\_domain\_id) | SageMaker Studio domain ID. |
| <a name="output_home_efs_file_system_id"></a> [home\_efs\_file\_system\_id](#output\_home\_efs\_file\_system\_id) | EFS file system ID backing the SageMaker home directories. |
| <a name="output_url"></a> [url](#output\_url) | Domain presigned URL for Studio access. |
| <a name="output_user_profile_arns"></a> [user\_profile\_arns](#output\_user\_profile\_arns) | Map of user profile name → ARN. |
<!-- END_TF_DOCS -->