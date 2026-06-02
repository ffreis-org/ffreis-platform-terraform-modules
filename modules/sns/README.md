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
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Enable content-based deduplication (FIFO topics only). | `bool` | `false` | no |
| <a name="input_delivery_policy"></a> [delivery\_policy](#input\_delivery\_policy) | JSON HTTP/HTTPS delivery retry policy. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name used in SMS messages and email subjects. | `string` | `""` | no |
| <a name="input_fifo_topic"></a> [fifo\_topic](#input\_fifo\_topic) | Create a FIFO topic. | `bool` | `false` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | Optional customer-managed KMS key ARN/alias for SSE. Null uses the AWS-managed SNS key with no fixed monthly CMK cost. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | SNS topic name. For FIFO topics must end in '.fifo'. | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | JSON topic access policy. null = AWS default (account-only). | `string` | `null` | no |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | Map of subscription name → configuration.<br/>protocol: email \| email-json \| http \| https \| lambda \| sqs \| sms \| firehose<br/>endpoint: ARN, URL, or phone number depending on the protocol.<br/>filter\_policy: optional JSON attribute filter. | <pre>map(object({<br/>    protocol                        = string<br/>    endpoint                        = string<br/>    raw_message_delivery            = optional(bool, false)<br/>    filter_policy                   = optional(string, null)<br/>    filter_policy_scope             = optional(string, "MessageAttributes")<br/>    confirmation_timeout_in_minutes = optional(number, 1)<br/>    endpoint_auto_confirms          = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | SNS topic ARN. |
| <a name="output_name"></a> [name](#output\_name) | SNS topic name. |
| <a name="output_subscription_arns"></a> [subscription\_arns](#output\_subscription\_arns) | Map of subscription name → subscription ARN. |
<!-- END_TF_DOCS -->