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
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_bucket"></a> [access\_logs\_bucket](#input\_access\_logs\_bucket) | S3 bucket name for ALB access logs. Empty = disabled. | `string` | `""` | no |
| <a name="input_access_logs_prefix"></a> [access\_logs\_prefix](#input\_access\_logs\_prefix) | S3 prefix for access logs. | `string` | `""` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ACM certificate ARN for HTTPS listener. | `string` | `null` | no |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | Drop HTTP headers with invalid field values. Security hardening. | `bool` | `true` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Prevent the ALB from being deleted via the AWS API. | `bool` | `true` | no |
| <a name="input_https_listener_rules"></a> [https\_listener\_rules](#input\_https\_listener\_rules) | Map of rule name → listener rule on the HTTPS listener.<br/>target\_group: key from var.target\_groups that this rule forwards to.<br/>priority: rule evaluation priority (1–50000).<br/>conditions: list of path\_pattern or host\_header conditions. | <pre>map(object({<br/>    target_group = string<br/>    priority     = number<br/>    conditions = list(object({<br/>      field  = string # "path-pattern" | "host-header"<br/>      values = list(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | Connection idle timeout in seconds. | `number` | `60` | no |
| <a name="input_name"></a> [name](#input\_name) | ALB name (max 32 chars). | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs. A security group allowing inbound 80/443 from the internet is expected. | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs for the ALB. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | Map of target group name → configuration. Each entry is available as an<br/>output so listeners and ECS services can reference target group ARNs. | <pre>map(object({<br/>    port                 = number<br/>    protocol             = optional(string, "HTTP")<br/>    target_type          = optional(string, "ip") # ip | instance | lambda<br/>    deregistration_delay = optional(number, 30)<br/>    health_check = optional(object({<br/>      path                = optional(string, "/")<br/>      protocol            = optional(string, "HTTP")<br/>      matcher             = optional(string, "200-399")<br/>      interval            = optional(number, 30)<br/>      timeout             = optional(number, 5)<br/>      healthy_threshold   = optional(number, 2)<br/>      unhealthy_threshold = optional(number, 3)<br/>    }), {})<br/>    stickiness = optional(object({<br/>      enabled  = bool<br/>      duration = optional(number, 86400)<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID. | `string` | n/a | yes |
| <a name="input_waf_acl_arn"></a> [waf\_acl\_arn](#input\_waf\_acl\_arn) | WAF WebACL ARN to associate with the ALB. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ALB ARN. |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | ALB DNS name (point Route 53 alias records here). |
| <a name="output_http_listener_arn"></a> [http\_listener\_arn](#output\_http\_listener\_arn) | HTTP listener ARN. |
| <a name="output_https_listener_arn"></a> [https\_listener\_arn](#output\_https\_listener\_arn) | HTTPS listener ARN (add extra listener rules here). |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | Security group IDs associated with the ALB. |
| <a name="output_target_group_arns"></a> [target\_group\_arns](#output\_target\_group\_arns) | Map of target group name → ARN. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | ALB hosted zone ID (use in Route 53 alias records). |
<!-- END_TF_DOCS -->