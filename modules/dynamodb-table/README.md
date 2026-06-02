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
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Attribute definitions for keys and GSI/LSI keys.<br/>Type is "S" (string), "N" (number), or "B" (binary).<br/>The hash\_key and range\_key attributes are added automatically. | <pre>list(object({<br/>    name = string<br/>    type = string<br/>  }))</pre> | `[]` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | 'PAY\_PER\_REQUEST' (default) or 'PROVISIONED'. | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Enable deletion protection to prevent accidental table deletion. Set true for production. | `bool` | `false` | no |
| <a name="input_global_secondary_indexes"></a> [global\_secondary\_indexes](#input\_global\_secondary\_indexes) | Global secondary indexes. | <pre>list(object({<br/>    name               = string<br/>    hash_key           = string<br/>    range_key          = optional(string, null)<br/>    projection_type    = optional(string, "ALL")<br/>    non_key_attributes = optional(list(string), [])<br/>    read_capacity      = optional(number, null)<br/>    write_capacity     = optional(number, null)<br/>  }))</pre> | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | Attribute name for the hash (partition) key. | `string` | n/a | yes |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | KMS key ARN for SSE. Leave empty to use AWS-managed key (DEFAULT). | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | DynamoDB table name. | `string` | n/a | yes |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | Attribute name for the range (sort) key. Leave empty for hash-only tables. | `string` | `""` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | Read capacity units. Required when billing\_mode = 'PROVISIONED'. | `number` | `null` | no |
| <a name="input_stream_enabled"></a> [stream\_enabled](#input\_stream\_enabled) | Enable DynamoDB Streams. | `bool` | `false` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | Stream view type when stream\_enabled = true. | `string` | `"NEW_AND_OLD_IMAGES"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the table. | `map(string)` | `{}` | no |
| <a name="input_ttl_attribute"></a> [ttl\_attribute](#input\_ttl\_attribute) | Attribute name for TTL. Leave empty to disable TTL. | `string` | `""` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | Write capacity units. Required when billing\_mode = 'PROVISIONED'. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Table ARN. |
| <a name="output_id"></a> [id](#output\_id) | Table name. |
| <a name="output_stream_arn"></a> [stream\_arn](#output\_stream\_arn) | DynamoDB Streams ARN (empty string when streams are disabled). |
<!-- END_TF_DOCS -->