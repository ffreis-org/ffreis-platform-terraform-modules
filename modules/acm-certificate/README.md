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
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Primary domain name for the certificate (e.g. 'example.com'). | `string` | n/a | yes |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | Route 53 hosted zone ID for automatic DNS validation record creation. Required when validation\_method = 'DNS'. | `string` | `null` | no |
| <a name="input_key_algorithm"></a> [key\_algorithm](#input\_key\_algorithm) | Key algorithm: 'RSA\_2048' (default), 'RSA\_4096', 'EC\_prime256v1', 'EC\_secp384r1'. | `string` | `"RSA_2048"` | no |
| <a name="input_subject_alternative_names"></a> [subject\_alternative\_names](#input\_subject\_alternative\_names) | Additional domain names (SANs) to include (e.g. ['*.example.com', 'api.example.com']). | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_validation_method"></a> [validation\_method](#input\_validation\_method) | Certificate validation method: 'DNS' (recommended) or 'EMAIL'. | `string` | `"DNS"` | no |
| <a name="input_wait_for_validation"></a> [wait\_for\_validation](#input\_wait\_for\_validation) | Block until the certificate is issued and validated. Recommended true. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ACM certificate ARN. |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | Primary domain name. |
| <a name="output_domain_validation_options"></a> [domain\_validation\_options](#output\_domain\_validation\_options) | Domain validation options (DNS record details for manual validation). |
| <a name="output_status"></a> [status](#output\_status) | Certificate status: PENDING\_VALIDATION \| ISSUED \| INACTIVE \| EXPIRED \| VALIDATION\_TIMED\_OUT \| REVOKED \| FAILED. |
<!-- END_TF_DOCS -->