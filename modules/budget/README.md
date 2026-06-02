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
| [aws_budgets_budget.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_email_addresses"></a> [alert\_email\_addresses](#input\_alert\_email\_addresses) | Email addresses to notify when a threshold is breached. | `list(string)` | `[]` | no |
| <a name="input_alert_sns_arns"></a> [alert\_sns\_arns](#input\_alert\_sns\_arns) | SNS topic ARNs to notify when a threshold is breached. | `list(string)` | `[]` | no |
| <a name="input_alert_thresholds"></a> [alert\_thresholds](#input\_alert\_thresholds) | List of alert thresholds. Each entry fires an SNS notification when the<br/>threshold is breached.<br/>threshold\_percent: percentage of the budget limit (e.g. 80 = 80%).<br/>comparison\_operator: 'GREATER\_THAN' or 'EQUAL\_TO'.<br/>threshold\_type: 'PERCENTAGE' or 'ABSOLUTE\_VALUE'.<br/>notification\_type: 'ACTUAL' (real spend) or 'FORECASTED' (projected spend). | <pre>list(object({<br/>    threshold_percent   = number<br/>    comparison_operator = optional(string, "GREATER_THAN")<br/>    threshold_type      = optional(string, "PERCENTAGE")<br/>    notification_type   = optional(string, "ACTUAL")<br/>  }))</pre> | <pre>[<br/>  {<br/>    "notification_type": "ACTUAL",<br/>    "threshold_percent": 50<br/>  },<br/>  {<br/>    "notification_type": "ACTUAL",<br/>    "threshold_percent": 80<br/>  },<br/>  {<br/>    "notification_type": "ACTUAL",<br/>    "threshold_percent": 100<br/>  },<br/>  {<br/>    "notification_type": "FORECASTED",<br/>    "threshold_percent": 100<br/>  }<br/>]</pre> | no |
| <a name="input_budget_type"></a> [budget\_type](#input\_budget\_type) | 'COST' (default) or 'USAGE'. | `string` | `"COST"` | no |
| <a name="input_cost_filters"></a> [cost\_filters](#input\_cost\_filters) | Map of cost filter name → list of values (e.g. { Service = ['Amazon EC2'] }). | `map(list(string))` | `{}` | no |
| <a name="input_limit_amount"></a> [limit\_amount](#input\_limit\_amount) | Maximum spend in USD before alerts fire. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Budget name. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the budget. | `map(string)` | `{}` | no |
| <a name="input_time_unit"></a> [time\_unit](#input\_time\_unit) | Budget reset period: 'MONTHLY', 'QUARTERLY', or 'ANNUALLY'. | `string` | `"MONTHLY"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Budget ID. |
| <a name="output_name"></a> [name](#output\_name) | Budget name. |
<!-- END_TF_DOCS -->