locals {
  account_id        = data.aws_caller_identity.current.account_id
  master_account_id = data.aws_organizations_organization.current.master_account_id
  is_master_account = local.account_id == local.master_account_id
  client_id         = try(jsondecode(data.http.check_current_client.response_body).id, "error")
  project_aws_list  = try(jsondecode(data.http.check_project_aws.response_body), "error")
  errors            = local.client_id == "error" || local.project_aws_list == "error" ? true : false
  matching_projects = [
    for project in local.project_aws_list : project
    if project.account_number == local.account_id
  ]
  project_count         = length(local.matching_projects)
  bucket_name           = var.system_bucket_name
  should_proceed        = var.reconfigure || local.project_count == 0
  existing_project_data = local.project_count == 1 ? local.matching_projects[0] : null
  new_project_data      = local.project_count == 0 ? jsondecode(data.http.create_nops_project[0].response_body) : null
  project_data          = coalesce(local.existing_project_data, local.new_project_data)
  external_id           = local.project_data != null ? local.project_data.external_id : null
  create_bucket         = local.is_master_account && var.system_bucket_name != "na" && local.should_proceed
}
