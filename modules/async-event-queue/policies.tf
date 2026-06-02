###############################################################################
# IAM policy documents exposed as JSON outputs. The module NEVER creates IAM
# role/policy attachments for the caller's Lambdas — callers compose these into
# their own lambda module's inline_policies. (Prevents ARN coupling + name
# collisions across environments.)
###############################################################################

locals {
  producer_action   = local.has_input_topic ? "sns:Publish" : "sqs:SendMessage"
  producer_resource = local.has_input_topic ? local.input_topic_arn : module.queue.queue_arn

  # real_time consumers also need sqs:SendMessage (the Lambda async on-failure
  # destination writes to the failure queue using the function's execution role).
  consumer_actions = local.is_real_time ? [
    "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes", "sqs:SendMessage",
    ] : [
    "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes",
  ]
}

# Producer: publish to the input topic (or send to the queue if no topic).
data "aws_iam_policy_document" "producer" {
  statement {
    sid       = "Produce"
    effect    = "Allow"
    actions   = [local.producer_action]
    resources = [local.producer_resource]
  }
}

# Consumer: drain/receive from the work queue.
data "aws_iam_policy_document" "consumer" {
  statement {
    sid       = "Consume"
    effect    = "Allow"
    actions   = local.consumer_actions
    resources = [module.queue.queue_arn]
  }
}

# DLQ consumer: manual re-drive / inspection access.
data "aws_iam_policy_document" "dlq_consumer" {
  count = var.create_dlq ? 1 : 0

  statement {
    sid       = "ConsumeDLQ"
    effect    = "Allow"
    actions   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
    resources = [module.queue.dlq_arn]
  }
}

# Output publisher: publish results to the output topic.
data "aws_iam_policy_document" "output_publisher" {
  count = var.create_output_topic ? 1 : 0

  statement {
    sid       = "PublishResult"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [local.output_topic_arn]
  }
}

# Replay job: read the S3 archive range + re-publish to the input topic.
data "aws_iam_policy_document" "replay" {
  count = var.create_archive ? 1 : 0

  statement {
    sid       = "ReadArchive"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = [local.archive_bucket_arn, "${local.archive_bucket_arn}/${local.archive_prefix}/*"]
  }
  statement {
    sid       = "RepublishToTopic"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [local.input_topic_arn]
  }
}
