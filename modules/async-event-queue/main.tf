###############################################################################
# async-event-queue — one-directional event-consumer unit
#
#   producer ─► [input topic] ─┬─ drain modes ─► [SQS work queue] ─drain─► Lambda
#                              ├─ real_time ───► Lambda ; on-failure ─► [SQS]
#                              └─ (optional) ──► Firehose ─► [S3 archive]  (replay)
#   Lambda ─sns:Publish(result)─► [output topic]  (= next unit's input; NO output queue)
#
# Composes the in-repo sqs + sns primitives. The durable queue belongs to the
# consumer. There is no producer-side output queue (D1).
###############################################################################

data "aws_partition" "current" {}

locals {
  queue_name = var.fifo ? "${var.name}.fifo" : var.name

  input_topic_name  = coalesce(var.input_topic_name, "${var.name}-events")
  output_topic_name = coalesce(var.output_topic_name, "${var.name}-completed")
  archive_prefix    = coalesce(var.archive_prefix, var.name)

  is_real_time = var.consumer_mode == "real_time"
  is_drain     = contains(["near_real_time", "batch"], var.consumer_mode)

  create_owned_input_topic = var.create_input_topic && var.external_input_topic_arn == null
  input_topic_arn          = var.external_input_topic_arn != null ? var.external_input_topic_arn : (local.create_owned_input_topic ? module.input_topic[0].arn : null)
  has_input_topic          = local.input_topic_arn != null

  # The work queue is fed by SNS only for drain/external modes. In real_time it
  # is the Lambda on-failure destination (fed by the Lambda service), not by SNS.
  topic_feeds_queue = local.has_input_topic && !local.is_real_time

  output_topic_arn = var.create_output_topic ? module.output_topic[0].arn : null
}

# ---------------------------------------------------------------------------
# Work queue (+ DLQ). Role depends on consumer_mode:
#   drain/external → primary buffer (SNS feeds it, drain consumes it)
#   real_time      → failure queue  (Lambda on-failure feeds it, failure-drain consumes it)
# ---------------------------------------------------------------------------
module "queue" {
  source = "../sqs"

  name                          = local.queue_name
  fifo_queue                    = var.fifo
  content_based_deduplication   = var.content_based_deduplication
  visibility_timeout_seconds    = var.visibility_timeout_seconds
  message_retention_seconds     = var.message_retention_seconds
  max_message_size              = var.max_message_size
  delay_seconds                 = var.delay_seconds
  receive_wait_time_seconds     = var.receive_wait_time_seconds
  kms_master_key_id             = var.kms_master_key_id
  create_dlq                    = var.create_dlq
  dlq_message_retention_seconds = var.dlq_retention_seconds
  max_receive_count             = var.max_receive_count

  tags = var.tags
}

# ---------------------------------------------------------------------------
# Input topic (owned). Topic only — all subscriptions are standalone below to
# avoid a queue<->topic dependency cycle and to support firehose/lambda subs.
# ---------------------------------------------------------------------------
module "input_topic" {
  count  = local.create_owned_input_topic ? 1 : 0
  source = "../sns"

  name              = var.fifo ? "${local.input_topic_name}.fifo" : local.input_topic_name
  fifo_topic        = var.fifo
  kms_master_key_id = var.kms_master_key_id
  subscriptions     = {}
  tags              = var.tags
}

# input topic → work queue (drain/external modes only)
resource "aws_sns_topic_subscription" "input_to_queue" {
  count = local.topic_feeds_queue ? 1 : 0

  topic_arn            = local.input_topic_arn
  protocol             = "sqs"
  endpoint             = module.queue.queue_arn
  raw_message_delivery = var.raw_message_delivery
  filter_policy        = var.input_filter_policy
  filter_policy_scope  = var.input_filter_policy != null ? var.input_filter_policy_scope : null
}

# allow the input topic to SendMessage to the work queue (drain/external modes)
data "aws_iam_policy_document" "queue_allow_sns" {
  count = local.topic_feeds_queue ? 1 : 0

  statement {
    sid     = "AllowSNSDeliver"
    effect  = "Allow"
    actions = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    resources = [module.queue.queue_arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [local.input_topic_arn]
    }
  }
}

resource "aws_sqs_queue_policy" "allow_sns" {
  count     = local.topic_feeds_queue ? 1 : 0
  queue_url = module.queue.queue_id
  policy    = data.aws_iam_policy_document.queue_allow_sns[0].json
}

