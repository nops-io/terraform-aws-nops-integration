output "project_aws_list" {
  description = "List of projects in nOps"
  value       = try(jsondecode(data.http.check_project_aws.response_body), "")
}

output "current_client_id" {
  description = "The client ID of the current account in nOps"
  value       = try(jsondecode(data.http.check_current_client.response_body), { id = "" }).id
}

output "master_account_id" {
  value       = local.master_account_id
  description = "The account ID of the AWS Organization's master account"
}

output "is_master_account" {
  value       = local.is_master_account
  description = "Whether the current account is the master account"
}

output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.nops_integration_role.arn
}

output "nops_integration_status" {
  description = "Indicates if the nOps integration notification was sent"
  value       = local.project_count == 0 ? "Notification sent to nOps" : "Integration skipped: Project already exists"
}

output "system_bucket_name" {
  description = "The name of the S3 bucket (if created)"
  value       = local.create_bucket ? local.system_bucket_name : null
}

output "project_status" {
  description = "Status of the nOps project for this account"
  value       = local.project_count == 0 ? "New project created" : "Existing project updated"
}

output "notify_nops_integration_complete_status" {
  description = "Status of the nOps integration notification"
  value       = local.project_count == 0 ? try(jsondecode(data.http.notify_nops_integration_complete[0].response_body), { "message" = "" }) : { message = "Integration skipped: Project already exists" }
}

output "is_master_account_out" {
  description = "Indicates if the account is the master account"
  value       = local.is_master_account
}
