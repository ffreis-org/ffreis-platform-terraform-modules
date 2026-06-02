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
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Human-readable description. | `string` | `""` | no |
| <a name="input_event_bus_name"></a> [event\_bus\_name](#input\_event\_bus\_name) | Name or ARN of the event bus. Defaults to the default event bus. | `string` | `"default"` | no |
| <a name="input_event_pattern"></a> [event\_pattern](#input\_event\_pattern) | JSON event pattern. Mutually exclusive with schedule\_expression. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | EventBridge rule name. | `string` | n/a | yes |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | Cron or rate expression (e.g. 'rate(5 minutes)', 'cron(0 12 * * ? *)'). Mutually exclusive with event\_pattern. | `string` | `null` | no |
| <a name="input_state"></a> [state](#input\_state) | Rule state: 'ENABLED' or 'DISABLED'. | `string` | `"ENABLED"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_targets"></a> [targets](#input\_targets) | Map of target name → configuration.<br/>arn: ARN of the target (Lambda, SQS, SNS, Kinesis, Step Functions, etc.).<br/>input:       Literal JSON string sent as event. Mutually exclusive with input\_path/input\_transformer.<br/>input\_path:  JSONPath string to extract part of the matched event.<br/>input\_transformer: Transform matched events (supports input\_paths\_map + input\_template).<br/>dead\_letter\_arn: SQS queue ARN for failed deliveries.<br/>retry\_policy: Optional retry configuration. | <pre>map(object({<br/>    arn        = string<br/>    role_arn   = optional(string, null)<br/>    input      = optional(string, null)<br/>    input_path = optional(string, null)<br/>    input_transformer = optional(object({<br/>      input_paths    = map(string)<br/>      input_template = string<br/>    }), null)<br/>    dead_letter_arn = optional(string, null)<br/>    retry_policy = optional(object({<br/>      maximum_event_age_in_seconds = number<br/>      maximum_retry_attempts       = number<br/>    }), null)<br/>    sqs_message_group_id = optional(string, null)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rule_arn"></a> [rule\_arn](#output\_rule\_arn) | EventBridge rule ARN. |
| <a name="output_rule_name"></a> [rule\_name](#output\_rule\_name) | EventBridge rule name. |
<!-- END_TF_DOCS -->