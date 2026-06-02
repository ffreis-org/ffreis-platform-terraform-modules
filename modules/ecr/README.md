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
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | Optional encryption type for the repository. Null defaults to 'AES256' for zero fixed cost unless kms\_key\_arn is set, in which case 'KMS' is used. | `string` | `null` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Allow Terraform to delete the repository even when it contains images. | `bool` | `false` | no |
| <a name="input_keep_image_count"></a> [keep\_image\_count](#input\_keep\_image\_count) | Keep the N most recent tagged images. 0 = keep all. Ignored if lifecycle\_policy is set. | `number` | `30` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Optional customer-managed KMS key ARN for repository encryption. Null keeps the default zero-fixed-cost encryption mode. | `string` | `null` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | JSON ECR lifecycle policy. null = AWS default (keep all images). | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | ECR repository name. | `string` | n/a | yes |
| <a name="input_repository_policy"></a> [repository\_policy](#input\_repository\_policy) | JSON ECR repository resource policy (cross-account access). null = private only. | `string` | `null` | no |
| <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push) | Scan images for vulnerabilities on push. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_untagged_image_expiry_days"></a> [untagged\_image\_expiry\_days](#input\_untagged\_image\_expiry\_days) | Expire untagged images after this many days. 0 = disabled. Ignored if lifecycle\_policy is set. | `number` | `14` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_registry_id"></a> [registry\_id](#output\_registry\_id) | Registry ID (AWS account ID). |
| <a name="output_repository_arn"></a> [repository\_arn](#output\_repository\_arn) | ECR repository ARN. |
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | ECR repository name. |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | ECR repository URL (used in docker push/pull commands). |
<!-- END_TF_DOCS -->