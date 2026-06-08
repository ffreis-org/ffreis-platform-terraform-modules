output "table_name" {
  description = "Jobs table name — set as JOBS_TABLE on the consumer and the status Lambda."
  value       = module.table.id
}

output "table_arn" {
  description = "Jobs table ARN."
  value       = module.table.arn
}

output "status_writer_policy_json" {
  description = "dynamodb:PutItem/UpdateItem/GetItem on the jobs table. Attach to the async consumer role (it writes the terminal status)."
  value       = data.aws_iam_policy_document.status_writer.json
}

output "status_reader_policy_json" {
  description = "dynamodb:GetItem on the jobs table. Attach to the sync status Lambda role (GET /api/status/{job_id})."
  value       = data.aws_iam_policy_document.status_reader.json
}
