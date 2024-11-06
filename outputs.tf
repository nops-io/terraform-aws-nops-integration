output "project_aws_list" {
  description = "List of projects in nOps"
  value       = data.nops_projects.current.projects
}

output "current_client_id" {
  description = "The client ID of the current account in nOps"
  value       = nops_project.project.client
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

output "system_bucket_name" {
  description = "The name of the S3 bucket (if created)"
  value       = local.create_bucket ? aws_s3_bucket.nops_system_bucket[0].id : "na"
}
