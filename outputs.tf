output "project_aws_list" {
  description = "List of projects in nOps"
  value       = jsondecode(data.http.check_project_aws.response_body)
}

output "current_client_id" {
  description = "The client ID of the current account in nOps"
  value       = jsondecode(data.http.check_current_client.response_body).id
}

output "master_account_id" {
  value = local.master_account_id
  description = "The account ID of the AWS Organization's master account"
}

output "is_master_account" {
  value = local.is_master_account
  description = "Whether the current account is the master account"
}

output "role_arn" {
  description = "The ARN of the IAM role"
  value       = local.should_proceed ? aws_iam_role.nops_integration_role.arn : "Integration skipped: Project already exists"
}

output "nops_integration_status" {
  description = "Indicates if the nOps integration notification was sent"
  value       = local.should_proceed ? "Notification sent to nOps" : "Integration skipped: Project already exists"
}

output "system_bucket_name" {
  description = "The name of the S3 bucket (if created)"
  value       = local.create_bucket ? var.system_bucket_name : "na"
}

output "project_status" {
  description = "Status of the nOps project for this account"
  value = local.project_count == 0 ? "New project created" : (local.project_count == 1 && var.reconfigure ? "Existing project updated" : (local.project_count == 1 && !var.reconfigure ? "Existing project found, integration skipped" : "Error: Multiple projects found"))
}

output "notify_nops_integration_complete_status" {
  description = "Status of the nOps integration notification"
  value = jsonencode(local.should_proceed ? jsondecode(data.http.notify_nops_integration_complete[0].response_body) : {"message": "Integration skipped: Project already exists"}
  )
}
