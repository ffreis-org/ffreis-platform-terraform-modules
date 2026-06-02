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
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_event_source_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [terraform_data.destroy_guard](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [aws_iam_policy_document.lambda_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture: ['x86\_64'] or ['arm64']. | `list(string)` | <pre>[<br/>  "arm64"<br/>]</pre> | no |
| <a name="input_dead_letter_target_arn"></a> [dead\_letter\_target\_arn](#input\_dead\_letter\_target\_arn) | ARN of an SQS queue or SNS topic for failed async invocations. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Human-readable description of the function. | `string` | `""` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Map of environment variables passed to the function. | `map(string)` | `{}` | no |
| <a name="input_event_source_mappings"></a> [event\_source\_mappings](#input\_event\_source\_mappings) | Map of event source name → configuration (SQS, DynamoDB Streams, Kinesis, MSK). | <pre>map(object({<br/>    event_source_arn                   = string<br/>    batch_size                         = optional(number, 10)<br/>    maximum_batching_window_in_seconds = optional(number, 0)<br/>    starting_position                  = optional(string, null) # TRIM_HORIZON | LATEST | AT_TIMESTAMP<br/>    enabled                            = optional(bool, true)<br/>    bisect_batch_on_function_error     = optional(bool, false)<br/>    maximum_retry_attempts             = optional(number, null)<br/>    parallelization_factor             = optional(number, null)<br/>    tumbling_window_in_seconds         = optional(number, null)<br/>    function_response_types            = optional(list(string), [])<br/>    filter_criteria = optional(list(object({<br/>      pattern = string<br/>    })), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | Use an existing IAM role ARN instead of creating one. When set, managed\_policy\_arns and inline\_policies are ignored. | `string` | `null` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | Path to the deployment package (zip). Mutually exclusive with image\_uri and s3\_bucket. | `string` | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Lambda function name. | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Function entry point (e.g. 'index.handler' for Node.js, 'main' for Go). | `string` | n/a | yes |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | ECR image URI. Mutually exclusive with filename. Package type becomes 'Image'. | `string` | `null` | no |
| <a name="input_inline_policies"></a> [inline\_policies](#input\_inline\_policies) | Map of inline policy name → JSON for the execution role. | `map(string)` | `{}` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS key ARN for encrypting environment variables and X-Ray traces. | `string` | `null` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda layer ARNs to attach (max 5). | `list(string)` | `[]` | no |
| <a name="input_log_kms_key_arn"></a> [log\_kms\_key\_arn](#input\_log\_kms\_key\_arn) | KMS key ARN for the Lambda CloudWatch log group. | `string` | `null` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days for /aws/lambda/<function\_name>. | `number` | `365` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | Managed policy ARNs to attach to the execution role (in addition to AWSLambdaBasicExecutionRole). | `list(string)` | `[]` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Lambda memory allocation in MB (128–10240). | `number` | `128` | no |
| <a name="input_prevent_destroy"></a> [prevent\_destroy](#input\_prevent\_destroy) | Set true in production to block accidental resource destruction. Uses a terraform\_data guard — to destroy the module, set this to false and apply first. | `bool` | `false` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | Reserved concurrency for this function. -1 = unreserved. | `number` | `-1` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda runtime identifier (e.g. 'python3.12', 'nodejs22.x', 'provided.al2023'). | `string` | n/a | yes |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | S3 bucket containing the deployment package. Must be set together with s3\_key. Mutually exclusive with filename and image\_uri. | `string` | `null` | no |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | S3 object key for the deployment package zip. Must be set together with s3\_bucket. | `string` | `null` | no |
| <a name="input_s3_object_version"></a> [s3\_object\_version](#input\_s3\_object\_version) | S3 object version ID of the deployment package. Optional. | `string` | `null` | no |
| <a name="input_source_code_hash"></a> [source\_code\_hash](#input\_source\_code\_hash) | Base64-encoded SHA-256 hash of the package. Used to detect changes. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Function timeout in seconds (1–900). | `number` | `30` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | Security group IDs for VPC-attached Lambda. | `list(string)` | `[]` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | Subnet IDs for VPC-attached Lambda. Empty = no VPC attachment. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | IAM execution role ARN. |
| <a name="output_execution_role_name"></a> [execution\_role\_name](#output\_execution\_role\_name) | IAM execution role name (empty if an external role was provided). |
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | Lambda function ARN. |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Lambda function name. |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | ARN used to invoke the function from API Gateway or other services. |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | CloudWatch log group ARN. |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | CloudWatch log group name for this function. |
| <a name="output_qualified_arn"></a> [qualified\_arn](#output\_qualified\_arn) | Qualified ARN (includes function version). |
<!-- END_TF_DOCS -->