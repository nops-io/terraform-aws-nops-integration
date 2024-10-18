resource "aws_iam_role" "nops_integration_role" {
  name = "NopsIntegrationRole-${local.client_id}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.nops_principal}:root"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = local.external_id
          }
        }
      }
    ]
  })

  tags = {
    version   = "1.1.0"
    createdat = formatdate("YYYYMMDD", timestamp())
  }
  depends_on = [null_resource.force_new_role]
  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [null_resource.reconfigure_trigger.id]
  }
}

resource "aws_iam_role_policy" "nops_integration_policy" {
  name = "NopsIntegrationPolicy"
  role = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "ce:ListCostAllocationTags",
          "ce:UpdateCostAllocationTagsStatus",
          "ce:GetCostAndUsage",
          "cloudformation:ListStacks",
          "cloudformation:DescribeStacks",
          "cloudtrail:DescribeTrails",
          "cloudwatch:ListMetrics",
          "config:DescribeConfigurationRecorders",
          "cur:DeleteReportDefinition",
          "cur:DescribeReportDefinitions",
          "cur:PutReportDefinition",
          "dynamodb:ListTables",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeNatGateways",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeRegions",
          "ec2:DescribeReservedInstances",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcs",
          "ecs:ListClusters",
          "eks:ListClusters",
          "elasticache:DescribeCacheClusters",
          "elasticache:DescribeCacheSubnetGroups",
          "elasticfilesystem:DescribeFileSystems",
          "elasticloadbalancing:DescribeLoadBalancers",
          "es:DescribeElasticsearchDomains",
          "es:ListDomainNames",
          "events:ListRules",
          "guardduty:ListDetectors",
          "iam:ListRoles",
          "iam:ListAccountAliases",
          "inspector:ListAssessmentRuns",
          # Required to decrypt lambdas encrypted at rest
          "kms:Decrypt",
          "lambda:GetFunction",
          "lambda:GetPolicy",
          "lambda:ListFunctions",
          "organizations:InviteAccountToOrganization",
          "rds:DescribeDBClusters",
          "rds:DescribeDBInstances",
          "rds:DescribeDBSnapshots",
          "redshift:DescribeClusters",
          "s3:ListBucket",
          "s3:ListAllMyBuckets",
          "savingsplans:DescribeSavingsPlans",
          "support:DescribeTrustedAdvisorCheckRefreshStatuses",
          "support:DescribeTrustedAdvisorCheckResult",
          "support:DescribeTrustedAdvisorChecks",
          "tagging:GetResources",
          "organizations:ListAccounts",
          "wellarchitected:*",
          "workspaces:DescribeWorkspaceDirectories"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "nops_eventbridge_integration_policy" {
  name = "NopsEventBridgeIntegrationPolicy"
  role = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["events:CreateEventBus"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "nops_system_bucket_policy" {
  count = local.is_master_account && var.system_bucket_name != "na" ? 1 : 0
  name  = "NopsSystemBucketPolicy"
  role  = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketPolicy",
          "s3:GetEncryptionConfiguration",
          "s3:GetBucketVersioning",
          "s3:GetBucketPolicyStatus",
          "s3:GetBucketAcl",
          "s3:GetBucketLogging",
          "s3:PutBucketPolicy",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${local.bucket_name}",
          "arn:aws:s3:::${local.bucket_name}/*"
        ]
      }
    ]
  })
}
