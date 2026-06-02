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
| [aws_cloudwatch_log_group.sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.sfn_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.sfn_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_sfn_state_machine.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine) | resource |
| [aws_iam_policy_document.sfn_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sfn_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_definition"></a> [definition](#input\_definition) | Amazon States Language JSON definition of the state machine. | `string` | n/a | yes |
| <a name="input_enable_xray_tracing"></a> [enable\_xray\_tracing](#input\_enable\_xray\_tracing) | Enable X-Ray tracing. | `bool` | `true` | no |
| <a name="input_log_include_execution_data"></a> [log\_include\_execution\_data](#input\_log\_include\_execution\_data) | Include input/output data in execution logs. Disable if data is sensitive. | `bool` | `false` | no |
| <a name="input_log_kms_key_arn"></a> [log\_kms\_key\_arn](#input\_log\_kms\_key\_arn) | KMS key ARN for the execution log group. | `string` | `null` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Execution logging level: 'OFF', 'ERROR', 'FATAL', or 'ALL'. | `string` | `"ERROR"` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention for execution logs. | `number` | `365` | no |
| <a name="input_name"></a> [name](#input\_name) | State machine name. | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | IAM role ARN for the state machine. Leave null to create one. | `string` | `null` | no |
| <a name="input_role_inline_policies"></a> [role\_inline\_policies](#input\_role\_inline\_policies) | Map of inline policy name → JSON for the auto-created state machine role. | `map(string)` | `{}` | no |
| <a name="input_role_managed_policy_arns"></a> [role\_managed\_policy\_arns](#input\_role\_managed\_policy\_arns) | Managed policy ARNs for the auto-created state machine role. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | State machine type: 'STANDARD' (long-running, exactly-once) or 'EXPRESS' (high-throughput, at-least-once). | `string` | `"STANDARD"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | State machine ARN. |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | CloudWatch log group ARN for execution logs. |
| <a name="output_name"></a> [name](#output\_name) | State machine name. |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | IAM role ARN used by the state machine. |
<!-- END_TF_DOCS -->