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
| [aws_vpc_endpoint.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpoint_policy"></a> [endpoint\_policy](#input\_endpoint\_policy) | JSON endpoint policy applied to all endpoints. null = full access. | `string` | `null` | no |
| <a name="input_gateway_endpoints"></a> [gateway\_endpoints](#input\_gateway\_endpoints) | Map of logical name → Gateway endpoint service name suffix.<br/>Common values: 's3', 'dynamodb'.<br/>Route table IDs that should reach the endpoint are provided in<br/>gateway\_route\_table\_ids. | `map(string)` | `{}` | no |
| <a name="input_gateway_route_table_ids"></a> [gateway\_route\_table\_ids](#input\_gateway\_route\_table\_ids) | Route table IDs that will use Gateway endpoints. Typically all private + database route tables. | `list(string)` | `[]` | no |
| <a name="input_interface_endpoints"></a> [interface\_endpoints](#input\_interface\_endpoints) | Map of logical name → Interface endpoint service name suffix.<br/>Common values: 'ssm', 'ssmmessages', 'ec2messages', 'ecr.api', 'ecr.dkr',<br/>'sts', 'secretsmanager', 'kms', 'logs', 'monitoring', 'sqs', 'sns',<br/>'lambda', 'execute-api', 'states', 'elasticloadbalancing'. | `map(string)` | `{}` | no |
| <a name="input_interface_security_group_ids"></a> [interface\_security\_group\_ids](#input\_interface\_security\_group\_ids) | Security group IDs attached to Interface endpoint ENIs. | `list(string)` | `[]` | no |
| <a name="input_interface_subnet_ids"></a> [interface\_subnet\_ids](#input\_interface\_subnet\_ids) | Subnet IDs where Interface endpoint ENIs are placed. Use private subnets. | `list(string)` | `[]` | no |
| <a name="input_private_dns_enabled"></a> [private\_dns\_enabled](#input\_private\_dns\_enabled) | Enable private DNS for Interface endpoints (resolves public hostnames to endpoint IPs). | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region (used to construct service names). | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID in which to create the endpoints. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gateway_endpoint_ids"></a> [gateway\_endpoint\_ids](#output\_gateway\_endpoint\_ids) | Map of logical name → Gateway endpoint ID. |
| <a name="output_interface_endpoint_dns"></a> [interface\_endpoint\_dns](#output\_interface\_endpoint\_dns) | Map of logical name → list of DNS entries for each Interface endpoint. |
| <a name="output_interface_endpoint_ids"></a> [interface\_endpoint\_ids](#output\_interface\_endpoint\_ids) | Map of logical name → Interface endpoint ID. |
<!-- END_TF_DOCS -->