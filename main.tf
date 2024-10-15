resource "null_resource" "reconfigure_trigger" {
  triggers = {
    reconfigure = var.reconfigure
  }
}

resource "null_resource" "check_existing_project" {
  count = local.project_count > 0 && !var.reconfigure ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Error: Project already exists for this account. Set reconfigure to true to proceed.' && exit 1"
  }
}

resource "null_resource" "project_check" {
  count = local.project_count > 1 ? 1 : 0
  provisioner "local-exec" {
    command = "echo 'Error: Multiple projects found for this account.' && exit 1"
  }
}

resource "null_resource" "force_new_role" {
  triggers = {
    account_id = local.account_id
  }
}


resource "time_sleep" "wait_for_iam_role" {
  depends_on = [
    aws_iam_role.nops_integration_role,
    aws_iam_role_policy.nops_integration_policy,
    aws_iam_role_policy.nops_eventbridge_integration_policy,
    aws_iam_role_policy.nops_system_bucket_policy
  ]

  create_duration = "60s"

  triggers = {
    timestamp = timestamp()
  }
}

data "http" "notify_nops_integration_complete" {
  count = local.should_proceed ? 1 : 0

  url    = "${var.nops_url}c/aws/integration/"
  method = "POST"

  request_headers = {
    Content-Type         = "application/json"
    X-Nops-Api-Key       = var.api_key
    X-Aws-Account-Number = local.account_id
  }

  request_body = jsonencode({
    external_id = local.external_id
    role_arn    = aws_iam_role.nops_integration_role.arn
    bucket_name = local.create_bucket ? var.system_bucket_name : "na"
    RequestType = local.project_count == 0 ? "Create" : "Update"
    ResourceProperties = {
      ServiceBucket = local.create_bucket ? var.system_bucket_name : "na"
      AWSAccountID  = local.account_id
      RoleArn       = aws_iam_role.nops_integration_role.arn
      ExternalID    = local.external_id
    }
  })

  depends_on = [
    time_sleep.wait_for_iam_role,
    aws_iam_role.nops_integration_role,
  ]
}
