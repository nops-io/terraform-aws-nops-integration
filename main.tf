resource "nops_project" "project" {
  name                        = "AWS Account ${data.aws_caller_identity.current.account_id}"
  account_number              = data.aws_caller_identity.current.account_id
  master_payer_account_number = data.aws_organizations_organization.current.master_account_id
}

resource "nops_integration" "integration" {
  role_arn       = aws_iam_role.nops_integration_role.arn
  external_id    = local.external_id
  aws_account_id = local.account_id
  bucket_name    = local.is_master_account ? local.system_bucket_name : "na"
  depends_on = [
    time_sleep.wait_for_resources
  ]
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
    aws_s3_bucket_server_side_encryption_configuration.nops_bucket_encryption,
    nops_project.project
  ]

  create_duration = "10s"
}
