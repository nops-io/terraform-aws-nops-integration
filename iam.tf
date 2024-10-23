resource "aws_iam_role" "nops_integration_role" {
  name = "NopsIntegrationRole-${local.client_id}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.nops_principal}:root"
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

resource "aws_iam_role_policy" "nops_wafr_policy" {
  count = var.wafr ? 1 : 0
  name  = "NopsWAFRPolicy"
  role  = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudtrail:DescribeTrails",
          "cloudtrail:LookupEvents",
          "cloudwatch:GetMetricStatistics",
          "config:DescribeConfigurationRecorders",
          "iam:ListUsers",
          "iam:GetRole",
          "iam:GetAccountSummary",
          "iam:GetAccountPasswordPolicy",
          "iam:ListAttachedUserPolicies",
          "inspector:ListAssessmentRuns",
          "ec2:DescribeFlowLogs",
          "ec2:DescribeSnapshots",
          "ec2:DescribeRouteTables",
          "wellarchitected:*",
          "workspaces:DescribeWorkspaceDirectories"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "nops_essentials_policy" {
  count = var.essentials ? 1 : 0
  name  = "NopsEssentialsPolicy"
  role  = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:ListMetrics",
          "events:CreateEventBus"
        ],
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "nops_compute_copilot_policy" {
  count = var.compute_copilot ? 1 : 0
  name  = "NopsComputeCopilotPolicy"
  role  = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "cloudformation:ListStacks",
          "cloudformation:DescribeStacks",
        ]
        Resource = "*"
      }
    ]
  })
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
          "ce:ListCostAllocationTags",
          "ce:UpdateCostAllocationTagsStatus",
          "ce:GetCostAndUsage",
          "ce:GetReservationPurchaseRecommendation",
          "config:DescribeConfigurationRecorders",
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
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstanceStatus",
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
          "kms:Decrypt",
          "lambda:GetFunction",
          "lambda:GetPolicy",
          "lambda:ListFunctions",
          "organizations:InviteAccountToOrganization",
          "rds:DescribeDBClusters",
          "rds:DescribeDBInstances",
          "rds:DescribeDBSnapshots",
          "redshift:DescribeClusters",
          "s3:ListAllMyBuckets",
          "s3:GetBucketVersioning",
          "savingsplans:DescribeSavingsPlans",
          "support:DescribeTrustedAdvisorCheckRefreshStatuses",
          "support:DescribeTrustedAdvisorCheckResult",
          "support:DescribeTrustedAdvisorChecks",
          "tagging:GetResources",
          "organizations:ListAccounts",
          "organizations:DescribeOrganization"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "nops_system_bucket_policy" {
  count = local.is_master_account && local.system_bucket_name != "na" ? 1 : 0
  name  = "NopsSystemBucketPolicy"
  role  = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketPolicy",
          "s3:GetEncryptionConfiguration",
          "s3:GetBucketVersioning",
          "s3:GetBucketPolicyStatus",
          "s3:GetBucketLocation",
          "s3:GetBucketAcl",
          "s3:GetBucketLogging",
          "s3:GetObject",
          "s3:PutBucketPolicy",
          "s3:PutObject",
          "s3:HeadBucket"
        ]
        Resource = [
          "arn:aws:s3:::${local.bucket_name}",
          "arn:aws:s3:::${local.bucket_name}/*"
        ]
      }
    ]
  })
}
