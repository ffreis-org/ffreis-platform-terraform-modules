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
| [aws_cloudwatch_log_group.exec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity_providers"></a> [capacity\_providers](#input\_capacity\_providers) | Capacity providers to associate with the cluster. Defaults to Fargate and Fargate Spot. | `list(string)` | <pre>[<br/>  "FARGATE",<br/>  "FARGATE_SPOT"<br/>]</pre> | no |
| <a name="input_default_capacity_provider_strategy"></a> [default\_capacity\_provider\_strategy](#input\_default\_capacity\_provider\_strategy) | Default capacity provider strategy applied to services that don't specify one. | <pre>list(object({<br/>    capacity_provider = string<br/>    weight            = optional(number, 1)<br/>    base              = optional(number, 0)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "base": 1,<br/>    "capacity_provider": "FARGATE",<br/>    "weight": 1<br/>  },<br/>  {<br/>    "base": 0,<br/>    "capacity_provider": "FARGATE_SPOT",<br/>    "weight": 4<br/>  }<br/>]</pre> | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | Enable CloudWatch Container Insights for the cluster. | `bool` | `true` | no |
| <a name="input_execute_command_kms_key_arn"></a> [execute\_command\_kms\_key\_arn](#input\_execute\_command\_kms\_key\_arn) | Optional customer-managed KMS key ARN for encrypting ECS Exec session data and audit logs. Null uses the default AWS-managed encryption path with no fixed monthly CMK cost. | `string` | `null` | no |
| <a name="input_execute_command_log_group_name"></a> [execute\_command\_log\_group\_name](#input\_execute\_command\_log\_group\_name) | CloudWatch log group name for ECS Exec audit logs. | `string` | `null` | no |
| <a name="input_execute_command_s3_bucket"></a> [execute\_command\_s3\_bucket](#input\_execute\_command\_s3\_bucket) | S3 bucket name for ECS Exec audit logs. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | ECS cluster name. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ECS cluster ARN. |
| <a name="output_id"></a> [id](#output\_id) | ECS cluster ID. |
| <a name="output_name"></a> [name](#output\_name) | ECS cluster name. |
<!-- END_TF_DOCS -->