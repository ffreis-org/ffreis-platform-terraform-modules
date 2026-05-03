# Agent Context

**This repo:** `ffreis-platform-terraform-modules` — opinionated AWS Terraform modules
with hardcoded security baselines. 30+ modules covering KMS, IAM, VPC, S3, DynamoDB,
RDS, Lambda, ECS, SQS, SNS, etc.

## Non-obvious facts

- **Security defaults are on by default; callers opt OUT explicitly.** All free security
  controls (encryption, audit logging, public-access blocking) are enabled unless the
  caller sets an override variable. This is intentional — opt-out is visible in code
  review, opt-in is invisible.

- **No thin wrappers.** Modules encode platform decisions: RDS always uses Secrets
  Manager, SQS always has a DLQ, Lambda pre-creates a log group with retention. Do not
  add modules that just expose a provider resource with no added decisions.

- **Every bounded variable has a `validation` block.** Do not add variables without
  adding validation.

- **Tagging convention:** all modules accept `tags = module.tags.tags`. Use the tagging
  module — don't add free-form tag inputs.

- **Module source pinning:** consumers use git source with version tags:
  `git::https://github.com/FelipeFuhr/ffreis-platform-terraform-modules.git//modules/s3-bucket?ref=v1.2.0`

- **Terratest integration tests** apply real resources — they cost money and require
  AWS credentials. CI only runs them on `main`.

## Structure

```
modules/<name>/   ← exactly: variables.tf, main.tf, outputs.tf
test/             ← Terratest integration tests
```

## Build/test

```bash
# Validate all modules
for dir in modules/*/; do
  (cd "$dir" && terraform init -backend=false && terraform validate)
done
# Integration tests (requires AWS credentials, costs money)
go test ./test/... -v -timeout 30m
```
