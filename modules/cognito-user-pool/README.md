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
| [aws_cognito_user_pool.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_advanced_security_mode"></a> [advanced\_security\_mode](#input\_advanced\_security\_mode) | Advanced security: 'OFF', 'AUDIT', or 'ENFORCED'. | `string` | `"ENFORCED"` | no |
| <a name="input_alias_attributes"></a> [alias\_attributes](#input\_alias\_attributes) | Attributes users can sign in with: 'email', 'phone\_number', 'preferred\_username'. | `list(string)` | <pre>[<br/>  "email"<br/>]</pre> | no |
| <a name="input_app_clients"></a> [app\_clients](#input\_app\_clients) | Map of app client name → configuration. | <pre>map(object({<br/>    generate_secret                      = optional(bool, false)<br/>    allowed_oauth_flows                  = optional(list(string), ["code"])<br/>    allowed_oauth_flows_user_pool_client = optional(bool, true)<br/>    allowed_oauth_scopes                 = optional(list(string), ["openid", "email", "profile"])<br/>    callback_urls                        = optional(list(string), [])<br/>    logout_urls                          = optional(list(string), [])<br/>    supported_identity_providers         = optional(list(string), ["COGNITO"])<br/>    access_token_validity                = optional(number, 60) # minutes<br/>    id_token_validity                    = optional(number, 60) # minutes<br/>    refresh_token_validity               = optional(number, 30) # days<br/>    enable_token_revocation              = optional(bool, true)<br/>    prevent_user_existence_errors        = optional(string, "ENABLED")<br/>    explicit_auth_flows = optional(list(string), [<br/>      "ALLOW_REFRESH_TOKEN_AUTH",<br/>      "ALLOW_USER_SRP_AUTH",<br/>    ])<br/>  }))</pre> | `{}` | no |
| <a name="input_auto_verified_attributes"></a> [auto\_verified\_attributes](#input\_auto\_verified\_attributes) | Attributes auto-verified after sign-up: 'email', 'phone\_number'. | `list(string)` | <pre>[<br/>  "email"<br/>]</pre> | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Prevent the user pool from being deleted: 'ACTIVE' or 'INACTIVE'. | `string` | `"ACTIVE"` | no |
| <a name="input_email_from_address"></a> [email\_from\_address](#input\_email\_from\_address) | SES verified email address to use as the FROM address. null = Cognito default. | `string` | `null` | no |
| <a name="input_email_source_arn"></a> [email\_source\_arn](#input\_email\_source\_arn) | SES verified identity ARN for sending emails. Required with email\_from\_address. | `string` | `null` | no |
| <a name="input_mfa_configuration"></a> [mfa\_configuration](#input\_mfa\_configuration) | MFA requirement: 'OFF', 'OPTIONAL', or 'ON'. | `string` | `"OPTIONAL"` | no |
| <a name="input_name"></a> [name](#input\_name) | Cognito user pool name. | `string` | n/a | yes |
| <a name="input_password_policy"></a> [password\_policy](#input\_password\_policy) | Password policy settings. | <pre>object({<br/>    minimum_length                   = optional(number, 12)<br/>    require_lowercase                = optional(bool, true)<br/>    require_uppercase                = optional(bool, true)<br/>    require_numbers                  = optional(bool, true)<br/>    require_symbols                  = optional(bool, true)<br/>    temporary_password_validity_days = optional(number, 7)<br/>  })</pre> | `{}` | no |
| <a name="input_schema_attributes"></a> [schema\_attributes](#input\_schema\_attributes) | Custom user pool schema attributes. | <pre>list(object({<br/>    name                = string<br/>    attribute_data_type = string # String | Number | DateTime | Boolean<br/>    required            = optional(bool, false)<br/>    mutable             = optional(bool, true)<br/>    string_attribute_constraints = optional(object({<br/>      min_length = optional(string, "0")<br/>      max_length = optional(string, "2048")<br/>    }), null)<br/>  }))</pre> | `[]` | no |
| <a name="input_software_token_mfa_enabled"></a> [software\_token\_mfa\_enabled](#input\_software\_token\_mfa\_enabled) | Allow TOTP authenticator apps as an MFA method. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | User pool ARN. |
| <a name="output_client_ids"></a> [client\_ids](#output\_client\_ids) | Map of app client name → client ID. |
| <a name="output_client_secrets"></a> [client\_secrets](#output\_client\_secrets) | Map of app client name → client secret (sensitive). Only set when generate\_secret = true. |
| <a name="output_domain"></a> [domain](#output\_domain) | Cognito hosted UI domain prefix. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | User pool endpoint (used as JWT issuer URL). |
| <a name="output_id"></a> [id](#output\_id) | User pool ID. |
<!-- END_TF_DOCS -->