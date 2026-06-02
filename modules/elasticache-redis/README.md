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
| [aws_elasticache_replication_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Apply changes immediately. | `bool` | `false` | no |
| <a name="input_at_rest_encryption_enabled"></a> [at\_rest\_encryption\_enabled](#input\_at\_rest\_encryption\_enabled) | Enable encryption at rest. | `bool` | `true` | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | AUTH token (password) for Redis. Required when transit\_encryption\_enabled = true. | `string` | `null` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Automatically apply minor Redis upgrades. | `bool` | `true` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Enable automatic failover. Requires num\_cache\_clusters >= 2. | `bool` | `true` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | ElastiCache replication group ID (max 40 chars, lowercase alphanumeric and hyphens). | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Human-readable description for the replication group. | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Redis engine version (e.g. '7.1'). | `string` | `"7.1"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ARN for at-rest encryption. null = ElastiCache-managed key. | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Preferred maintenance window (e.g. 'sun:04:00-sun:05:00'). | `string` | `"sun:04:00-sun:05:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Enable Multi-AZ support. | `bool` | `true` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | ElastiCache node type (e.g. 'cache.t4g.micro', 'cache.r7g.large'). | `string` | n/a | yes |
| <a name="input_notification_topic_arn"></a> [notification\_topic\_arn](#input\_notification\_topic\_arn) | SNS topic ARN for ElastiCache cluster notifications. | `string` | `null` | no |
| <a name="input_num_cache_clusters"></a> [num\_cache\_clusters](#input\_num\_cache\_clusters) | Number of cache nodes in the replication group (1 = no replica, 2+ = with replica). | `number` | `2` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Parameter group name. null = engine default. | `string` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | Redis port. | `number` | `6379` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs to associate with the cluster. | `list(string)` | n/a | yes |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | Number of days to retain automatic snapshots (0–35). 0 = disabled. | `number` | `7` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | Daily snapshot window (e.g. '03:00-04:00'). Must not overlap maintenance\_window. | `string` | `"03:00-04:00"` | no |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | ElastiCache subnet group name. The subnets must be in the same VPC as the security groups. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | Enable TLS in-transit encryption. | `bool` | `true` | no |
| <a name="input_transit_encryption_mode"></a> [transit\_encryption\_mode](#input\_transit\_encryption\_mode) | TLS mode: 'required' (enforce TLS) or 'preferred' (allow plaintext fallback). | `string` | `"required"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Replication group ARN. |
| <a name="output_port"></a> [port](#output\_port) | Redis port. |
| <a name="output_primary_endpoint_address"></a> [primary\_endpoint\_address](#output\_primary\_endpoint\_address) | DNS address of the primary node endpoint. |
| <a name="output_reader_endpoint_address"></a> [reader\_endpoint\_address](#output\_reader\_endpoint\_address) | DNS address of the read-only replica endpoint (Multi-AZ clusters). |
| <a name="output_replication_group_id"></a> [replication\_group\_id](#output\_replication\_group\_id) | Replication group ID. |
<!-- END_TF_DOCS -->