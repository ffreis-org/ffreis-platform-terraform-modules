###############################################################################
# async-event-queue — one-directional event-consumer unit
#   input SNS topic → SQS (+DLQ) → { SNS-push | scheduled-drain } Lambda
#   + optional output topic (emit/chain) + optional S3 archive (replay)
# The durable queue always belongs to the CONSUMER. There is no output queue.
###############################################################################

variable "name" {
  description = "Base name for the unit. All resource names derive from it (e.g. '<name>', '<name>-dlq', '<name>-events')."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources (use the tagging module output)."
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------
# Tier 1 — Input SQS queue
# ---------------------------------------------------------------------------

variable "visibility_timeout_seconds" {
  description = "SQS visibility timeout. Set >= consumer Lambda timeout WITH MARGIN (the existing 6x multiple) so a slow drain run does not make a message visible mid-processing and get double-picked by the next tick."
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "Primary queue message retention (default 4 days)."
  type        = number
  default     = 345600
}

variable "max_message_size" {
  description = "Max SQS message size in bytes (1024-262144)."
  type        = number
  default     = 262144
}

variable "delay_seconds" {
  description = "SQS delivery delay (0-900)."
  type        = number
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "Long-poll wait time (0-20). 20 reduces empty-receive cost during drains."
  type        = number
  default     = 20
}

variable "fifo" {
  description = "FIFO queue + topic (auto-appends '.fifo'). Incompatible with consumer_mode = real_time (SNS FIFO cannot target Lambda)."
  type        = bool
  default     = false

  validation {
    condition     = !(var.fifo && var.consumer_mode == "real_time")
    error_message = "M1: fifo = true is incompatible with consumer_mode = \"real_time\" — SNS FIFO topics can only target SQS FIFO queues, never Lambda."
  }
}

variable "content_based_deduplication" {
  description = "FIFO content-based dedup (FIFO only)."
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "Optional CMK for SSE. null = SQS-managed / AWS-managed SNS key (no fixed CMK cost; the org default)."
  type        = string
  default     = null
}

# NOTE: prevent_destroy is intentionally NOT a variable. Terraform requires
# lifecycle.prevent_destroy to be a literal (it cannot be set from a variable),
# and the in-repo sqs module does not expose it yet (see its feat/prevent-destroy
# branch). Callers needing destroy protection should manage it once the sqs
# module supports it; document this in the README.

# ---------------------------------------------------------------------------
# Tier 2 — Input DLQ
# ---------------------------------------------------------------------------

variable "create_dlq" {
  description = "Create a DLQ + redrive policy on the primary queue."
  type        = bool
  default     = true
}

variable "max_receive_count" {
  description = "Deliveries before a message moves to the DLQ (3 for critical flows, 5 for background)."
  type        = number
  default     = 5
}

variable "dlq_retention_seconds" {
  description = "DLQ retention (default 14 days, room to investigate)."
  type        = number
  default     = 1209600
}

# ---------------------------------------------------------------------------
# Tier 3 — Input SNS topic
# ---------------------------------------------------------------------------

variable "create_input_topic" {
  description = "Create an input SNS topic that fans into the queue. false = producers send directly to SQS (single-producer flows)."
  type        = bool
  default     = true
}

variable "input_topic_name" {
  description = "Override the input topic name. null = '<name>-events'."
  type        = string
  default     = null
}

variable "external_input_topic_arn" {
  description = "Subscribe the queue to a PRE-EXISTING topic (chaining: a previous unit's output_topic_arn) instead of creating one. Mutually exclusive with create_input_topic."
  type        = string
  default     = null
}

variable "input_filter_policy" {
  description = "JSON SNS filter policy on the topic->queue subscription (route event subtypes)."
  type        = string
  default     = null
}

variable "input_filter_policy_scope" {
  description = "MessageAttributes | MessageBody."
  type        = string
  default     = "MessageAttributes"
}

variable "raw_message_delivery" {
  description = "true = SQS body is the raw producer JSON (no SNS envelope). Keep true so the drain handler reads the payload directly."
  type        = bool
  default     = true
}

variable "additional_input_subscriptions" {
  description = "Extra non-SQS subscribers on the input topic (email/http/lambda). Map of name -> {protocol, endpoint, raw_message_delivery, filter_policy}."
  type = map(object({
    protocol             = string
    endpoint             = string
    raw_message_delivery = optional(bool, false)
    filter_policy        = optional(string, null)
  }))
  default = {}
}

# ---------------------------------------------------------------------------
# Tier 4 — Consumer trigger (no ESM)
# ---------------------------------------------------------------------------

variable "consumer_mode" {
  description = "real_time (SNS->Lambda push) | near_real_time (drain) | batch (drain, cron) | external (caller manages the trigger)."
  type        = string
  default     = "near_real_time"

  validation {
    condition     = contains(["real_time", "near_real_time", "batch", "external"], var.consumer_mode)
    error_message = "consumer_mode must be real_time, near_real_time, batch, or external."
  }
}

variable "consumer_lambda_arn" {
  description = "Consumer Lambda ARN. Required for real_time/near_real_time/batch."
  type        = string
  default     = null

  validation {
    condition     = var.consumer_mode == "external" || var.consumer_lambda_arn != null
    error_message = "consumer_lambda_arn is required unless consumer_mode = \"external\"."
  }
}

variable "consumer_lambda_name" {
  description = "Consumer Lambda function name (for lambda permissions + on-failure config + EventBridge target)."
  type        = string
  default     = null
}

# real_time specific
variable "real_time_input_filter_policy" {
  description = "SNS filter policy on the topic->Lambda subscription (real_time only)."
  type        = string
  default     = null
}

variable "real_time_subscription_enabled" {
  description = "Create the SNS->Lambda subscription + permission (real_time). Kept false until the drain-mode handler ships (an SNS subscription cannot be created disabled; creating it early would invoke an un-updated handler). Flip true at go-live (Phase 4)."
  type        = bool
  default     = false
}

variable "create_failure_queue" {
  description = "real_time: create the SQS failure queue that the Lambda async on-failure destination targets."
  type        = bool
  default     = true
}

variable "failure_drain_schedule_expression" {
  description = "How often to replay the real_time failure queue."
  type        = string
  default     = "rate(15 minutes)"
}

variable "failure_drain_enabled" {
  description = "Enable the failure-drain EventBridge rule (so real_time failures are not silently lost). Kept false until the handler ships; flip true at go-live."
  type        = bool
  default     = false
}

# near_real_time / batch (drain)
variable "drain_schedule_expression" {
  description = "EventBridge rate/cron for the scheduled drain (near_real_time/batch)."
  type        = string
  default     = "rate(5 minutes)"
}

variable "drain_enabled" {
  description = "Enable the drain EventBridge rule. Kept false until the drain-mode handler ships; flip true at go-live (Phase 4)."
  type        = bool
  default     = false
}

# NOTE: reserved concurrency for the drain Lambda CANNOT be set here (the module
# does not own the Lambda). The CALLER must set reserved_concurrent_executions = 1
# on the consumer Lambda module for near_real_time/batch to prevent overlapping
# drains from double-processing (I5). See README.

# ---------------------------------------------------------------------------
# Tier 5 — Output topic (emit / chain — NO output queue)
# ---------------------------------------------------------------------------

variable "create_output_topic" {
  description = "Create a result/chain-anchor topic the Lambda publishes to. Only create it when a subscriber exists (an unsubscribed topic drops messages)."
  type        = bool
  default     = false
}

variable "output_topic_name" {
  description = "Override the output topic name. null = '<name>-completed'."
  type        = string
  default     = null
}

variable "output_subscriptions" {
  description = "Subscribers on the output topic (non-SQS: webhook/email/lambda). A downstream SQS consumer should instead set external_input_topic_arn = this output_topic_arn and own its own queue."
  type = map(object({
    protocol             = string
    endpoint             = string
    raw_message_delivery = optional(bool, false)
    filter_policy        = optional(string, null)
  }))
  default = {}
}

# ---------------------------------------------------------------------------
# Tier 6 — Archive + replay (D2)
# ---------------------------------------------------------------------------

variable "create_archive" {
  description = "Archive every event on the input topic to S3 via Kinesis Firehose (for full reprocessing replay). NEVER enable on flows carrying secrets/PII (e.g. auth passwords)."
  type        = bool
  default     = false
}

variable "archive_bucket_name" {
  description = "Existing S3 bucket name for the raw archive. Required when create_archive."
  type        = string
  default     = null

  validation {
    condition     = !var.create_archive || var.archive_bucket_name != null
    error_message = "archive_bucket_name is required when create_archive = true."
  }
}

variable "archive_prefix" {
  description = "S3 key prefix for this flow's archive. null = '<name>'. Firehose appends 'YYYY/MM/DD/HH/'."
  type        = string
  default     = null
}

variable "archive_buffer_seconds" {
  description = "Firehose buffering interval hint (60-900). Lower = fresher archive, more S3 PUTs."
  type        = number
  default     = 300
}

variable "archive_buffer_mb" {
  description = "Firehose buffering size hint in MB (1-128)."
  type        = number
  default     = 5
}

# ---------------------------------------------------------------------------
# Tier 7 — Observability
# ---------------------------------------------------------------------------

variable "create_alarms" {
  description = "Create CloudWatch alarms (depth, age, DLQ depth) on the managed queues."
  type        = bool
  default     = false
}

variable "alarm_sns_topic_arn" {
  description = "Ops SNS topic for alarm actions. Required when create_alarms."
  type        = string
  default     = null

  validation {
    condition     = !var.create_alarms || var.alarm_sns_topic_arn != null
    error_message = "alarm_sns_topic_arn is required when create_alarms = true."
  }
}

variable "alarm_depth_threshold" {
  description = "ApproximateNumberOfMessagesVisible alarm threshold (primary queue). For a real_time failure queue the module uses 0 (any message = failure)."
  type        = number
  default     = 50
}

variable "alarm_age_threshold_seconds" {
  description = "ApproximateAgeOfOldestMessage alarm threshold."
  type        = number
  default     = 600
}
