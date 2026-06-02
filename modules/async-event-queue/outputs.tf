# ---------------------------------------------------------------------------
# Work queue (primary buffer for drain/external; failure queue for real_time)
# ---------------------------------------------------------------------------
output "queue_url" {
  description = "Work queue URL — set as QUEUE_URL on the consumer Lambda (drain reads it)."
  value       = module.queue.queue_id
}

output "queue_arn" {
  description = "Work queue ARN."
  value       = module.queue.queue_arn
}

output "queue_name" {
  description = "Work queue name (CloudWatch dimension)."
  value       = module.queue.queue_name
}

output "dlq_url" {
  description = "DLQ URL (empty if create_dlq = false)."
  value       = module.queue.dlq_id
}

output "dlq_arn" {
  description = "DLQ ARN (empty if create_dlq = false)."
  value       = module.queue.dlq_arn
}

# ---------------------------------------------------------------------------
# Topics (no output queue — D1)
# ---------------------------------------------------------------------------
output "input_topic_arn" {
  description = "Input topic ARN — set as TOPIC_ARN on the producer Lambda. null if create_input_topic = false and no external topic."
  value       = local.input_topic_arn
}

output "output_topic_arn" {
  description = "Output/result topic ARN — set as OUTPUT_TOPIC_ARN on the consumer Lambda. null if create_output_topic = false. Chain by passing this as the next unit's external_input_topic_arn."
  value       = local.output_topic_arn
}

# ---------------------------------------------------------------------------
# Archive (D2)
# ---------------------------------------------------------------------------
output "archive_bucket_arn" {
  description = "S3 archive bucket ARN (null if create_archive = false)."
  value       = local.archive_bucket_arn
}

output "archive_firehose_arn" {
  description = "Firehose delivery stream ARN (null if create_archive = false)."
  value       = var.create_archive ? aws_kinesis_firehose_delivery_stream.archive[0].arn : null
}

# ---------------------------------------------------------------------------
# IAM policy JSON — attach to the caller's Lambda inline_policies
# ---------------------------------------------------------------------------
output "producer_policy_json" {
  description = "sns:Publish on the input topic (or sqs:SendMessage on the queue if no topic)."
  value       = data.aws_iam_policy_document.producer.json
}

output "consumer_policy_json" {
  description = "sqs:ReceiveMessage/DeleteMessage/GetQueueAttributes on the work queue (+ SendMessage in real_time for the on-failure destination)."
  value       = data.aws_iam_policy_document.consumer.json
}

output "dlq_consumer_policy_json" {
  description = "Re-drive/inspection access to the DLQ (null if create_dlq = false)."
  value       = var.create_dlq ? data.aws_iam_policy_document.dlq_consumer[0].json : null
}

output "output_publisher_policy_json" {
  description = "sns:Publish on the output topic (null if create_output_topic = false)."
  value       = var.create_output_topic ? data.aws_iam_policy_document.output_publisher[0].json : null
}

output "replay_policy_json" {
  description = "s3:GetObject on the archive prefix + sns:Publish on the input topic, for the replay job (null if create_archive = false)."
  value       = var.create_archive ? data.aws_iam_policy_document.replay[0].json : null
}
