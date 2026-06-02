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
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Enable content-based deduplication (FIFO queues only). | `bool` | `false` | no |
| <a name="input_create_dlq"></a> [create\_dlq](#input\_create\_dlq) | Create a Dead-Letter Queue and configure the redrive policy. | `bool` | `true` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | Delivery delay in seconds (0–900). | `number` | `0` | no |
| <a name="input_dlq_message_retention_seconds"></a> [dlq\_message\_retention\_seconds](#input\_dlq\_message\_retention\_seconds) | Message retention on the DLQ (seconds). | `number` | `1209600` | no |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Create a FIFO queue. | `bool` | `false` | no |
| <a name="input_kms_data_key_reuse_period_seconds"></a> [kms\_data\_key\_reuse\_period\_seconds](#input\_kms\_data\_key\_reuse\_period\_seconds) | How long (seconds) SQS reuses a data key before requesting a new one (60–86400). | `number` | `300` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | Optional customer-managed KMS key ARN/alias for SSE-KMS. Null uses SQS-managed server-side encryption with no fixed monthly CMK cost. | `string` | `null` | no |
| <a name="input_max_message_size"></a> [max\_message\_size](#input\_max\_message\_size) | Maximum message size in bytes (1024–262144). | `number` | `262144` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | Number of times a message is delivered before being moved to the DLQ. | `number` | `5` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | Time a message is retained in the queue (60–1209600 seconds, default 4 days). | `number` | `345600` | no |
| <a name="input_name"></a> [name](#input\_name) | SQS queue name. For FIFO queues must end in '.fifo'. | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | JSON queue resource policy. null = no custom policy. | `string` | `null` | no |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | Long-poll wait time in seconds (0–20). 20 is recommended to reduce empty-receive costs. | `number` | `20` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | Visibility timeout in seconds (0–43200). Should exceed the consumer processing time. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dlq_arn"></a> [dlq\_arn](#output\_dlq\_arn) | DLQ ARN (empty if create\_dlq = false). |
| <a name="output_dlq_id"></a> [dlq\_id](#output\_dlq\_id) | DLQ URL (empty if create\_dlq = false). |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | Queue ARN. |
| <a name="output_queue_id"></a> [queue\_id](#output\_queue\_id) | Queue URL (used as the queue ID). |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | Queue name. |
<!-- END_TF_DOCS -->