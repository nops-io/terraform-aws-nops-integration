locals {
  nops_principal     = "202279780353"
  account_id         = data.aws_caller_identity.current.account_id
  master_account_id  = data.aws_organizations_organization.current.master_account_id
  is_master_account  = local.account_id == local.master_account_id
  client_id          = nops_project.project.id
  project_id         = nops_project.project.client
  external_id        = nops_project.project.external_id
  system_bucket_name = "nops-${local.client_id}-${local.project_id}-${local.account_id}"
  create_bucket      = local.is_master_account
  # tflint-ignore: terraform_unused_declarations
  validate_permissions = var.cri_usage_only && var.min_required_permissions ? tobool("ERROR: cri_usage_only and min_required_permissions cannot both be true") : true
}
