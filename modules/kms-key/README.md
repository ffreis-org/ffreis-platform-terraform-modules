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
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_principals"></a> [additional\_principals](#input\_additional\_principals) | List of IAM principal ARNs to grant Decrypt/GenerateDataKey in addition to the key owner. | `list(string)` | `[]` | no |
| <a name="input_alias"></a> [alias](#input\_alias) | KMS key alias (without the 'alias/' prefix). | `string` | n/a | yes |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Number of days after which the key is deleted following a deletion request (7–30). | `number` | `30` | no |
| <a name="input_description"></a> [description](#input\_description) | Human-readable description for the KMS key. | `string` | n/a | yes |
| <a name="input_multi_region"></a> [multi\_region](#input\_multi\_region) | Create a multi-Region primary key. | `bool` | `false` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | JSON IAM key policy. When null the default AWS key policy is used. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alias_arn"></a> [alias\_arn](#output\_alias\_arn) | KMS alias ARN. |
| <a name="output_alias_name"></a> [alias\_name](#output\_alias\_name) | KMS alias name (alias/...). |
| <a name="output_key_arn"></a> [key\_arn](#output\_key\_arn) | KMS key ARN. |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | KMS key ID. |
<!-- END_TF_DOCS -->