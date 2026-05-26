# tagging

Single source of truth for AWS resource tags across the ffreis workspace.

Call this module once per Terraform root module, pass its `tags` output to
`provider "aws" { default_tags { … } }`, and forward `module.tags.tags` to
every nested module that takes a `tags` input.

## Usage

```hcl
module "tags" {
  source = "git::https://github.com/FelipeFuhr/ffreis-platform-terraform-modules.git//modules/tagging?ref=v2.0.0"

  project           = "flemming"
  environment       = var.environment              # dev | prod
  stack             = "flemming"
  layer             = "flemming-infra"
  terraform_repo    = "ffreis-flemming-infra"
  terraform_root    = "infra"
  terraform_version = "1.9.8"
  cost_center       = "flemming"                   # per-product, not "engineering"
  domain            = "flemming.com.br"
  lifecycle_state   = var.environment == "prod" ? "production" : "development"
  fixed_cost_tier   = "low"                        # honest fixed monthly cost band

  # Optional defaults below already set:
  # owner               = "felipefuhr"
  # managed_by          = "terraform"
  # compliance_framework = "none"
  # data_classification  = "internal"
  # backup_policy        = "none"
}

provider "aws" {
  default_tags { tags = module.tags.tags }
}
```

Per-resource override (rare — usually `default_tags` is enough):

```hcl
resource "aws_dynamodb_table" "experiments" {
  # …
  tags = merge(module.tags.tags, {
    Lifecycle     = "experiment"
    FixedCostTier = "none"
  })
}
```

## Tag schema

| Tag | Required? | Notes |
|---|---|---|
| `Project` | ✅ | Per-product slug (`flemming`, `petlook`, `ffreis-website`, …) |
| `Environment` | ✅ | `dev` or `prod` (validated) |
| `Stack` | ✅ | Logical grouping; usually = `Project` |
| `Layer` | ✅ | Sub-component within stack |
| `ManagedBy` | ✅ | Defaults to `terraform` |
| `TerraformRepo` | ✅ | Repo name |
| `TerraformRoot` | ✅ | Root module path (`infra` / `stack`) |
| `CostCenter` | ✅ | **Per-product**, drives Cost Explorer grouping |
| `Owner` | ✅ | Defaults to `felipefuhr` |
| `Compliance` | ✅ | Defaults to `none` |
| `DataClassification` | ✅ | Defaults to `internal`, validated |
| `BackupPolicy` | ✅ | Defaults to `none` |
| `Lifecycle` | ✅ | `production` \| `development` \| `experiment` \| `legacy` (validated) |
| `FixedCostTier` | ✅ | `none` \| `low` (<$1/mo) \| `medium` ($1-$10/mo) \| `high` (>$10/mo) (validated) |
| `Domain` | ✅ | `flemming.com.br` \| `ffreis.com` \| `petlook.ai` \| `internal` (validated) |
| `TerraformVersion` | conditional | Emitted only if `terraform_version` is set |
| `Repository` | conditional | Emitted only if `repository` is set |

## Decision rules

### `Lifecycle`
- `production` — serves real users; deletion would cause an incident.
- `development` — dev / staging twin of a production resource; recreatable.
- `experiment` — short-lived spike, PoC, or one-off; safe to delete after the experiment ends.
- `legacy` — superseded by something newer; flagged for cleanup. Audit queries use this tag.

### `FixedCostTier`
Set honestly. Cost Explorer queries like *"show me all medium+ fixed-cost resources"* depend on it.
- `none` — pay-per-request only (Lambda, DDB on-demand, CloudFront, API Gateway, S3 storage).
- `low` — < $1/mo (Route 53 zone $0.50, single CloudWatch alarm $0.10, etc.).
- `medium` — $1 to $10/mo (KMS key $1, WAF web ACL $5, small ALB share, etc.).
- `high` — > $10/mo (NAT gateway $32, RDS instance, ElastiCache, idle Lambda provisioned concurrency, …).

### `Domain`
Use `internal` for resources not tied to a public domain (TF state buckets, GitHub OIDC providers, internal scheduling). Otherwise pick the public hostname the resource ultimately serves.

## Versioning

- **v1.x** — original schema (`Workspace` / `Service` / `Team` / …). Not consumed by any infra repo. Kept for reference.
- **v2.0.0** — current schema. Breaking change. Pin via `?ref=v2.0.0` until a v3 ships.
