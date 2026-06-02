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
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_authorizer.jwt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_authorizer) | resource |
| [aws_apigatewayv2_integration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_cloudwatch_log_group.access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_permission.apigw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [terraform_data.destroy_guard](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_arn"></a> [access\_log\_arn](#input\_access\_log\_arn) | CloudWatch log group ARN for access logs. null = create a log group in this module. | `string` | `null` | no |
| <a name="input_access_log_format"></a> [access\_log\_format](#input\_access\_log\_format) | Access log format for the stage. | `string` | `"{\"httpMethod\":\"$context.httpMethod\",\"integrationErrorMessage\":\"$context.integrationErrorMessage\",\"ip\":\"$context.identity.sourceIp\",\"path\":\"$context.path\",\"requestId\":\"$context.requestId\",\"requestTime\":\"$context.requestTime\",\"responseLength\":\"$context.responseLength\",\"routeKey\":\"$context.routeKey\",\"status\":\"$context.status\",\"userAgent\":\"$context.identity.userAgent\"}"` | no |
| <a name="input_access_log_kms_key_arn"></a> [access\_log\_kms\_key\_arn](#input\_access\_log\_kms\_key\_arn) | KMS key ARN for encrypting the access log group created by this module (when access\_log\_arn is null). | `string` | `null` | no |
| <a name="input_access_log_retention_days"></a> [access\_log\_retention\_days](#input\_access\_log\_retention\_days) | Retention in days for the access log group created by this module (when access\_log\_arn is null). | `number` | `30` | no |
| <a name="input_auto_deploy"></a> [auto\_deploy](#input\_auto\_deploy) | Auto-deploy on change. | `bool` | `true` | no |
| <a name="input_cors_configuration"></a> [cors\_configuration](#input\_cors\_configuration) | CORS settings. null = no CORS configuration. | <pre>object({<br/>    allow_origins     = optional(list(string), ["*"])<br/>    allow_methods     = optional(list(string), ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD"])<br/>    allow_headers     = optional(list(string), ["Content-Type", "Authorization", "X-Amz-Date", "X-Api-Key"])<br/>    expose_headers    = optional(list(string), [])<br/>    max_age           = optional(number, 300)<br/>    allow_credentials = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Human-readable description. | `string` | `""` | no |
| <a name="input_jwt_authorizer"></a> [jwt\_authorizer](#input\_jwt\_authorizer) | JWT authorizer (e.g. Cognito). null = no authorizer. | <pre>object({<br/>    name             = string<br/>    issuer           = string       # e.g. Cognito user pool endpoint<br/>    audience         = list(string) # e.g. Cognito app client IDs<br/>    identity_sources = optional(list(string), ["$request.header.Authorization"])<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | HTTP API name. | `string` | n/a | yes |
| <a name="input_prevent_destroy"></a> [prevent\_destroy](#input\_prevent\_destroy) | Set true in production to block accidental resource destruction. Uses a terraform\_data guard — to destroy the module, set this to false and apply first. | `bool` | `false` | no |
| <a name="input_protocol_type"></a> [protocol\_type](#input\_protocol\_type) | 'HTTP' or 'WEBSOCKET'. | `string` | `"HTTP"` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | Map of 'METHOD /path' → integration config.<br/>integration\_uri: Lambda invoke ARN or HTTP endpoint.<br/>integration\_type: 'AWS\_PROXY' (Lambda) or 'HTTP\_PROXY'.<br/>authorizer: 'jwt' to require the JWT authorizer; 'none' for public unauthenticated routes; null or omitted = AWS\_IAM (secure default).<br/>authorization\_scopes: OAuth2 scopes required. | <pre>map(object({<br/>    integration_uri        = string<br/>    integration_type       = optional(string, "AWS_PROXY")<br/>    payload_format_version = optional(string, "2.0")<br/>    timeout_milliseconds   = optional(number, 29000)<br/>    authorizer             = optional(string, null)<br/>    authorization_scopes   = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | Deployment stage name. '$default' = auto-deploy. | `string` | `"$default"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_throttle_burst_limit"></a> [throttle\_burst\_limit](#input\_throttle\_burst\_limit) | Stage throttle burst limit. -1 = no limit. | `number` | `500` | no |
| <a name="input_throttle_rate_limit"></a> [throttle\_rate\_limit](#input\_throttle\_rate\_limit) | Stage throttle rate limit (requests/second). -1 = no limit. | `number` | `1000` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_endpoint"></a> [api\_endpoint](#output\_api\_endpoint) | API invocation endpoint URL. |
| <a name="output_api_id"></a> [api\_id](#output\_api\_id) | HTTP API ID. |
| <a name="output_authorizer_id"></a> [authorizer\_id](#output\_authorizer\_id) | JWT authorizer ID (empty if no authorizer configured). |
| <a name="output_execution_arn"></a> [execution\_arn](#output\_execution\_arn) | API Gateway execution ARN (use in Lambda permissions). |
<!-- END_TF_DOCS -->