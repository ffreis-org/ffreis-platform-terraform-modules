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
| [aws_guardduty_detector.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_guardduty_ipset.trusted](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_ipset) | resource |
| [aws_guardduty_publishing_destination.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_publishing_destination) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable"></a> [enable](#input\_enable) | Enable the GuardDuty detector. | `bool` | `true` | no |
| <a name="input_enable_eks_protection"></a> [enable\_eks\_protection](#input\_enable\_eks\_protection) | Enable EKS audit log monitoring. | `bool` | `false` | no |
| <a name="input_enable_malware_protection"></a> [enable\_malware\_protection](#input\_enable\_malware\_protection) | Enable malware scanning for EC2 EBS volumes. | `bool` | `false` | no |
| <a name="input_enable_s3_protection"></a> [enable\_s3\_protection](#input\_enable\_s3\_protection) | Enable S3 data-event threat intelligence. | `bool` | `true` | no |
| <a name="input_finding_publishing_frequency"></a> [finding\_publishing\_frequency](#input\_finding\_publishing\_frequency) | How often to publish findings: 'FIFTEEN\_MINUTES', 'ONE\_HOUR', or 'SIX\_HOURS'. | `string` | `"ONE_HOUR"` | no |
| <a name="input_findings_kms_key_arn"></a> [findings\_kms\_key\_arn](#input\_findings\_kms\_key\_arn) | KMS key ARN to encrypt exported findings. | `string` | `null` | no |
| <a name="input_findings_s3_bucket"></a> [findings\_s3\_bucket](#input\_findings\_s3\_bucket) | S3 bucket name to export findings to. null = no export. | `string` | `null` | no |
| <a name="input_ipset_iplist_uri"></a> [ipset\_iplist\_uri](#input\_ipset\_iplist\_uri) | S3 URI of a trusted IP list (e.g. 's3://bucket/trusted-ips.txt'). null = skip. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_detector_arn"></a> [detector\_arn](#output\_detector\_arn) | GuardDuty detector ARN. |
| <a name="output_detector_id"></a> [detector\_id](#output\_detector\_id) | GuardDuty detector ID. |
<!-- END_TF_DOCS -->