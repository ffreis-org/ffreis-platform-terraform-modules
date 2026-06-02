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
| [aws_appautoscaling_policy.cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.task_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.task_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.ecs_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Assign a public IP to the task ENI. Required for Fargate in public subnets without NAT. | `bool` | `false` | no |
| <a name="input_autoscaling_cpu_target"></a> [autoscaling\_cpu\_target](#input\_autoscaling\_cpu\_target) | Target CPU utilisation percentage for auto-scaling. null = no CPU scaling. | `number` | `70` | no |
| <a name="input_autoscaling_max_capacity"></a> [autoscaling\_max\_capacity](#input\_autoscaling\_max\_capacity) | Maximum task count for auto-scaling. | `number` | `null` | no |
| <a name="input_autoscaling_memory_target"></a> [autoscaling\_memory\_target](#input\_autoscaling\_memory\_target) | Target memory utilisation percentage for auto-scaling. null = no memory scaling. | `number` | `80` | no |
| <a name="input_autoscaling_min_capacity"></a> [autoscaling\_min\_capacity](#input\_autoscaling\_min\_capacity) | Minimum task count for auto-scaling. null = no auto-scaling. | `number` | `null` | no |
| <a name="input_capacity_provider_strategy"></a> [capacity\_provider\_strategy](#input\_capacity\_provider\_strategy) | Capacity provider strategy. Defaults to FARGATE\_SPOT with FARGATE base. | <pre>list(object({<br/>    capacity_provider = string<br/>    weight            = optional(number, 1)<br/>    base              = optional(number, 0)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "base": 1,<br/>    "capacity_provider": "FARGATE",<br/>    "weight": 1<br/>  },<br/>  {<br/>    "base": 0,<br/>    "capacity_provider": "FARGATE_SPOT",<br/>    "weight": 4<br/>  }<br/>]</pre> | no |
| <a name="input_cluster_arn"></a> [cluster\_arn](#input\_cluster\_arn) | ARN of the ECS cluster. | `string` | n/a | yes |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | JSON array of container definitions. Use jsonencode(). | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | Task CPU units (256, 512, 1024, 2048, 4096). | `number` | `256` | no |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | Maximum running tasks during deployment (percentage of desired\_count). | `number` | `200` | no |
| <a name="input_deployment_minimum_healthy_percent"></a> [deployment\_minimum\_healthy\_percent](#input\_deployment\_minimum\_healthy\_percent) | Minimum healthy tasks during deployment (percentage of desired\_count). | `number` | `100` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Number of tasks to run. | `number` | `1` | no |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | Enable ECS Exec for interactive debugging. Disable in production unless actively debugging. | `bool` | `false` | no |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | Grace period after task start before ALB health checks matter. | `number` | `30` | no |
| <a name="input_load_balancers"></a> [load\_balancers](#input\_load\_balancers) | List of ALB/NLB target group associations. | <pre>list(object({<br/>    target_group_arn = string<br/>    container_name   = string<br/>    container_port   = number<br/>  }))</pre> | `[]` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Task memory in MiB. | `number` | `512` | no |
| <a name="input_name"></a> [name](#input\_name) | ECS service name. | `string` | n/a | yes |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Task network mode. Fargate requires 'awsvpc'. | `string` | `"awsvpc"` | no |
| <a name="input_propagate_tags"></a> [propagate\_tags](#input\_propagate\_tags) | Propagate tags to tasks: 'SERVICE' or 'TASK\_DEFINITION'. | `string` | `"SERVICE"` | no |
| <a name="input_requires_compatibilities"></a> [requires\_compatibilities](#input\_requires\_compatibilities) | Launch types: ['FARGATE'] or ['EC2']. | `list(string)` | <pre>[<br/>  "FARGATE"<br/>]</pre> | no |
| <a name="input_runtime_platform"></a> [runtime\_platform](#input\_runtime\_platform) | OS family and CPU architecture for Fargate. | <pre>object({<br/>    operating_system_family = optional(string, "LINUX")<br/>    cpu_architecture        = optional(string, "ARM64")<br/>  })</pre> | `{}` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs attached to the task ENI. | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs for the awsvpc network interface (private subnets recommended). | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_task_execution_role_arn"></a> [task\_execution\_role\_arn](#input\_task\_execution\_role\_arn) | IAM role ARN for the ECS task execution role (pull images, write logs). Leave null to create one. | `string` | `null` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | IAM role ARN the running task assumes for AWS API calls. Leave null to create one. | `string` | `null` | no |
| <a name="input_task_role_inline_policies"></a> [task\_role\_inline\_policies](#input\_task\_role\_inline\_policies) | Map of inline policy name → JSON for the task role (used when task\_role\_arn = null). | `map(string)` | `{}` | no |
| <a name="input_task_role_managed_policy_arns"></a> [task\_role\_managed\_policy\_arns](#input\_task\_role\_managed\_policy\_arns) | Managed policy ARNs for the task role (used when task\_role\_arn = null). | `list(string)` | `[]` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | EFS or bind-mount volumes to attach to the task. | <pre>list(object({<br/>    name = string<br/>    efs_volume_configuration = optional(object({<br/>      file_system_id     = string<br/>      root_directory     = optional(string, "/")<br/>      transit_encryption = optional(string, "ENABLED")<br/>      authorization_config = optional(object({<br/>        access_point_id = optional(string, null)<br/>        iam             = optional(string, "ENABLED")<br/>      }), null)<br/>    }), null)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | Task execution IAM role ARN. |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ECS service ID. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | ECS service name. |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | Active task definition ARN. |
| <a name="output_task_definition_family"></a> [task\_definition\_family](#output\_task\_definition\_family) | Task definition family name. |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | Task IAM role ARN. |
| <a name="output_task_role_name"></a> [task\_role\_name](#output\_task\_role\_name) | Task IAM role name. |
<!-- END_TF_DOCS -->