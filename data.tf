data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "current" {}

data "http" "check_project_aws" {
  url    = "${local.nops_url}c/admin/projectaws/"
  method = "GET"
  request_headers = {
    Accept         = "application/json"
    X-Nops-Api-Key = var.api_key
  }
}

data "http" "check_current_client" {
  url    = "${local.nops_url}c/admin/current_client/"
  method = "GET"
  request_headers = {
    Accept         = "application/json"
    X-Nops-Api-Key = var.api_key
  }
}

data "http" "create_nops_project" {
  count = local.should_proceed && local.project_count == 0 ? 1 : 0


  url    = "${local.nops_url}c/admin/projectaws/"
  method = "POST"

  request_headers = {
    Content-Type   = "application/json"
    X-Nops-Api-Key = var.api_key
  }

  request_body = jsonencode({
    name                        = "AWS Account ${local.account_id}"
    account_number              = local.account_id
    master_payer_account_number = local.master_account_id
  })
}
