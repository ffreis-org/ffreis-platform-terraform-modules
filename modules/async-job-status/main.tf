###############################################################################
# async-job-status — the honest-success correlation store.
#
# A jobs DynamoDB table keyed by `job_id` (== DomainEvent.correlation_id). The
# async consumer's LAST step writes a terminal status row (conditional PutItem —
# the idempotency record); a caller-owned SYNC "status" Lambda reads it to serve
# GET /api/status/{job_id}, which the browser polls until terminal.
#
# This module owns ONLY the table + IAM policy-JSON outputs (ports-and-adapters:
# the caller wires its own status Lambda + APIGW route and attaches these
# policies). $0 fixed cost — PAY_PER_REQUEST, AWS-owned encryption (no KMS).
###############################################################################

module "table" {
  source = "../dynamodb-table"

  name         = var.name
  hash_key     = "job_id"
  billing_mode = "PAY_PER_REQUEST"
  # `job_id` (the hash key) is added to the attribute set automatically.
  ttl_attribute               = var.ttl_attribute
  kms_master_key_id           = null # AWS-owned key — no fixed KMS cost (fleet convention)
  deletion_protection_enabled = var.deletion_protection_enabled

  tags = var.tags
}

# Attach to the async CONSUMER role: write the terminal status (PutItem/UpdateItem,
# GetItem for the conditional/idempotency read).
data "aws_iam_policy_document" "status_writer" {
  statement {
    sid       = "WriteJobStatus"
    effect    = "Allow"
    actions   = ["dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:GetItem"]
    resources = [module.table.arn]
  }
}

# Attach to the SYNC status Lambda role: read one job's status.
data "aws_iam_policy_document" "status_reader" {
  statement {
    sid       = "ReadJobStatus"
    effect    = "Allow"
    actions   = ["dynamodb:GetItem"]
    resources = [module.table.arn]
  }
}
