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
| [aws_cloudwatch_metric_alarm.alb_5xx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.alb_target_response_time](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ecs_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ecs_memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.lambda_duration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.lambda_errors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.lambda_throttles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.rds_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.rds_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.sqs_age](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.sqs_dlq_depth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | SNS topic ARNs to notify when an alarm fires. | `list(string)` | `[]` | no |
| <a name="input_alb_alarms"></a> [alb\_alarms](#input\_alb\_alarms) | Map of ALB full name (load\_balancer attribute) → alarm thresholds. | <pre>map(object({<br/>    error_5xx_threshold  = optional(number, 10) # count per period<br/>    error_4xx_threshold  = optional(number, null)<br/>    target_response_time = optional(number, 2) # seconds p95<br/>  }))</pre> | `{}` | no |
| <a name="input_ecs_alarms"></a> [ecs\_alarms](#input\_ecs\_alarms) | Map of 'cluster/service' → alarm thresholds. | <pre>map(object({<br/>    cpu_threshold    = optional(number, 80) # %<br/>    memory_threshold = optional(number, 80) # %<br/>  }))</pre> | `{}` | no |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | Number of periods over which data is compared to the threshold. | `number` | `3` | no |
| <a name="input_lambda_alarms"></a> [lambda\_alarms](#input\_lambda\_alarms) | Map of Lambda function name → alarm thresholds. | <pre>map(object({<br/>    error_rate_threshold   = optional(number, 1)    # % of invocations that error<br/>    throttle_threshold     = optional(number, 5)    # count per evaluation period<br/>    duration_p99_threshold = optional(number, null) # ms — null = skip<br/>    concurrent_threshold   = optional(number, null) # count — null = skip<br/>  }))</pre> | `{}` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for all alarm names. | `string` | n/a | yes |
| <a name="input_ok_actions"></a> [ok\_actions](#input\_ok\_actions) | SNS topic ARNs to notify when an alarm recovers. | `list(string)` | `[]` | no |
| <a name="input_period_seconds"></a> [period\_seconds](#input\_period\_seconds) | Period in seconds for each evaluation point. | `number` | `60` | no |
| <a name="input_rds_alarms"></a> [rds\_alarms](#input\_rds\_alarms) | Map of RDS instance identifier → alarm thresholds. | <pre>map(object({<br/>    cpu_threshold           = optional(number, 80)         # %<br/>    free_storage_bytes      = optional(number, 5368709120) # 5 GiB<br/>    connection_threshold    = optional(number, null)       # count — null = skip<br/>    read_latency_threshold  = optional(number, null)       # seconds — null = skip<br/>    write_latency_threshold = optional(number, null)       # seconds — null = skip<br/>  }))</pre> | `{}` | no |
| <a name="input_sqs_alarms"></a> [sqs\_alarms](#input\_sqs\_alarms) | Map of SQS queue name → alarm thresholds. | <pre>map(object({<br/>    dlq_depth_threshold   = optional(number, 1)    # messages in DLQ<br/>    queue_depth_threshold = optional(number, null) # messages visible — null = skip<br/>    age_threshold_seconds = optional(number, null) # oldest message age — null = skip<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all alarms. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_alarm_arns"></a> [alb\_alarm\_arns](#output\_alb\_alarm\_arns) | Map of alarm name → ARN for all ALB alarms. |
| <a name="output_ecs_alarm_arns"></a> [ecs\_alarm\_arns](#output\_ecs\_alarm\_arns) | Map of alarm name → ARN for all ECS alarms. |
| <a name="output_lambda_alarm_arns"></a> [lambda\_alarm\_arns](#output\_lambda\_alarm\_arns) | Map of alarm name → ARN for all Lambda alarms. |
| <a name="output_rds_alarm_arns"></a> [rds\_alarm\_arns](#output\_rds\_alarm\_arns) | Map of alarm name → ARN for all RDS alarms. |
| <a name="output_sqs_alarm_arns"></a> [sqs\_alarm\_arns](#output\_sqs\_alarm\_arns) | Map of alarm name → ARN for all SQS alarms. |
<!-- END_TF_DOCS -->