# Module: WAF

This module creates an AWS WAF v2 Web ACL for either Regional resources or CloudFront distributions.

## Features
- WAF v2 Web ACL creation
- Support for REGIONAL and CLOUDFRONT scopes
- Customizable default action (allow/block)
- Tagging support

## Usage
```hcl
module "waf" {
  source = "../../terraform-modules/terraform-aws-waf"

  name   = "my-web-acl"
  scope  = "REGIONAL"
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | n/a | WAF name |
| `scope` | `string` | n/a | WAF scope (REGIONAL or CLOUDFRONT) |
| `default_action` | `string` | `"allow"` | Default action |
| `tags` | `map(string)` | `{}` | Tags to apply |

## Outputs
| Name | Description |
|------|-------------|
| `web_acl_arn` | WAF Web ACL ARN |
| `web_acl_id` | WAF Web ACL ID |

## Environment Variables
None

## Notes
- `scope` must be `CLOUDFRONT` for CloudFront distributions and `REGIONAL` for ALB/API Gateway.
- If scope is `CLOUDFRONT`, the WAF must be created in the `us-east-1` region.