# extra non-SQS subscribers on the input topic
resource "aws_sns_topic_subscription" "additional_input" {
  for_each = var.additional_input_subscriptions

  topic_arn            = local.input_topic_arn
  protocol             = each.value.protocol
  endpoint             = each.value.endpoint
  raw_message_delivery = each.value.raw_message_delivery
  filter_policy        = each.value.filter_policy
}

# ---------------------------------------------------------------------------
# Consumer trigger — near_real_time / batch: scheduled drain
# ---------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "drain" {
  count = local.is_drain ? 1 : 0

  name                = "${var.name}-drain"
  description         = "Scheduled drain of ${local.queue_name}. Replaces always-on ESM polling."
  schedule_expression = var.drain_schedule_expression
  state               = var.drain_enabled ? "ENABLED" : "DISABLED"
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "drain" {
  count = local.is_drain ? 1 : 0

  rule      = aws_cloudwatch_event_rule.drain[0].name
  target_id = "${var.name}-drain-lambda"
  arn       = var.consumer_lambda_arn
}

resource "aws_lambda_permission" "drain" {
  count = local.is_drain ? 1 : 0

  statement_id  = "AllowDrainSchedule"
  action        = "lambda:InvokeFunction"
  function_name = var.consumer_lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.drain[0].arn
}

# ---------------------------------------------------------------------------
# Consumer trigger — real_time: SNS→Lambda push + on-failure capture
# ---------------------------------------------------------------------------
# Lambda async on-failure destination → the work queue (now the failure queue).
resource "aws_lambda_function_event_invoke_config" "on_failure" {
  count = local.is_real_time && var.create_failure_queue ? 1 : 0

  function_name          = var.consumer_lambda_name
  maximum_retry_attempts = 2

  destination_config {
    on_failure {
      destination = module.queue.queue_arn
    }
  }
}

# SNS→Lambda subscription — gated; an SNS subscription cannot be created
# disabled, so it is only created once the handler ships (Phase 4).
resource "aws_sns_topic_subscription" "topic_to_lambda" {
  count = local.is_real_time && var.real_time_subscription_enabled ? 1 : 0

  topic_arn     = local.input_topic_arn
  protocol      = "lambda"
  endpoint      = var.consumer_lambda_arn
  filter_policy = var.real_time_input_filter_policy
}

resource "aws_lambda_permission" "sns_invoke" {
  count = local.is_real_time && var.real_time_subscription_enabled ? 1 : 0

  statement_id  = "AllowSNSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.consumer_lambda_name
  principal     = "sns.amazonaws.com"
  source_arn    = local.input_topic_arn
}

# Failure-drain — replays the failure queue on a low-frequency schedule.
resource "aws_cloudwatch_event_rule" "failure_drain" {
  count = local.is_real_time && var.create_failure_queue ? 1 : 0

  name                = "${var.name}-failure-drain"
  description         = "Replays the ${local.queue_name} failure queue."
  schedule_expression = var.failure_drain_schedule_expression
  state               = var.failure_drain_enabled ? "ENABLED" : "DISABLED"
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "failure_drain" {
  count = local.is_real_time && var.create_failure_queue ? 1 : 0

  rule      = aws_cloudwatch_event_rule.failure_drain[0].name
  target_id = "${var.name}-failure-drain-lambda"
  arn       = var.consumer_lambda_arn
}

resource "aws_lambda_permission" "failure_drain" {
  count = local.is_real_time && var.create_failure_queue ? 1 : 0

  statement_id  = "AllowFailureDrainSchedule"
  action        = "lambda:InvokeFunction"
  function_name = var.consumer_lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.failure_drain[0].arn
}

# ---------------------------------------------------------------------------
# Output topic (emit / chain) — NO output queue (D1)
# ---------------------------------------------------------------------------
module "output_topic" {
  count  = var.create_output_topic ? 1 : 0
  source = "../sns"

  name              = var.fifo ? "${local.output_topic_name}.fifo" : local.output_topic_name
  fifo_topic        = var.fifo
  kms_master_key_id = var.kms_master_key_id
  subscriptions     = {}
  tags              = var.tags
}

resource "aws_sns_topic_subscription" "output" {
  for_each = var.create_output_topic ? var.output_subscriptions : {}

  topic_arn            = module.output_topic[0].arn
  protocol             = each.value.protocol
  endpoint             = each.value.endpoint
  raw_message_delivery = each.value.raw_message_delivery
  filter_policy        = each.value.filter_policy
}

# ---------------------------------------------------------------------------
# Archive (D2) — input topic → Kinesis Firehose → S3 raw archive
# ---------------------------------------------------------------------------
locals {
  archive_bucket_arn = var.create_archive ? "arn:${data.aws_partition.current.partition}:s3:::${var.archive_bucket_name}" : null
}

data "aws_iam_policy_document" "firehose_assume" {
  count = var.create_archive ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "firehose" {
  count              = var.create_archive ? 1 : 0
  name               = "${var.name}-archive-firehose"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume[0].json
  tags               = var.tags
}

data "aws_iam_policy_document" "firehose_s3" {
  count = var.create_archive ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]
    resources = [
      local.archive_bucket_arn,
      "${local.archive_bucket_arn}/${local.archive_prefix}/*",
    ]
  }
}

