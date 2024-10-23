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

resource "null_resource" "check_api_errors" {
  count = local.errors ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Error: An error occurred while requesting the nOps API, please try again later.' && exit 1"
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


resource "time_sleep" "wait_for_resources" {
  depends_on = [
    aws_iam_role.nops_integration_role,
    aws_iam_role_policy.nops_integration_policy,
    aws_iam_role_policy.nops_system_bucket_policy,
    aws_iam_role_policy.nops_essentials_policy,
    aws_iam_role_policy.nops_compute_copilot_policy,
    aws_iam_role_policy.nops_wafr_policy,
    aws_s3_bucket.nops_system_bucket,
    aws_s3_bucket_policy.nops_bucket_policy,
    aws_s3_bucket_server_side_encryption_configuration.nops_bucket_encryption
  ]

  create_duration = "60s"

  triggers = {
    timestamp = timestamp()
  }
}
