locals {
  required_tags = {
    Project            = var.project
    Environment        = var.environment
    Stack              = var.stack
    Layer              = var.layer
    ManagedBy          = var.managed_by
    TerraformRepo      = var.terraform_repo
    TerraformRoot      = var.terraform_root
    CostCenter         = var.cost_center
    Owner              = var.owner
    Compliance         = var.compliance_framework
    DataClassification = var.data_classification
    BackupPolicy       = var.backup_policy
    Lifecycle          = var.lifecycle_state
    FixedCostTier      = var.fixed_cost_tier
    Domain             = var.domain
  }

  terraform_version_tag = var.terraform_version != "" ? { TerraformVersion = var.terraform_version } : {}
  repository_tag        = var.repository != "" ? { Repository = var.repository } : {}

  tags = merge(
    local.required_tags,
    local.terraform_version_tag,
    local.repository_tag,
    var.additional_tags,
  )
}
