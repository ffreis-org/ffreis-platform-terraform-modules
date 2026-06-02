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
| [aws_kinesis_stream.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ARN for server-side encryption. Use 'alias/aws/kinesis' for the AWS-managed key. | `string` | `"alias/aws/kinesis"` | no |
| <a name="input_name"></a> [name](#input\_name) | Kinesis Data Stream name. | `string` | n/a | yes |
| <a name="input_retention_period"></a> [retention\_period](#input\_retention\_period) | Data retention period in hours (24–8760). Default 24h. | `number` | `24` | no |
| <a name="input_shard_count"></a> [shard\_count](#input\_shard\_count) | Number of shards. Required when stream\_mode = 'PROVISIONED'. | `number` | `null` | no |
| <a name="input_shard_level_metrics"></a> [shard\_level\_metrics](#input\_shard\_level\_metrics) | Enhanced shard-level CloudWatch metrics to enable. | `list(string)` | <pre>[<br/>  "IncomingBytes",<br/>  "IncomingRecords",<br/>  "OutgoingBytes",<br/>  "OutgoingRecords",<br/>  "WriteProvisionedThroughputExceeded",<br/>  "ReadProvisionedThroughputExceeded",<br/>  "IteratorAgeMilliseconds"<br/>]</pre> | no |
| <a name="input_stream_mode"></a> [stream\_mode](#input\_stream\_mode) | 'ON\_DEMAND' (auto-scales, recommended) or 'PROVISIONED' (fixed shard count). | `string` | `"ON_DEMAND"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Stream ARN. |
| <a name="output_name"></a> [name](#output\_name) | Stream name. |
| <a name="output_shard_count"></a> [shard\_count](#output\_shard\_count) | Current shard count (null for ON\_DEMAND). |
<!-- END_TF_DOCS -->