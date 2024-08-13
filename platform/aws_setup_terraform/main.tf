# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.7"
    }

  }
}

provider "aws" {
  region = var.aws_region
}

provider "http" {}

variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "The AWS region to deploy resources"
}

variable "nops_url" {
  type        = string
  default     = "https://app.nops.io/"
  description = "The nOps base URL"
}

variable "nops_principal" {
  type        = string
  default     = "202279780353"
  description = "The nOps principal account number"
}

variable "api_key" {
  type        = string
  description = "The nOps API key"
}

variable "system_bucket_name" {
  type        = string
  description = "The name of the system bucket for nOps integration"
}

variable "reconfigure" {
  type        = bool
  default     = false
  description = "If true, allows overriding existing project settings. If false, stops execution if project already exists."
}

resource "null_resource" "reconfigure_trigger" {
  triggers = {
    reconfigure = var.reconfigure
  }
}


data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "current" {}

data "http" "check_project_aws" {
  url    = "${var.nops_url}c/admin/projectaws/"
  method = "GET"
  request_headers = {
    Accept         = "application/json"
    X-Nops-Api-Key = var.api_key
  }
}

data "http" "check_current_client" {
  url    = "${var.nops_url}c/admin/current_client/"
  method = "GET"
  request_headers = {
    Accept         = "application/json"
    X-Nops-Api-Key = var.api_key
  }
}

output "project_aws_list" {
  description = "List of projects in nOps"
  value       = jsondecode(data.http.check_project_aws.response_body)
}

output "current_client_id" {
  description = "The client ID of the current account in nOps"
  value       = jsondecode(data.http.check_current_client.response_body).id
}

locals {
  account_id        = data.aws_caller_identity.current.account_id
  master_account_id = data.aws_organizations_organization.current.master_account_id
  is_master_account = local.account_id == local.master_account_id
  client_id = jsondecode(data.http.check_current_client.response_body).id


  project_aws_list  = jsondecode(data.http.check_project_aws.response_body)
  matching_projects = [
    for project in local.project_aws_list : project
    if project.account_number == local.account_id
  ]
  project_count    = length(local.matching_projects)
  existing_project = local.project_count == 1 ? local.matching_projects[0] : null
  bucket_name      = var.system_bucket_name
  should_proceed = var.reconfigure || local.project_count == 0
}

output "master_account_id" {
  value = local.master_account_id
  description = "The account ID of the AWS Organization's master account"
}

output "is_master_account" {
  value = local.is_master_account
  description = "Whether the current account is the master account"
}


resource "null_resource" "check_existing_project" {
  count = local.project_count > 0 && !var.reconfigure ? 1 : 0
  
  provisioner "local-exec" {
    command = "echo 'Error: Project already exists for this account. Set reconfigure to true to proceed.' && exit 1"
  }
}

output "is_master_account_out" {
  description = "Indicates if the account is the master account"
  value       = local.is_master_account
}

resource "null_resource" "project_check" {
  count = local.project_count > 1 ? 1 : 0
  provisioner "local-exec" {
    command = "echo 'Error: Multiple projects found for this account.' && exit 1"
  }
}


data "http" "create_nops_project" {
  count = local.should_proceed && local.project_count == 0 ? 1 : 0


  url    = "${var.nops_url}c/admin/projectaws/"
  method = "POST"

  request_headers = {
    Content-Type   = "application/json"
    X-Nops-Api-Key = var.api_key
  }

  request_body = jsonencode({
    name = "AWS Account ${local.account_id}"
    account_number = local.account_id
    master_payer_account_number = local.master_account_id
  })
}

locals {
  existing_project_data = local.project_count == 1 ? local.matching_projects[0] : null
  new_project_data      = local.project_count == 0 ? jsondecode(data.http.create_nops_project[0].response_body) : null
  project_data          = coalesce(local.existing_project_data, local.new_project_data)
  external_id           = local.project_data != null ? local.project_data.external_id : null
  create_bucket = local.is_master_account && var.system_bucket_name != "na" && local.should_proceed
}

resource "aws_s3_bucket" "nops_system_bucket" {
  count         = local.create_bucket ? 1 : 0
  bucket        = var.system_bucket_name
  force_destroy = false

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }

  depends_on = [time_sleep.wait_for_iam_role]
}


resource "aws_s3_bucket_server_side_encryption_configuration" "nops_bucket_encryption" {
  count  = local.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.nops_system_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
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

output "notify_nops_integration_complete_status" {
  description = "Status of the nOps integration notification"
  value = jsonencode(local.should_proceed ? jsondecode(data.http.notify_nops_integration_complete[0].response_body) : {"message": "Integration skipped: Project already exists"}
  )
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
