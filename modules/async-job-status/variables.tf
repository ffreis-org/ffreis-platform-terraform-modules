variable "name" {
  description = "Jobs table name, e.g. '<site>-jobs-<env>'."
  type        = string
}

variable "ttl_attribute" {
  description = "DynamoDB TTL attribute (unix epoch seconds). Rows self-expire after the job result is no longer needed (~1h). The consumer sets it on the terminal-status write."
  type        = string
  default     = "expires_at"
}

variable "deletion_protection_enabled" {
  description = "DynamoDB deletion protection. Job status is transient (TTL'd), so false by default."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the table (use the tagging module output; set a per-product CostCenter)."
  type        = map(string)
  default     = {}
}