resource "aws_iam_role_policy" "firehose_s3" {
  count  = var.create_archive ? 1 : 0
  name   = "s3-archive"
  role   = aws_iam_role.firehose[0].id
  policy = data.aws_iam_policy_document.firehose_s3[0].json
}

resource "aws_kinesis_firehose_delivery_stream" "archive" {
  count       = var.create_archive ? 1 : 0
  name        = "${var.name}-archive"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose[0].arn
    bucket_arn          = local.archive_bucket_arn
    prefix              = "${local.archive_prefix}/"
    error_output_prefix = "${local.archive_prefix}-errors/"
    buffering_interval  = var.archive_buffer_seconds
    buffering_size      = var.archive_buffer_mb
    compression_format  = "GZIP"
  }

  tags = var.tags
}

# SNS needs a role to put records into Firehose.
data "aws_iam_policy_document" "sns_firehose_assume" {
  count = var.create_archive ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "sns_to_firehose" {
  count              = var.create_archive ? 1 : 0
  name               = "${var.name}-archive-sns"
  assume_role_policy = data.aws_iam_policy_document.sns_firehose_assume[0].json
  tags               = var.tags
}

data "aws_iam_policy_document" "sns_firehose" {
  count = var.create_archive ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "firehose:DescribeDeliveryStream",
      "firehose:ListDeliveryStreams",
      "firehose:PutRecord",
      "firehose:PutRecordBatch",
    ]
    resources = [aws_kinesis_firehose_delivery_stream.archive[0].arn]
  }
}

resource "aws_iam_role_policy" "sns_to_firehose" {
  count  = var.create_archive ? 1 : 0
  name   = "sns-to-firehose"
  role   = aws_iam_role.sns_to_firehose[0].id
  policy = data.aws_iam_policy_document.sns_firehose[0].json
}

resource "aws_sns_topic_subscription" "archive" {
  count = var.create_archive ? 1 : 0

  topic_arn             = local.input_topic_arn
  protocol              = "firehose"
  endpoint              = aws_kinesis_firehose_delivery_stream.archive[0].arn
  subscription_role_arn = aws_iam_role.sns_to_firehose[0].arn
  raw_message_delivery  = true
}

# ---------------------------------------------------------------------------
# Observability alarms
# ---------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "queue_depth" {
  count = var.create_alarms ? 1 : 0

  alarm_name          = "${var.name}-queue-depth"
  namespace           = "AWS/SQS"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  dimensions          = { QueueName = module.queue.queue_name }
  statistic           = "Maximum"
  period              = 300
  evaluation_periods  = 1
  threshold           = local.is_real_time ? 0 : var.alarm_depth_threshold
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [var.alarm_sns_topic_arn]
  tags                = var.tags
}

resource "aws_cloudwatch_metric_alarm" "queue_age" {
  count = var.create_alarms ? 1 : 0

  alarm_name          = "${var.name}-message-age"
  namespace           = "AWS/SQS"
  metric_name         = "ApproximateAgeOfOldestMessage"
  dimensions          = { QueueName = module.queue.queue_name }
  statistic           = "Maximum"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.alarm_age_threshold_seconds
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [var.alarm_sns_topic_arn]
  tags                = var.tags
}

resource "aws_cloudwatch_metric_alarm" "dlq_depth" {
  count = var.create_alarms && var.create_dlq ? 1 : 0

  alarm_name          = "${var.name}-dlq-depth"
  namespace           = "AWS/SQS"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  dimensions          = { QueueName = "${trimsuffix(local.queue_name, ".fifo")}-dlq${var.fifo ? ".fifo" : ""}" }
  statistic           = "Maximum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [var.alarm_sns_topic_arn]
  tags                = var.tags
}
