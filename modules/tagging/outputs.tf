output "tags" {
  description = "Complete tag map. Pass as `tags = module.tags.tags` to every other module, and as `provider \"aws\" { default_tags { tags = module.tags.tags } }` at the root."
  value       = local.tags
}

output "project" {
  description = "Project tag value (useful for name prefixes)."
  value       = var.project
}

output "stack" {
  description = "Stack tag value."
  value       = var.stack
}

output "environment" {
  description = "Environment tag value."
  value       = var.environment
}

output "cost_center" {
  description = "CostCenter tag value."
  value       = var.cost_center
}
