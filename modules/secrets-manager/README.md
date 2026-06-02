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
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_policy) | resource |
| [aws_secretsmanager_secret_rotation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Human-readable description of the secret. | `string` | `""` | no |
| <a name="input_enable_rotation"></a> [enable\_rotation](#input\_enable\_rotation) | Enable automatic secret rotation. | `bool` | `false` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ARN/ID for encrypting the secret. null = AWS-managed key. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Secret name (or prefix when name\_prefix is used). | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | JSON resource policy. null = no resource policy. | `string` | `null` | no |
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | Number of days before a secret is permanently deleted after deletion (0 = immediate, 7–30). | `number` | `30` | no |
| <a name="input_rotation_automatically_after_days"></a> [rotation\_automatically\_after\_days](#input\_rotation\_automatically\_after\_days) | Rotate the secret every N days. | `number` | `30` | no |
| <a name="input_rotation_lambda_arn"></a> [rotation\_lambda\_arn](#input\_rotation\_lambda\_arn) | ARN of the Lambda function that handles rotation. Required when enable\_rotation = true. | `string` | `null` | no |
| <a name="input_secret_binary"></a> [secret\_binary](#input\_secret\_binary) | The secret value as base64-encoded bytes. Mutually exclusive with secret\_string. | `string` | `null` | no |
| <a name="input_secret_string"></a> [secret\_string](#input\_secret\_string) | The secret value as a string (plain text or JSON). Mutually exclusive with secret\_binary. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_use_name_prefix"></a> [use\_name\_prefix](#input\_use\_name\_prefix) | Use var.name as a prefix (adds a unique suffix to avoid conflicts). | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | Secret ARN. |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | Secret ID (same as ARN for Secrets Manager). |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Secret name. |
| <a name="output_version_id"></a> [version\_id](#output\_version\_id) | Secret version ID of the current secret value. |
<!-- END_TF_DOCS -->